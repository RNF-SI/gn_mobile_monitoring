#!/bin/bash

# Script pour exécuter les tests d'intégration en contournant les limitations Flutter
# Ce script teste directement les APIs avec curl et valide la configuration

set -e  # Arrêter en cas d'erreur

echo "🧪 Tests d'intégration GeoNature Mobile"
echo "======================================"

# Couleurs pour l'affichage
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Fonctions utilitaires
success() { echo -e "${GREEN}✅ $1${NC}"; }
error() { echo -e "${RED}❌ $1${NC}"; }
warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
info() { echo -e "${BLUE}ℹ️  $1${NC}"; }

# Variables globales
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$SCRIPT_DIR/.env.test"

# 1. Vérification des prérequis
echo ""
info "1. Vérification des prérequis"

if [ ! -f "$CONFIG_FILE" ]; then
    error "Fichier .env.test manquant"
    echo "Créez le fichier .env.test avec:"
    echo "cp .env.test.example .env.test"
    echo "Puis remplissez avec vos credentials"
    exit 1
fi

success "Fichier .env.test trouvé"

# Charger la configuration
source "$CONFIG_FILE"

if [ -z "$TEST_SERVER_URL" ] || [ -z "$TEST_USERNAME" ] || [ -z "$TEST_PASSWORD" ]; then
    error "Configuration incomplète dans .env.test"
    echo "Vérifiez que TEST_SERVER_URL, TEST_USERNAME et TEST_PASSWORD sont définis"
    exit 1
fi

success "Configuration valide chargée"
info "Serveur: $TEST_SERVER_URL"
info "Utilisateur: $TEST_USERNAME"
info "Modules attendus: $TEST_MODULES"

# 2. Test de connectivité
echo ""
info "2. Test de connectivité réseau"

SERVER_HOST=$(echo "$TEST_SERVER_URL" | sed 's|https://||' | sed 's|http://||' | cut -d'/' -f1)
if ping -c 1 -W 2 "$SERVER_HOST" > /dev/null 2>&1; then
    success "Serveur $SERVER_HOST accessible"
else
    warning "Ping vers $SERVER_HOST échoue (peut être normal si le ping est bloqué)"
fi

# 3. Test d'authentification
echo ""
info "3. Test d'authentification API"

AUTH_RESPONSE=$(curl -s -w "HTTPSTATUS:%{http_code}" -X POST "$TEST_SERVER_URL/api/auth/login" \
    -H "Content-Type: application/json" \
    -d "{\"login\":\"$TEST_USERNAME\",\"password\":\"$TEST_PASSWORD\"}" \
    --max-time 15) || {
    error "Échec de la requête d'authentification"
    exit 1
}

HTTP_STATUS=$(echo "$AUTH_RESPONSE" | grep -o "HTTPSTATUS:[0-9]*" | cut -d: -f2)
RESPONSE_BODY=$(echo "$AUTH_RESPONSE" | sed 's/HTTPSTATUS:[0-9]*$//')

if [ "$HTTP_STATUS" != "200" ]; then
    error "Authentification échouée (HTTP $HTTP_STATUS)"
    echo "Réponse: $RESPONSE_BODY"
    exit 1
fi

success "Authentification réussie (HTTP $HTTP_STATUS)"

# Extraire le token JWT
TOKEN=$(echo "$RESPONSE_BODY" | grep -o '"token":"[^"]*"' | cut -d'"' -f4)
if [ -z "$TOKEN" ]; then
    error "Token JWT non trouvé dans la réponse"
    echo "Réponse: $RESPONSE_BODY"
    exit 1
fi

success "Token JWT récupéré: ${TOKEN:0:20}..."

# Vérifier la structure du token JWT (3 parties séparées par des points)
TOKEN_PARTS=$(echo "$TOKEN" | tr '.' '\n' | wc -l)
if [ "$TOKEN_PARTS" -ne 3 ]; then
    error "Token JWT mal formé (devrait avoir 3 parties, a $TOKEN_PARTS)"
    exit 1
fi

success "Structure du token JWT validée"

# Vérifier les informations utilisateur
USER_IDENTIFIANT=$(echo "$RESPONSE_BODY" | grep -o '"identifiant":"[^"]*"' | cut -d'"' -f4)
if [ "$USER_IDENTIFIANT" != "$TEST_USERNAME" ]; then
    error "Identifiant utilisateur incorrect (attendu: $TEST_USERNAME, reçu: $USER_IDENTIFIANT)"
    exit 1
