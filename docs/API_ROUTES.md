# Routes serveur utilisées par l'application

Inventaire établi le 2026-10-13 :
- à partir du code (`lib/data/datasource/implementation/api/`) ;
- à partir des logs d'un serveur GeoNature develop (`07306b85b`) avec monitoring develop (`274671fc`), pendant toute la suite e2e ;
- par des appels directs à ce serveur et à un serveur GeoNature 2.17.1 avec monitoring 1.3.0.

Dans monitoring develop, les routes dépréciées sont celles de `routes/legacy.py`. Le serveur les signale par l'en-tête `Deprecation: True` et l'avertissement `Legacy route used` dans ses logs.

## Détection de la version de monitoring

`GET /monitorings/module/<module_code>?field_name=module_code`, dans `monitoring_routes.dart` :
- **200** : refonte (monitoring ≥ develop / GeoNature 2.18) → routes actuelles.
- **404** : monitoring 1.2.x / 1.3.x → routes `/object/...`, qui sont les seules disponibles.

Le résultat est mis en cache pour chaque serveur.

## Monitoring

| Route | Usage | Statut |
|---|---|---|
| `GET /monitorings/modules` | liste des modules | actuelle |
| `GET /monitorings/module/{id}` | module, jeux de données (refonte) | actuelle |
| `GET /monitorings/module/{code}?field_name=module_code` | détection de version | actuelle (404 en 1.3.x) |
| `GET /monitorings/config/{module}` | configuration du module | actuelle (aussi `/refacto/config/{module}`) |
| `GET /monitorings/util/dataset/{id}` | détail d'un jeu de données | actuelle |
| `GET /monitorings/util/taxonomy_list/{id}` | liste taxonomique | actuelle |
| `GET /monitorings/sites/types`, `/sites/types/{id}` | types de site | actuelle |
| `GET /monitorings/refacto/{module}/sites` et `/sites_groups` | téléchargement des sites et groupes | actuelle |
| `POST /monitorings/{module}/sites`, `PATCH .../sites/{id}` | envoi des sites | actuelle (refonte) |
| `POST /monitorings/{module}/sites_groups` | envoi des groupes | actuelle (refonte) |
| `POST /monitorings/{module}/visits`, `PATCH .../visits/{id}` | envoi des visites | actuelle (refonte) |
| `POST /monitorings/{module}/observations`, `PATCH .../observations/{id}` | envoi des observations | actuelle (refonte) |
| `POST /monitorings/{module}/observation_details` | envoi des détails d'observation | actuelle (refonte) |
| `POST/PATCH /monitorings/object/{module}/{type}[/{id}]` | envoi, **monitoring 1.3.x seulement** | dépréciée : repli de compatibilité |
| `GET /monitorings/object/{module}/module` | jeux de données, **monitoring 1.3.x seulement** (la refonte les fournit dans `/module/{id}`) | dépréciée : repli de compatibilité |

Contre un serveur à jour, l'app n'appelle **aucune** route dépréciée : aucun `/object/` n'apparaît dans les logs de la suite e2e. Les replis `/object/...` ne servent qu'aux serveurs en monitoring 1.3.x. On pourra les supprimer quand l'app ne prendra plus en charge GeoNature 2.17.

## GeoNature (cœur) et TaxHub

| Route | Usage | Statut |
|---|---|---|
| `POST /auth/login` | connexion | actuelle |
| `GET /gn_commons/modules` | version de monitoring | actuelle |
| `GET /gn_commons/t_mobile_apps?app_code=MONITORING` | mises à jour de l'app | actuelle |
| `GET /nomenclatures/nomenclature/{code_type}` | nomenclatures | actuelle |
| `GET /taxhub/api/taxref/` | taxons d'une liste (pagination) | actuelle |

## Retiré le 2026-10-13

Ces méthodes appelaient des routes qui n'existent plus (404 sur GeoNature 2.17 comme sur develop). Aucun code ne les utilisait : les recherches de taxons et de nomenclatures passent par la base locale.

- `TaxonApi.getTaxonByCdNom` → `GET /taxonomie/taxref/{cd_nom}` (TaxHub v1)
- `TaxonApi.searchTaxons` → `GET /taxonomie/taxref/search` (TaxHub v1)
- `GlobalApi.getNomenclatureTypes` → `GET /nomenclatures/nomenclature_types`
- `GlobalApi.getNomenclatureTypeByMnemonique` → `GET /nomenclatures/nomenclature_types/{mnemonique}`

`GET /taxhub/api/taxref` est maintenant appelée avec la barre finale. Sans elle, le serveur répondait par une redirection 308, ce qui faisait une requête de plus par page de taxons.
