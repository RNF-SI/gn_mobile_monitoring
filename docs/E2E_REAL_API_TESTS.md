# Tests E2E contre un vrai serveur GeoNature

Ces tests pilotent l'application sur un téléphone Android (ou émulateur) contre
une **vraie** API GeoNature, avec une vraie base SQLite. À l'opposé des tests
mock-based de `integration_test/scenarios/`.

- **Fichiers** : `integration_test/scenarios_real/`
- **Script de lancement** : `run_real_e2e_tests.sh`
- **Module cible par défaut** : **POPAmphibien** (module de suivi du protocole
  POPAmphibien de la **SHF - Société Herpétologique de France**). Le module a
  la particularité d'utiliser des **groupes de sites** (pas de sites directement
  rattachés au module), ce qui influence le flow de navigation des tests.

## Pré-requis (une seule fois)

- Un serveur GeoNature accessible (par défaut : local sur port 8001)
- Le fichier `.env.test` à la racine du projet (gitignored), copié depuis
  `.env.test.example` et adapté
- Un téléphone Android avec **débogage USB activé** (ou un émulateur)
- La config `network_security_config.xml` pour HTTP en clair en debug
  (déjà présente : `android/app/src/debug/res/xml/network_security_config.xml`)
- Le module POPAmphibien doit exister côté serveur avec au moins un groupe de
  sites (sinon adapter `TEST_MODULE_CODE` dans `.env.test`)

## Démarrage rapide

```bash
adb devices                                                    # vérif téléphone
./run_real_e2e_tests.sh --device=<device_id> auth
```

Le script configure automatiquement `adb reverse` pour mapper le port du
serveur GeoNature local vers le téléphone, et pré-accorde les permissions
Android (notamment la localisation) en boucle pendant toute la durée du test.

## Scénarios disponibles

| Commande | Tests | Couverture |
|---|---|---|
| `auth` | 3 | Login OK / KO / Logout |
| `module` | 3 | Téléchargement et navigation module |
| `sites` | 1 | CRUD site (create / edit / delete) |
| `groups` | 1 | CRUD groupe de sites |
| `visits` | 1 | CRUD visite |
| `observations` | 1 | CRUD observation avec recherche taxon |
| `sync-download` | 1 | Menu « Mettre à jour les données » → confirmation → sync OK |
| `sync-upload` | 1 | Menu « Téléversement » → confirmation → upload OK |
| `all` | 12 | Enchaîne tous les scénarios ci-dessus |

### Ce que couvre `all`

L'exécution `all` lance les **12 tests** à la suite (~18-22 min au total) pour
valider l'intégration bout-en-bout :

1. **auth** : login valide → HomePage, login invalide → reste sur LoginPage,
   logout → retour LoginPage (nettoie la DB locale)
2. **module** : POPAmphibien visible dans la liste, téléchargement complet,
   ouverture et navigation dans le module
3. **sites** : création d'un site `E2E_Site_<timestamp>` dans un groupe
   existant, modification du nom, suppression
4. **groups** : création d'un groupe `E2E_Group_<timestamp>` avec nomenclature
   Habitat principal, modification, suppression
5. **visits** : création d'une visite sur un site existant avec
   `accessibility=Non` (stratégie qui masque les champs requis conditionnels)
6. **observations** : création d'une visite puis d'une observation avec
   `presence=Non` (stratégie qui masque cd_nom, count, sexe, stade, etc.)
7. **sync-download** : ouverture du menu burger → « Mettre à jour les
   données » → dialog de confirmation → attente fin de sync sans erreur
8. **sync-upload** : pré-requis download (pour passer la garde « < 7 jours »
   du `SyncService`) → menu burger → « Téléversement » → confirmation →
   attente fin sans erreur

Chaque test crée ses propres données avec un timestamp pour éviter les
collisions, et les laisse sur le serveur (préfixe `E2E_` pour identifier).

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
# URL du serveur (utilise 127.0.0.1 + adb reverse pour appareil physique,
# ou 10.0.2.2 pour émulateur)
TEST_SERVER_URL=http://127.0.0.1:8001

