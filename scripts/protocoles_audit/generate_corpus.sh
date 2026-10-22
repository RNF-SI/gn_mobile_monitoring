#!/usr/bin/env bash
# Régénère test/fixtures/js_expressions_corpus.json : expressions hidden/required
# des protocoles + cas synthétiques, évaluées par Node (référence web).
#
# Usage : scripts/protocoles_audit/generate_corpus.sh <dossier_protocoles> [...]
#   ex. : scripts/protocoles_audit/generate_corpus.sh ~/protocoles_suivi
# Prérequis : python3, node.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$HERE/../.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

python3 "$HERE/extract_expressions.py" "$@" > "$TMP/protocoles.json"
python3 - "$HERE/synthetic_cases.json" "$TMP/protocoles.json" > "$TMP/all.json" <<'PY'
import json, sys
cases = []
for path in sys.argv[1:]:
    cases += json.load(open(path, encoding='utf-8'))
json.dump(cases, sys.stdout, ensure_ascii=False)
PY
node "$HERE/eval_js.js" "$TMP/all.json" > "$ROOT/test/fixtures/js_expressions_corpus.json"
python3 -c "
import json; c=json.load(open('$ROOT/test/fixtures/js_expressions_corpus.json'))
print(len(c), 'cas,', sum('error' in x for x in c), 'erreurs JS,', len({x['expr'] for x in c}), 'expressions distinctes')"
