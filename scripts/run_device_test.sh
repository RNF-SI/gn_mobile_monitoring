#!/usr/bin/env bash
# Lance un test d'intégration sur un émulateur/appareil Android en compilant
# l'APK via gradlew + JDK 17 (flutter test/run embarque le JBR d'Android Studio,
# que Gradle 8.7 refuse).
#
# Usage : scripts/run_device_test.sh [fichier_de_test] [device_id]
#   ex.  scripts/run_device_test.sh integration_test/scenarios/audit_bugs_e2e_test.dart emulator-5554
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET="${1:-integration_test/scenarios/audit_bugs_e2e_test.dart}"
DEVICE="${2:-emulator-5554}"
JAVA_HOME="${JAVA_HOME_17:-/usr/lib/jvm/java-17-openjdk-amd64}"

cd "$ROOT"
# Le migrateur Flutter peut modifier gradle.properties : on le restaure après.
cp android/gradle.properties /tmp/gradle.properties.run_device_test
trap 'cp /tmp/gradle.properties.run_device_test "$ROOT/android/gradle.properties"' EXIT

(cd android && JAVA_HOME="$JAVA_HOME" ./gradlew app:assembleDebug -q \
  -Ptarget="$ROOT/$TARGET")

flutter drive \
  --driver=test_driver/integration_test.dart \
  --target="$TARGET" \
  -d "$DEVICE" \
  --use-application-binary=build/app/outputs/flutter-apk/app-debug.apk