# Compte utilisateur sur le serveur
TEST_USERNAME=admin
TEST_PASSWORD=admin

# Module à tester (doit exister sur le serveur)
TEST_MODULE_CODE=POPAmphibien
```

## Helpers disponibles (`real_test_helpers.dart`)

### Navigation
- `loginAndReachHome(tester, testApp, config)` — login + sync + dismiss dialogs
- `downloadAndOpenModule(tester, moduleCode)` — télécharge + ouvre le module
  (scopé au module cible)
- `tapTab(tester, tabText)` — tap sur un onglet par son texte
- `tapFirstListCard(tester, {skipFirst})` — tap sur le premier Card visible
- `waitForNavigation`, `waitForSyncToFinish` — attentes actives

### Formulaires
- `enterFormField(tester, fieldName, value, {isRequired})` — saisie texte +
  cache clavier auto + dump des keys en cas d'échec
- `pickFormDate(tester, fieldName, {isRequired})` — ouvre le DatePicker et
  confirme (date du jour)
- `selectFirstSelectOption(tester, fieldName)` — dropdown `select_*`
- `selectFirstNomenclature(tester, typeCode)` — dropdown `nomenclature_*`
- `tapRadioOption(tester, label)` — tap sur un radio via son ListTile parent
- `tapFormSave(tester)` — tap sur save + **polling actif** jusqu'à fermeture
  du form avec dismiss auto des dialogs qui apparaissent (45s max)
- `expectFormClosed(tester)` — vérif + dump diagnostic si échec

### Dialogs
- `dismissBlockingDialogs(tester, {timeout})` — ferme en **polling actif**
  pendant [timeout] tous les dialogs connus :
  - `AppUpdateDialog` ("Mise à jour disponible") → "Plus tard"
  - `_askForVisit` ("Créer une visite ?") → "Non"
  - `_askForObservation` ("Créer une observation ?") → "Non"
  - `AlertDialog` générique → OK/Fermer/Annuler/Plus tard/Non

### Autres
- `hideKeyboard(tester)` — cache le clavier mobile (nécessaire avant de
  chercher `form-save-button` qui est masqué quand clavier visible)
- `uniqueName(prefix)` — génère `E2E_<prefix>_<timestamp>` pour éviter
  collisions
- `pumpFor(tester, duration)` — attente brute (à éviter si possible, préférer
  `waitForWidget`)
- `waitForWidget(tester, finder, {timeout})` — attente active

## Pièges connus et apprentissages

### Ne PAS toucher l'écran pendant l'exécution
Le framework `integration_test` propage les taps physiques à l'app. Si tu vois
dans les logs des blocs `Some possible finders for the widgets at Offset(...)`,
c'est la signature d'un toucher accidentel. Pose le téléphone à plat et regarde
sans interagir.

### Pas de watcher uiautomator pour les popups
On a essayé un watcher bash `uiautomator dump + input tap` pour auto-accepter
les popups de permission. **À éviter** : le dump prend ~1-2s pendant lesquelles
l'UI peut changer, et le tap tombe alors sur le mauvais widget (source majeure
de flakiness). On utilise uniquement `adb shell pm grant` en boucle rapide.

### Utiliser polling actif au lieu de `pumpFor` fixe
Les `await pumpFor(tester, Duration(seconds: 5))` sont une source de flakiness
(si l'API est lente, on passe à l'étape suivante trop tôt). Préférer :
- `waitForWidget(tester, finder)` pour attendre qu'un widget apparaisse
- `_waitForFormClosedOrDismiss()` pour attendre la fermeture d'un formulaire
  en dismissant les dialogs entre-temps

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
non téléchargé visible (qui peut être un gros référentiel taxonomique de
plusieurs centaines de milliers d'entrées).

### POPAmphibien utilise des groupes de sites
`cor_site_module` est vide pour ce module — tous les sites passent par des
groupes. Conséquences pour les tests :
- Pas d'onglet "Sites" sur la page module, juste la liste des groupes directement
- Pour créer un site, il faut d'abord **naviguer dans un groupe**
  (tap sur l'icône `Icons.visibility` du groupe) puis utiliser
  `create-site-button` sur la `SiteGroupDetailPage`

### Champs requis conditionnels dans les formulaires
Les formulaires visite/observation ont de nombreux champs requis conditionnels
(via `hidden_expression_evaluator`). **Stratégie efficace pour les tests** :
- **Visite** : `accessibility = 'Non'` masque Heure_debut, Heure_fin,
  methode_de_prospection, etat_site, date_changement_etat_site
- **Observation** : `presence = 'Non'` masque cd_nom, count_min/max,
  id_nomenclature_sex/stade/typ_denbr

Ça permet de ne remplir que les champs vraiment obligatoires (nom, date,
expertise pour visite ; presence pour observation).

### Le bouton `form-save-button` est masqué quand le clavier est visible
Le layout `BaseFormLayout` utilise `if (!isKeyboardVisible) _buildActionButtons`.
Après une saisie texte (`enterText`), appeler `hideKeyboard()` AVANT de chercher
`form-save-button`, sinon il n'existe pas dans le widget tree. Le helper
`enterFormField()` le fait automatiquement.

### Compilation longue au premier lancement
`flutter test integration_test/...` recompile l'APK avec les tests embarqués
à chaque exécution (1-3 min). C'est incompressible.

### Données créées sur le serveur
Chaque test qui crée des objets (sites, visites, observations) les laisse sur
le serveur. Les noms sont préfixés `E2E_<type>_<timestamp>` pour les identifier.
Le backend accumule les données au fil des runs — prévoir un nettoyage manuel
occasionnel ou un compte utilisateur dédié aux tests.

### Accumulation = tests de plus en plus lents en mode `all`
En mode cumulé (`all`), chaque test laisse des données sur le serveur. Plus la
suite progresse, plus le backend est lent (listes plus longues, syncs plus
coûteuses). Les timeouts des tests en tiennent compte (jusqu'à 45s pour
certaines opérations).

## Troubleshooting

| Symptôme | Cause probable | Solution |
|---|---|---|
| `Connection refused` | `adb reverse` perdu ou serveur GeoNature pas démarré | `curl http://127.0.0.1:8001/` pour vérif + relancer le script (reconfigure `adb reverse`) |
| `Widget non trouve apres N min : bouton Ouvrir` | Téléchargement trop long ou serveur lent | Vérifier les logs `downloadTaxons` + augmenter le timeout |
| `Some possible finders for the widgets at Offset` | Toucher écran pendant test | Ne pas interagir, relancer |
| `Champ "X" introuvable` | Widget custom avec key différente | Le helper dumpe les ValueKeys présentes pour debug — adapter le test en conséquence |
| `Le formulaire est toujours ouvert apres save. Validation echouee ?` | Champ requis non rempli | Le helper dumpe les textes visibles — identifier le(s) champ(s) avec `*` non rempli(s) |
| Tests qui timeout sur la sync | Beaucoup de modules visibles côté user | Augmenter le timeout dans `waitForSyncToFinish` |
| Popup permission location qui apparaît | `pm grant` pas assez rapide | Le watcher devrait la prévenir, sinon accepter manuellement une fois |

## Architecture

```
integration_test/
├── e2e_test_app_real.dart          # RealE2ETestApp + chargement .env.test
├── scenarios_real/
│   ├── helpers/
│   │   └── real_test_helpers.dart  # Helpers partagés (login, sync, dialogs,
│   │                                 formulaires, dropdowns, radio, etc.)
│   ├── real_auth_e2e_test.dart
│   ├── real_module_browsing_e2e_test.dart
│   ├── real_site_management_e2e_test.dart
│   ├── real_site_group_e2e_test.dart
│   ├── real_visit_workflow_e2e_test.dart
│   ├── real_observation_workflow_e2e_test.dart
│   ├── real_sync_download_e2e_test.dart
│   └── real_sync_upload_e2e_test.dart
└── robots/                         # Robots réutilisés depuis les tests mock
    ├── login_robot.dart, home_robot.dart, etc.
```
