# GeoNature des e2e réels

Serveur GeoNature + module monitoring en Docker pour les scénarios réels
(`integration_test/scenarios_real/`). Utilisé par le workflow
`.github/workflows/e2e_real_tests.yml`, et utilisable en local.

```bash
.github/geonature-e2e/up.sh                  # GeoNature sur http://127.0.0.1:5000, admin/admin
.github/geonature-e2e/run_scenarios.sh POPAmphibien,POPReptile POPReptile
docker compose -p gne2e -f .github/geonature-e2e/docker-compose.yml down -v   # tout effacer
```

`up.sh` :
- démarre PostGIS et le backend (`ghcr.io/pnx-si/geonature-backend-extra`, à
  changer avec `GEONATURE_IMAGE`). Au premier lancement, la base s'installe
  avec TAXREF, les utilisateurs et les données exemples, sans couches SIG ni
  mailles (environ 5 min) ;
- clone PnX-SI/protocoles_suivi au commit `PROTOCOLES_REF` et installe les
  protocoles demandés (défaut : POPAmphibien et POPReptile) ;
- donne tous les droits au groupe `Grp_admin`, ouvre le jeu de données
  exemple aux protocoles, leur associe une liste « Herpéto test » (amphibiens
  et reptiles de TAXREF) et leurs types de site, et crée un groupe et un site
  par protocole.

Il se relance sans risque : les protocoles déjà installés sont gardés.

Le port doit être l'un de ceux pour lesquels l'app n'ajoute pas `/api`
(`lib/config/config.dart`) : 5000 par défaut, ou 4000 (`GEONATURE_PORT`).

`run_scenarios.sh` lance `all_scenarios_test.dart` (tous les scénarios réels)
une fois par liste de modules : le premier module de la liste est celui testé,
et le scénario multi-modules ne tourne que si la liste en contient plusieurs.
