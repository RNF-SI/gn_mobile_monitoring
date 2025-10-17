# Fonctionnalités JavaScript supportées dans les formulaires GeoNature Mobile

## Vue d'ensemble

Les formulaires dynamiques de GeoNature Mobile permettent de définir des **conditions de visibilité** (`hidden`) et des **validations conditionnelles** (`required`) des champs en utilisant des expressions JavaScript. Ces expressions sont interprétées côté Dart lors du chargement des modules.

## Expressions supportées ✅

### 1. Accès aux propriétés

#### Format JavaScript (historique)
```javascript
({value}) => value.test_detectabilite
({value}) => value.champ_exemple
```

#### Format Dart
```javascript
(value) => value['test_detectabilite']
(value) => value['champ_exemple']
```

### 2. Opérateurs logiques

#### AND (&&)
```javascript
(value) => value['field1'] && value['field2']
(value) => value['test'] && value['autre_test']
```

#### OR (||)
```javascript
(value) => value['field1'] || value['field2']
(value) => value['option_a'] || value['option_b']
```

#### NOT (!)
```javascript
(value) => !value['field1']
(value) => !value['est_visible']
```

### 3. Opérateurs de comparaison

#### Égalité
```javascript
// Égalité simple
(value) => value['statut'] == 'actif'
(value) => value['count'] != 0

// Égalité stricte (type + valeur)
(value) => value['id'] === 123
(value) => value['code'] !== 'ABC'
```

#### Comparaisons numériques
```javascript
(value) => value['age'] > 18
(value) => value['score'] >= 50
(value) => value['temperature'] < 0
(value) => value['niveau'] <= 100
```

### 4. Valeurs littérales supportées

```javascript
// Nombres entiers
(value) => value['count'] == 42

// Nombres décimaux
(value) => value['price'] > 19.99

// Notation scientifique
(value) => value['distance'] < 1e6

// Booléens
(value) => value['is_active'] == true
(value) => value['is_deleted'] == false

// Chaînes de caractères
(value) => value['status'] == 'pending'
(value) => value['type'] == "complex"
```

### 5. Cast de type (Dart)

```javascript
// Forcer l'interprétation en booléen
(value) => value['flag'] as bool
```

### 6. Fonction spéciale Object.keys

```javascript
// Compter le nombre de propriétés d'un objet
(value) => Object.keys(value.metadata).length > 0
```

### 7. Conditions complexes

```javascript
// Combinaisons d'opérateurs
(value) => !value['disabled'] && value['count'] > 0
(value) => value['type'] == 'A' || (value['type'] == 'B' && value['subtype'] == 'X')

// Comparaisons multiples
(value) => value['age'] >= 18 && value['age'] <= 65
```

## Expressions NON supportées ❌

### 1. Méthodes de tableaux

```javascript
// ❌ Array.includes()
(value) => value['tags'].includes('important')

// ❌ Array.map()
(value) => value['items'].map(i => i.id)

// ❌ Array.filter()
(value) => value['items'].filter(i => i.active).length > 0

// ❌ Array.some()
(value) => value['users'].some(u => u.role === 'admin')

// ❌ Array.length sur des tableaux
(value) => value['items'].length > 0
```

### 2. Méthodes de chaînes

```javascript
// ❌ String.includes()
(value) => value['description'].includes('mot-clé')

// ❌ String.match()
(value) => value['email'].match(/^.+@.+$/)

// ❌ String.toLowerCase() / toUpperCase()
(value) => value['code'].toLowerCase() === 'abc'
```

### 3. Fonctions globales

```javascript
// ❌ parseInt() / parseFloat()
(value) => parseInt(value['string_number']) > 10

// ❌ isNaN()
(value) => !isNaN(value['maybe_number'])

// ❌ Math.*
(value) => Math.max(value['a'], value['b']) > 100
```

### 4. Opérateurs modernes JavaScript

```javascript
// ❌ Opérateur ternaire
(value) => value['type'] === 'A' ? true : false

// ❌ Nullish coalescing (??)
(value) => value['field'] ?? 'default'

// ❌ Optional chaining (?.)
(value) => value?.nested?.property
```

### 5. Manipulation de dates

```javascript
// ❌ Constructeur Date
(value) => new Date(value['date']).getFullYear() === 2024

// ❌ Comparaisons de dates
(value) => new Date(value['start']) < new Date(value['end'])
```

### 6. Expressions arithmétiques

