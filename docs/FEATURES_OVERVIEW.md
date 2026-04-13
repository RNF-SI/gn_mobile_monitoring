# Vue d'ensemble des fonctionnalités - GeoNature Mobile Monitoring

Ce document présente les capacités et limitations de l'application mobile GeoNature pour le monitoring de la biodiversité.

> 💡 Pour la documentation technique détaillée des expressions JavaScript, voir [JAVASCRIPT_EXPRESSIONS.md](JAVASCRIPT_EXPRESSIONS.md)

## 🆕 Dernières Améliorations (Octobre 2025)

### Support Complet des Expressions `required`
L'application supporte maintenant les **validations conditionnelles dynamiques** avec évaluation des expressions JavaScript pour le champ `required`.

**Fonctionnalités ajoutées :**
- ✅ Évaluation dynamique des expressions `required` sous forme de chaînes JavaScript
- ✅ Support des formats `"required": "({value}) => expression"` et `"validations": {"required": "expression"}`
- ✅ Mise à jour en temps réel de l'indicateur visuel (astérisque rouge) selon les conditions
- ✅ Validation intelligente qui ignore automatiquement les champs cachés
- ✅ Support des mêmes opérateurs que pour `hidden` (==, !=, ===, !==, &&, ||, !, etc.)

**Impact sur la compatibilité :**
- Les modules POPAmphibien, POPReptile et ecrevisses_pattes_blanches passent de **90% à 100% de compatibilité** 🎉
- Toutes les expressions conditionnelles `required` sont maintenant évaluées correctement
- L'expérience utilisateur est améliorée avec un retour visuel immédiat sur les champs requis

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

**Commit de référence :** [`eb54732`](../../commit/eb54732) - "Champs required qui traite à présent les expressions string"

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

## 📊 Compatibilité des Modules

### Résumé par Complexité JavaScript

#### 🟢 Modules Simples (23 modules - 72%)
Compatible à 100%, utilise uniquement `"hidden": true/false` et `"required": true/false`
- apollons, cheveches, chiro, chronocapture, chronoventaire
- lichens_bio_indicateurs, micromam_analyse_pelotes_rejection_gmb
- nidif_gypa, oedic, osmodermes, piegeages_passifs
- prairies_fleuries, pt_ecoute_avifaune, pyrales
- RHOMEOOdonate, RHOMEOOrthoptere, sterf, stom
- Tous les modules **suivi_*** (sauf suivi_phytosocio)

#### 🟡 Modules Moyens (3 modules - 9%)
✅ **Compatible à 100%** (🆕 amélioration récente - support des expressions `required`)
- ecrevisses_pattes_blanches, POPAmphibien, POPReptile
- **Fonctionnalités supportées** : Expressions JavaScript pour `hidden` et `required`

#### 🟠 Modules Complexes (3 modules - 9%)
Compatible à 60%, nécessite extensions majeures
- ligne_lecture, RHOMEOAmphibien
- **Extensions requises** : `Object.keys()`, `includes()`

#### 🔴 Modules Très Complexes (3 modules - 9%)
Compatible à 20%, refactoring nécessaire
- petite_chouette_montagne, RHOMEOFlore, suivi_phytosocio
- **Problèmes** : Blocs multi-lignes, manipulation formulaires

### Statut de Test des Modules

| Module | Testé | Fonctionne | Complexité JS | Notes |
|--------|-------|------------|---------------|-------|
| **apollons** | ✅ | ✅ | 🟢 Simple | Module ID 21, expressions basiques |
| **cheveches** | ☐ | ☐ | 🟢 Simple | À tester |
| **chiro** | 🔄 | ⚠️ | 🟢 Simple | Tests d'erreurs |
| **POPAmphibien** | ✅ | ✅ | 🟡 Moyenne | 🆕 Validations conditionnelles `required` supportées |
| **POPReptile** | ✅ | ✅ | 🟡 Moyenne | 🆕 Tests complets avec expressions `required` et `hidden` |
| **RHOMEOAmphibien** | ☐ | ☐ | 🟠 Complexe | Méthode `includes()` |
| **petite_chouette_montagne** | ☐ | ☐ | 🔴 Très complexe | Opérateurs ternaires imbriqués |
| **RHOMEOFlore** | ☐ | ☐ | 🔴 Très complexe | Blocs multi-lignes |
| **suivi_phytosocio** | ☐ | ☐ | 🔴 Très complexe | Manipulation formulaires |

**Légende** :
- ✅ Testé et fonctionne | 🔄 Partiellement testé | ⚠️ Fonctionne partiellement | ☐ Non testé | ❌ Incompatible
- 🟢 Simple (100% compatible) | 🟡 Moyenne (90% compatible) | 🟠 Complexe (60% compatible) | 🔴 Très complexe (20% compatible)

## ⚠️ Limitations Connues

### Types de Widgets Manquants
- ❌ **Champs de fichiers/médias** : Upload d'images, documents
- ❌ **Champs géographiques** : Coordonnées GPS, cartes interactives
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
- **Framework** : Flutter 3.22.3
- **Architecture** : Clean Architecture (Domain/Data/Presentation)
- **State Management** : Riverpod
- **Base de données locale** : Drift (SQLite)
- **Navigation** : GoRouter
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

## 📝 Plan de Développement Recommandé

### Phase 1 - Tests Immédiats (23 modules 🟢)
1. Tester tous les modules simples
2. Valider la compatibilité 100%
3. Documenter les modules fonctionnels

### Phase 2 - Extensions Convertisseur (3 modules 🟠)
1. Supporter `Object.keys()` → `map.keys`
2. Supporter `includes()` → `contains()`
3. Tester modules complexes

### Phase 3 - Refactoring (3 modules 🔴)
1. Simplifier opérateurs ternaires
2. Convertir blocs multi-lignes en fonctions Dart
3. Adapter manipulation formulaires à Flutter

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

**Dernière mise à jour** : 22 octobre 2025
**Version de l'application** : Flutter 3.22.3
**Architecture** : Clean Architecture avec Riverpod

## 📋 Historique des Changements

### Version du 22 octobre 2025
- ✅ Ajout du support complet des expressions `required` conditionnelles
- ✅ Amélioration de la compatibilité des modules POPAmphibien, POPReptile et ecrevisses_pattes_blanches (100%)
- ✅ Ajout de l'évaluation dynamique des validations avec expressions JavaScript
- ✅ Indicateurs visuels en temps réel pour les champs requis

### Version du 17 octobre 2025
- ✅ Documentation initiale des fonctionnalités supportées
- ✅ Catalogue complet des types de widgets
- ✅ Documentation des expressions JavaScript pour `hidden`
