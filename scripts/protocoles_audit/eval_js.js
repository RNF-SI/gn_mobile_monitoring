#!/usr/bin/env node
// Évalue chaque cas avec le moteur JavaScript de Node (référence : le module
// web GeoNature Monitoring exécute ces expressions avec eval) et ajoute
// `expected` (valeur de vérité) ou `error` si l'expression lève.
//
// Usage : eval_js.js cases.json > corpus.json
const fs = require('fs');
const cases = JSON.parse(fs.readFileSync(process.argv[2], 'utf8'));
for (const c of cases) {
  try {
    const fn = eval('(' + c.expr + ')');
    const result = typeof fn === 'function' ? fn(c.context) : fn;
    c.expected = !!result;
  } catch (e) {
    c.error = e.message;
  }
}
process.stdout.write(JSON.stringify(cases, null, 1));