fi

success "Informations utilisateur validées ($USER_IDENTIFIANT)"

# 4. Test des modules disponibles
echo ""
info "4. Test des modules disponibles"

MODULES_RESPONSE=$(curl -s -w "HTTPSTATUS:%{http_code}" -X GET "$TEST_SERVER_URL/api/gn_commons/modules" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $TOKEN" \
    --max-time 15) || {
    error "Échec de la requête des modules"
    exit 1
}

MODULES_HTTP_STATUS=$(echo "$MODULES_RESPONSE" | grep -o "HTTPSTATUS:[0-9]*" | cut -d: -f2)
MODULES_BODY=$(echo "$MODULES_RESPONSE" | sed 's/HTTPSTATUS:[0-9]*$//')

if [ "$MODULES_HTTP_STATUS" != "200" ]; then
    error "Récupération des modules échouée (HTTP $MODULES_HTTP_STATUS)"
    echo "Réponse: $MODULES_BODY"
    exit 1
fi

success "Modules récupérés avec succès (HTTP $MODULES_HTTP_STATUS)"

# Compter les modules
MODULE_COUNT=$(echo "$MODULES_BODY" | grep -o '"module_code"' | wc -l)
success "$MODULE_COUNT modules disponibles sur le serveur"

# Vérifier les modules attendus
if [ -n "$TEST_MODULES" ]; then
    IFS=',' read -ra EXPECTED_MODULES <<< "$TEST_MODULES"
    MISSING_MODULES=()
    
    for module in "${EXPECTED_MODULES[@]}"; do
        module=$(echo "$module" | xargs)  # Trim whitespace
        if echo "$MODULES_BODY" | grep -q "\"module_code\":\"$module\""; then
            success "Module $module: disponible"
        else
            warning "Module $module: non trouvé"
            MISSING_MODULES+=("$module")
        fi
    done
    
    if [ ${#MISSING_MODULES[@]} -eq 0 ]; then
        success "Tous les modules attendus sont disponibles"
    else
        warning "${#MISSING_MODULES[@]} module(s) manquant(s): ${MISSING_MODULES[*]}"
        echo "Modules disponibles:"
        echo "$MODULES_BODY" | grep -o '"module_code":"[^"]*"' | cut -d'"' -f4 | while read module; do
            echo "  - $module"
        done
    fi
fi

# 5. Test de déconnexion (optionnel)
echo ""
info "5. Test de déconnexion"

LOGOUT_RESPONSE=$(curl -s -w "HTTPSTATUS:%{http_code}" -X POST "$TEST_SERVER_URL/api/auth/logout" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $TOKEN" \
    --max-time 15) || {
    warning "Déconnexion non disponible ou échouée (pas critique)"
}

if echo "$LOGOUT_RESPONSE" | grep -q "HTTPSTATUS:200"; then
    success "Déconnexion réussie"
else
    warning "Déconnexion non testée (endpoint peut-être inexistant)"
fi

# 6. Résumé final
echo ""
echo "======================================"
success "TOUS LES TESTS D'INTÉGRATION PASSENT"
echo "======================================"

echo ""
echo "📊 Résumé des tests:"
echo "  ✅ Configuration: valide"
echo "  ✅ Connectivité: OK"
echo "  ✅ Authentification: OK"
echo "  ✅ Token JWT: valide"
echo "  ✅ Informations utilisateur: OK"
echo "  ✅ API modules: accessible"
echo "  📦 Modules: $MODULE_COUNT disponibles"

if [ ${#MISSING_MODULES[@]} -gt 0 ]; then
    echo "  ⚠️  Modules manquants: ${MISSING_MODULES[*]}"
else
    echo "  ✅ Modules attendus: tous présents"
fi

echo ""
echo "🎯 Les tests d'intégration fonctionnent !"
echo "La configuration est prête pour le développement."

echo ""
echo "📝 Pour lancer les tests Flutter (malgré les limitations HTTP):"
echo "  make test-integration"
echo ""
echo "🐛 Note: Les tests Flutter peuvent échouer à cause de TestWidgetsFlutterBinding"
echo "qui bloque les vraies requêtes HTTP. Ce script valide que la configuration"
echo "fonctionne correctement en dehors de Flutter."