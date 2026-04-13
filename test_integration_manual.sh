#!/bin/bash

# Script de test manuel pour vérifier la configuration des tests d'intégration

echo "🧪 Test manuel des tests d'intégration"
echo "====================================="

# Vérification du fichier .env.test
echo ""
echo "1️⃣ Vérification du fichier .env.test :"
if [ -f ".env.test" ]; then
    echo "✅ Fichier .env.test trouvé"
    echo "📋 Contenu (sans mot de passe) :"
    cat .env.test | grep -v "PASSWORD"
else
    echo "❌ Fichier .env.test manquant"
    exit 1
fi

# Chargement des variables depuis le fichier
source .env.test

echo ""
echo "2️⃣ Test de la connexion réseau :"
echo "🌐 Test de ping vers le serveur..."
if ping -c 1 -W 2 $(echo $TEST_SERVER_URL | sed 's|https://||' | cut -d'/' -f1) > /dev/null 2>&1; then
    echo "✅ Serveur accessible"
else
    echo "⚠️  Serveur non accessible via ping"
fi

echo ""
echo "3️⃣ Test de l'API d'authentification :"
echo "🔑 Test de connexion avec curl..."

# Test d'authentification
echo "🔍 Commande curl : POST ${TEST_SERVER_URL}/api/auth/login"
echo "👤 Utilisateur : ${TEST_USERNAME}"

AUTH_RESULT=$(curl -s -X POST "${TEST_SERVER_URL}/api/auth/login" \
    -H "Content-Type: application/json" \
    -d "{\"login\":\"${TEST_USERNAME}\",\"password\":\"${TEST_PASSWORD}\"}" \
    --max-time 10 \
    --write-out "HTTPSTATUS:%{http_code}")

# Extraire le code de statut HTTP
HTTP_STATUS=$(echo $AUTH_RESULT | grep -o "HTTPSTATUS:[0-9]*" | cut -d: -f2)
RESPONSE_BODY=$(echo $AUTH_RESULT | sed -E 's/HTTPSTATUS:[0-9]*$//')

echo "📊 Code de réponse HTTP: $HTTP_STATUS"

if [ "$HTTP_STATUS" = "200" ]; then
    echo "✅ Authentification réussie"
    
    # Extraire le token (si la réponse est un JSON valide)
    TOKEN=$(echo $RESPONSE_BODY | grep -o '"token":"[^"]*"' | cut -d'"' -f4)
    if [ -n "$TOKEN" ]; then
        echo "🔑 Token JWT récupéré: ${TOKEN:0:20}..."
    else
        echo "⚠️  Aucun token trouvé dans la réponse"
    fi
    
    # Extraire les infos utilisateur
    USER_ID=$(echo $RESPONSE_BODY | grep -o '"identifiant":"[^"]*"' | cut -d'"' -f4)
    if [ -n "$USER_ID" ]; then
        echo "👤 Utilisateur connecté: $USER_ID"
    fi
    
else
    echo "❌ Échec de l'authentification"
    echo "📄 Réponse du serveur: $RESPONSE_BODY"
fi

echo ""
echo "4️⃣ Test des modules disponibles :"
if [ "$HTTP_STATUS" = "200" ] && [ -n "$TOKEN" ]; then
    echo "📦 Récupération des modules..."
    
    MODULES_RESULT=$(curl -s -X GET "${TEST_SERVER_URL}/api/gn_commons/modules" \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $TOKEN" \
        --max-time 10 \
        --write-out "HTTPSTATUS:%{http_code}")
    
    MODULES_HTTP_STATUS=$(echo $MODULES_RESULT | grep -o "HTTPSTATUS:[0-9]*" | cut -d: -f2)
    MODULES_RESPONSE=$(echo $MODULES_RESULT | sed -E 's/HTTPSTATUS:[0-9]*$//')
    
    if [ "$MODULES_HTTP_STATUS" = "200" ]; then
        echo "✅ Modules récupérés avec succès"
        
        # Compter le nombre de modules
        MODULE_COUNT=$(echo $MODULES_RESPONSE | grep -o '"module_code"' | wc -l)
        echo "📊 Nombre de modules: $MODULE_COUNT"
        
        # Vérifier les modules attendus
        IFS=',' read -ra EXPECTED_MODULES <<< "$TEST_MODULES"
        for module in "${EXPECTED_MODULES[@]}"; do
            if echo $MODULES_RESPONSE | grep -q "\"module_code\":\"$module\""; then
                echo "✅ Module $module: trouvé"
            else
                echo "❌ Module $module: non trouvé"
            fi
        done
        
    else
        echo "❌ Échec de récupération des modules"
        echo "📊 Code HTTP: $MODULES_HTTP_STATUS"
        echo "📄 Réponse: $MODULES_RESPONSE"
    fi
else
    echo "⏭️  Test des modules skippé (pas de token valide)"
fi

echo ""
echo "5️⃣ Résumé :"
echo "==========="

if [ "$HTTP_STATUS" = "200" ]; then
    echo "✅ Configuration des tests d'intégration : FONCTIONNELLE"
    echo ""
    echo "📝 Prochaines étapes :"
    echo "   - Les credentials fonctionnent"
    echo "   - Le serveur est accessible"
    echo "   - L'authentification fonctionne"
    echo "   - Il faut maintenant corriger le chargement du .env.test dans Flutter"
else
    echo "❌ Configuration des tests d'intégration : PROBLÉMATIQUE"
    echo ""
    echo "🔧 Actions requises :"
    echo "   - Vérifier les credentials dans .env.test"
    echo "   - Vérifier l'accès réseau au serveur"
    echo "   - Contacter l'administrateur du serveur si nécessaire"
fi

echo ""
echo "🎯 Pour exécuter les vrais tests d'intégration Flutter :"
echo "   make test-integration"
echo ""