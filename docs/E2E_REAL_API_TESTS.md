# Tests E2E contre un vrai serveur GeoNature

Ces tests pilotent l'application sur un téléphone Android (ou émulateur) contre
une **vraie** API GeoNature, avec une vraie base SQLite. À l'opposé des tests
mock-based de `integration_test/scenarios/`.

Fichiers : `integration_test/scenarios_real/`
Script de lancement : `run_real_e2e_tests.sh`

## Pré-requis (une seule fois)

- Un serveur GeoNature accessible (par défaut : local sur port 8001)
- Le fichier `.env.test` à la racine du projet (gitignored), copié depuis
  `.env.test.example` et adapté
- Un téléphone Android avec **débogage USB activé** (ou un émulateur)
- La config `network_security_config.xml` pour HTTP en clair en debug
  (déjà présente : `android/app/src/debug/res/xml/network_security_config.xml`)

## Démarrage rapide

```bash
adb devices                                                    # vérif téléphone
./run_real_e2e_tests.sh --device=<device_id> auth
```

Le script configure automatiquement `adb reverse` pour mapper le port du
serveur GeoNature local vers le téléphone.

## Scénarios disponibles

| Commande | Couverture |
|---|---|
| `auth` | Login OK / KO / Logout |
| `module` | Téléchargement et navigation module |
| `sites` | CRUD site (create / edit / delete) |
| `visits` | CRUD visite |
| `observations` | CRUD observation avec recherche taxon |
| `all` | Tous les scénarios à la suite |

## Procédure après reboot du PC

`adb reverse` et le mode "stayon" sont **non persistants** — ils sautent à
chaque reboot, débranchement USB ou redémarrage du serveur ADB.

```bash
# 1. Démarrer le serveur GeoNature local (cf. votre install GeoNature)

# 2. Brancher le téléphone et vérifier qu'il est détecté
adb devices

# 3. (Optionnel) Garder l'écran allumé pendant les tests
adb -s <device_id> shell svc power stayon usb

# 4. Lancer le test (le script s'occupe de adb reverse automatiquement)
./run_real_e2e_tests.sh --device=<device_id> auth
```

Si le téléphone n'est pas détecté par `adb devices` :
- Vérifier que le câble USB transmet bien les données (pas que la charge)
- Sur le téléphone, autoriser le débogage si une popup apparaît
- `adb kill-server && adb start-server` pour repartir d'un état propre

## Configuration `.env.test`

```bash
# URL du serveur (utilise 127.0.0.1 + adb reverse pour appareil physique)
TEST_SERVER_URL=http://127.0.0.1:8001

# Compte utilisateur sur le serveur
TEST_USERNAME=admin
TEST_PASSWORD=admin

# Module à tester (doit exister sur le serveur)
TEST_MODULE_CODE=POPAmphibien
```

## Pièges connus

### Ne PAS toucher l'écran pendant l'exécution
Le framework `integration_test` propage les taps physiques à l'app. Si tu vois
dans les logs des blocs `Some possible finders for the widgets at Offset(...)`,
c'est la signature d'un toucher accidentel. Pose le téléphone à plat et regarde
sans interagir.

### Sync automatique post-login
Après login, l'app lance une sync incrémentale qui affiche un `ModalBarrier`
bloquant les taps + désactive le menu burger. Le helper `loginAndReachHome()`
attend automatiquement la fin de la sync (timeout 5 min).

### Dialog de mise à jour app
Si le serveur indique qu'une mise à jour est disponible, un `AppUpdateDialog`
s'affiche en overlay et bloque tout. `dismissBlockingDialogs()` le ferme via
"Plus tard".

### Téléchargement de gros modules par accident
La recherche du bouton "Télécharger" est **scopée à la card du module cible**
via `find.descendant`. Sans ce scoping, on téléchargerait le premier module
non téléchargé visible (qui peut être un gros référentiel taxonomique).

### Compilation longue au premier lancement
`flutter test integration_test/...` recompile l'APK avec les tests embarqués
à chaque exécution (1-3 min). C'est incompressible.

### Données créées sur le serveur
Chaque test qui crée des objets (sites, visites, observations) les laisse sur
le serveur. Les noms sont préfixés `E2E_<type>_<timestamp>` pour les identifier.

## Troubleshooting

| Symptôme | Cause probable | Solution |
|---|---|---|
| `Connection refused` | `adb reverse` perdu | Relancer le script (il reconfigure automatiquement) |
| `Widget non trouve apres N min : bouton Ouvrir` | Téléchargement trop long ou serveur lent | Vérifier les logs `downloadTaxons` + augmenter le timeout |
| `Some possible finders for the widgets at Offset` | Toucher écran pendant test | Ne pas interagir, relancer |
| Tests qui timeout sur la sync | Beaucoup de modules visibles côté user | Augmenter le timeout dans `helpers/real_test_helpers.dart` |

## Architecture

```
integration_test/
├── e2e_test_app_real.dart          # RealE2ETestApp + chargement .env.test
├── scenarios_real/
│   ├── helpers/
│   │   └── real_test_helpers.dart  # Helpers partagés (login, sync, dialogs)
│   ├── real_auth_e2e_test.dart
│   ├── real_module_browsing_e2e_test.dart
│   ├── real_site_management_e2e_test.dart
│   ├── real_visit_workflow_e2e_test.dart
│   └── real_observation_workflow_e2e_test.dart
└── robots/                         # Robots réutilisés depuis les tests mock
```
