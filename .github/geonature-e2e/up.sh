#!/bin/bash
# Monte le GeoNature des e2e réels et ses données de test.
# Usage : up.sh [code_module...]   (défaut : POPAmphibien POPReptile)
# Variables : GEONATURE_PORT (5000), PROTOCOLES_REF (commit de PnX-SI/protocoles_suivi).
set -euo pipefail
cd "$(dirname "$0")"

MODULES=("$@")
[ $# -eq 0 ] && MODULES=(POPAmphibien POPReptile)
PORT=${GEONATURE_PORT:-5000}
API=http://127.0.0.1:$PORT
PROTOCOLES_REF=${PROTOCOLES_REF:-3ef22ad}
export PROTOCOLES_DIR=${PROTOCOLES_DIR:-$PWD/protocoles}
compose() { docker compose -p "${COMPOSE_PROJECT:-gne2e}" "$@"; }
psql_q() { compose exec -T postgres psql -U geonatadmin -d geonature2db -Atc "$1"; }

if [ ! -d "$PROTOCOLES_DIR/.git" ]; then
  git clone -q https://github.com/PnX-SI/protocoles_suivi.git "$PROTOCOLES_DIR"
fi
git -C "$PROTOCOLES_DIR" checkout -q "$PROTOCOLES_REF"

# Premier démarrage : installation de la base (TAXREF compris), ~10 min.
compose up -d
echo "Attente de l'API GeoNature sur $API…"
for _ in $(seq 1 180); do
  curl -sf -o /dev/null "$API/gn_commons/config" && break
  if [ "$(compose ps -q geonature | xargs docker inspect -f '{{.State.Running}}')" != true ]; then
    compose logs --tail 50 geonature; exit 1
  fi
  sleep 10
done
curl -sf -o /dev/null "$API/gn_commons/config" || { compose logs --tail 50 geonature; exit 1; }

# Protocoles à installer : ceux absents de la base (l'installation ne se
# rejoue pas).
TO_INSTALL=()
for code in "${MODULES[@]}"; do
  [ -z "$(psql_q "SELECT 1 FROM gn_commons.t_modules WHERE module_code = '$code'")" ] \
    && TO_INSTALL+=("$code")
done
compose exec -T -e SEED_MODULES="${MODULES[*]}" geonature /seed/seed.sh "${TO_INSTALL[@]}"
codes=$(printf "'%s'," "${MODULES[@]}")
sed "s/:codes/${codes%,}/g" seed/seed.sql \
  | compose exec -T postgres psql -q -v ON_ERROR_STOP=1 -U geonatadmin -d geonature2db

# Types de site déclarés par chaque protocole (nomenclature.json) : à
# rattacher au module, comme dans l'administration du module web.
for code in "${MODULES[@]}"; do
  for cd in $(jq -r '.nomenclatures[] | select(.type == "TYPE_SITE") | .cd_nomenclature' \
      "$PROTOCOLES_DIR/$code/nomenclature.json"); do
    psql_q "INSERT INTO gn_monitoring.cor_module_type (id_type_site, id_module)
      SELECT n.id_nomenclature, m.id_module
      FROM ref_nomenclatures.t_nomenclatures n
      JOIN ref_nomenclatures.bib_nomenclatures_types t USING (id_type)
      CROSS JOIN gn_commons.t_modules m
      WHERE t.mnemonique = 'TYPE_SITE' AND n.cd_nomenclature = '$cd'
        AND m.module_code = '$code'
      ON CONFLICT DO NOTHING" >/dev/null
  done
done

# Un groupe et un site par protocole, créés par l'API comme le fait l'app.
TOKEN=$(curl -sf -X POST "$API/auth/login" -H 'Content-Type: application/json' \
  -d '{"login":"admin","password":"admin"}' | jq -r .token)
ID_ADMIN=$(psql_q "SELECT id_role FROM utilisateurs.t_roles WHERE identifiant = 'admin'")
for code in "${MODULES[@]}"; do
  id_module=$(psql_q "SELECT id_module FROM gn_commons.t_modules WHERE module_code = '$code'")
  if [ -n "$(psql_q "SELECT 1 FROM gn_monitoring.cor_sites_group_module WHERE id_module = $id_module LIMIT 1")" ]; then
    continue
  fi
  id_type=$(psql_q "SELECT id_type_site FROM gn_monitoring.cor_module_type WHERE id_module = $id_module LIMIT 1")
  id_group=$(curl -sf -X POST "$API/monitorings/object/$code/sites_group" \
    -H "Authorization: Bearer $TOKEN" -H 'Content-Type: application/json' -d @- <<JSON | jq -r .id
{"type": "Feature", "module_code": "$code", "geometry": null,
 "properties": {"sites_group_name": "Groupe test $code", "sites_group_code": "GT",
                "modules": [$id_module]}}
JSON
)
  curl -sf -o /dev/null -X POST "$API/monitorings/object/$code/site" \
    -H "Authorization: Bearer $TOKEN" -H 'Content-Type: application/json' -d @- <<JSON
{"type": "Feature", "module_code": "$code",
 "geometry": {"type": "Point", "coordinates": [5.75, 45.15]},
 "properties": {"base_site_name": "Site test $code", "base_site_code": "ST",
                "id_inventor": $ID_ADMIN, "id_digitiser": $ID_ADMIN,
                "id_sites_group": $id_group, "types_site": [$id_type],
                "modules": [$id_module]}}
JSON
  echo "$code : groupe $id_group et un site créés"
done
echo "GeoNature prêt sur $API (admin/admin)"
