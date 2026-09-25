# Vue d'ensemble des fonctionnalités - GeoNature Mobile Monitoring

Ce document présente les capacités et limitations de l'application mobile GeoNature pour le monitoring de la biodiversité.

> 💡 Pour la documentation technique détaillée des expressions JavaScript (`hidden`, `required`, règles `change`), voir [JAVASCRIPT_EXPRESSIONS.md](JAVASCRIPT_EXPRESSIONS.md)

## 🆕 Dernières Améliorations (Septembre 2026 — `v1.1.1+3`)

### Depuis `v1.1.1` (non encore publié dans une release)
- ✅ **Correctifs des formulaires (audit septembre 2026)**, vérifiés contre le module web 1.3.0 et les configurations réelles de [protocoles_suivi](https://github.com/PnX-SI/protocoles_suivi) (voir [Bugs corrigés](#bugs-corrigés-audit-septembre-2026)) :
  - nouvel **interpréteur JavaScript** pour `hidden`, `required` et les règles `change` : parenthèses, `!( … )`, `'2' == 2`, comparaisons avec un champ vide, `includes()`, arithmétique… donnent le même résultat que sur le web ;
  - enregistrement des visites avec une nomenclature simple (erreur « `_Map` is not a subtype of `num?` », module blaireautière) ;
  - widget `multiselect` (cases à cocher) et choix du groupe de sites à la création d'un site depuis l'onglet Sites ;
  - valeurs fixes des champs masqués (`hidden: true` + `value`, ex. taxon unique) enregistrées ;
  - nomenclatures à choix multiple conservées à l'enregistrement (observations, sites, groupes) ; clé web `multi_select` reconnue ;
  - règles `change` conservées au format d'origine (plus de perte des `const`/`patchValue` hors `if`) ;
  - contexte des expressions aligné sur le web : taxon en objet (`value.cd_nom.cd_nom`), `meta.nomenclatures`.
- ✅ Version de l'application affichée en bas de l'écran d'accueil (« Monitoring vX.Y.Z »)
- ✅ Dialogue « Informations sur la version » : version installée (lue via `package_info_plus`) en plus de la compatibilité avec le module monitoring
- ✅ Page Financeurs : l'AppBar suit le thème de l'app (suppression du vert codé en dur)

### Release `v1.1.1` (2026-05-19)
- ✅ Carte des sites pour les modules **sans groupes de sites** (+ UX de chargement)
- ✅ Onglet Sites virtualisé (`ListView.builder`) — meilleures performances sur les gros modules
- ✅ Correctifs carte : crash sur bounds dégénérés, `autoDispose` du MapViewModel, fuite GPS
- ✅ Titres de groupes cliquables, labels et FAB sur la vue groupes

### Release `v1.1.0` (2026-04-30)
- ✅ Renommage de l'app en **Monitoring** avec nouveau logo
- ✅ Badges orange pour visualiser les saisies non synchronisées
- ✅ Désinstallation de modules depuis le menu détail
- ✅ Refonte des appels d'API de synchronisation (endpoints `/refacto/` du module serveur)
- ✅ Modules mixtes : onglets **Groupes** + **Sites** (sites sans groupe parent) sur la page module (#157)
- ✅ Déterminateur (`datalist` + `type_util: "user"` mono) auto-rempli avec l'utilisateur connecté
- ✅ `min`/`max` d'un `NumberField` pouvant référencer un autre champ (`"min": "({value}) => value.count_min"`)
- ✅ Pré-remplissage aligné sur le web : seul `value` pré-remplit un champ (`default` est ignoré)

### Saisie et visualisation de géométrie de site (`v1.0.0`)
L'app gère désormais la création et l'édition de géométries de site directement depuis le mobile — fini le besoin de passer par l'interface web pour tracer une aire.

- ✅ Support `Point`, `LineString`, `Polygon` (et les variantes `Multi*` en lecture)
- ✅ Picker plein écran avec OSM en fond de carte, sommets numérotés, validation auto des polygones
- ✅ Détection et refus des polygones auto-intersectés avant envoi serveur
- ✅ Mini-carte en lecture seule sur la page de détail d'un site, avec bouton « Ajuster sur la carte »
- ✅ Calcul de distance GPS → site avec support `Point`, `LineString`, `Polygon`, `MultiPoint`, `MultiLineString`, `MultiPolygon`
- ✅ Marker bleu `Icons.my_location` superposé sur le picker et les mini-cartes pour situer l'utilisateur
- ✅ Indicateur « Calcul… » avec spinner pendant l'acquisition GPS (au lieu d'un badge qui disparaît)

### Synchronisation plus robuste
- ✅ Remapping à la volée des `id_sites_group` lors du push d'un site pour éviter les conflits serveur
- ✅ Normalisation du champ `modules` des groupes de sites (corrige un bug qui rendait les groupes invisibles côté web)
- ✅ Menu burger `Mettre à jour les données` / `Téléversement` testés en E2E réel contre un GeoNature local

### Infrastructure de tests
- ✅ **15 scénarios E2E réels** (11 fichiers dans `integration_test/scenarios_real/`, dont 1 désactivé : `real_many_taxa_e2e_test`) contre un GeoNature local (auth, module, sites, groupes, visites, observations, sync download, sync upload, stress multi-modules)
- ✅ **54 scénarios E2E mock** (11 fichiers dans `integration_test/scenarios/`, dont 19 de non-régression des formulaires dans `audit_bugs_e2e_test.dart`) avec bases in-memory et interceptor Dio, lancés sur émulateur Pixel 6 (API 35) via `scripts/run_device_test.sh`
- ✅ Helpers communs pour dismiss de dialogs bloquants et attente de fin de sync post-login
- ✅ **~1565 tests unitaires/widget** (`flutter test test/`) : tous passent (7 tests marqués `skip`) — septembre 2026, dont un corpus de 1 330 évaluations d'expressions comparées à JavaScript (`test/fixtures/js_expressions_corpus.json`)

### Expressions conditionnelles et règles de changement (rappel)
L'application supporte les **validations conditionnelles dynamiques** avec évaluation des expressions JavaScript pour `required` et `hidden` (astérisque rouge mis à jour en temps réel, champs cachés ignorés par la validation), ainsi que les **règles `change`** (mise à jour automatique de champs, ex. `presence = "Non"` → `cd_nom` fixé).

**Exemple d'utilisation :**
```json
{
  "Heure_debut": {
    "type_widget": "time",
    "attribut_label": "Heure de début",
    "required": "({value}) => value.accessibility === 'Oui'",
    "hidden": "({value}) => value.accessibility === 'Non'"
  }
}
```

## 🚀 Types de Champs Supportés

> ℹ️ **Où déclarer les attributs ?** Les attributs `value`, `min`, `max`, `description`, `code_nomenclature_type`, `filters` et les expressions `required` ne sont lus que dans la partie **`specific`** de la configuration d'un objet. Pour un champ `generic`, seuls `attribut_label`, `type_widget`, `type_util`, `hidden`, `required` (booléen uniquement), `api`, `multiple`, `values`, `change`… sont conservés (voir la section « Limitations Connues »).

### 📝 Champs de Base

#### TextField - Saisie de texte simple
```json
{
  "participants_nom": {
    "type_widget": "text",
    "attribut_label": "Participant(s) nom",
    "required": false
  }
}
```

#### TextField_multiline - Saisie de texte multiligne
```json
{
  "comments": {
    "type_widget": "textarea",
    "attribut_label": "Commentaire",
    "required": false
  }
}
```

#### NumberField - Saisie numérique avec validation
```json
{
  "temperature": {
    "type_widget": "number",
    "attribut_label": "Température de l'air (°C)",
    "required": true,
    "min": 0,
    "max": 60
  }
}
```

- ✅ `min` / `max` : nombre, chaîne numérique (`"5"`) ou référence à un autre champ (`"({value}) => value.count_min"`). Toute autre expression est ignorée (la borne est désactivée).
- ⚠️ **Entiers uniquement** : la saisie est validée par `int.tryParse` — une valeur décimale (`12.5`) est refusée (« Veuillez entrer un nombre valide »).

### 🎯 Champs de Sélection

#### DropdownButton - Liste déroulante simple
```json
{
  "periode": {
    "type_widget": "select",
    "values": ["Nocturne", "Diurne"],
    "attribut_label": "Période",
    "required": true
  }
}
```
`values` accepte des chaînes ou des objets `{"value": ..., "label": ...}`. La valeur est stockée sous forme de chaîne.

#### DatalistField - Sélection avec recherche
```json
{
  "methode_prospection": {
    "type_widget": "datalist",
    "multiple": true,
    "attribut_label": "Méthode de prospection",
    "values": ["Par observation directe", "Par plaques"],
    "required": "({value}) => value.accessibility === 'Oui'",
    "hidden": "({value}) => value.accessibility === 'Non'"
  }
}
```

Comportement selon la configuration :

| Configuration datalist | Rendu | Statut |
|------------------------|-------|--------|
| `values` statiques, `multiple: false` | Autocomplete avec recherche | ✅ |
| `values` statiques, `multiple: true` | Liste de cases à cocher (valeurs stockées en `List<String>`) | ✅ (⚠️ `required` non bloquant, voir limitations) |
| `api: "nomenclatures/nomenclature/XXX"` ou `type_util: "nomenclature"` | Redirigé vers **NomenclatureSelector** | ✅ |
| `type_util: "user"` + `multiple: false` | Redirigé vers **CurrentUserField** (auto-rempli) | ✅ |
| `type_util: "taxonomy"` | Redirigé vers **TaxonSelector** | ✅ |
| `type_util: "dataset"` | Redirigé vers **DatasetSelector** | ✅ |
| Autre `api` (ex. `users/menu/…` avec `multiple: true`, habitats, listes monitoring…) | Liste **vide** : les données d'API ne sont pas chargées | ❌ |
| `values` en objets avec d'autres clés que `value`/`label` (`keyValue`/`keyLabel`) | Libellés vides | ❌ |

#### RadioButton - Boutons radio pour choix unique
```json
{
  "chevelu_racinaire": {
    "type_widget": "radio",
    "values": ["oui", "non"],
    "required": true,
    "value": "non",
    "attribut_label": "Chevelu racinaire"
  }
}
```
- ✅ Disposition horizontale automatique si ≤ 4 options courtes, verticale sinon
- ⚠️ `values` doit contenir des scalaires : un objet `{"value", "label"}` est affiché tel quel (`{value: …, label: …}`) — sauf pour un champ taxonomique en radio (`cd_nom` avec `values` `[{value: <cd_nom>, label}]`), qui est géré

#### Checkbox - Cases à cocher
```json
{
  "en_vol": {
    "type_widget": "bool_checkbox",
    "attribut_label": "Observé en vol",
    "description": "Observé en vol",
    "value": false
  }
}
```
- ✅ `checkbox` est accepté comme alias de `bool_checkbox`
- ℹ️ La case est initialisée à `false` si aucune `value` n'est fournie (la clé `default` est ignorée) : la valeur `false` est donc toujours enregistrée
- ⚠️ Pas de validation `required` sur une case à cocher

### 📅 Champs Date/Heure

#### DatePicker - Sélecteur de date
```json
{
  "visit_date_min": {
    "type_widget": "date",
    "attribut_label": "Date du passage",
    "required": true
  }
}
```
- ✅ Stockage `YYYY-MM-DD`, affichage `jj/MM/aaaa` (formulaire et pages de détail)
- ✅ `type_util: "date"` sans `type_widget` → DatePicker
- ✅ `visit_date_min` ne peut pas être dans le futur
- ⚠️ Plage de sélection limitée à 2000–2100 ; pas de contrôle `visit_date_max ≥ visit_date_min`
- ⚠️ En édition, une date existante est affichée brute (`2026-05-01…`) tant qu'elle n'est pas re-sélectionnée

#### TimePicker - Sélecteur d'heure
```json
{
  "time_start": {
    "type_widget": "time",
    "attribut_label": "Heure de début",
    "required": "({value}) => value.accessibility === 'Oui'"
  }
}
```
Valeur stockée au format `HH:MM`.

### 🧬 Champs Spécialisés GeoNature

#### TaxonSelector - Sélection d'espèces avec recherche
```json
{
  "cd_nom": {
    "type_widget": "taxonomy",
    "attribut_label": "Espèce observée",
    "multiple": false,
    "id_list": "__MODULE.ID_LIST_TAXONOMY",
    "application": "TaxHub",
    "required": true,
    "type_util": "taxonomy"
  }
}
```
- ✅ Recherche hors-ligne dans les taxons téléchargés (à partir de 3 caractères), filtrée par la liste du champ (`id_list` ou `api: "taxref/allnamebylist/<id>"`) sinon par `__MODULE.ID_LIST_TAXONOMY`
- ✅ Suggestions (chips) issues de la liste taxonomique quand le champ est vide
- ✅ Valeur stockée : `cd_nom` (entier)
- ❌ `multiple: true` non supporté (sélection d'un seul taxon)
- ⚠️ En page de détail, seul le champ nommé `cd_nom` est résolu en nom de taxon ; un autre champ taxonomique affiche le `cd_nom` brut

#### NomenclatureSelector - Nomenclatures GeoNature

**Sélection simple** (dropdown) :
```json
{
  "id_nomenclature_statut_observation": {
    "type_widget": "nomenclature",
    "attribut_label": "Statut d'observation",
    "code_nomenclature_type": "STATUT_OBS",
    "required": true,
    "type_util": "nomenclature"
  }
}
```

ou avec API :
```json
{
  "id_nomenclature_typ_denbr": {
    "type_widget": "datalist",
    "attribut_label": "Type de dénombrement",
    "api": "nomenclatures/nomenclature/TYP_DENBR",
    "application": "GeoNature",
    "keyValue": "id_nomenclature",
    "keyLabel": "label_fr",
    "data_path": "values",
    "type_util": "nomenclature",
    "required": "({value}) => value.presence === 'Oui'",
    "hidden": "({value}) => value.presence === 'Non'"
  }
}
```

- ✅ Type de nomenclature déduit de `code_nomenclature_type`, sinon de l'`api` (`nomenclatures/nomenclature/<TYPE>`)
- ✅ Libellé affiché : `label_fr` → `label_default` → `cd_nomenclature` (`keyLabel` / `keyValue` / `data_path` sont ignorés)
- ✅ Valeur envoyée au serveur : `id_nomenclature` (entier)
- ❌ `filters` (ex. `{"cd_nomenclature": ["Co", "Es"]}`) **non appliqué** : toutes les valeurs du type sont proposées

**Sélection multiple** (checkboxes) :
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

**Compatibilité avec `required` et `hidden` :**
- ✅ Visibilité conditionnelle avec `hidden` (expressions JavaScript)
- ✅ Astérisque et message « requis » dynamiques avec `required`
- ⚠️ Le message « requis » est **informatif** : il ne bloque pas l'enregistrement (le sélecteur multiple n'est pas un `FormField`)
- ✅ Sélection multiple déclarée par `multiple: true` (datalist) ou `multi_select: true` (widget `nomenclature` du web)
- ✅ Liste d'IDs conservée à l'enregistrement pour tous les objets (corrigé en septembre 2026 : les champs `id_nomenclature_*` des observations, sites et groupes perdaient leur sélection)
- ✅ Les valeurs sélectionnées sont sauvegardées dans un tableau d'IDs de nomenclatures et affichées par libellés en page de détail

> 📘 **Documentation complète** : Voir [MULTIPLE_NOMENCLATURE_SELECTOR.md](MULTIPLE_NOMENCLATURE_SELECTOR.md) pour plus de détails sur la sélection multiple de nomenclatures.

#### DatasetSelector - Sélection de jeux de données
```json
{
  "id_dataset": {
    "type_widget": "dataset",
    "type_util": "dataset",
    "hidden": "({meta}) => meta.dataset && Object.keys(meta.dataset).length == 1"
  }
}
```
- ✅ Détection par `type_widget: "dataset"` ou `type_util: "dataset"`
- ✅ Liste des jeux de données du module (hors-ligne), **sélection automatique s'il n'y en a qu'un**
- ✅ Pour une visite, si aucun jeu n'est choisi, le premier jeu du module est utilisé à l'enregistrement
- ℹ️ L'expression `hidden` ci-dessus ne masque pas le champ : `meta.dataset` n'est pas fourni (le web ne le renseigne que par effet de bord de cache). Le champ reste visible et pré-sélectionné s'il n'y a qu'un jeu de données

#### ObserverField - Gestion des observateurs
⚠️ **Note** : Ce champ n'est **pas éditable** dans cette version : l'utilisateur connecté est automatiquement ajouté aux observateurs.

```json
{
  "observers": {
    "type_widget": "observers",
    "attribut_label": "Observateurs",
    "required": true
  }
}
```

Comportement réel (tout champ nommé `observers`, quel que soit son `type_widget`) :
- **Création** : liste vide dans le formulaire, message « Vous êtes automatiquement ajouté comme observateur » ; l'ID de l'utilisateur connecté est ajouté à l'enregistrement de la visite
- **Édition d'une visite avec plusieurs observateurs** : les observateurs existants sont conservés et affichés en chips « Observateur #<id> » (ID numérique, pas de nom) qu'on peut retirer ; l'utilisateur courant est ré-ajouté à l'enregistrement même s'il a été retiré
- ❌ Impossible d'ajouter un autre observateur (pas de sélection dans la liste des observateurs)
- ⚠️ En page de détail d'une visite, seul le nombre d'observateurs est affiché (« N observateur(s) »)

#### CurrentUserField - Datalist mono-utilisateur (ex: déterminateur)
⚠️ **Note** : Tant que l'API `users/menu/<id_list>` n'est pas câblée localement, tout champ `datalist` ciblant un utilisateur unique (`type_util: "user"`, `multiple: false`) est traité comme `ObserverField` : auto-rempli avec l'utilisateur connecté et affiché en lecture seule (chrome partagé via `_buildAutoFilledUserField`). En édition, une valeur existante (autre utilisateur) est conservée, mais le message affiché reste « Vous êtes automatiquement assigné… ».

```json
{
  "determiner": {
    "type_widget": "datalist",
    "attribut_label": "Déterminateur",
    "api": "users/menu/__MODULE.ID_LIST_OBSERVER",
    "type_util": "user",
    "multiple": false,
    "required": true
  }
}
```

#### Champs non supportés
- ❌ **`medias`** : le parseur le mappe vers `MediaUploadField`, mais aucun widget n'existe → il est rendu comme un **simple champ texte** (aucun upload de fichier/photo)
- ❌ **`html`** : exclu du formulaire (comme sur le web)
- ℹ️ **Tout `type_widget` inconnu** (ou absent sur un champ `specific`) → champ texte simple

## 🔄 Mapping Configuration → Widget

| Configuration JSON | Widget Flutter | Particularités |
|-------------------|----------------|----------------|
| `"type_widget": "text"` | TextField | Validation `required` |
| `"type_widget": "textarea"` | TextField_multiline | 3 lignes |
| `"type_widget": "number"` | NumberField | Entiers uniquement, `min`/`max` (valeur ou référence à un champ) |
| `"type_widget": "date"` ou `"type_util": "date"` | DatePicker | Stockage ISO `YYYY-MM-DD`, affichage `jj/MM/aaaa` |
| `"type_widget": "time"` | TimePicker | Format `HH:MM` |
| `"type_widget": "select"` | DropdownButton | `values` chaînes ou `{value, label}` |
| `"type_widget": "datalist"` (+ `values`) | DatalistField | Recherche, simple ou `multiple` ; `api` hors nomenclature/user non chargée (sauf groupes de sites, proposés depuis la base locale) |
| `"type_widget": "multiselect"` (+ `values`) | DatalistField multiple | Cases à cocher, valeur : liste des `value` cochées |
| `"type_widget": "radio"` | RadioButton | Choix unique, valeurs scalaires |
| `"type_widget": "bool_checkbox"` / `"checkbox"` | Checkbox | Valeur booléenne, `false` par défaut |
| `"type_widget": "nomenclature"` (ou `type_util`/`api` nomenclature) | NomenclatureSelector | Simple (dropdown) ou `multiple` / `multi_select` (cases à cocher) ; `filters` ignoré |
| `"type_widget": "taxonomy"` (ou `type_util: "taxonomy"`) | TaxonSelector | Recherche hors-ligne, sélection simple |
| `"type_widget": "observers"` (ou champ nommé `observers`) | ObserverField | Auto-rempli avec l'utilisateur connecté, non éditable (chips retirables en édition) |
| `"type_widget": "datalist"` + `"type_util": "user"` (`multiple: false`) | CurrentUserField | Auto-rempli avec l'utilisateur connecté (chrome partagé avec ObserverField) |
| `"type_widget": "dataset"` ou `"type_util": "dataset"` | DatasetSelector | Auto-sélection si un seul jeu de données |
| `"type_widget": "medias"` | ❌ (TextField) | Pas de widget d'upload |
| `"type_widget": "html"` | — | Champ exclu |
| Autre / absent | TextField | Type par défaut |

## 🎯 Logique Conditionnelle

### Visibilité (`hidden`)
- ✅ **Booléens statiques** : `"hidden": true` ou `"hidden": false`. Un champ `hidden: true` n'est pas affiché ; s'il porte une `value`, celle-ci est enregistrée (comme sur le web)
- ✅ **Expressions JavaScript** avec la sémantique du web : opérateurs logiques et parenthèses à tous les niveaux, `==` non strict, ternaires, arithmétique, `includes()`, `.length`, `Object.keys()`, `meta.nomenclatures[…]`, taxon en objet (`value.cd_nom.cd_nom`)… (détail : [JAVASCRIPT_EXPRESSIONS.md](JAVASCRIPT_EXPRESSIONS.md))
- ✅ **Cascades et auto-références** : chaque champ est évalué avec les valeurs courantes du formulaire
- ℹ️ **Expression en erreur** (ex. `value.o.p` avec `o` vide) : champ affiché
- ⚠️ **Enregistrement** : les valeurs des champs masqués par une expression sont conservées **pendant la saisie**, mais un tel champ n'est envoyé que s'il est `required: true` (booléen) ou rempli par une règle `change`. Le web envoie toujours ces valeurs : choix délibéré de l'app, pour ne pas enregistrer une valeur saisie puis masquée

### Validation (`required`)
- ✅ **Booléens statiques** : `"required": true` ou `"required": false`
- ✅ **Expressions conditionnelles** : `"required": "({value}) => value.champ === 'valeur'"` (dans `specific` uniquement)
- ✅ **Format validations** : `"validations": {"required": true}` ou avec expressions JavaScript
- ✅ **Champs cachés** : Les champs cachés ne sont pas validés (validation ignorée automatiquement)
- ✅ **Indicateur visuel** : Affichage dynamique de l'astérisque (*) selon l'état du champ requis
- ⚠️ **Non bloquant** pour les sélections multiples (datalist `multiple`, nomenclatures multiples), les cases à cocher, `observers` et `CurrentUserField` : seuls les champs texte, nombre, date, heure, select, radio, datalist simple, nomenclature simple, taxon et dataset bloquent l'enregistrement

### Règles de changement (`change`)
- ✅ Les règles `change` d'un objet (visite, observation, site…) sont stockées **au format JavaScript d'origine** et appliquées par `ChangeRuleProcessor` : blocs `if`, `patchValue` conditionnels ou non, `const` (y compris arithmétique), ternaires, propriétés abrégées, `meta.nomenclatures`, `objForm.controls.xxx.dirty`
- ✅ Un champ fixé par une règle est conservé à l'enregistrement même s'il est caché (ex. `presence = "Non"` → `cd_nom` = Amphibia)
- ⚠️ Les règles ne sont réévaluées qu'après une modification d'un champ **texte, nombre, select, radio ou taxon** : elles ne sont pas exécutées à l'ouverture du formulaire, ni après un changement de date, heure, case à cocher, datalist, nomenclature ou jeu de données (elles le seront à la prochaine modification d'un champ déclencheur)

