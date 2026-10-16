#!/bin/bash
# Données de test des e2e réels, à lancer dans le conteneur geonature une fois
# la base installée : protocoles et permissions (le reste : seed.sql et up.sh).
# Usage : SEED_MODULES="A B" seed.sh [code_module...]
#   SEED_MODULES : protocoles dont la config est (re)copiée dans le media ;
#   arguments : protocoles à installer en base.
set -euo pipefail

MODULES=("$@")
MEDIA=/dist/media/monitorings

# monitoring 1.3.1 refuse `"type_util": "sites_group"`, utilisé par les
# protocoles à groupes de sites (PnX-SI/gn_module_monitoring#639, corrigé
# après 1.3.1).
constant=$(python -c "import gn_module_monitoring.command.imports.constant as c; print(c.__file__)")
if ! python -c "import gn_module_monitoring.command.imports.constant as c, sys; sys.exit('sites_group' not in c.INT_TYPE_UTILS)"; then
  sed -i 's/^INT_TYPE_UTILS = \[/INT_TYPE_UTILS = [\n    "sites_group",/' "$constant"
fi
mkdir -p "$MEDIA"

for code in ${SEED_MODULES:-}; do
  rm -rf "${MEDIA:?}/$code"
  cp -r "/protocoles/$code" "$MEDIA/$code"
done
for code in "${MODULES[@]}"; do
  geonature monitorings install "$code"
done

# Jeux de données exemples (le seul ouvert aux protocoles en vient).
geonature db upgrade occtax-samples@head

# admin (groupe Grp_admin) : tous les droits, y compris sur les protocoles.
geonature permissions supergrant --group --nom "Grp_admin" --yes
