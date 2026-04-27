# Vue d'ensemble des fonctionnalités - GeoNature Mobile Monitoring

Ce document présente les capacités et limitations de l'application mobile GeoNature pour le monitoring de la biodiversité.

> 💡 Pour la documentation technique détaillée des expressions JavaScript, voir [JAVASCRIPT_EXPRESSIONS.md](JAVASCRIPT_EXPRESSIONS.md)

## 🆕 Dernières Améliorations (Avril 2026 — `v1.0.0-geonature-2.17`)

### Saisie et visualisation de géométrie de site
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

### Infrastructure de tests E2E
- ✅ **12 scénarios E2E réels** contre un GeoNature local (auth, module, sites, groupes, visites, observations, sync download, sync upload)
- ✅ **33 scénarios E2E mock** avec bases in-memory et interceptor Dio, lancés sur Pixel 6a
- ✅ Helpers communs pour dismiss de dialogs bloquants et attente de fin de sync post-login

### Support des Expressions `required` (antérieur, rappel)
L'application supporte les **validations conditionnelles dynamiques** avec évaluation des expressions JavaScript pour `required` et `hidden` (astérisque rouge mis à jour en temps réel, champs cachés ignorés par la validation).

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

#### Checkbox - Cases à cocher
```json
{
  "en_vol": {
    "type_widget": "bool_checkbox",
    "attribut_label": "Observé en vol",
    "description": "Observé en vol",
    "default": false
  }
}
```

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
    "hidden": "({value}) => value.presence === 'Non'",
    "filters": {
      "cd_nomenclature": ["Co", "Es"]
    }
  }
}
```

**Sélection multiple** (checkboxes) - 🆕 **Nouveau** :
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
- ✅ Les nomenclatures multiples supportent pleinement les expressions conditionnelles
- ✅ Validation dynamique avec `required` (expressions JavaScript)
- ✅ Visibilité conditionnelle avec `hidden` (expressions JavaScript)
- ✅ Les valeurs sélectionnées sont sauvegardées dans un tableau d'IDs de nomenclatures

> 📘 **Documentation complète** : Voir [MULTIPLE_NOMENCLATURE_SELECTOR.md](MULTIPLE_NOMENCLATURE_SELECTOR.md) pour plus de détails sur la sélection multiple de nomenclatures.

#### DatasetSelector - Sélection de jeux de données
```json
{
  "id_dataset": {
    "hidden": "({meta}) => meta.dataset && Object.keys(meta.dataset).length == 1"
  }
}
```

#### ObserverField - Gestion des observateurs
⚠️ **Note** : Ce champ est automatiquement assigné à l'utilisateur courant dans cette version de l'application mobile

```json
{
  "observers": {
    "type_widget": "observers",
    "attribut_label": "Observateurs",
    "required": true
  }
}
```

#### CurrentUserField - Datalist mono-utilisateur (ex: déterminateur)
⚠️ **Note** : Tant que l'API `users/menu/<id_list>` n'est pas câblée localement, tout champ `datalist` ciblant un utilisateur unique (`type_util: "user"`, `multiple: false`) est traité comme `ObserverField` : auto-rempli avec l'utilisateur connecté et affiché en lecture seule (chrome partagé via `_buildAutoFilledUserField`).

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

## 🔄 Mapping Configuration → Widget

| Configuration JSON | Widget Flutter | Particularités |
|-------------------|----------------|----------------|
| `"type_widget": "text"` | TextField | Validation optionnelle |
| `"type_widget": "textarea"` | TextField_multiline | 3 lignes par défaut |
| `"type_widget": "number"` | NumberField | Support min/max |
| `"type_widget": "date"` | DatePicker | Format ISO 8601 |
| `"type_widget": "time"` | TimePicker | Format HH:MM |
| `"type_widget": "select"` | DropdownButton | Valeurs simples |
| `"type_widget": "datalist"` | DatalistField | Recherche + label/value |
| `"type_widget": "radio"` | RadioButton | Choix unique |
| `"type_widget": "bool_checkbox"` | Checkbox | Valeur booléenne |
| `"type_widget": "nomenclature"` | NomenclatureSelector | Référentiels GN |
| `"type_widget": "taxonomy"` | TaxonSelector | Recherche taxonomique |
| `"type_widget": "observers"` | ObserverField | Multi-sélection |
| `"type_widget": "datalist"` + `"type_util": "user"` (`multiple: false`) | CurrentUserField | Auto-rempli avec l'utilisateur connecté (chrome partagé avec ObserverField) |
| `"attribut_name": "id_dataset"` | DatasetSelector | Auto-détection |

## 🎯 Logique Conditionnelle

### Visibilité (`hidden`)
- ✅ **Booléens statiques** : `"hidden": true` ou `"hidden": false`
- ✅ **Conditions simples** : Masquage basé sur une valeur de champ
- ✅ **Expressions JavaScript** : `"hidden": "({value}) => value.champ === 'valeur'"`
- ✅ **Conditions complexes** : Combinaisons avec opérateurs logiques (&&, ||, !)
- ✅ **Cascades** : Champs cachés en cascade (A→B→C)
- ✅ **Auto-références** : Un champ peut se référencer lui-même
- ✅ **Persistance** : Conservation des valeurs des champs cachés

### Validation (`required`)
- ✅ **Booléens statiques** : `"required": true` ou `"required": false`
- ✅ **Expressions conditionnelles** : `"required": "({value}) => value.champ === 'valeur'"`
- ✅ **Format validations** : `"validations": {"required": true}` ou avec expressions JavaScript
- ✅ **Support des expressions string** : 🆕 Les expressions sous forme de chaîne sont maintenant évaluées dynamiquement
- ✅ **Champs cachés** : Les champs cachés ne sont pas validés (validation ignorée automatiquement)
- ✅ **Indicateur visuel** : Affichage dynamique de l'astérisque (*) selon l'état du champ requis

**Exemple complet de validation et visibilité conditionnelles** (POPReptile) :
```json
{
  "accessibility": {
    "type_widget": "radio",
    "values": ["Oui", "Non"],
    "value": "Oui",
    "default": "Oui"
  },
  "Heure_debut": {
    "type_widget": "time",
    "attribut_label": "Heure de début",
    "required": "({value}) => value.accessibility === 'Oui'",
    "hidden": "({value}) => value.accessibility === 'Non'"
  }
}
```

**Comportement dynamique** (🆕 amélioration récente) :
- Quand `accessibility = "Oui"` :
  - ✅ Le champ "Heure de début" est **visible**
  - ✅ Le label affiche "Heure de début **\***" (avec astérisque rouge)
  - ✅ La validation est **active** et évaluée dynamiquement
  - ✅ L'expression `required` est interprétée en temps réel

- Quand `accessibility = "Non"` :
  - ✅ Le champ "Heure de début" est **caché**
  - ✅ La validation est **désactivée** automatiquement (même si `required` est défini)
  - ✅ Les valeurs cachées sont conservées mais non validées

**Mise à jour en temps réel** : L'astérisque, le label et la validation s'ajustent instantanément lors des changements de valeur des champs dont dépend la condition.

> 📘 Pour la liste complète des expressions JavaScript supportées, voir [JAVASCRIPT_EXPRESSIONS.md](JAVASCRIPT_EXPRESSIONS.md)

## 📊 Statut de Test des Modules

Seuls les modules validés en conditions de terrain sont listés ici. Les autres modules de `gn_module_monitoring` peuvent fonctionner mais ne bénéficient pas d'une validation formelle sur cette version.

| Module | Testé | Fonctionne | Notes |
|--------|-------|------------|-------|
| **POPAmphibien** | ✅ | ✅ | Validations conditionnelles `required` et `hidden` évaluées dynamiquement |
| **POPReptile** | ✅ | ✅ | Tests complets incluant expressions JavaScript et distance GPS sur transect (issue #154) |

**Légende** : ✅ Testé et fonctionne | 🔄 Partiellement testé | ⚠️ Fonctionne partiellement | ❌ Incompatible

> ℹ️ Pour proposer la validation d'un autre module, voir la section [Processus de Test d'un Nouveau Module](#-processus-de-test-dun-nouveau-module) en fin de document.

## ⚠️ Limitations Connues

### Fonctionnalités applicatives non couvertes
- ❌ **Permissions CRUVED non appliquées côté UI** : le schéma est parsé mais n'est lu nulle part dans `lib/presentation/`. Tout utilisateur authentifié avec un module téléchargé peut créer/modifier/supprimer visites et observations, indépendamment de ses droits serveur.
- ❌ **Formulaire « Individus »** : le formulaire complémentaire de suivi individuel (marquage/recapture) exposé par certains modules monitoring côté web n'est pas pris en charge — ni UI de saisie, ni sync.
- ⚠️ **Modules mixtes sites + groupes de sites** : dès que `children_types` contient `sites_group`, la page module masque la liste des sites au profit des groupes. La saisie directe de sites au niveau module n'est accessible que si le module n'a aucun groupe de sites déclaré.
- ⚠️ **Couverture de tests inégale sur les compléments d'observation** : les champs `observation_detail` sont moins couverts que les visites/sites, des cas limites peuvent encore être rencontrés en production.

### Types de Widgets Manquants
- ❌ **Champs de fichiers/médias** : Upload d'images, documents
- ❌ **Champs avancés** : Couleurs, sliders, ranges
- ❌ **Composants complexes** : Tables dynamiques, formulaires imbriqués

### Validation Avancée
- ❌ **Validations cross-champs** : Pas de validation entre plusieurs champs
- ❌ **Validations asynchrones** : Pas de vérification côté serveur en temps réel
- ❌ **Messages d'erreur personnalisés** : Limités aux messages par défaut

### Performance
- ⚠️ **Rebuild complet** : Reconstruction de tout le formulaire lors de changements
- ⚠️ **Pas de lazy loading** : Tous les champs générés d'emblée
- ⚠️ **Cache limité** : Pas de mise en cache des configurations complexes

## 🔧 Architecture Technique

### Stack Technologique
- **Framework** : Flutter 3.38.4 (Dart 3.10.3)
- **Architecture** : Clean Architecture (Domain/Data/Presentation)
- **State Management** : Riverpod
- **Base de données locale** : Drift (SQLite, 28 migrations)
- **Carte** : `flutter_map` + tuiles OpenStreetMap
- **Localisation** : `geolocator` 14.x
- **HTTP** : Dio 5.x
- **Navigation** : GoRouter (routes d'auth) + Navigator.push (reste)
- **Modèles** : Freezed (immutable)

### Pipeline de Traitement des Formulaires

```
Configuration JSON (GeoNature)
    ↓