> 📘 Détail des règles `change` supportées : voir [JAVASCRIPT_EXPRESSIONS.md](JAVASCRIPT_EXPRESSIONS.md#règles-change--remplissage-automatique).

**Exemple complet de validation et visibilité conditionnelles** (POPReptile) :
```json
{
  "accessibility": {
    "type_widget": "radio",
    "values": ["Oui", "Non"],
    "value": "Oui"
  },
  "Heure_debut": {
    "type_widget": "time",
    "attribut_label": "Heure de début",
    "required": "({value}) => value.accessibility === 'Oui'",
    "hidden": "({value}) => value.accessibility === 'Non'"
  }
}
```

**Comportement dynamique** :
- Quand `accessibility = "Oui"` :
  - ✅ Le champ "Heure de début" est **visible**
  - ✅ Le label affiche "Heure de début **\***" (avec astérisque rouge)
  - ✅ La validation est **active** et évaluée dynamiquement
  - ✅ L'expression `required` est interprétée en temps réel

- Quand `accessibility = "Non"` :
  - ✅ Le champ "Heure de début" est **caché**
  - ✅ La validation est **désactivée** automatiquement (même si `required` est défini)
  - ✅ La valeur saisie est conservée en mémoire tant que le formulaire est ouvert, mais **n'est pas enregistrée** (champ caché non requis)

**Mise à jour en temps réel** : L'astérisque, le label et la validation s'ajustent instantanément lors des changements de valeur des champs dont dépend la condition.

> 📘 Pour la liste complète des expressions JavaScript supportées, voir [JAVASCRIPT_EXPRESSIONS.md](JAVASCRIPT_EXPRESSIONS.md)

## 📄 Affichage en Page de Détail

| Type de valeur | Affichage | Statut |
|----------------|-----------|--------|
| Texte, select, radio, heure | Valeur brute | ✅ |
| Date ISO | `jj/MM/aaaa` | ✅ |
| Nomenclature simple | Libellé (`label_fr`) | ✅ |
| Nomenclatures multiples | Libellés séparés par des virgules | ✅ |
| `cd_nom` | Nom vernaculaire ou latin selon `TAXONOMY_DISPLAY_FIELD_NAME` | ✅ |
| Groupe de sites (`id_sites_group`) | Nom du groupe | ✅ |
| Nombre égal à `0` | « Non renseigné » | ⚠️ (un comptage à 0 apparaît comme vide) |
| Booléen (`bool_checkbox`) | `true` / `false` (seul `type_widget: "checkbox"` est traduit en Oui/Non dans les tableaux) | ⚠️ |
| Observateurs | Nombre d'observateurs uniquement | ⚠️ |
| Autre champ taxonomique que `cd_nom` | `cd_nom` brut | ⚠️ |

## 📊 Statut de Test des Modules

> 📋 **Tableau complet par module** (37 protocoles : analyse des configurations, tests automatisés, retours terrain) : [MODULES_COMPATIBILITY.md](MODULES_COMPATIBILITY.md).

Modules validés en conditions de terrain :

| Module | Testé | Fonctionne | Notes |
|--------|-------|------------|-------|
| **POPAmphibien** | ✅ | ✅ | Écarts d'expressions avec le web (« Etat du site » demandé à chaque passage, `count_max` requis quand `count_min` est vide) corrigés en septembre 2026, vérifiés sur émulateur ; nouvelle validation terrain recommandée |
| **POPReptile** | ✅ | ✅ | Distance GPS sur transect OK (issue #154). Mêmes correctifs que POPAmphibien |

**Légende** : ✅ Testé et fonctionne | 🔄 Partiellement testé | ⚠️ Fonctionne partiellement | ❌ Incompatible

> ℹ️ Pour proposer la validation d'un autre module, voir la section [Processus de Test d'un Nouveau Module](#-processus-de-test-dun-nouveau-module) en fin de document, et reporter le résultat dans [MODULES_COMPATIBILITY.md](MODULES_COMPATIBILITY.md).

## ⚠️ Limitations Connues

### Fonctionnalités applicatives non couvertes
- ❌ **Permissions CRUVED non appliquées côté UI** : le schéma est parsé mais n'est lu nulle part dans `lib/presentation/`. Tout utilisateur authentifié avec un module téléchargé peut créer/modifier/supprimer visites et observations, indépendamment de ses droits serveur.
- ❌ **Formulaire « Individus »** : le formulaire complémentaire de suivi individuel (marquage/recapture) exposé par certains modules monitoring côté web n'est pas pris en charge — ni UI de saisie, ni sync.
- ⚠️ **Modules mixtes sites + groupes de sites** : depuis `v1.1.0` (#157), la page module affiche deux onglets **Groupes** / **Sites** lorsque le module déclare `site` dans `children_types` ou possède des sites sans groupe parent. Si `children_types` ne contient que `sites_group` et qu'aucun site orphelin n'existe, les sites ne se créent que depuis un groupe. La création de site dépend aussi de `is_editable_on_field`.
- ⚠️ **Compléments d'observation (`observation_detail`)** : saisie et affichage supportés, mais la navigation depuis une erreur de synchronisation vers un détail d'observation n'est pas implémentée (message « non implémentée »), et la couverture de tests reste inférieure à celle des visites/sites.

### Bugs corrigés (audit septembre 2026)
Les 289 expressions `hidden`/`required` (28 modules) de [PnX-SI/protocoles_suivi](https://github.com/PnX-SI/protocoles_suivi) et du fork [Geomaticien-shf/protocoles_suivi](https://github.com/Geomaticien-shf/protocoles_suivi) ont été comparées à JavaScript : avant correction, **15 des 52 expressions distinctes** divergeaient du web et 3 reposaient sur `meta.nomenclatures`, absent de l'app. Référence : module web GeoNature Monitoring 1.3.0.

| Bug | Modules touchés | Correctif | Test de non-régression |
|---|---|---|---|
| **Visite : erreur « `_Map<String, dynamic>` is not a subtype of type `num?` » à l'enregistrement** (nomenclature simple stockée en objet, colonne `id_nomenclature_tech_collect_campanule`) ; les autres nomenclatures simples des visites partaient au serveur en objet | suivi_terriers_blaireau_gmb (remonté du terrain en v1.1.1), suivi_nardaie | Les visites passent par `FormDataProcessor.processFormData` comme les observations et sites (objet → `id_nomenclature`, `{code_nomenclature_type, cd_nomenclature}` résolu) | `test/presentation/viewmodel/site_visits_viewmodel_test.dart`, E2E blaireautière |
| Widget `multiselect` rendu en champ texte | ecrevisses_pattes_blanches, nidif_gypa, stom | Rendu en liste à cases à cocher (valeur : liste des `value` cochées, comme `pnx-multiselect`) | `test/presentation/widgets/multiselect_widget_test.dart`, E2E stom |
| « Groupe de site » obligatoire mais liste vide pour un site créé depuis l'onglet Sites du module (enregistrement impossible) | petite_chouette_montagne | Groupes du module proposés dans la liste ; groupe choisi rattaché au site | `test/presentation/widgets/site_group_field_test.dart`, `site_form_viewmodel_test.dart`, E2E petite_chouette_montagne |
| Champ `hidden: true` + `value` non enregistré (observations/visites sans taxon) | nidif_gypa, apollons, cheveches, craves, popanomaloglossus | Valeur fixe initialisée et envoyée (`DynamicFormBuilder._initializeFixedHiddenValues`) | `test/presentation/widgets/fixed_hidden_values_test.dart`, E2E popanomaloglossus |
| Nomenclatures multiples `id_nomenclature_*` supprimées à l'enregistrement | RHOMEOOdonate, RHOMEOOrthoptere, osmodermes, arbres_interet_ecologique | Listes d'IDs conservées (`FormDataProcessor.processFormData`) | `test/presentation/viewmodel/form_data_processor_test.dart`, E2E bug 1 |
| Règles `change` : `const`/`patchValue` hors `if` perdus au téléchargement | RHOMEOFlore, suivi_phytosocio (nom de site) | Règles conservées au format d'origine | `test/presentation/viewmodel/change_rule_processor_real_configs_test.dart`, E2E RHOMEOFlore |
| Parenthèses internes, `!( … )` non évalués | POPAmphibien, POPReptile, pt_ecoute_avifaune, suivi_Camphi_gmb, suivi_loutre ×2 | Interpréteur JavaScript (`JsExpressionInterpreter`) | Corpus `js_expression_interpreter_test.dart`, E2E POPAmphibien, pt_ecoute_avifaune |
| `'2' == 2` faux | pt_ecoute_avifaune | Égalité non stricte JavaScript | Corpus |
| `null > 0` vrai, opérande non reconnu → comparaison toujours vraie | POPAmphibien, POPReptile | Conversions JavaScript | Corpus, E2E bugs 4a/4b |
| `!a && b` et `&&` avec comparaisons faussés en `hidden` (normalisation) | lichens_bio_indicateurs | Normalisation supprimée | Corpus, E2E bug 3 |
| `includes()`, `-`, `*`, `%`, décimaux, négatifs non gérés | RHOMEOAmphibien | Interpréteur JavaScript | Corpus |
| Taxon comparé en entier (`value.cd_nom.cd_nom` sans effet) | suivi_Camphi_gmb, suivi_loutre ×2 | Taxon exposé en objet `{cd_nom}` aux expressions | E2E suivi_loutre |
| `meta.nomenclatures` absent | suivi_Camphi_gmb, suivi_loutre ×2, suivi_terriers_blaireau_gmb | Nomenclatures du formulaire indexées par ID | E2E suivi_loutre |
| `meta.dataset` = `id_list_taxonomy` | 11 modules (`id_dataset`) | Retiré (non fourni, comme le plus souvent sur le web) | — |
| `value['a'] \|\| value['b']` lu comme un seul accès | aucun (latent) | Interpréteur JavaScript | Corpus, E2E bug 2 |
| Nomenclature multiple avec ID en chaîne : plantage | aucun connu | Conversion tolérante | `multiple_nomenclature_initial_value_test.dart` |

> 🧪 Tests sur émulateur : [`integration_test/scenarios/audit_bugs_e2e_test.dart`](../integration_test/scenarios/audit_bugs_e2e_test.dart) (19 scénarios, dont des extraits de configurations réelles), lancés avec `scripts/run_device_test.sh`.

> ℹ️ **Config à signaler aux auteurs** : `petite_chouette_montagne` compare `value.cd_nom != 3507`, alors que le taxon est un objet dans le formulaire web ; ses champs se comportent donc de la même façon (non conforme à l'intention) sur le web et sur mobile.

**Fork Geomaticien-shf** : `master` est identique à PnX-SI ; les branches `dev/POPAmphibien` et `dev/POPReptile` ne modifient que les exports SQL. Deux nouveaux modules :
- **popanomaloglossus** : compatible depuis la correction des champs masqués à valeur fixe.
- **cmr_cistude** (capture-marquage-recapture) : **non supporté**. Il repose sur les objets `individual` et `marking` et sur le widget `individuals` (rendu en champ texte) ; il utilise aussi `medias` (champ texte), une datalist d'habitats (`habref`, liste vide) et la variable `__MODULE.CD_NOM`, que l'app ne substitue pas.

### Configuration GeoNature partiellement lue
- ⚠️ **Champs `generic`** : `required` y est converti en booléen (une expression devient `false`) et `value`, `min`, `max`, `description`, `code_nomenclature_type`, `filters` n'y sont pas repris dans le schéma du formulaire — seuls les champs `specific` les exploitent (exception : `id_list` et `value` des champs taxonomiques).
- ❌ **Attributs ignorés** : `default` (volontairement, comme sur le web), `definition` (pas d'infobulle), `filters`, `keyValue` / `keyLabel` / `data_path` / `application`, `designStyle`, `nullDefault`.
- ℹ️ **Type de site** (`id_nomenclature_type_site` masqué avec `value`, présent dans presque tous les modules) : géré par le champ `types_site` du formulaire de site (premier type du module par défaut), et non par la valeur fixe.
- ⚠️ **`meta` dans les expressions** : `meta.nomenclatures` et `meta.bChainInput` sont fournis ; `meta.parents` est partiel, `meta.dataset` et `meta.id_role` sont absents.
- ⚠️ **`__MODULE.CD_NOM`**, `__MODULE.TYPES_SITE` et `__MODULE.IDS_TYPE_SITE` ne sont pas substitués (les autres variables `__MODULE.*` le sont).

### Types de Widgets Manquants
- ❌ **Champs de fichiers/médias** : `medias` rendu en champ texte, pas d'upload d'images ou documents
- ❌ **Datalist alimentées par API** (hors nomenclatures et utilisateur unique) : liste vide
- ❌ **Sélection multiple de taxons** et **sélection libre d'observateurs**
- ❌ **Nombres décimaux** dans `NumberField`
- ❌ **Champs avancés** : Couleurs, sliders, ranges
- ❌ **Composants complexes** : Tables dynamiques, formulaires imbriqués

### Validation Avancée
- ⚠️ **Validations cross-champs** : limitées aux bornes `min`/`max` référençant un autre champ et à la date de début non future ; pas de contrôle `date_max ≥ date_min` ni de règle générique entre champs
- ⚠️ **`required` non bloquant** sur les sélections multiples, cases à cocher et champs utilisateur (voir [Validation](#validation-required))
- ⚠️ **Datalist simple** : un texte tapé sans choisir une option passe la validation `required` mais n'est pas enregistré
- ❌ **Validations asynchrones** : Pas de vérification côté serveur en temps réel
- ❌ **Messages d'erreur personnalisés** : Limités aux messages par défaut (« Ce champ est requis », bornes min/max…)

### Performance
- ⚠️ **Rebuild complet** : chaque modification reconstruit tout le formulaire et réévalue toutes les expressions `hidden`/`required`
- ⚠️ **Pas de lazy loading** : tous les champs sont générés d'emblée dans une seule carte (`Column`, pas de `ListView.builder`)
- ⚠️ **Cache limité** : les règles `change` et les nomenclatures sont mises en cache, mais le schéma unifié est régénéré à chaque ouverture de formulaire et plusieurs fois par page de détail

## 🔧 Architecture Technique

### Stack Technologique
- **Framework** : Flutter 3.38.4 (Dart 3.10.3)
- **Architecture** : Clean Architecture (Domain/Data/Presentation)
- **State Management** : Riverpod
- **Base de données locale** : Drift (SQLite, schéma version 29)
- **Carte** : `flutter_map` 8.x + tuiles OpenStreetMap
- **Localisation** : `geolocator` 14.x
- **HTTP** : Dio 5.x
- **Navigation** : GoRouter (routes d'auth) + Navigator.push (reste)
- **Modèles** : Freezed (immutable)

### Pipeline de Traitement des Formulaires

```
Configuration JSON (GeoNature)
    ↓ (téléchargement du module : stockage tel quel, sans conversion)
    ↓
FormConfigParser.generateUnifiedSchema()
    ↓ (fusion generic + specific, substitution __MODULE.*, filtrage display_form/display_properties)
    ↓
DynamicFormBuilder (State Management)
    ↓
    ├─→ _buildEvaluationContext() : {value (taxon en objet), meta (nomenclatures…)}
    │
    ├─→ FormDataProcessor.isFieldRequired() / isFieldHidden()
    │   └─→ HiddenExpressionEvaluator → JsExpressionInterpreter
    │
    └─→ ChangeRuleProcessor.processChangeRules()
        └─→ ChangeExpressionEvaluator (analyse des règles)
            └─→ JsExpressionInterpreter (conditions, const) → patchValue
    ↓
Widgets Flutter dynamiques (mise à jour en temps réel)
    ↓
DynamicFormBuilder.getFormValues() (champs cachés filtrés, valeurs fixes incluses)
    ↓
FormDataProcessor.processFormData() (nomenclatures → id ou liste d'id, cd_nom → int)
    ↓
ViewModels (visite / observation / site) → base locale Drift → synchronisation
```

> ℹ️ **Note technique** : `hidden`, `required` et les conditions/expressions des règles `change` passent toutes par le même interpréteur, `JsExpressionInterpreter`.

### Fichiers Clés

#### Core Layer
- **[`lib/core/helpers/form_config_parser.dart`](../lib/core/helpers/form_config_parser.dart)** :
  - Parsing et fusion des configurations JSON (`generic` + `specific`)
  - Détermination du widget (`determineWidgetType`) et génération du schéma unifié
  - Tri des champs selon l'ordre d'affichage

- **[`lib/core/helpers/js_expression_interpreter.dart`](../lib/core/helpers/js_expression_interpreter.dart)** :
  - Interpréteur d'expressions JavaScript (analyse lexicale et syntaxique, sémantique JS)
  - Accepte aussi les anciennes formes converties au format Dart

- **[`lib/core/helpers/hidden_expression_evaluator.dart`](../lib/core/helpers/hidden_expression_evaluator.dart)** :
  - Point d'entrée des expressions `hidden`, `required` et des conditions `change`

- **[`lib/core/helpers/change_expression_evaluator.dart`](../lib/core/helpers/change_expression_evaluator.dart)** :
  - Parsing des règles `change` JavaScript et évaluation de leurs conditions
  - Résolution des valeurs `patchValue` (y compris nomenclatures)

#### Data Layer
- **[`lib/data/repository/modules_repository_impl.dart`](../lib/data/repository/modules_repository_impl.dart)** :
  - Téléchargement et stockage de la configuration du module (sans conversion des expressions)

#### Presentation Layer
- **[`lib/presentation/viewmodel/form_data_processor.dart`](../lib/presentation/viewmodel/form_data_processor.dart)** :
  - **Méthode `isFieldRequired()`** : Évaluation dynamique des champs requis
  - **Méthode `isFieldHidden()`** : Évaluation dynamique de la visibilité
  - Traitement des données de formulaire avant sauvegarde (`processFormData`) et avant affichage (`processFormDataForDisplay`)
  - Conversion des nomenclatures et taxonomies

- **[`lib/presentation/viewmodel/change_rule_processor.dart`](../lib/presentation/viewmodel/change_rule_processor.dart)** :
  - Application des règles `change` après modification d'un champ

- **[`lib/presentation/widgets/dynamic_form_builder.dart`](../lib/presentation/widgets/dynamic_form_builder.dart)** :
  - Construction dynamique des formulaires
  - Gestion de l'état des champs
  - Mise à jour en temps réel des validations
  - Affichage de l'astérisque (*) pour les champs requis

- **[`lib/presentation/widgets/property_display_widget.dart`](../lib/presentation/widgets/property_display_widget.dart)** et **[`lib/presentation/view/base/detail_page.dart`](../lib/presentation/view/base/detail_page.dart)** :
  - Affichage des propriétés en page de détail (enrichissement nomenclatures / taxons / groupes de sites, formatage des valeurs)

## 🔄 Processus de Test d'un Nouveau Module

1. **Analyse des fichiers de configuration**
   - `module.json`, `site.json`, `visit.json`, `observation.json`
   - Vérification des expressions JavaScript et des règles `change`
   - Repérage des types non supportés (`medias`, datalist sur `api`, taxons multiples, nombres décimaux…)

2. **Test des composants**
   - Types de champs utilisés
   - Logique de visibilité conditionnelle
   - Nomenclatures et taxonomie

3. **Test d'intégration**
   - Mode hors-ligne
   - Synchronisation serveur
   - Gestion d'erreurs

4. **Validation fonctionnelle**
   - Workflow complet de saisie
   - Export des données
   - Cohérence avec GeoNature web

## 📞 Support et Contribution

Pour tester un nouveau module ou signaler des problèmes :
1. Créer une issue sur le repository GitHub
2. Fournir les fichiers de configuration du module
3. Décrire les fonctionnalités critiques à valider
4. Documenter les expressions JavaScript complexes utilisées

### Mise à jour du Tableau de Compatibilité

Pour mettre à jour le tableau après avoir testé un module :
1. Modifiez ce fichier `docs/FEATURES_OVERVIEW.md`
2. Ajoutez une ligne avec ✅ (testé et fonctionne), ⚠️ (fonctionne partiellement) ou ❌ (ne fonctionne pas)
3. Précisez dans « Notes » les fonctionnalités ou expressions concernées
4. Documentez les expressions JavaScript problématiques dans [JAVASCRIPT_EXPRESSIONS.md](JAVASCRIPT_EXPRESSIONS.md)

---

**Dernière mise à jour** : septembre 2026 (`v1.1.1+3` + commits post-release, dont les correctifs de l'audit des formulaires)
**Version de l'application** : Flutter 3.38.4 / Dart 3.10.3
**Architecture** : Clean Architecture avec Riverpod

## 📋 Historique des Changements

### Septembre 2026 — post `v1.1.1`
- ✅ Correctifs de l'audit des formulaires : enregistrement des visites avec nomenclature simple (blaireautière), interpréteur JavaScript, champs masqués à valeur fixe, nomenclatures multiples, règles `change` conservées au format d'origine, contexte `meta.nomenclatures` et taxon en objet, clé `multi_select` (voir [Bugs corrigés](#bugs-corrigés-audit-septembre-2026))
- ✅ Widget `multiselect` et choix du groupe de sites à la création d'un site depuis le module
- ✅ Tableau de compatibilité des 37 modules ([MODULES_COMPATIBILITY.md](MODULES_COMPATIBILITY.md))
- ✅ Tests : corpus d'expressions comparé à JavaScript, 19 scénarios E2E de non-régression, scripts `scripts/run_device_test.sh` et `scripts/protocoles_audit/`
- ✅ Version de l'app affichée sur l'accueil et dans le dialogue « Informations sur la version »
- ✅ Page Financeurs alignée sur le thème
- ✅ Audit de ce document contre le code : statuts des widgets, limitations et comptage des tests mis à jour

### Release `v1.1.1` — mai 2026
- ✅ Carte des sites pour les modules sans groupes de sites (+ UX de chargement)
- ✅ Onglet Sites virtualisé via `ListView.builder` (performances)
- ✅ Correctifs carte : crash bounds dégénérés, `autoDispose` du MapViewModel, fuite GPS
- ✅ Titres de groupes cliquables, labels et FAB sur la vue groupes

### Release `v1.1.0` — avril 2026
- ✅ Renommage de l'app en **Monitoring** avec nouveau logo
- ✅ Badges orange sur la liste pour repérer les saisies non synchronisées
- ✅ Désinstallation d'un module depuis le menu détail
- ✅ Refonte des appels d'API de synchronisation (endpoints `/refacto/` du module serveur)
- ✅ Onglets Groupes + Sites pour les modules mixtes (#157)
- ✅ E2E : 35 scénarios mock, 15 scénarios réels (dont 1 désactivé)
- ✅ Une trentaine de correctifs de saisie

### Release `v1.0.0` — avril 2026
- ✅ Picker de géométrie site `LineString`/`Polygon` plein écran avec validation des polygones auto-intersectés
- ✅ Aperçu carte en lecture seule sur la page de détail d'un site (`LocationPreviewHeader`)
- ✅ Calcul de distance GPS → site pour tous les types `Multi*` (issue #154)
- ✅ Marker GPS `Icons.my_location` visible dans le picker et les mini-cartes
- ✅ Normalisation du champ `modules` dans les payloads de groupes de sites (bug terrain)
- ✅ Remapping à la volée de `id_sites_group` lors du push pour éviter les conflits serveur
- ✅ Infrastructure E2E réelle contre un GeoNature local (12 scénarios) + E2E mock (33 scénarios)

### Release `v1.0.0-geonature-2.16` — avril 2026
- ✅ Snapshot de l'état code supportant GeoNature 2.16.x (branche `support/geonature-2.16`)

### Janvier – février 2026
- ✅ Règles `change` (`ChangeExpressionEvaluator`, `ChangeRuleProcessor`)
- ✅ Ternaire et addition supportés dans les expressions `hidden` / `required`

### Octobre 2025 — avant le bump de compat
- ✅ Ajout du support complet des expressions `required` conditionnelles
- ✅ Amélioration de la compatibilité des modules POPAmphibien et POPReptile
- ✅ Ajout de l'évaluation dynamique des validations avec expressions JavaScript
- ✅ Indicateurs visuels en temps réel pour les champs requis
- ✅ Documentation initiale des fonctionnalités supportées
- ✅ Catalogue complet des types de widgets
- ✅ Documentation des expressions JavaScript pour `hidden`
