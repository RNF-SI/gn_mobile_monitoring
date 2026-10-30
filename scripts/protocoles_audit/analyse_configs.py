#!/usr/bin/env python3
"""Classe les protocoles Monitoring selon ce que l'app sait saisir.

Fusionne les champs génériques et spécifiques comme le backend web
(gn_module_monitoring/config/utils.py), garde les champs que le formulaire
dynamique web affiche (widget connu, hidden différent de true) et relève ceux
que l'app ne gère pas encore.

usage : analyse_configs.py <dossier config/generic du module monitoring> <dossier protocoles>…
        (ex. ~/GeoNature/contrib/gn_module_monitoring/backend/gn_module_monitoring/config/generic ~/protocoles_suivi)
"""
import collections
import copy
import glob
import json
import os
import sys

OBJS = ['module', 'sites_group', 'site', 'visit', 'observation', 'observation_detail', 'individual', 'marking']
# Widgets rendus par le formulaire dynamique web (dynamic-form.component.html)
WEB = {'text', 'time', 'number', 'textarea', 'select', 'file', 'checkbox', 'bool_checkbox', 'radio', 'bool_radio', 'medias',
       'nomenclature', 'taxonomy', 'dataset', 'observers', 'observers-text', 'date', 'areas', 'municipalities', 'multiselect',
       'datalist', 'individuals'}
# Limites communes à presque tous les protocoles, signalées à part (#232, #230)
COMMUNES = {'photos', 'observateurs'}


def jl(p):
    try:
        return json.load(open(p))
    except FileNotFoundError:
        return {}


def tree_keys(tree):
    out = set()
    for k, v in (tree or {}).items():
        out.add(k)
        if isinstance(v, dict):
            out |= tree_keys(v)
    return out


def module(gen, d):
    cfg = jl(f'{gen}/config.json')
    cfg.update(jl(f'{d}/config.json'))
    tree = tree_keys(cfg['tree'])
    objects = {}
    for o in OBJS:
        if o not in tree:
            continue
        c = jl(f'{gen}/{o}.json')
        c.update(jl(f'{d}/{o}.json'))
        g = copy.deepcopy(c.get('generic', {}))
        for k, v in (c.get('specific') or {}).items():
            if k in g and not (v.get('type_widget') and v.get('type_widget') == g[k].get('type_widget')):
                g[k].update(v)
            else:
                g[k] = copy.deepcopy(v)
        objects[o] = g
    return tree, objects


def limits(tree, objects):
    lim = collections.defaultdict(list)
    if {'individual', 'marking'} & tree:
        lim['individus'].append('objets ' + ', '.join(sorted({'individual', 'marking'} & tree)))
    for o, fields in objects.items():
        if o == 'module':
            continue
        for k, f in fields.items():
            w = f.get('type_widget')
            if f.get('hidden') is True or w not in WEB:
                continue
            multi = bool(f.get('multiple') or f.get('multi_select'))
            lab = f'{o}.{k}' + (' (requis)' if f.get('required') is True else '')
            if w == 'medias':
                lim['photos'].append(o)
            elif w == 'individuals':
                lim['individus'].append(lab)
            elif f.get('type_util') == 'habitat':
                lim['habitats'].append(lab)
            elif k == 'observers':
                # L'app affiche toujours le champ `observers` comme ObserverField
                if multi:
                    lim['observateurs'].append(lab)
            elif k == 'id_inventor':
                # Inventeur du site (champ générique) : l'utilisateur connecté,
                # comme les observateurs ; masqué pour les groupes de sites
                continue
            elif f.get('type_util') == 'user' or w == 'observers':
                if w == 'datalist' and multi:
                    lim['utilisateurs (liste vide)'].append(lab)
                elif multi:
                    lim['observateurs'].append(lab)
                elif w == 'datalist':
                    lim['utilisateur connecté imposé'].append(lab)
            elif w in ('areas', 'municipalities', 'file', 'bool_radio', 'observers-text'):
                lim[f'widget {w}'].append(lab)
    return lim


def main():
    gen, roots = sys.argv[1], sys.argv[2:]
    bilan = collections.Counter()
    for r in roots:
        for d in sorted(glob.glob(f'{r}/*/')):
            d = d.rstrip('/')
            if not os.path.exists(f'{d}/config.json'):
                continue
            lim = limits(*module(gen, d))
            spec = {k: v for k, v in lim.items() if k not in COMMUNES}
            requis = any('(requis)' in x for k, v in spec.items() if k == 'utilisateurs (liste vide)' for x in v)
            cat = '❌' if 'individus' in spec or requis else ('⚠️' if spec else '✅')
            bilan[cat] += 1
            print(f'{cat} {os.path.basename(d)}')
            for k, v in sorted(lim.items()):
                print(f'     {k} : {", ".join(v)}')
    print('\nBilan (hors photos et observateurs multiples) :', dict(bilan))


if __name__ == '__main__':
    main()