```javascript
// ❌ Addition
(value) => value['a'] + value['b'] > 10

// ❌ Multiplication
(value) => value['quantity'] * value['price'] > 100

// ❌ Modulo
(value) => value['number'] % 2 === 0
```

### 7. Structures de contrôle

```javascript
// ❌ Conditions if/else
(value) => {
  if (value['type'] === 'A') return true;
  else return false;
}

// ❌ Boucles
(value) => {
  for (let item of value['items']) {
    if (item.active) return true;
  }
  return false;
}
```

### 8. Expressions régulières

```javascript
// ❌ RegExp
(value) => /^[0-9]+$/.test(value['code'])
```

## Propriétés supportant les expressions conditionnelles

### 1. `hidden` - Visibilité conditionnelle

Permet de masquer ou afficher un champ selon des conditions dynamiques.

```javascript
// Exemple : Cacher un champ si "accessibility" n'est pas "Oui"
"Heure_debut": {
  "type_widget": "time",
  "attribut_label": "Heure de début",
  "hidden": "({value}) => value.accessibility !== 'Oui'"
}
```

### 2. `required` - Validation conditionnelle

Permet de rendre un champ requis ou optionnel selon des conditions dynamiques.

```javascript
// Exemple : Le champ est requis seulement si "accessibility" est "Oui"
"Heure_debut": {
  "type_widget": "time",
  "attribut_label": "Heure de début",
  "required": "({value}) => value.accessibility === 'Oui'",
  "hidden": "({value}) => value.accessibility === 'Non'"
}
```

**Formats supportés pour `required` :**
- Booléen statique : `"required": true` ou `"required": false`
- Expression JavaScript : `"required": "({value}) => expression"`
- Dans `validations` : `"validations": {"required": true}` ou `"validations": {"required": "({value}) => expression"}`

**⚠️ Note importante (Bug corrigé en octobre 2025)** :
Les expressions conditionnelles pour `required` n'étaient pas correctement préservées lors de la génération du schéma unifié. Ce bug a été corrigé dans `FormConfigParser.generateUnifiedSchema()`. Si vous utilisez une version antérieure, les expressions `required` conditionnelles seront converties en `false`.

## Mécanisme de visibilité en cascade

Le système supporte la propagation automatique des conditions de masquage :

### Principe
- Si un champ A est caché et qu'un champ B dépend de la valeur de A, alors B sera automatiquement caché
- Cette propagation est récursive avec une limite de 10 itérations pour éviter les boucles infinies

### Exemple
```javascript
// Configuration des champs
champA: {
  hidden: "(value) => value['option'] == false"
}

champB: {
  hidden: "(value) => value['champA'] == 'valeur_specifique'"
}

// Si option == false, alors champA est caché
// Si champA est caché, alors champB est automatiquement caché aussi
```

### Important
- Les champs cachés **conservent leurs valeurs** dans le formulaire
- Les champs `required` cachés **ne sont PAS validés** (la validation est ignorée pour les champs cachés)
- Les champs `required` + cachés restent dans les données envoyées au serveur
- Les champs non-required cachés sont exclus des données finales

## Optimisations

Le système utilise des expressions normalisées en interne pour améliorer les performances :

- `NORMALIZED:SIMPLE:fieldName` - Accès direct à un champ
- `NORMALIZED:NOT:fieldName` - Négation simple
- `NORMALIZED:AND:field1:field2` - Condition ET entre deux champs
- `NORMALIZED:NOTAND:field1:field2` - !field1 && field2
- `NORMALIZED:ANDNOT:field1:field2` - field1 && !field2

## Recommandations

1. **Privilégier les expressions simples** pour de meilleures performances
2. **Éviter les dépendances circulaires** entre champs
3. **Tester les expressions** dans différents contextes (valeurs nulles, types inattendus)
4. **Utiliser le format Dart** `(value) => value['field']` pour les nouvelles configurations

## Exemples pratiques

### Afficher un champ selon une case à cocher
```javascript
// Le champ "details" n'apparaît que si "needs_details" est coché
details: {
  hidden: "(value) => !value['needs_details']"
}
```

### Condition sur une nomenclature
```javascript
// Afficher le champ seulement si le statut est "autre"
champ_precision: {
  hidden: "(value) => value['id_nomenclature_statut'] != 999"
}
```

### Conditions multiples
```javascript
// Afficher seulement si adulte ET consentement donné
donnees_sensibles: {
  hidden: "(value) => !(value['age'] >= 18 && value['consent'] == true)"
}
```