# Expressions JavaScript dans les formulaires GeoNature Mobile

## Vue d'ensemble

Les formulaires dynamiques reprennent trois types de règles écrites en JavaScript dans la configuration des modules GeoNature Monitoring :

- **`hidden`** : visibilité conditionnelle d'un champ ;
- **`required`** : caractère obligatoire conditionnel d'un champ ;
- **`change`** : remplissage automatique de champs quand le formulaire change (voir [Règles `change`](#règles-change--remplissage-automatique)).

Le module web exécute ces chaînes avec `eval`. L'application embarque un **interpréteur d'expressions JavaScript** (`JsExpressionInterpreter`) qui reproduit la sémantique JavaScript sur tout ce qu'utilisent les protocoles : opérateurs et priorités, égalité non stricte (`'2' == 2`), valeurs « falsy », `undefined`, méthodes usuelles. Depuis septembre 2026, il remplace l'ancien évaluateur à base d'expressions régulières.

> ✅ **Vérifié contre JavaScript** : les 289 expressions `hidden`/`required` (28 modules) des 37 protocoles de [PnX-SI/protocoles_suivi](https://github.com/PnX-SI/protocoles_suivi) et du fork [Geomaticien-shf/protocoles_suivi](https://github.com/Geomaticien-shf/protocoles_suivi), plus des cas ciblés, forment un corpus de 1 330 évaluations comparées à Node.js (`test/core/helpers/js_expression_interpreter_test.dart`). Toutes donnent le même résultat que le web.

Fichiers concernés :

| Rôle | Fichier |
|------|---------|
| Interpréteur JavaScript | `lib/core/helpers/js_expression_interpreter.dart` |
| Point d'entrée `hidden` / `required` / conditions `change` | `lib/core/helpers/hidden_expression_evaluator.dart` |
| Évaluation par champ | `lib/presentation/viewmodel/form_data_processor.dart` (`isFieldHidden`, `isFieldRequired`) |
| Contexte `{value, meta}` du formulaire | `lib/presentation/widgets/dynamic_form_builder.dart` (`_buildEvaluationContext`) |
| Règles `change` : analyse | `lib/core/helpers/change_expression_evaluator.dart` |
| Règles `change` : application | `lib/presentation/viewmodel/change_rule_processor.dart` |
| Corpus de référence et scripts | `test/fixtures/js_expressions_corpus.json`, `scripts/protocoles_audit/` |

### Chaîne de traitement

1. **Au téléchargement du module** (et à chaque « Mettre à jour les données »), la configuration est stockée **telle que servie par le serveur**, sans conversion. Les versions antérieures convertissaient les `hidden` au format Dart et les règles `change` en format structuré, ce qui perdait de l'information. Les modules installés avant 09/2026 retrouvent leurs expressions d'origine à la prochaine synchronisation ; d'ici là, l'interpréteur accepte aussi les anciennes formes converties (`(value) => value['x'] as bool`, `(meta['dataset'] as Map).keys.length`).
2. **À l'affichage du formulaire**, chaque expression est évaluée avec le contexte `{value, meta}` décrit ci-dessous. Le résultat est interprété selon la valeur de vérité JavaScript.

## Contexte d'évaluation

Aligné sur le module web 1.3.0 (`monitoring-form.component.ts`, `dynamic-form.service.ts`) :

| Clé | Contenu dans l'app | Remarque |
|---|---|---|
| `value` | Valeurs du formulaire | Un champ taxonomique est exposé en **objet** `{cd_nom: …}`, comme la valeur du widget web : `value.cd_nom.cd_nom == 60630` fonctionne |
| `meta.nomenclatures` | Nomenclatures des champs du formulaire, indexées par `id_nomenclature` (`cd_nomenclature`, `mnemonique`, `label_default`, `label_fr`, `code_type`) | Ex. `(meta.nomenclatures[value.technique_observation] \|\| {}).cd_nomenclature === '0'` |
| `meta.bChainInput` | Enchaînement des saisies activé | |
| `meta.parents` | `{site, module}` | Partiel : le web fournit les objets parents complets |
| `meta.dataset` | **Absent** (`undefined`) | Le web ne le renseigne que par effet de bord de cache ; `meta.dataset && …` vaut donc faux et le choix du jeu de données reste affiché |
| `meta.id_role` | Absent | Non utilisé par les protocoles connus |

Paramètres acceptés : `({value})`, `({value, meta})`, `({meta, value})`, et les formes converties `(value) => …` des anciennes versions.

## Syntaxe supportée

Tout ce qui suit a la sémantique JavaScript exacte (vérifiée par le corpus).

| Catégorie | Exemples |
|---|---|
| Accès | `value.a`, `value['a']`, `value.cd_nom.cd_nom`, `value.o?.p`, `meta.nomenclatures[value.t]` |
| Logique | `a && b`, `a \|\| b`, `!a`, `!!a`, `a ?? b`, parenthèses à tous les niveaux : `!(a && b)`, `a \|\| (b && c)` |
| Comparaison | `==`, `!=` (non strictes : `'2' == 2` vrai), `===`, `!==`, `<`, `<=`, `>`, `>=` (`null > 0` faux, `undefined > 0` faux) |
| Arithmétique | `+` (addition ou concaténation), `-`, `*`, `/`, `%`, `-x` |
| Ternaire | `a ? b : c`, imbriqués, conditions composées : `a && b ? 1 : 0` |
| Littéraux | nombres (`19.99`, `-5`, `1e6`), chaînes, `true`, `false`, `null`, `undefined`, tableaux `['A', null]`, objets `{}` |
| Tableaux | `.length`, `.includes()`, `.indexOf()`, `.join()`, `.some()`, `.every()`, `.filter()`, `.map()`, `.find()` avec fonctions fléchées |
| Chaînes | `.length`, `.includes()`, `.indexOf()`, `.startsWith()`, `.endsWith()`, `.toLowerCase()`, `.toUpperCase()`, `.trim()`, `.split()` |
| Fonctions globales | `Object.keys()`, `Object.values()`, `Array.isArray()`, `parseInt()`, `parseFloat()`, `Number()`, `String()`, `Boolean()`, `isNaN()`, `Math.abs/round/floor/ceil/max/min` |
| Divers | `typeof`, corps en bloc `{ return …; }`, `controls.champ.dirty` / `objForm.controls.champ.dirty` |

### Non supporté

`new Date(…)` et les méthodes de dates, les expressions régulières (`/…/.test()`), les blocs `if`/`for` dans `hidden`/`required` (ils sont en revanche reconnus dans les règles `change`), les template literals avec `${…}`, l'affectation.

## Comportement en cas d'erreur

- Une expression invalide, ou qui lève une erreur JavaScript (ex. `value.o.p` quand `o` est vide, variable inconnue), vaut `null` :
  - `hidden` → le champ est **affiché** ;
  - `required` → le champ est **non requis** ;
  - règle `change` → la règle n'est **pas appliquée**.
- Sur le web, la même erreur apparaît dans la console du navigateur. Les expressions robustes se protègent comme le font les protocoles : `(meta.nomenclatures[value.x] || {}).cd_nomenclature`.

## Propriétés supportant les expressions

### `hidden`

```json
"heure_debut": {
  "type_widget": "time",
  "attribut_label": "Heure de début",
  "hidden": "({value}) => value.accessibility !== 'Oui'"
}
```

- Un champ masqué **n'est pas validé** (plus souple que le web, où un champ masqué dont `required` est vrai bloque l'enregistrement).
- Sa valeur est conservée pendant la saisie (elle réapparaît si le champ redevient visible).
- À l'enregistrement, un champ masqué par une **expression** n'est envoyé que s'il est `required: true` (booléen) ou s'il a été rempli par une règle `change`. Le web l'envoie toujours : choix délibéré de l'app, pour ne pas enregistrer une valeur saisie puis masquée.
- Un champ masqué **en dur** (`"hidden": true`) avec une `value` est toujours envoyé avec cette valeur, comme sur le web (ex. taxon fixe d'un protocole).

### `required`

```json
"etat_site": {
  "type_widget": "radio",
  "required": "({value}) => value.accessibility === 'Oui' && (value.num_passage === 1)",
  "hidden": "({value}) => value.accessibility === 'Non' || (value.num_passage !== 1)"
}
```

Formats : booléen, expression (partie `specific` de la configuration), ou `"validations": {"required": …}`. Dans la partie `generic`, une expression `required` est ramenée à `false` par le parseur de configuration (aucun protocole connu n'en utilise).

## Règles `change` : remplissage automatique

Les règles `change` modifient automatiquement des champs quand l'utilisateur en modifie un autre (remettre des effectifs à 0 si « absence », calculer un nom de site, un total…).

### Format côté configuration GeoNature

Au niveau d'un objet (`site`, `sites_group`, `visit`, `observation`, `observation_detail`), sous forme de tableau de lignes de code :

```json
"change": [
  "({objForm, meta}) => {",
  "const base_site_name = 'T' + (objForm.value.num_transect) + 'Q' + (objForm.value.num_placette);",
  "if (!objForm.controls.base_site_name.dirty) {",
  "objForm.patchValue({base_site_name})",
  "}",
  "}",
  ""
]
```
*(configuration RHOMEOFlore, `test/presentation/viewmodel/change_rule_processor_real_configs_test.dart`)*

### Syntaxe reconnue

| Construction | Exemple |
|---|---|
| Bloc `if` + `patchValue` | `if (cond) { objForm.patchValue({a: 0}) }` |
| `patchValue` inconditionnel | `objForm.patchValue({nb_total});` |
| Ternaire | `(cond ? objForm.patchValue({x}) : '');` |
| `const` | `const surface = objForm.value.longueur * objForm.value.largeur;` |
| Propriété abrégée | `patchValue({surface})` : valeur de la `const`, sinon du champ de même nom |
| Valeurs de `patchValue` | `null`, booléens, nombres, chaînes, objets imbriqués, `objForm.value.champ` |
| `console.log(...)`, `{emitEvent: false}` | Ignorés |

Les conditions et les expressions de `const` sont évaluées par l'interpréteur JavaScript (mêmes capacités que `hidden`/`required`), avec `objForm.value`, `objForm.controls.x.dirty` et `meta.nomenclatures`.

### Comportement à l'exécution

- Les règles sont évaluées à chaque modification d'un champ texte, nombre, liste, bouton radio ou taxon par l'utilisateur, mais **pas à l'ouverture du formulaire** (le web les exécute aussi à l'initialisation, via `valueChanges`).
- Toutes les règles dont la condition est vraie sont appliquées, dans l'ordre, sur le même instantané des valeurs : en cas de conflit, la dernière l'emporte.
- Les champs remplis par une règle sont conservés à l'enregistrement même s'ils sont masqués, tant que l'utilisateur ne les a pas modifiés à la main.

## Recommandations pour les auteurs de configuration

1. Tester les expressions avec des champs **vides** : `value.x > 0` est faux quand `x` est vide, `value.x.y` lève une erreur.
2. Pour un taxon, comparer `value.cd_nom.cd_nom` (objet), comme sur le web : `value.cd_nom != 3507` compare un objet à un nombre et est toujours vrai (cas de `petite_chouette_montagne`, identique sur le web).
3. Protéger les accès aux nomenclatures : `(meta.nomenclatures[value.x] || {}).cd_nomenclature`.
4. Ne pas compter sur `meta.dataset`, rarement renseigné (web comme mobile).

## Maintenance du corpus

Quand les protocoles évoluent :

```bash
scripts/protocoles_audit/generate_corpus.sh ~/protocoles_suivi [autre_dossier…]
flutter test test/core/helpers/js_expression_interpreter_test.dart
```

Le script extrait toutes les expressions `hidden`/`required`, génère des valeurs de test (vides, valeurs déclarées, nombres), les évalue avec Node.js et régénère `test/fixtures/js_expressions_corpus.json`. Les cas ciblés sont dans `scripts/protocoles_audit/synthetic_cases.json`. Prérequis : `python3`, `node`.

---

Dernière mise à jour : septembre 2026 (v1.1.1+3, correctifs de l'audit des formulaires)
