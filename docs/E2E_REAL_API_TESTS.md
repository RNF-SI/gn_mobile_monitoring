# Tests E2E contre un vrai serveur GeoNature

Ces tests pilotent l'application sur un téléphone Android (ou émulateur) contre
une **vraie** API GeoNature, avec une vraie base SQLite. À l'opposé des tests
mock-based de `integration_test/scenarios/`.

- **Fichiers** : `integration_test/scenarios_real/`
- **Serveur de test** : GeoNature + monitoring en Docker,
  `.github/geonature-e2e/` (le même que la CI)
- **Scripts de lancement** : `.github/geonature-e2e/run_scenarios.sh` (tous
  les scénarios d'un coup) ou `run_real_e2e_tests.sh` (un scénario à la fois,
  serveur au choix)
- **Modules testés** : **POPAmphibien** et **POPReptile** (protocoles de la
  **SHF - Société Herpétologique de France**). POPAmphibien utilise des
  **groupes de sites** (pas de sites directement rattachés au module), ce qui
  influence le flow de navigation des tests.

## Pré-requis (une seule fois)

- Docker avec le plugin `compose`, `git`, `curl` et `jq`
- Flutter et un JDK 17 (comme pour un build normal de l'app)
- Un téléphone Android avec **débogage USB activé**, ou un émulateur
- La config `network_security_config.xml` pour HTTP en clair en debug
  (déjà présente : `android/app/src/debug/res/xml/network_security_config.xml`)

Aucune base GeoNature n'est à récupérer : le serveur de test et ses données
se construisent depuis le dépôt.

## Démarrage rapide (GeoNature en Docker)

```bash
# 1. Monter GeoNature sur http://127.0.0.1:5000 (admin/admin).
#    Premier lancement ~10 min (installation de la base avec TAXREF),
#    quelques secondes ensuite.
.github/geonature-e2e/up.sh

# 2. Brancher le téléphone (ou lancer un émulateur) et vérifier qu'il est vu
adb devices

# 3. Lancer tous les scénarios : une passe POPAmphibien (avec le scénario
#    multi-modules), une passe POPReptile
.github/geonature-e2e/run_scenarios.sh POPAmphibien,POPReptile POPReptile

# 4. Arrêter le serveur en gardant la base…
docker compose -p gne2e -f .github/geonature-e2e/docker-compose.yml stop
#    … ou tout effacer
docker compose -p gne2e -f .github/geonature-e2e/docker-compose.yml down -v
```

`run_scenarios.sh` configure `adb reverse` pour que le téléphone atteigne le
serveur sur `localhost:5000`, et accorde la localisation en boucle pendant le
test. `DEVICE=<id>` choisit l'appareil si plusieurs sont branchés.

Le serveur n'utilise que des conteneurs et des volumes Docker du projet
`gne2e` : il ne touche à aucune install GeoNature existante. Si le port 5000
est pris, `GEONATURE_PORT=4000` (pour `up.sh` et `run_scenarios.sh`) ; le
détail est dans [`.github/geonature-e2e/README.md`](../.github/geonature-e2e/README.md).

## Avec son propre serveur GeoNature

`run_real_e2e_tests.sh` lance un scénario à la fois contre le serveur décrit
dans `.env.test` (gitignored, copié depuis `.env.test.example`) :

```bash
cp .env.test.example .env.test       # puis adapter, cf. « Configuration .env.test »
./run_real_e2e_tests.sh --device=<device_id> auth
./run_real_e2e_tests.sh --env-file=.env.test.remote all   # autre serveur
```

Pour la base Docker ci-dessus, `.env.test` contient
`TEST_SERVER_URL=http://127.0.0.1:5000`, `admin`/`admin` et
`TEST_MODULE_CODES=POPAmphibien,POPReptile`.

Avec un autre serveur, les modules de `TEST_MODULE_CODES` doivent y être
installés, avec au moins un groupe de sites ou un site, et l'utilisateur doit
avoir les droits de saisie dessus. Les tests y laissent leurs données
(préfixe `E2E_`).

Le script configure `adb reverse` pour le port de l'URL et accorde les
permissions Android (notamment la localisation) en boucle pendant le test.

## Scénarios disponibles

Commandes de `run_real_e2e_tests.sh` :

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
| `many-taxa` | — | Saisies en série sur un module à gros référentiel taxonomique |
| `cross-module` | — | Saisies sur plusieurs modules en une session, puis upload |
| `all` | — | Tous les fichiers de `scenarios_real/` |

Les autres fichiers de `scenarios_real/` ne passent que par `all` (ou
`all_scenarios_test.dart`) :

- `real_download_fidelity` : après téléchargement, groupes et sites en base
  locale identiques à ceux de l'API
- `real_site_roundtrip` : groupe et site créés sans visite → téléversement →
  vérification sur le serveur (rattachements, géométrie, types de site)
- `real_upload_roundtrip` : visite + observation marquées → téléversement →
  vérification sur le serveur
- `real_protocol_roundtrip` : aller-retour complet sur n'importe quel
  protocole, formulaires remplis par `GenericFormFiller`
- `real_site_group_module_filtering` : filtrage par module des sites d'un
  groupe (#169) ; dépend d'un jeu de données de recette (`plaquesreptiles`)
  absent de la base Docker, donc ignoré sans
  `TEST_MODULE_CODES=plaquesreptiles,POPReptile`

`all_scenarios_test.dart` regroupe tous les scénarios dans un seul binaire,
ce qui évite de recompiler l'app pour chaque fichier ; c'est lui que lancent
`run_scenarios.sh` et la CI. Le module testé est le premier de
`TEST_MODULE_CODES`, d'où un run par module.

### Les scénarios de base

Les huit scénarios de base :

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

## En CI

Le workflow `.github/workflows/e2e_real_tests.yml` lance tous les scénarios
réels chaque lundi, et à la main (onglet Actions) avant une release. Il monte
le même GeoNature Docker (`up.sh`) puis lance `run_scenarios.sh` sur un
émulateur. L'image GeoNature (par défaut
`ghcr.io/pnx-si/geonature-backend-extra:2.17.4`) se choisit au lancement
manuel ; en local, c'est la variable `GEONATURE_IMAGE` d'`up.sh`.

## Procédure après reboot du PC

`adb reverse` et le mode "stayon" sont **non persistants** — ils sautent à
chaque reboot, débranchement USB ou redémarrage du serveur ADB.

```bash
# 1. Redémarrer le serveur GeoNature (base conservée, quelques secondes)
.github/geonature-e2e/up.sh

# 2. Brancher le téléphone et vérifier qu'il est détecté
adb devices

# 3. (Optionnel) Garder l'écran allumé pendant les tests
adb -s <device_id> shell svc power stayon usb

# 4. Lancer les tests (les scripts refont adb reverse)
.github/geonature-e2e/run_scenarios.sh POPAmphibien
./run_real_e2e_tests.sh --device=<device_id> auth
```

Si le téléphone n'est pas détecté par `adb devices` :
- Vérifier que le câble USB transmet bien les données (pas que la charge)
- Sur le téléphone, autoriser le débogage si une popup apparaît
- `adb kill-server && adb start-server` pour repartir d'un état propre

## Configuration `.env.test`

```bash
# URL du serveur : 127.0.0.1 + adb reverse (fait par le script) pour un
# téléphone, 10.0.2.2 pour un émulateur
TEST_SERVER_URL=http://127.0.0.1:5000

# Compte utilisateur sur le serveur
TEST_USERNAME=admin
TEST_PASSWORD=admin

# Modules à tester (doivent exister sur le serveur)
TEST_MODULE_CODES=POPAmphibien,POPReptile
```

L'app n'ajoute pas `/api` aux routes pour `localhost`, `127.0.0.1` et les
ports 3000, 4000, 5000, 8000 et 8001 (`lib/config/config.dart`) : un serveur
local doit répondre sans `/api`, comme `geonature dev-back` ou le conteneur
Docker. Avec `10.0.2.2`, choisir un de ces ports. Un serveur distant derrière
Apache (`https://…/geonature`) prend `/api` automatiquement.

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
| `Connection refused` | `adb reverse` perdu ou serveur GeoNature pas démarré | `curl http://127.0.0.1:5000/gn_commons/config` pour vérif + relancer le script (reconfigure `adb reverse`) |
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
│   ├── helpers/                    # Helpers partagés (login, sync, dialogs,
│   │                                 formulaires, GenericFormFiller, etc.)
│   ├── all_scenarios_test.dart     # Tous les scénarios en un binaire
│   └── real_*_e2e_test.dart        # Un fichier par scénario
└── robots/                         # Robots réutilisés depuis les tests mock
    ├── login_robot.dart, home_robot.dart, etc.

.github/geonature-e2e/
├── docker-compose.yml              # PostGIS + backend GeoNature
├── up.sh                           # Monte le serveur et ses données de test
├── run_scenarios.sh                # Lance all_scenarios_test.dart par module
└── seed/                           # Droits, liste taxo, groupes et sites
```
