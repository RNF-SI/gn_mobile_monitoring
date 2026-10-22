#!/usr/bin/env python3
"""Extrait les expressions hidden/required des protocoles GeoNature Monitoring
et génère des contextes d'évaluation (valeurs de champs au format du
formulaire web).

Usage : extract_expressions.py <dossier_protocoles> [<dossier> ...] > cases.json

Chaque dossier contient un sous-dossier par module (site.json, visit.json…),
comme https://github.com/PnX-SI/protocoles_suivi.
"""
import itertools
import json
import os
import re
import sys

OBJECTS = ['site', 'sites_group', 'visit', 'observation', 'observation_detail']
# Nomenclatures fictives pour les expressions meta.nomenclatures[...]
META_NOMENCLATURES = {
    '1': {'id_nomenclature': 1, 'cd_nomenclature': '0', 'label_fr': 'Aucun'},
    '2': {'id_nomenclature': 2, 'cd_nomenclature': 'PATUR', 'label_fr': 'Pâturage'},
    '3': {'id_nomenclature': 3, 'cd_nomenclature': 'Co', 'label_fr': 'Compté'},
}


def load(path):
    try:
        with open(path, encoding='utf-8') as f:
            return json.load(f)
    except (OSError, ValueError):
        return None


def domain(ref, field, expr):
    """Valeurs de test d'un champ, au format du formulaire web."""
    tw = field.get('type_widget')
    if re.search(r'meta\.nomenclatures\[\s*value\.' + ref + r'\s*\]', expr):
        return [None, 1, 2, 3, 99]
    if ref == 'cd_nom' or tw == 'taxonomy':
        nums = sorted({int(n) for n in re.findall(r'\b(\d{3,})\b', expr)})
        # Web : le taxon est un objet {cd_nom, …}
        return [None] + [{'cd_nom': n} for n in nums + [1]]
    if field.get('values'):
        vals = [v.get('value') if isinstance(v, dict) else v for v in field['values']]
        return [None] + vals
    if tw == 'number':
        return [None, 0, 1, 2, 3, 20]
    if tw in ('bool_checkbox', 'checkbox'):
        return [None, True, False]
    if tw in ('text', 'textarea'):
        return [None, '', 'abc']
    return [None, 1, 'abc']


def main(roots):
    cases = []
    for root in roots:
        for module in sorted(os.listdir(root)):
            mdir = os.path.join(root, module)
            if not os.path.isdir(mdir):
                continue
            for obj in OBJECTS:
                cfg = load(os.path.join(mdir, obj + '.json'))
                if not isinstance(cfg, dict):
                    continue
                fields = {}
                for part in ('generic', 'specific'):
                    for k, v in (cfg.get(part) or {}).items():
                        if isinstance(v, dict):
                            fields[k] = v
                for fid, f in fields.items():
                    for prop in ('hidden', 'required'):
                        expr = f.get(prop)
                        if isinstance(expr, list):
                            expr = '\n'.join(map(str, expr))
                        if not isinstance(expr, str) or '=>' not in expr:
                            continue
                        refs = sorted(set(re.findall(r'value\.(\w+)', expr)))
                        domains = [domain(r, fields.get(r, {}), expr) for r in refs]
                        metas = [{}]
                        if 'meta.nomenclatures' in expr:
                            metas = [{'nomenclatures': META_NOMENCLATURES}]
                        elif 'meta.dataset' in expr:
                            metas = [{}, {'dataset': {'1': {'id_dataset': 1}}},
                                     {'dataset': {'1': {}, '2': {}}}]
                        for combo in list(itertools.product(*domains))[:300]:
                            for meta in metas:
                                cases.append({
                                    'source': f'{module}/{obj}.{fid}.{prop}',
                                    'expr': expr,
                                    'context': {
                                        'value': dict(zip(refs, combo)),
                                        'meta': meta,
                                    },
                                })
    json.dump(cases, sys.stdout, ensure_ascii=False, indent=1)


if __name__ == '__main__':
    main(sys.argv[1:])
