# Mobile-monitoring

Application mobile du module Monitoring de GeoNature, pour la saisie de données de protocoles de suivi sur smartphone.

## 📱 Description

Monitoring-mobile est une application mobile du module Monitoring de GeoNature. Elle permet la saisie de données de protocoles de suivi directement depuis un smartphone et leur envoi vers votre instance GeoNature.

## ✨ Fonctionnalités

- **Saisie terrain** : interface optimisée pour smartphone
- **Synchronisation** : envoi automatique des données vers GeoNature
- **Mode hors ligne** : saisie sans connexion, synchronisation ultérieure
- **Protocoles multiples** : support des protocoles configurés dans GeoNature
- **Formulaires dynamiques** : adaptation automatique selon le protocole

## Compatibilité des versions

| Version app mobile | GeoNature core | Monitoring serveur (min) | Code de version (à saisir côté admin GeoNature) |
|---|---|---|---|
| `v1.1.0-geonature-2.17` | 2.17.x | ≥ 1.2.6 | `2` |
| `v1.0.0-geonature-2.17` | 2.17.x | 1.2.6 | `1` |

Le **code de version** est la valeur à renseigner côté admin GeoNature (voir [Déploiement](#-déploiement-et-mise-à-jour)). Pour l'historique complet des releases, voir [`docs/VERSIONS.md`](./docs/VERSIONS.md).

L'application vérifie automatiquement la version du module Monitoring sur le serveur GeoNature avant chaque téléchargement de module. Si la version est inférieure à la version minimale requise, le téléchargement est bloqué avec un message explicatif.

Chaque ligne majeure GeoNature a sa propre branche de support : `support/geonature-2.17` et `support/geonature-2.16` pour les hotfixes. Le développement courant sur `develop` cible la prochaine compat.

## 📋 Prérequis

- Android 5.0 minimum
- GeoNature 2.16.x ou 2.17.x avec le module Monitoring correspondant (voir matrice ci-dessus)
- Compte utilisateur avec droits sur les modules

## 🚀 Installation

### Application Android (bêta)
Téléchargez la dernière version APK depuis les [Releases](../../releases).

### Depuis les sources
```bash
# Cloner le repository
git clone https://github.com/RNF-SI/gn_mobile_monitoring/
cd gn_mobile_monitoring

# Installer les dépendances
flutter pub get

# Générer le code
flutter pub run build_runner build --delete-conflicting-outputs

# Lancer l'application
flutter run
```

## ⚙️ Configuration

1. Lancer l'application
2. Saisir l'URL de votre instance GeoNature
3. Se connecter avec ses identifiants GeoNature
4. Télécharger les modules de Monitoring souhaités

## 🛠️ Développement

L'application utilise Flutter 3.38.4 (Dart 3.10.3) et suit une architecture Clean Architecture. Voir [CURSORRULES.md](./CURSORRULES.md) pour les conventions de code.

### Documentation
- [Vue d'ensemble des fonctionnalités](./docs/FEATURES_OVERVIEW.md) — types de widgets, compatibilité des modules et limitations
- [Expressions JavaScript supportées](./docs/JAVASCRIPT_EXPRESSIONS.md) — documentation technique des expressions JS
- [Tâches](./TASKS.md)
- [Snippets](./SNIPPETS.md)
- [.cursorrules](./CURSORRULES.md)
- [Fichiers de Prompts](./PROMPTS.md)

## 🧪 Tests

### Tests unitaires
```bash
make test              # Exécute les tests unitaires
make test-unit         # Alias pour les tests unitaires
```

### Tests d'intégration
Les tests d'intégration vérifient l'interaction avec les API réelles de GeoNature.

#### Configuration
1. Copier le fichier de configuration : `cp .env.test.example .env.test`
2. Configurer avec des identifiants réels (déjà configuré pour POPAmphibien/POPReptile)

#### Exécution
```bash
make test-integration              # Tests d'intégration avec vraies requêtes HTTP
make test-integration-manual       # Validation rapide de la configuration
```

Pour plus de détails, voir [la documentation des tests d'intégration](./test/integration/README.md).

#### Tests E2E contre un vrai serveur GeoNature
Tests qui pilotent l'app sur un téléphone Android contre une vraie API GeoNature
(login, navigation module, CRUD sites/visites/observations).

```bash
./run_real_e2e_tests.sh --device=<id> auth   # auth | module | sites | visits | observations | all
```

Voir [la documentation des tests E2E réels](./docs/E2E_REAL_API_TESTS.md) pour la
configuration, la procédure après reboot et le troubleshooting.

## 🔄 CI/CD

Le projet utilise GitHub Actions pour l'intégration continue :
- Tests unitaires sur chaque push
- Tests d'intégration sur les pull requests vers `develop` et `main`
- Analyse statique du code avec `flutter analyze`

Voir [.github/workflows/integration_tests.yml](.github/workflows/integration_tests.yml) pour la configuration.

## 📦 Déploiement et mise à jour

### Publier une nouvelle version

1. Compiler l'APK : `flutter build apk --release`
2. Créer une release sur GitHub avec l'APK en pièce jointe

### Configurer le serveur GeoNature

Pour que les utilisateurs soient notifiés des mises à jour, l'administrateur du serveur GeoNature doit :

1. **Créer le dossier et le fichier de configuration** :
   ```bash
   mkdir -p <GEONATURE>/backend/media/mobile/monitoring/
   echo '{}' > <GEONATURE>/backend/media/mobile/monitoring/settings.json
   ```

2. **Déposer l'APK** (téléchargé depuis les releases GitHub) :
   ```bash
   cp monitoring-v<X.Y.Z>-geonature-<M.m>.apk <GEONATURE>/backend/media/mobile/monitoring/monitoring.apk
   ```

   > ⚠️ **Le nom du fichier sur le serveur doit correspondre EXACTEMENT au champ « Chemin relatif » de l'admin** (étape 3). L'app construit l'URL de téléchargement directement à partir de ce chemin — un nom différent → 404 → la mise à jour reste bloquée en chargement chez l'utilisateur.
   >
   > La convention est de renommer en `monitoring.apk` (URL stable d'une release à l'autre, le chemin admin ne change jamais — seul le **Code de version** est à incrémenter à chaque release).

3. **Enregistrer l'application** dans l'admin GeoNature :
   - Aller dans **Administration > Autres > Applications mobiles**
   - Créer une entrée avec :

   | Champ | Valeur |
   |-------|--------|
   | Code application | `MONITORING` |
   | Chemin relatif de l'APK | `monitoring/monitoring.apk` |
   | Nom du paquet | `fr.geonature.monitoring` |
   | Code de version | Valeur publiée avec chaque release — voir le tableau [Compatibilité des versions](#compatibilité-des-versions) ou [`docs/VERSIONS.md`](./docs/VERSIONS.md). Pour la release `v1.0.0`, c'est `1`. |

   > ⚠️ **Code de version** : ne pas confondre avec le nom de version (`1.0.0`). C'est un entier strictement croissant, fixé à la compilation (buildNumber de `pubspec.yaml`), que l'admin doit saisir tel quel. L'app ne propose une mise à jour que si la valeur admin est **strictement supérieure** à celle de l'APK installé.

4. **Mettre à jour** : lors d'une nouvelle version, **remplacer le fichier `monitoring.apk`** sur le serveur (en renommant le nouvel APK téléchargé) et incrémenter le **Code de version** dans l'admin. Le chemin relatif reste inchangé.

L'application vérifie automatiquement au lancement et après chaque synchronisation si une mise à jour est disponible.

## 🤝 Contribution

Les contributions sont bienvenues ! N'hésitez pas à ouvrir une issue ou proposer une PR.

## 🐛 Support

Pour tout problème ou question, ouvrir une issue sur ce repository.
