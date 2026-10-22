# Widget de sélection multiple de nomenclatures

> Documentation mise à jour en septembre 2026 (v1.1.1+3, après les correctifs de l'audit des formulaires). Tout ce qui suit a été vérifié dans le code. Les numéros de ligne donnés entre parenthèses peuvent avoir légèrement bougé depuis.

## Vue d'ensemble

Le `MultipleNomenclatureSelectorWidget` permet de sélectionner plusieurs nomenclatures à la fois dans les formulaires dynamiques de l'application GeoNature Mobile Monitoring. Il affiche une liste de cases à cocher et produit une liste d'IDs de nomenclatures (`List<int>`).

## Contexte

L'application prend en charge :
- ✅ **Sélection simple de nomenclatures** via `NomenclatureSelectorWidget` (dropdown)
- ✅ **Sélection multiple de valeurs statiques** via `_buildMultiSelectDatalist` (checkboxes)
- ✅ **Sélection multiple de nomenclatures** via `MultipleNomenclatureSelectorWidget` (checkboxes), ajoutée en octobre 2025 (commit `dffe791`)

Le module POPAmphibien de la SHF a été le premier à nécessiter la sélection multiple de nomenclatures (champ `methode_de_prospection`). C'est ce besoin qui a conduit à créer ce widget.

## Fichiers concernés

### Widgets

1. **Widget de saisie** : [`lib/presentation/widgets/multiple_nomenclature_selector_widget.dart`](../lib/presentation/widgets/multiple_nomenclature_selector_widget.dart)
   - `ConsumerStatefulWidget` qui affiche une liste de `CheckboxListTile`
   - Paramètres : `label`, `fieldConfig`, `onChanged` (`ValueChanged<List<int>?>`), `value` (`List<int>?`), `isRequired`, `description`
   - Il émet `null` (et non une liste vide) quand plus rien n'est coché
   - Il déclare aussi son propre `nomenclaturesByTypeProvider` (voir [Limitations connues](#limitations-connues))

2. **Widget d'affichage** : [`lib/presentation/widgets/multiple_nomenclature_display_widget.dart`](../lib/presentation/widgets/multiple_nomenclature_display_widget.dart)
   - `MultipleNomenclatureDisplayWidget(nomenclatureIds, typeCode)` affiche les labels séparés par des virgules
   - ⚠️ **Il n'est utilisé nulle part dans `lib/`** (code mort). L'affichage en détail passe par `PropertyDisplayWidget` (voir [Affichage en détail](#4-affichage-en-détail))

### Fichiers impliqués dans le flux

| Fichier | Rôle |
|---------|------|
| [`lib/core/helpers/form_config_parser.dart`](../lib/core/helpers/form_config_parser.dart) | Conserve `multiple` dans le schéma unifié (`_convertGenericFieldToMap` et `generateUnifiedSchema`). Détecte les champs nomenclature (`isNomenclatureField`, l.259) et choisit le widget (`determineWidgetType`, l.531) |
| [`lib/presentation/widgets/dynamic_form_builder.dart`](../lib/presentation/widgets/dynamic_form_builder.dart) | `_buildNomenclatureField()` (l.2085) détecte `multiple: true` et délègue à `_buildMultipleNomenclatureField()` (l.2174) |
| [`lib/presentation/widgets/property_display_widget.dart`](../lib/presentation/widgets/property_display_widget.dart) | Résout les listes d'IDs en labels sur les pages de détail (`_enrichDataWithNomenclatures`, branche `fieldValue is List` l.151). Ajouté en janvier 2026 (commit `dc3f798`) |
| [`lib/core/helpers/value_formatter.dart`](../lib/core/helpers/value_formatter.dart) | `formatList()` (l.39) : texte de repli quand les IDs n'ont pas été résolus |
| [`lib/presentation/viewmodel/form_data_processor.dart`](../lib/presentation/viewmodel/form_data_processor.dart) | `processFormData()` normalise les nomenclatures des observations, sites et groupes de sites (voir [Sauvegarde](#3-sélection--sauvegarde)) |
| [`lib/presentation/viewmodel/site_visits_viewmodel.dart`](../lib/presentation/viewmodel/site_visits_viewmodel.dart) | `_extractModuleSpecificData()` conserve la liste telle quelle pour les visites (l.479) |
| [`lib/data/datasource/implementation/api/visits_api_impl.dart`](../lib/data/datasource/implementation/api/visits_api_impl.dart) | Copie les données complémentaires dans `properties` sans transformation (l.75 et l.278) |
| [`lib/core/helpers/json_parser_helper.dart`](../lib/core/helpers/json_parser_helper.dart) | Reconvertit en vraies listes les tableaux stockés sous forme de chaîne (`"[1, 2]"`) |

### Tests

- [`test/presentation/widgets/multiple_nomenclature_selector_test.dart`](../test/presentation/widgets/multiple_nomenclature_selector_test.dart) : 8 tests du widget
- [`test/core/helpers/form_config_parser_multiple_test.dart`](../test/core/helpers/form_config_parser_multiple_test.dart) : 5 tests du parser
- [`test/core/helpers/json_parser_array_test.dart`](../test/core/helpers/json_parser_array_test.dart) : 10 tests du parsing des tableaux
- [`test/core/helpers/value_formatter_test.dart`](../test/core/helpers/value_formatter_test.dart) : couvre notamment le texte de repli des listes d'IDs

## Utilisation

### Configuration JSON

Deux configurations mènent au widget multiple. Dans les deux cas, il faut `multiple: true`.

**Variante `datalist` + API de nomenclatures** (format du module POPAmphibien) :

```json
{
  "methode_de_prospection": {
    "type_widget": "datalist",
    "attribut_label": "Méthode(s) de prospection",
    "api": "nomenclatures/nomenclature/METHODE_PROSPECTION",
    "application": "GeoNature",
    "keyValue": "id_nomenclature",
    "keyLabel": "label_fr",
    "multiple": true,
    "data_path": "values",
    "type_util": "nomenclature",
    "required": "({value}) => value.accessibility === 'Oui'",
    "hidden": "({value}) => value.accessibility === 'Non'"
  }
}
```

**Variante `type_widget: nomenclature`** :

```json
{
  "methode_de_prospection": {
    "type_widget": "nomenclature",
    "code_nomenclature_type": "METHODE_PROSPECTION",
    "multiple": true
  }
}
```

### Sélection du widget

`FormConfigParser.determineWidgetType()` renvoie `NomenclatureSelector` dès que `isNomenclatureField()` reconnaît le champ, c'est-à-dire si **l'un** des critères suivants est rempli :

- `type_widget: "nomenclature"`
- `type_util: "nomenclature"`
- `api` contient `nomenclatures/nomenclature/`
- présence de `code_nomenclature_type`
- `attribut_name` commence par `id_nomenclature_`

Le parser ne choisit pas entre simple et multiple. C'est `DynamicFormBuilder._buildNomenclatureField()` qui choisit le widget multiple si `multiple == true` (clé du widget `datalist` web) **ou** `multi_select == true` (clé du widget `nomenclature` web, prise en charge depuis septembre 2026). Seul le booléen `true` est accepté. Dans la partie `generic`, le modèle convertit `"true"` en booléen (`_toBool`). Dans la partie `specific`, la config est lue telle quelle : la chaîne `"true"` y donne le widget simple.

### Propriétés clés

| Propriété | Valeur | Description |
|-----------|--------|-------------|
| `type_widget` | `"datalist"` ou `"nomenclature"` | Type de widget de base |
| `api` | `"nomenclatures/nomenclature/XXX"` | Suffit à faire traiter le champ comme une nomenclature. Le type (`XXX`) est le dernier segment de l'URL |
| `code_nomenclature_type` | `"XXX"` | Prioritaire sur `api` pour déterminer le type |
| `type_util` | `"nomenclature"` | Marque le champ comme nomenclature (facultatif si `api` est présent) |
| **`multiple`** | **`true`** (booléen) | **Active la sélection multiple** (widget `datalist`) |
| **`multi_select`** | **`true`** (booléen) | **Active la sélection multiple** (widget `nomenclature`, comme sur le web) |
| `keyValue`, `keyLabel`, `data_path`, `application` | — | **Ignorés** par le widget : l'ID est toujours `id_nomenclature` et le label vient de `label_fr`, sinon `label_default`, sinon `cd_nomenclature` |

### Format de données

#### Sauvegarde

Le formulaire stocke une **liste d'IDs** (`List<int>`), dans l'ordre où les cases ont été cochées :

```json
{
  "methode_de_prospection": [654, 657, 659]
}
```

Si l'utilisateur décoche tout (ou clique sur « Tout désélectionner »), la clé est **retirée** de `_formValues`. On n'enregistre jamais de liste vide.

#### Chargement

`_buildMultipleNomenclatureField()` convertit la valeur existante avant de la passer au widget :

```dart
// Liste d'IDs (format normal)
[654, 657, 659]                 →  [654, 657, 659]

// Liste de chaînes numériques
["654", "657"]                  →  [654, 657]

// Liste d'objets (id entier ou chaîne numérique)
[{"id": 654}, {"id": "657"}]    →  [654, 657]

// Valeur seule : entier, chaîne numérique ou objet
657  /  "657"  /  {"id": "657"} →  [657]
```

Cas non pris en charge (le champ s'affiche vide) :
- objet sans `id`, par exemple `{"cd_nomenclature": "X", "code_nomenclature_type": "T"}` ;
- `null` ou clé absente, qui donnent simplement une sélection vide.

Jusqu'en septembre 2026, un `{"id": "657"}` (id en chaîne) faisait planter la construction du champ (cast `as int`) ; test : `test/presentation/widgets/multiple_nomenclature_initial_value_test.dart`.

Les tableaux stockés sous forme de chaîne (`"[654, 657]"`) sont reconvertis en listes par `JsonParserHelper` à la lecture de la base, avant d'arriver au formulaire.

#### Valeur par défaut (`value` dans la config)

Le formulaire pré-remplit un champ à partir de la clé `value` de la config (et non `default`). Pour un `NomenclatureSelector`, `_setDefaultValueByType()` (l.345) ne garde que deux formes :
- un `int`, qui devient `{"id": n}` puis `[n]` ;
- une `Map`.

**Une liste en valeur par défaut est ignorée.** Le mécanisme de défaut par `cd_nomenclature` du widget simple (`getSelectedNomenclatureCode`) n'est pas repris dans la branche multiple.

## Fonctionnalités

### Interface utilisateur

Le widget affiche :

1. **Label et description**
   - Label suivi de ` *` si le champ est requis
   - Description en italique grise si `description` est renseignée

2. **En-tête avec compteur**
   - Icône `Icons.checklist`
   - Nombre d'éléments sélectionnés (ex : « 2 sélectionné(s) »)
   - Bouton « Tout désélectionner », visible s'il y a au moins une sélection

3. **Liste de nomenclatures**
   - Une `CheckboxListTile` compacte (`dense`) par nomenclature, case à gauche
   - Label : `labelFr`, sinon `labelDefault`, sinon `cdNomenclature`
   - Toutes les nomenclatures du type, dans l'ordre renvoyé par le service
   - **Pas de hauteur maximale ni de scroll interne** : depuis avril 2026 (commit `0ed6612`, issue #181), la liste est une `Column` qui prend sa hauteur naturelle. L'ancienne `ListView` limitée à 300 px bloquait le scroll de la page.

4. **Indication « requis »**
   - Bandeau rouge « Au moins une sélection est requise » quand le champ est requis et vide
   - L'état requis vient de `FormDataProcessor.isFieldRequired()`, qui évalue aussi les expressions `required`
   - ⚠️ Ce message est **seulement visuel** (voir [Limitations connues](#limitations-connues))

5. **États de chargement**
   - `CircularProgressIndicator` pendant le chargement
   - « Aucune nomenclature disponible » si le type n'a aucune valeur en base
   - « Erreur de chargement: … » en rouge en cas d'erreur
   - « Type de nomenclature non spécifié » si aucun type n'a pu être déduit de la config

### Exemple visuel

```
Méthode(s) de prospection *
Sélectionnez une ou plusieurs méthodes
┌─────────────────────────────────────────┐
│ ✓ 2 sélectionné(s)  [Tout désélectionner]│
├─────────────────────────────────────────┤
│ ☑ Capture au filet troubleau            │
│ ☑ Observation à vue                     │
│ ☐ Écoute                                │
│ ☐ Recherche d'indices de présence       │
└─────────────────────────────────────────┘
```

## Flux de données

### 1. Configuration → Widget

```
Configuration JSON
    ↓
FormConfigParser.generateUnifiedSchema()
    ↓ (conserve `multiple`, calcule widget_type via determineWidgetType)
DynamicFormBuilder._buildFieldWidget()
    ↓ (widget_type == 'NomenclatureSelector')
_buildNomenclatureField()
    ↓ (fieldConfig['multiple'] == true)
_buildMultipleNomenclatureField()   ← conversion de la valeur en List<int>
    ↓
MultipleNomenclatureSelectorWidget
```

### 2. Chargement des nomenclatures

```
MultipleNomenclatureSelectorWidget
    ↓
FormConfigParser.getNomenclatureTypeCode(fieldConfig)
    ↓
nomenclaturesByTypeProvider(typeCode)   (autoDispose, rafraîchi par cacheVersionProvider)
    ↓
NomenclatureService.getNomenclaturesByTypeCode()
    ↓
Cache mémoire du service, sinon base locale
    ↓
List<Nomenclature>
```

Tout fonctionne hors ligne : les nomenclatures doivent avoir été téléchargées au préalable avec le module.

### 3. Sélection → Sauvegarde

```
L'utilisateur coche une case
    ↓
_toggleNomenclature(id)
    ↓
_selectedIds.add(id) ou .remove(id)
    ↓
widget.onChanged(liste, ou null si vide)
    ↓
DynamicFormBuilder._formValues[fieldName] = [ids...]   (clé supprimée si null)
    ↓
getFormValues()   (filtre les champs cachés, voir plus bas)
```

La suite dépend de l'objet enregistré :

| Objet | Traitement | Résultat |
|-------|------------|----------|
| **Visite** | `FormDataProcessor.processFormData()` (depuis septembre 2026), puis `SiteVisitsViewModel._extractModuleSpecificData()` | Liste d'IDs stockée dans `t_visit_complements.data` (JSON) |
| **Observation, site, groupe de sites** | `FormDataProcessor.processFormData()` | Liste conservée ; pour un champ `id_nomenclature_*`, chaque élément est normalisé en ID entier (`int`, chaîne numérique ou `{"id": …}`), les éléments invalides sont écartés. Avant septembre 2026, ces listes étaient **supprimées** |

### 4. Affichage en détail

Les pages de détail (`DetailPage`, donc aussi visites, sites et observations) passent par `PropertyDisplayWidget._enrichDataWithNomenclatures()`. Pour un champ nomenclature (reconnu dans la config ou préfixé `id_nomenclature_`) dont la valeur est une `List` :

1. chaque élément est converti en ID (`int`, chaîne numérique ou `{"id": …}`) ;
2. chaque ID est résolu avec `NomenclatureService.getNomenclatureNameById()` (cache, puis base) ;
3. la valeur devient `{"items": [{id, label}, …], "label": "Label 1, Label 2"}`, et c'est le `label` qui s'affiche.

Cas particuliers :
- **Aucun ID résolu** : la liste brute est conservée, et `ValueFormatter.formatList()` affiche « 3 nomenclatures sélectionnées (IDs: 654, 657, 659) ».
- **Résolution partielle** : les IDs introuvables sont **omis sans avertissement**. Seuls les labels trouvés sont affichés.
- **Liste vide** : « Non renseigné ».

Dans les **tableaux** (par exemple la liste des observations d'une visite, `DetailPage.formatDataCellValue()`), les IDs ne sont pas résolus :
- `type_widget: "nomenclature"` affiche la liste brute (`[654, 657]`) ;
- les autres types passent par `ValueFormatter` et affichent « N nomenclatures sélectionnées (IDs: …) ».

### 5. Synchronisation (upload)

Pour les visites, `VisitsApiImpl.sendVisit()` / `updateVisit()` recopie chaque clé de `visit.data` dans `properties` **sans transformation**. Le serveur reçoit donc :

```json
{
  "properties": {
    "methode_de_prospection": [654, 657, 659]
  }
}
```

Aucune conversion `cd_nomenclature` → ID n'est faite sur les listes : elles doivent déjà contenir des IDs.

### 6. Champs cachés et expressions

- `hidden` et `required` acceptent les expressions JavaScript décrites dans [`JAVASCRIPT_EXPRESSIONS.md`](JAVASCRIPT_EXPRESSIONS.md). Un champ caché n'est pas rendu.
- Dans `getFormValues()`, un champ caché n'est gardé que si `required == true` (booléen littéral) ou s'il a été rempli par une règle `change`. Un champ caché dont le `required` est une **expression** est donc retiré de la sauvegarde.
- Les expressions peuvent **lire** la valeur d'un champ multiple comme sur le web : c'est une liste d'IDs (`value.methode_de_prospection.includes(654)`, `.length`, `.some(id => …)`), et `meta.nomenclatures[id]` donne la nomenclature complète (`cd_nomenclature`, `label_fr`…).

## Tests

### Tests du widget (8 tests)

```bash
flutter test test/presentation/widgets/multiple_nomenclature_selector_test.dart
```

1. ✅ Affichage de la liste avec checkboxes
2. ✅ Sélection de plusieurs éléments
3. ✅ Désélection d'éléments
4. ✅ Bouton « Tout désélectionner »
5. ✅ Message si le champ est requis et vide
6. ✅ Pas de message si le champ est requis et a une sélection
7. ✅ Indicateur de chargement
8. ✅ Gestion de liste vide

### Tests du parser (5 tests)

```bash
flutter test test/core/helpers/form_config_parser_multiple_test.dart
```

1. ✅ Préservation de `multiple: true`
2. ✅ Préservation de `multiple: false`
3. ✅ Absence de `multiple` quand non spécifié
4. ✅ Support pour champs select
5. ✅ Fusion de `multiple` depuis config specific

### Tests du parsing des tableaux (10 tests)

```bash
flutter test test/core/helpers/json_parser_array_test.dart
```

Ils vérifient la reconversion en listes des tableaux stockés sous forme de chaîne (`"[1034, 1035]"`, format « dict Python », virgules entre crochets ou parenthèses).

### Tests de non-régression (audit septembre 2026)

- `test/presentation/viewmodel/form_data_processor_test.dart` : conservation et normalisation des listes `id_nomenclature_*` par `processFormData()` ;
- `test/presentation/widgets/multiple_nomenclature_initial_value_test.dart` : valeurs initiales avec ID en chaîne, clé `multi_select`, via `DynamicFormBuilder` ;
- `integration_test/scenarios/audit_bugs_e2e_test.dart` (émulateur) : sélection de deux cases puis traitement d'enregistrement.

> Dernière exécution (septembre 2026) : tous ces tests passent.

**Non couvert par les tests** : l'enrichissement par `PropertyDisplayWidget`, `MultipleNomenclatureDisplayWidget` et le payload de synchronisation.

## Comparaison avec les widgets existants

| Widget | Sélection | Composant UI | Format de sortie | Cas d'usage |
|--------|-----------|--------------|------------------|-------------|
| `NomenclatureSelectorWidget` | Simple | DropdownButtonFormField | `Map<String, dynamic>` (converti en `int` à la sauvegarde) | Nomenclature unique |
| **`MultipleNomenclatureSelectorWidget`** | **Multiple** | **CheckboxListTile** | **`List<int>`** | **Nomenclatures multiples** |
| `_buildMultiSelectDatalist` | Multiple | CheckboxListTile | `List<String>` | Valeurs statiques multiples |

## Architecture

### Responsabilités

- **MultipleNomenclatureSelectorWidget** :
  - Chargement des nomenclatures du type via `nomenclaturesByTypeProvider`
  - Affichage de la liste de checkboxes
  - Gestion de l'état des sélections (`_selectedIds`, un `Set<int>` resynchronisé dans `didUpdateWidget`)
  - Communication avec le parent via `onChanged`
  - Indication visuelle du caractère requis

- **DynamicFormBuilder** :
  - Détection de `multiple: true`
  - Conversion des valeurs initiales en `List<int>`
  - Stockage dans `_formValues` (clé supprimée si vide)
  - Filtrage des champs cachés dans `getFormValues()`

- **FormConfigParser** :
  - Conservation de la propriété `multiple`
  - Détection des nomenclatures et conversion `datalist` + API nomenclature → `NomenclatureSelector`
  - Extraction du code de type (`getNomenclatureTypeCode`)

- **PropertyDisplayWidget** :
  - Résolution des listes d'IDs en labels pour l'affichage en détail

### Principe de conception

Le choix d'un widget séparé (plutôt que de modifier `NomenclatureSelectorWidget`) suit le **principe de responsabilité unique** :

- Chaque widget a une responsabilité claire
- Code plus simple et maintenable
- Tests séparés et plus clairs
- Pas de risque de régression sur le widget existant

## Compatibilité

### Backend GeoNature

Le format `List<int>` correspond à celui du module Monitoring web, qui stocke les nomenclatures multiples sous forme de tableau d'IDs dans le JSON `data` :

```json
{
  "methode_de_prospection": [654, 657, 659]
}
```

### Migration des données

Les anciennes données au format entier ou `{"id": n}` sont converties **à l'affichage du formulaire** :

```dart
// Ancien format (int)
657

// Format affiché puis réenregistré (List<int>)
[657]
```

La valeur n'est réécrite qu'au prochain enregistrement du formulaire. Aucune migration n'est faite en base.

## Exemples d'utilisation

### Module POPAmphibien (SHF)

Le champ `methode_de_prospection` permet aux observateurs d'indiquer toutes les méthodes de prospection utilisées lors d'un passage :

- Capture au filet troubleau
- Observation à vue
- Écoute
- Recherche d'indices de présence
- etc.

### Autres cas d'usage possibles

- **Habitats** : sélection de plusieurs types d'habitats
- **Menaces** : identification de plusieurs menaces sur un site
- **Activités humaines** : enregistrement de plusieurs activités observées
- **Méthodes d'observation** : combinaison de plusieurs techniques

Protocoles utilisant une nomenclature multiple sur un champ `id_nomenclature_*` hors visite (fonctionnels depuis septembre 2026) : RHOMEOOdonate, RHOMEOOrthoptere (observation), osmodermes, arbres_interet_ecologique (site).

## Limitations connues

1. **« Requis » non bloquant** : le widget n'est pas un `FormField`. `DynamicFormBuilder.validate()` (qui appelle `_formKey.currentState.validate()`, l.423) ne vérifie donc pas qu'une sélection a été faite. Un formulaire dont le champ multiple est requis mais vide peut être enregistré, et seul le bandeau rouge avertit l'utilisateur.

2. **Filtres de nomenclatures ignorés** : ni ce widget ni le widget simple n'appliquent de filtre de config (`cd_nomenclatures`, `filters`…). Toutes les nomenclatures du type sont proposées.

3. **Valeurs initiales** : une `Map` sans `id` est ignorée, et une liste en valeur par défaut (`value` dans la config) aussi.

4. **Nomenclature absente du cache ou de la base** :
   - dans le formulaire, un ID enregistré qui n'appartient plus au type n'a pas de case, mais il **reste dans la sélection** : il compte dans « N sélectionné(s) » et il est renvoyé au serveur ;
   - en détail, il est omis sans avertissement si au moins un autre ID est résolu.

5. **Affichage en tableau** : les IDs ne sont pas résolus en labels dans les colonnes des tableaux (voir [Affichage en détail](#4-affichage-en-détail)).

6. **Deux providers homonymes** : `nomenclaturesByTypeProvider` est défini à la fois dans `nomenclature_selector_widget.dart` et dans `multiple_nomenclature_selector_widget.dart` (l.282). Ce sont deux instances distinctes : chacune a son propre état et doit être surchargée séparément dans les tests.

7. **Widget d'affichage inutilisé** : `MultipleNomenclatureDisplayWidget` n'est référencé nulle part.

8. **Pas de recherche** ni de bouton « Tout sélectionner » (seulement « Tout désélectionner »).

9. **Liste longue** : depuis la suppression du scroll interne, un type comptant beaucoup de valeurs rend le formulaire très long.

## Améliorations futures

1. **Validation bloquante** : envelopper le widget dans un `FormField<List<int>>` pour que `validate()` refuse une liste vide quand le champ est requis
2. **Filtres** : prendre en charge `cd_nomenclatures` / `filters` de la config
3. **Recherche/filtrage** : champ de recherche pour les longues listes
4. **Sélection groupée** : bouton « Tout sélectionner »
5. **Compteur plus détaillé** : « 2/10 sélectionnés »
6. **Mode compact** : afficher les sélections sous forme de chips
7. **Nettoyage** : mutualiser `nomenclaturesByTypeProvider`, puis utiliser ou supprimer `MultipleNomenclatureDisplayWidget`

## Références

- Widget de saisie : [`lib/presentation/widgets/multiple_nomenclature_selector_widget.dart`](../lib/presentation/widgets/multiple_nomenclature_selector_widget.dart)
- Widget d'affichage (inutilisé) : [`lib/presentation/widgets/multiple_nomenclature_display_widget.dart`](../lib/presentation/widgets/multiple_nomenclature_display_widget.dart)
- Intégration formulaire : [`lib/presentation/widgets/dynamic_form_builder.dart`](../lib/presentation/widgets/dynamic_form_builder.dart)
- Affichage détail : [`lib/presentation/widgets/property_display_widget.dart`](../lib/presentation/widgets/property_display_widget.dart)
- Tests : [`test/presentation/widgets/multiple_nomenclature_selector_test.dart`](../test/presentation/widgets/multiple_nomenclature_selector_test.dart), [`test/core/helpers/form_config_parser_multiple_test.dart`](../test/core/helpers/form_config_parser_multiple_test.dart)
- Commits : `dffe791` (création, oct. 2025), `dc3f798` (affichage multi-select dans `PropertyDisplayWidget`, janv. 2026), `0ed6612` (suppression du scroll interne, avr. 2026, issue #181) ; correctifs de l'audit des formulaires (sept. 2026 : listes `id_nomenclature_*` conservées, ID en chaîne, `multi_select`)

## Auteur

- **Claude Code** (Anthropic)
- **Date** : 21 octobre 2025, mis à jour en septembre 2026
- **Version de l'application** : v1.1.1+3
