# Widget de sélection multiple de nomenclatures

## Vue d'ensemble

Le `MultipleNomenclatureSelectorWidget` est un nouveau widget ajouté pour permettre la sélection de plusieurs nomenclatures simultanément dans les formulaires dynamiques de l'application GeoNature Mobile Monitoring.

## Contexte

Jusqu'à présent, l'application supportait :
- ✅ **Sélection simple de nomenclatures** via `NomenclatureSelectorWidget` (dropdown)
- ✅ **Sélection multiple de valeurs statiques** via `_buildMultiSelectDatalist` (checkboxes)
- ❌ **Sélection multiple de nomenclatures** : **NON SUPPORTÉ**

Le module POPamphibien de la SHF est le premier module à nécessiter la sélection multiple de nomenclatures (champ `methode_de_prospection`), ce qui a motivé la création de ce widget.

## Fichiers créés/modifiés

### Nouveaux fichiers

1. **Widget principal** : [`lib/presentation/widgets/multiple_nomenclature_selector_widget.dart`](../lib/presentation/widgets/multiple_nomenclature_selector_widget.dart)
   - Widget Flutter pour la sélection multiple avec checkboxes
   - Format de sortie : `List<int>` (liste d'IDs de nomenclatures)

2. **Tests du widget** : [`test/presentation/widgets/multiple_nomenclature_selector_test.dart`](../test/presentation/widgets/multiple_nomenclature_selector_test.dart)
   - 8 tests couvrant toutes les fonctionnalités
   - Tests de sélection, désélection, validation, chargement

3. **Tests du parser** : [`test/core/helpers/form_config_parser_multiple_test.dart`](../test/core/helpers/form_config_parser_multiple_test.dart)
   - 5 tests vérifiant la préservation de la propriété `multiple`
   - Tests de fusion de configuration

### Fichiers modifiés

1. **Parser de configuration** : [`lib/core/helpers/form_config_parser.dart`](../lib/core/helpers/form_config_parser.dart)
   - Ajout de la propriété `multiple` dans le schéma unifié (ligne 563)

2. **Générateur de formulaire** : [`lib/presentation/widgets/dynamic_form_builder.dart`](../lib/presentation/widgets/dynamic_form_builder.dart)
   - Import du nouveau widget (ligne 11)
   - Détection de `multiple: true` dans `_buildNomenclatureField()` (ligne 1768)
   - Nouvelle méthode `_buildMultipleNomenclatureField()` (lignes 1839-1882)

## Utilisation

### Configuration JSON

Pour activer la sélection multiple de nomenclatures, utilisez la configuration suivante :

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

### Propriétés clés

| Propriété | Valeur | Description |
|-----------|--------|-------------|
| `type_widget` | `"datalist"` | Type de widget de base |
| `api` | `"nomenclatures/nomenclature/XXX"` | API de nomenclatures (déclenche la conversion) |
| `type_util` | `"nomenclature"` | Indique qu'il s'agit d'une nomenclature |
| **`multiple`** | **`true`** | **Active la sélection multiple** |

### Format de données

#### Sauvegarde

Le widget sauvegarde les valeurs au format **array d'IDs** pour être compatible avec le backend GeoNature :

```json
{
  "methode_de_prospection": [654, 657, 659]
}
```

#### Chargement

Le widget accepte plusieurs formats de valeurs initiales et les convertit automatiquement :

```dart
// Format array d'IDs (recommandé)
[654, 657, 659]

// Format entier unique (converti en array)
657  →  [657]

// Format objet (extrait l'ID)
{"id": 657}  →  [657]

// Format array d'objets (extrait les IDs)
[{"id": 654}, {"id": 657}]  →  [654, 657]
```

## Fonctionnalités

### Interface utilisateur

Le widget affiche :

1. **En-tête avec compteur**
   - Icône de checklist
   - Nombre d'éléments sélectionnés (ex: "2 sélectionné(s)")
   - Bouton "Tout désélectionner" (visible si au moins 1 sélection)

2. **Liste de nomenclatures**
   - Checkboxes pour chaque nomenclature
   - Labels en français (ou libellé par défaut)
   - Scrollable avec hauteur max de 300px

3. **Validation**
   - Message d'erreur si le champ est requis et vide
   - Respect des expressions conditionnelles `required`

4. **États de chargement**
   - Indicateur de chargement pendant le fetch
   - Message "Aucune nomenclature disponible" si liste vide
   - Gestion des erreurs de chargement

### Exemple visuel

```
┌─────────────────────────────────────────┐
│ Méthode(s) de prospection *             │
│ Sélectionnez une ou plusieurs méthodes  │
├─────────────────────────────────────────┤
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
    ↓ (préserve `multiple: true`)
DynamicFormBuilder._buildFieldWidget()
    ↓ (détecte widget_type: NomenclatureSelector)
_buildNomenclatureField()
    ↓ (détecte multiple: true)
_buildMultipleNomenclatureField()
    ↓
MultipleNomenclatureSelectorWidget
```

### 2. Chargement des nomenclatures

```
MultipleNomenclatureSelectorWidget
    ↓
nomenclaturesByTypeProvider(typeCode)
    ↓
NomenclatureService.getNomenclaturesByTypeCode()
    ↓
Cache ou Database
    ↓
List<Nomenclature>
```

### 3. Sélection → Sauvegarde

```
User clicks checkbox
    ↓
_toggleNomenclature(id)
    ↓
_selectedIds.add(id) ou .remove(id)
    ↓
widget.onChanged(selectedList)
    ↓
DynamicFormBuilder._formValues[fieldName] = [ids...]
    ↓
Sauvegarde dans t_visit_complements.data
```

## Tests

### Tests du widget (8 tests)

```bash
flutter test test/presentation/widgets/multiple_nomenclature_selector_test.dart
```

1. ✅ Affichage de la liste avec checkboxes
2. ✅ Sélection de plusieurs éléments
3. ✅ Désélection d'éléments
4. ✅ Bouton "Tout désélectionner"
5. ✅ Validation pour champ requis et vide
6. ✅ Pas de validation si requis mais a une sélection
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

## Comparaison avec les widgets existants

| Widget | Sélection | Composant UI | Format de sortie | Cas d'usage |
|--------|-----------|--------------|------------------|-------------|
| `NomenclatureSelectorWidget` | Simple | DropdownButton | `Map<String, dynamic>` | Nomenclature unique requise |
| **`MultipleNomenclatureSelectorWidget`** | **Multiple** | **CheckboxListTile** | **`List<int>`** | **Nomenclatures multiples** |
| `_buildMultiSelectDatalist` | Multiple | CheckboxListTile | `List<String>` | Valeurs statiques multiples |

## Architecture

### Responsabilités

- **MultipleNomenclatureSelectorWidget** :
  - Affichage de la liste de checkboxes
  - Gestion de l'état des sélections (`_selectedIds`)
  - Communication avec le parent via `onChanged`
  - Validation visuelle (message d'erreur)

- **DynamicFormBuilder** :
  - Détection de `multiple: true`
  - Conversion des valeurs initiales en `List<int>`
  - Stockage dans `_formValues`
  - Validation du formulaire

- **FormConfigParser** :
  - Préservation de la propriété `multiple`
  - Conversion `datalist` + API nomenclature → `NomenclatureSelector`

### Principe de conception

Le choix de créer un widget séparé (au lieu de modifier `NomenclatureSelectorWidget`) suit le **principe de responsabilité unique** :

- Chaque widget a une responsabilité claire
- Code plus simple et maintenable
- Tests séparés et plus clairs
- Pas de risque de régression sur le widget existant

## Compatibilité

### Backend GeoNature

Le format `List<int>` est compatible avec le backend GeoNature qui stocke les nomenclatures multiples sous forme d'array :

```json
{
  "methode_de_prospection": [654, 657, 659]
}
```

### Migration des données

Les données existantes au format entier sont automatiquement converties :

```dart
// Ancien format (int)
657

// Nouveau format (List<int>)
[657]
```

## Exemples d'utilisation

### Module POPamphibien (SHF)

Le champ `methode_de_prospection` permet aux observateurs de sélectionner plusieurs méthodes de prospection utilisées lors d'un passage :

- Capture au filet troubleau
- Observation à vue
- Écoute
- Recherche d'indices de présence
- etc.

### Autres cas d'usage possibles

- **Habitats** : Sélection de plusieurs types d'habitats
- **Menaces** : Identification de multiples menaces sur un site
- **Activités humaines** : Enregistrement de plusieurs activités observées
- **Méthodes d'observation** : Combinaison de plusieurs techniques

## Limitations connues

1. **Hauteur max** : La liste est limitée à 300px de hauteur pour éviter un widget trop grand. Au-delà, un scroll apparaît.

2. **Pas de recherche** : Contrairement au widget simple qui pourrait avoir une recherche, ce widget n'en a pas pour le moment.

3. **Pas de sélection groupée** : Pas de bouton "Tout sélectionner" (seulement "Tout désélectionner").

## Améliorations futures

1. **Recherche/filtrage** : Ajouter un champ de recherche pour les longues listes
2. **Sélection groupée** : Bouton "Tout sélectionner"
3. **Ordre personnalisé** : Permettre de réordonner les sélections
4. **Compteur plus détaillé** : "2/10 sélectionnés"
5. **Mode compact** : Option pour afficher les sélections sous forme de chips

## Références

- Widget principal : [`lib/presentation/widgets/multiple_nomenclature_selector_widget.dart`](../lib/presentation/widgets/multiple_nomenclature_selector_widget.dart)
- Tests : [`test/presentation/widgets/multiple_nomenclature_selector_test.dart`](../test/presentation/widgets/multiple_nomenclature_selector_test.dart)
- Issue/PR : [À compléter]

## Auteur

- **Claude Code** (Anthropic)
- **Date** : 21 octobre 2025
- **Version** : 1.0.0