FormConfigParser.generateUnifiedSchema()
    ↓ (parsing et fusion object_config + custom_config)
    ↓
DynamicFormBuilder (State Management)
    ↓
    ├─→ FormDataProcessor.isFieldRequired()
    │   └─→ HiddenExpressionEvaluator.evaluateExpression()
    │       └─→ Évaluation des expressions `required`
    │
    └─→ FormDataProcessor.isFieldVisible()
        └─→ HiddenExpressionEvaluator.evaluateExpression()
            └─→ Évaluation des expressions `hidden`
    ↓
Widgets Flutter dynamiques (mise à jour en temps réel)
```

> ℹ️ **Note technique** : Les deux types d'expressions (`required` et `hidden`) utilisent la même classe `HiddenExpressionEvaluator` pour l'évaluation. Cette classe générique peut interpréter n'importe quelle expression JavaScript conditionnelle, qu'elle soit pour la visibilité ou la validation.

### Fichiers Clés

#### Core Layer
- **[`lib/core/helpers/form_config_parser.dart`](../../lib/core/helpers/form_config_parser.dart)** :
  - Parsing et fusion des configurations JSON
  - Génération du schéma unifié
  - Tri des champs selon l'ordre d'affichage

- **[`lib/core/helpers/hidden_expression_evaluator.dart`](../../lib/core/helpers/hidden_expression_evaluator.dart)** :
  - Évaluation **générique** des expressions JavaScript (utilisée pour `hidden` ET `required`)
  - Support des opérateurs logiques (&&, ||, !)
  - Support des comparaisons (==, !=, ===, !==, <, >, <=, >=)
  - Conversion des syntaxes JS vers Dart
  - **Classe réutilisable** : Une seule implémentation pour tous types d'expressions conditionnelles

#### Presentation Layer
- **[`lib/presentation/viewmodel/form_data_processor.dart`](../../lib/presentation/viewmodel/form_data_processor.dart)** :
  - **Méthode `isFieldRequired()`** : Évaluation dynamique des champs requis (🆕 ajoutée récemment)
  - **Méthode `isFieldVisible()`** : Évaluation dynamique de la visibilité
  - Traitement des données de formulaire avant sauvegarde
  - Conversion des nomenclatures et taxonomies

- **[`lib/presentation/widgets/dynamic_form_builder.dart`](../../lib/presentation/widgets/dynamic_form_builder.dart)** :
  - Construction dynamique des formulaires
  - Gestion de l'état des champs
  - Mise à jour en temps réel des validations
  - Affichage de l'astérisque (*) pour les champs requis

## 🔄 Processus de Test d'un Nouveau Module

1. **Analyse des fichiers de configuration**
   - `module.json`, `site.json`, `visit.json`, `observation.json`
   - Vérification des expressions JavaScript

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
2. Changez ☐ vers ✅ (testé et fonctionne) ou ❌ (ne fonctionne pas)
3. Mettez à jour la complexité JS si nécessaire
4. Documentez les expressions JavaScript problématiques dans [JAVASCRIPT_EXPRESSIONS.md](JAVASCRIPT_EXPRESSIONS.md)

---

**Dernière mise à jour** : avril 2026 (release `v1.0.0-geonature-2.17`)
**Version de l'application** : Flutter 3.38.4 / Dart 3.10.3
**Architecture** : Clean Architecture avec Riverpod

## 📋 Historique des Changements

### Release `v1.0.0-geonature-2.17` — avril 2026
- ✅ Picker de géométrie site `LineString`/`Polygon` plein écran avec validation des polygones auto-intersectés
- ✅ Aperçu carte en lecture seule sur la page de détail d'un site (`LocationPreviewHeader`)
- ✅ Calcul de distance GPS → site pour tous les types `Multi*` (issue #154)
- ✅ Marker GPS `Icons.my_location` visible dans le picker et les mini-cartes
- ✅ Normalisation du champ `modules` dans les payloads de groupes de sites (bug terrain)
- ✅ Remapping à la volée de `id_sites_group` lors du push pour éviter les conflits serveur
- ✅ Infrastructure E2E réelle contre un GeoNature local (12 scénarios) + E2E mock (33 scénarios)

### Release `v1.0.0-geonature-2.16` — avril 2026
- ✅ Snapshot de l'état code supportant GeoNature 2.16.x (branche `support/geonature-2.16`)

### Octobre 2025 — avant le bump de compat
- ✅ Ajout du support complet des expressions `required` conditionnelles
- ✅ Amélioration de la compatibilité des modules POPAmphibien et POPReptile
- ✅ Ajout de l'évaluation dynamique des validations avec expressions JavaScript
- ✅ Indicateurs visuels en temps réel pour les champs requis
- ✅ Documentation initiale des fonctionnalités supportées
- ✅ Catalogue complet des types de widgets
- ✅ Documentation des expressions JavaScript pour `hidden`
