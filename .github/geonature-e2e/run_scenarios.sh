#!/bin/bash
# Lance tous les scénarios réels (integration_test/scenarios_real/all_scenarios_test.dart)
# sur l'appareil Android connecté, contre le GeoNature monté par up.sh.
# Usage : run_scenarios.sh <codes_modules>...  — un run par argument, ex. :
#   run_scenarios.sh POPAmphibien,POPReptile POPReptile
# Variables : GEONATURE_PORT (5000), DEVICE (premier appareil adb).
set -uo pipefail
cd "$(dirname "$0")/../.."

PORT=${GEONATURE_PORT:-5000}
DEVICE=${DEVICE:-$(adb devices | awk 'NR>1 && $2=="device" {print $1; exit}')}
APP=org.reserves_naturelles.monitoring
adb -s "$DEVICE" reverse tcp:"$PORT" tcp:"$PORT"

# La demande d'autorisation de localisation bloquerait l'écran : on l'accorde
# en continu, l'app étant réinstallée à chaque run.
(
  while true; do
    for perm in ACCESS_FINE_LOCATION ACCESS_COARSE_LOCATION; do
      adb -s "$DEVICE" shell pm grant "$APP" "android.permission.$perm" 2>/dev/null
    done
    sleep 0.5
  done
) &
WATCHER=$!
trap 'kill $WATCHER 2>/dev/null' EXIT

status=0
for codes in "$@"; do
  echo "::group::Scénarios réels — $codes"
  flutter test integration_test/scenarios_real/all_scenarios_test.dart -d "$DEVICE" \
    --dart-define=TEST_SERVER_URL="http://localhost:$PORT" \
    --dart-define=TEST_USERNAME=admin --dart-define=TEST_PASSWORD=admin \
    --dart-define=TEST_MODULE_CODES="$codes" --dart-define=TEST_WITH_UPLOAD=true \
    --timeout 1800s || status=1
  echo "::endgroup::"
done
exit $status
