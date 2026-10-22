# Audit des expressions des protocoles

Outils qui comparent l'évaluation des expressions `hidden` / `required` de l'app (`JsExpressionInterpreter`) à celle du module web, qui les exécute en JavaScript.

| Fichier | Rôle |
|---|---|
| `extract_expressions.py` | Extrait les expressions des protocoles (`<module>/site.json`, `visit.json`…) et génère des contextes `{value, meta}` au format du formulaire web |
| `synthetic_cases.json` | Cas ciblés (opérateurs, égalités JS, champs vides, méthodes, `meta`…) |
| `eval_js.js` | Évalue chaque cas avec Node.js (référence) |
| `generate_corpus.sh` | Enchaîne les étapes et écrit `test/fixtures/js_expressions_corpus.json` |

## Utilisation

```bash
# Protocoles à jour (clone de https://github.com/PnX-SI/protocoles_suivi, et forks éventuels)
scripts/protocoles_audit/generate_corpus.sh ~/protocoles_suivi [autre_dossier…]
flutter test test/core/helpers/js_expression_interpreter_test.dart
```

Un test en échec indique une expression dont le résultat diffère du web : corriger l'interpréteur, ou signaler la configuration si elle est fautive côté web.

Prérequis : `python3`, `node`.

Corpus actuel (septembre 2026) : PnX-SI/protocoles_suivi `origin/master` (`3ef22ad`) et les branches `dev/cmr_cistude` et `dev/popanomaloglossus` du fork Geomaticien-shf/protocoles_suivi.
