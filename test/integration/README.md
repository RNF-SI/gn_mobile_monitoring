# Tests d'Intégration - GN Mobile Monitoring

Ce répertoire contient les tests d'intégration pour valider l'application avec un serveur GeoNature réel (2.16.x ou 2.17.x).

> 💡 **Pour les tests E2E sur appareil Android** (pilotage de l'app, sync complète, CRUD sites/visites/observations), voir plutôt [`integration_test/`](../../integration_test/) et sa [documentation dédiée](../../docs/E2E_REAL_API_TESTS.md). Les tests documentés ici (couche Dart uniquement, sans UI) se concentrent sur la validation des repositories/viewmodels contre l'API serveur.

## 📋 Table des matières

- [Vue d'ensemble](#vue-densemble)
- [Configuration](#configuration)
- [Exécution des tests](#exécution-des-tests)
- [Structure](#structure)
- [Prérequis serveur](#prérequis-serveur)
- [CI/CD](#cicd)
- [Troubleshooting](#troubleshooting)

---

## 🎯 Vue d'ensemble

Les tests d'intégration valident les flux critiques de l'application avec un serveur GeoNature réel :

- **Authentification** : Connexion, gestion du token JWT, déconnexion
- **Synchronisation upload** : Envoi de visites/observations vers le serveur (POST/PATCH)
- **Synchronisation download** : Téléchargement de données depuis le serveur
- **Gestion des conflits** : Détection et résolution des conflits de données
- **Workflows complets** : Scénarios utilisateur end-to-end

### Différence avec les tests unitaires

- **Tests unitaires** (`test/`) : Rapides, avec mocks, pas de réseau
- **Tests d'intégration** (`test/integration/`) : Plus lents, serveur réel, validation complète

---

## ⚙️ Configuration

### 1. Configuration locale (développement)

#### Option A : Fichier `.env.test` (recommandé)

Créer un fichier `.env.test` à la racine du projet :

```bash
cp .env.test.example .env.test
```

Modifier `.env.test` avec vos credentials :

```bash
# Configuration du serveur GeoNature de test (valeurs à adapter)
TEST_SERVER_URL=https://geonature-test.example.fr
TEST_USERNAME=<votre_identifiant>
TEST_PASSWORD=<votre_mot_de_passe>
TEST_MODULES=POPAmphibien,POPReptile
```

**Important** : Le fichier `.env.test` est git-ignored pour ne pas exposer les credentials.

#### Option B : Variables d'environnement

Alternativement, définir les variables d'environnement :

```bash
export TEST_SERVER_URL="https://geonature-test.reservenaturelle.fr"
export TEST_USERNAME="votre_username"
export TEST_PASSWORD="votre_password"
export TEST_MODULES="POPAmphibien,POPReptile"
```

### 2. Configuration CI/CD (GitHub Actions)

Configurer les secrets dans **Settings → Secrets and variables → Actions** :

| Secret           | Description                   |
|------------------|-------------------------------|
| `TEST_SERVER_URL` | URL du serveur de test (ex: `https://geonature-test.reservenaturelle.fr`) |
| `TEST_USERNAME`   | Utilisateur de test           |
| `TEST_PASSWORD`   | Mot de passe de test (⚠️ ne jamais commiter en clair) |
| `TEST_MODULES`    | Modules disponibles, au format CSV (ex: `POPAmphibien,POPReptile`) |

---

## 🚀 Exécution des tests

### Tests d'intégration recommandés (avec vraies requêtes HTTP)

```bash
# Tests d'intégration complets avec validation réseau réelle
./run_integration_tests.sh

# Tests d'intégration basiques
./test_integration_manual.sh
```

### Commandes Makefile

```bash
# Tests unitaires uniquement (rapide)
make test-unit

# Tests d'intégration Flutter (⚠️ limités par TestWidgetsFlutterBinding)
make test-integration

# Tous les tests (unit + integration)
make test-all
```

### Commandes Flutter directes

```bash
# Tests unitaires
flutter test --exclude-tags=integration

# Tests d'intégration Flutter (⚠️ HTTP bloqué)
flutter test test/integration/ --tags=integration

# Tests d'intégration avec variables d'environnement
TEST_SERVER_URL="..." TEST_USERNAME="..." TEST_PASSWORD="..." flutter test test/integration/
```

### ⚠️ Limitation importante des tests Flutter

Les tests d'intégration Flutter utilisant `TestWidgetsFlutterBinding` **bloquent toutes les vraies requêtes HTTP** et retournent systématiquement des erreurs 400. 

**Solutions recommandées :**
1. **✅ Utiliser `./run_integration_tests.sh`** pour les vrais tests d'intégration (recommandé)
2. **✅ Utiliser `./test_integration_manual.sh`** pour les tests basiques
3. **Utiliser `make test-unit`** pour les tests Flutter avec mocks
4. **Utiliser `integration_test` package** pour les tests Flutter avec réseau réel (à implémenter)

### 📋 Scripts de tests disponibles

#### `./run_integration_tests.sh` (Recommandé)
Script complet qui teste toute la chaîne d'authentification et de modules :
- ✅ Validation de la configuration `.env.test`
- ✅ Test de connectivité réseau  
- ✅ Test d'authentification avec validation JWT
- ✅ Test de récupération des modules
- ✅ Validation que POPAmphibien et POPReptile sont disponibles
- 🎯 **Utilisation : validation complète de l'environnement**

#### `./test_integration_manual.sh` 
Script basique pour tester l'authentification :
- ✅ Test de connexion simple
- ✅ Récupération du token JWT
- 🎯 **Utilisation : debug rapide de problèmes de connexion**

### Exécuter un test spécifique

```bash
flutter test test/integration/tests/01_auth_integration_test.dart
```

### Avec variables d'environnement inline

```bash
TEST_SERVER_URL="https://..." TEST_USERNAME="..." TEST_PASSWORD="..." \
  flutter test test/integration/tests/01_auth_integration_test.dart
```

---

## 📁 Structure

```
test/integration/
├── config/
│   ├── test_server_config.dart          # Configuration serveur de test
│   └── test_environment_setup.dart       # Setup/teardown global
├── helpers/
│   ├── auth_helper.dart                  # Helper authentification
│   ├── test_data_helper.dart             # Helper création données test
│   └── cleanup_helper.dart               # (À créer) Nettoyage
├── fixtures/
│   └── api_responses/                    # (À créer) Réponses API exemples
├── tests/
│   ├── 01_auth_integration_test.dart     # ✅ Tests authentification
│   ├── 02_sync_upload_test.dart          # (À créer) Tests upload
│   ├── 03_sync_download_test.dart        # (À créer) Tests download
│   ├── 04_conflict_management_test.dart  # (À créer) Tests conflits
│   └── 05_complete_workflow_test.dart    # (À créer) Tests E2E
└── README.md                             # Cette documentation
```

---

## 🖥️ Prérequis serveur

### Serveur GeoNature de test requis

Pour que les tests d'intégration fonctionnent, le serveur de test doit être configuré :

#### 1. Modules GeoNature installés

Au minimum :
- **gn_module_monitoring** (module de base)
- **POPAmphibien** (protocole amphibiens) ✅ **INSTALLÉ**
- **POPReptile** (protocole reptiles) ✅ **INSTALLÉ**

```bash
# Sur le serveur GeoNature
cd ~/geonature/backend
source venv/bin/activate

# Installer le module monitoring si nécessaire
geonature install-packaged-gn-module \
  https://github.com/PnX-SI/gn_module_monitoring/archive/X.Y.Z.zip \
  MONITORING

# Vérifier les modules installés
geonature modules list
```

#### 2. Utilisateur de test configuré

Créer un utilisateur avec les droits nécessaires :

```sql
-- Se connecter à la base de données GeoNature
psql -U geonatadmin -d geonaturedb

-- Vérifier que l'utilisateur existe
SELECT id_role, nom_role, prenom_role, email, active
FROM utilisateurs.t_roles
WHERE identifiant = '<votre_identifiant>';

-- Si l'utilisateur n'existe pas, le créer (adapter les valeurs)
INSERT INTO utilisateurs.t_roles (
  nom_role, prenom_role, identifiant, email, pass, active, id_organisme
) VALUES (
  '<NOM>', '<Prenom>', '<identifiant>', '<email@example.com>',
  '<hash_du_mot_de_passe>', true, 1
);
```

#### 3. Droits CRUVED pour les modules

L'utilisateur doit avoir les droits CRUVED sur les modules de test :

```sql
-- Vérifier les droits
SELECT r.nom_role, m.module_code, pc.*
FROM gn_commons.t_modules m
CROSS JOIN utilisateurs.t_roles r
LEFT JOIN gn_permissions.t_permissions pc
  ON pc.id_role = r.id_role
  AND pc.id_module = m.id_module
WHERE r.identifiant = '<votre_identifiant>'
  AND m.module_code IN ('POPAmphibien', 'POPReptile', 'MONITORING');

-- Accorder les droits si nécessaire (C=Create, R=Read, U=Update, V=Validate, E=Export, D=Delete)
-- Adapter selon vos besoins
```

#### 4. Données de test

Quelques données minimales pour les tests :

```sql
-- Créer des groupes de sites de test
INSERT INTO gn_monitoring.t_site_groups (sites_group_name, sites_group_code, id_module)
SELECT 'Groupe Test Amphibiens', 'TEST_AMPH', id_module
FROM gn_commons.t_modules WHERE module_code = 'POPAmphibien';

-- Créer des sites de test
INSERT INTO gn_monitoring.t_sites (
  base_site_name, base_site_code, id_sites_group, geom
) VALUES (
  'Site Test 1', 'SITE_TEST_1',
  (SELECT id_sites_group FROM gn_monitoring.t_site_groups WHERE sites_group_code = 'TEST_AMPH'),
  ST_SetSRID(ST_MakePoint(6.5, 45.0), 4326)
);

-- Vérifier
SELECT * FROM gn_monitoring.t_site_groups WHERE sites_group_code = 'TEST_AMPH';
SELECT * FROM gn_monitoring.t_sites WHERE base_site_code = 'SITE_TEST_1';
```

#### 5. Datasets configurés

Vérifier qu'il existe au moins un dataset actif :

```sql
SELECT id_dataset, dataset_name, active
FROM gn_meta.t_datasets
WHERE active = true
LIMIT 5;
```

---

## 🔄 CI/CD

### Workflow GitHub Actions

Le workflow `.github/workflows/integration_tests.yml` exécute :

1. **Unit tests** (toujours) : Tests rapides avec mocks
2. **Integration tests** (sur main/develop) : Tests avec serveur réel

### Déclenchement

- **Automatique** : Push sur `main` ou `develop`
- **Manuel** : Via l'onglet "Actions" → "Integration Tests" → "Run workflow"
- **Pull requests** : Tests unitaires uniquement (économie de temps)

### Résultats

- ✅ **Success** : Tous les tests passent
- ❌ **Failure** : Au moins un test échoue
- ⏭️ **Skipped** : Tests d'intégration non exécutés (PR ou branche autre que main/develop)

### Artifacts

Les résultats des tests sont uploadés comme artifacts dans GitHub Actions :
- **integration-test-results** : Résultats détaillés et couverture

---

## 🐛 Troubleshooting

### Erreur : "Variable d'environnement manquante"

**Cause** : Le fichier `.env.test` n'existe pas ou les variables d'environnement ne sont pas définies.

**Solution** :
```bash
# Vérifier que le fichier existe
ls -la .env.test

# Si non, copier depuis l'exemple
cp .env.test.example .env.test

# Éditer avec vos credentials
nano .env.test
```

### Erreur : "Connection refused" ou "Network error"

**Cause** : Le serveur de test n'est pas accessible.

**Solutions** :
1. Vérifier que l'URL est correcte :
   ```bash
   curl https://geonature-test.reservenaturelle.fr/api/
   ```

2. Vérifier que vous êtes sur le bon réseau (VPN si nécessaire)

3. Vérifier que le serveur est en ligne

### Erreur : "Unauthorized" ou "401"

**Cause** : Credentials invalides ou utilisateur sans droits.

**Solutions** :
1. Vérifier les credentials dans `.env.test`
2. Se connecter manuellement au serveur web pour tester
3. Vérifier que l'utilisateur a les droits CRUVED sur les modules

### Erreur : "Module not found"

**Cause** : Module non installé sur le serveur de test.

**Solution** :
1. Vérifier les modules installés :
   ```bash
   # Sur le serveur
   geonature modules list
   ```

2. Installer le module manquant (voir [Prérequis serveur](#prérequis-serveur))

### Tests qui timeout

**Cause** : Serveur lent ou problème réseau.

**Solutions** :
1. Augmenter le timeout dans le test
2. Vérifier la latence réseau :
   ```bash
   ping geonature-test.reservenaturelle.fr
   ```

3. Exécuter les tests un par un pour isoler le problème

---

## 📚 Ressources

- [Documentation GeoNature](https://docs.geonature.fr/)
- [gn_module_monitoring](https://github.com/PnX-SI/gn_module_monitoring)
- [Flutter Testing](https://docs.flutter.dev/testing)
- [GitHub Actions](https://docs.github.com/en/actions)

---

## 🤝 Contribution

Pour ajouter de nouveaux tests d'intégration :

1. Créer un fichier dans `test/integration/tests/`
2. Ajouter le tag `@Tags(['integration'])`
3. Utiliser les helpers existants (`AuthHelper`, `TestDataHelper`)
4. Suivre le pattern : `setUpAll` → `test` → `tearDownAll`
5. Documenter les scénarios testés

---

**Auteur** : Équipe GeoNature Mobile
**Date** : 6 novembre 2025
**Version** : 1.0
