#!/bin/bash
# =============================================================================
# Script de lancement des tests E2E reels contre un serveur GeoNature local
#
# Pre-requis :
#   - Serveur GeoNature accessible (par defaut http://10.0.2.2:8000)
#   - Emulateur Android lance OU appareil branche en USB
#   - Fichier .env.test configure (copie depuis .env.test.example)
#
# Usage :
#   ./run_real_e2e_tests.sh                    # Tous les tests, emulateur
#   ./run_real_e2e_tests.sh auth               # Seulement les tests d'auth
#   ./run_real_e2e_tests.sh module             # Seulement les tests de module
#   ./run_real_e2e_tests.sh --device=<id>      # Appareil specifique
#   ./run_real_e2e_tests.sh --url=http://192.168.1.10:8000  # URL custom
# =============================================================================

set -e

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Valeurs par defaut
DEVICE=""
SCENARIO="all"
CUSTOM_URL=""
TIMEOUT="600s"

# Parser les arguments
for arg in "$@"; do
  case $arg in
    --device=*)
      DEVICE="${arg#*=}"
      ;;
    --url=*)
      CUSTOM_URL="${arg#*=}"
      ;;
    --timeout=*)
      TIMEOUT="${arg#*=}"
      ;;
    auth)
      SCENARIO="auth"
      ;;
    module)
      SCENARIO="module"
      ;;
    site|sites)
      SCENARIO="sites"
      ;;
    group|groups|sitegroup|sitegroups)
      SCENARIO="groups"
      ;;
    visit|visits)
      SCENARIO="visits"
      ;;
    obs|observation|observations)
      SCENARIO="observations"
      ;;
    sync-download|download)
      SCENARIO="sync-download"
      ;;
    sync-upload|upload)
      SCENARIO="sync-upload"
      ;;
    all)
      SCENARIO="all"
      ;;
    *)
      echo -e "${RED}Argument inconnu: $arg${NC}"
      echo "Usage: $0 [auth|module|sites|groups|visits|observations|sync-download|sync-upload|all] [--device=<id>] [--url=<url>] [--timeout=<duration>]"
      exit 1
      ;;
  esac
done

# --- Verification des pre-requis ---

echo -e "${BLUE}=== Tests E2E reels - GeoNature Mobile Monitoring ===${NC}"
echo ""

# Verifier .env.test
if [ ! -f ".env.test" ]; then
  echo -e "${RED}Erreur: .env.test non trouve${NC}"
  echo "Copiez .env.test.example vers .env.test et configurez les valeurs"
  exit 1
fi

# Charger .env.test
source <(grep -v '^#' .env.test | grep -v '^\s*$' | sed 's/^/export /')

# Override URL si passee en argument
if [ -n "$CUSTOM_URL" ]; then
  TEST_SERVER_URL="$CUSTOM_URL"
fi

echo -e "Serveur:  ${GREEN}${TEST_SERVER_URL}${NC}"
echo -e "User:     ${GREEN}${TEST_USERNAME}${NC}"
echo -e "Module:   ${GREEN}${TEST_MODULE_CODE}${NC}"
echo -e "Scenario: ${GREEN}${SCENARIO}${NC}"
echo -e "Timeout:  ${GREEN}${TIMEOUT}${NC}"
echo ""

# Verifier Flutter
FLUTTER_BIN="${HOME}/flutter/bin/flutter"
if [ ! -f "$FLUTTER_BIN" ]; then
  FLUTTER_BIN="flutter"
fi

if ! command -v "$FLUTTER_BIN" &> /dev/null; then
  echo -e "${RED}Erreur: Flutter non trouve${NC}"
  echo "Ajoutez Flutter au PATH ou verifiez l'installation"
  exit 1
fi

echo -e "${BLUE}Flutter: $($FLUTTER_BIN --version | head -1)${NC}"

# Verifier les appareils connectes
echo ""
echo -e "${BLUE}Appareils disponibles :${NC}"
$FLUTTER_BIN devices

DEVICE_ARG=""
if [ -n "$DEVICE" ]; then
  DEVICE_ARG="-d $DEVICE"
  echo -e "${YELLOW}Appareil selectionne: $DEVICE${NC}"
fi

# Extraire le port depuis l'URL (ex: http://127.0.0.1:8001 → 8001)
PORT=$(echo "$TEST_SERVER_URL" | sed -E 's|.*:([0-9]+).*|\1|')

# Verifier la connectivite au serveur (depuis le host)
# Note: sur l'emulateur, 10.0.2.2 n'est pas accessible depuis le host
HOST_URL="${TEST_SERVER_URL}"
HOST_URL="${HOST_URL//10.0.2.2/localhost}"

echo ""
echo -e "${BLUE}Test de connectivite vers $HOST_URL ...${NC}"
if curl -s --connect-timeout 5 "$HOST_URL" > /dev/null 2>&1; then
  echo -e "${GREEN}Serveur accessible depuis le host${NC}"
else
  echo -e "${YELLOW}Attention: serveur potentiellement inaccessible depuis le host${NC}"
  echo -e "${YELLOW}(normal si vous utilisez 10.0.2.2 qui est l'adresse emulateur)${NC}"
  echo ""
  read -p "Continuer quand meme ? (o/N) " -n 1 -r
  echo ""
  if [[ ! $REPLY =~ ^[Oo]$ ]]; then
    exit 1
  fi
fi

# --- Configuration adb reverse pour appareil physique ---
# Si on cible un appareil physique avec une URL en 127.0.0.1, il faut
# que adb reverse soit actif pour que le telephone puisse atteindre le PC.
if [[ "$TEST_SERVER_URL" == *"127.0.0.1"* ]] || [[ "$TEST_SERVER_URL" == *"localhost"* ]]; then
  echo ""
  echo -e "${BLUE}Configuration adb reverse pour le port $PORT ...${NC}"

  # Selectionner l'appareil pour adb si specifie
  ADB_DEVICE_ARG=""
  if [ -n "$DEVICE" ]; then
    ADB_DEVICE_ARG="-s $DEVICE"
  fi

  # Verifier l'etat actuel
  CURRENT_REVERSES=$(adb $ADB_DEVICE_ARG reverse --list 2>/dev/null)
  if echo "$CURRENT_REVERSES" | grep -q "tcp:$PORT"; then
    echo -e "${GREEN}adb reverse tcp:$PORT deja actif${NC}"
  else
    if adb $ADB_DEVICE_ARG reverse tcp:$PORT tcp:$PORT 2>&1; then
      echo -e "${GREEN}adb reverse tcp:$PORT tcp:$PORT configure${NC}"
    else
      echo -e "${RED}Erreur: impossible de configurer adb reverse${NC}"
      echo "Verifiez que le telephone est branche et debogage USB active"
      exit 1
    fi
  fi
fi

# --- Pre-grant des permissions Android (en arriere-plan) ---
# Eviter les popups de demande de permission qui bloquent les tests E2E.
# Probleme : flutter test reinstalle l'APK a chaque run, ce qui revoque les
# permissions. On lance un processus en arriere-plan qui :
#   1. Tente un grant immediat (au cas ou l'APK est deja installee d'un run precedent)
#   2. Detecte le lancement du process (pidof - tres rapide ~50ms)
#   3. Grant en boucle pendant 30s pour couvrir la fenetre demande permission
APP_PACKAGE="com.example.gn_mobile_monitoring"
PERMISSIONS=(
  "android.permission.ACCESS_FINE_LOCATION"
  "android.permission.ACCESS_COARSE_LOCATION"
)
echo ""
echo -e "${BLUE}Demarrage du watcher de permissions en arriere-plan ...${NC}"

# Tentative de grant immediat (l'APK est peut-etre deja installee)
for perm in "${PERMISSIONS[@]}"; do
  adb $ADB_DEVICE_ARG shell pm grant "$APP_PACKAGE" "$perm" 2>/dev/null && \
    echo -e "  ${GREEN}✓${NC} pre-grant $perm" || true
done

(
  # Boucle infinie : tente le grant en continu tant que le test tourne.
  # Le watcher est tue par le trap EXIT a la fin du test.
  # On grant les permissions tant que l'app est installee. Si elle n'existe
  # pas (entre uninstall et reinstall), on attend.
  #
  # NOTE : pas de watcher uiautomator/input-tap qui etait une source de
  # flakiness (le dump prend ~1-2s, l'UI peut changer entre-temps, le tap
  # tombe sur le mauvais bouton). Le `pm grant` polling rapide est
  # deterministe et safe.
  echo "[grant-watcher] Demarrage en boucle infinie (poll 200ms)" >&2
  while true; do
    if adb $ADB_DEVICE_ARG shell pm list packages 2>/dev/null | grep -q "$APP_PACKAGE"; then
      for perm in "${PERMISSIONS[@]}"; do
        adb $ADB_DEVICE_ARG shell pm grant "$APP_PACKAGE" "$perm" 2>/dev/null
      done
    fi
    sleep 0.2
  done
) &
GRANT_WATCHER_PID=$!

# Cleanup du watcher en cas d'arret du script
trap 'kill $GRANT_WATCHER_PID 2>/dev/null || true' EXIT

# --- Construire les arguments dart-define ---

DART_DEFINES=""
DART_DEFINES="$DART_DEFINES --dart-define=TEST_SERVER_URL=$TEST_SERVER_URL"
DART_DEFINES="$DART_DEFINES --dart-define=TEST_USERNAME=$TEST_USERNAME"
DART_DEFINES="$DART_DEFINES --dart-define=TEST_PASSWORD=$TEST_PASSWORD"
DART_DEFINES="$DART_DEFINES --dart-define=TEST_MODULE_CODE=$TEST_MODULE_CODE"

# --- Selectionner les fichiers de test ---

TEST_FILES=""
case $SCENARIO in
  auth)
    TEST_FILES="integration_test/scenarios_real/real_auth_e2e_test.dart"
    ;;
  module)
    TEST_FILES="integration_test/scenarios_real/real_module_browsing_e2e_test.dart"
    ;;
  site|sites)
    TEST_FILES="integration_test/scenarios_real/real_site_management_e2e_test.dart"
    ;;
  group|groups|sitegroup|sitegroups)
    TEST_FILES="integration_test/scenarios_real/real_site_group_e2e_test.dart"
    ;;
  visit|visits)
    TEST_FILES="integration_test/scenarios_real/real_visit_workflow_e2e_test.dart"
    ;;
  obs|observation|observations)
    TEST_FILES="integration_test/scenarios_real/real_observation_workflow_e2e_test.dart"
    ;;
  sync-download)
    TEST_FILES="integration_test/scenarios_real/real_sync_download_e2e_test.dart"
    ;;
  sync-upload)
    TEST_FILES="integration_test/scenarios_real/real_sync_upload_e2e_test.dart"
    ;;
  all)
    TEST_FILES="integration_test/scenarios_real/"
    ;;
esac

# --- Lancement des tests ---

echo ""
echo -e "${BLUE}=== Lancement des tests ===${NC}"
echo -e "Commande: $FLUTTER_BIN test $TEST_FILES $DEVICE_ARG --timeout $TIMEOUT $DART_DEFINES"
echo ""

$FLUTTER_BIN test $TEST_FILES \
  $DEVICE_ARG \
  --timeout "$TIMEOUT" \
  $DART_DEFINES

EXIT_CODE=$?

echo ""
if [ $EXIT_CODE -eq 0 ]; then
  echo -e "${GREEN}=== Tous les tests sont passes ===${NC}"
else
  echo -e "${RED}=== Des tests ont echoue (code: $EXIT_CODE) ===${NC}"
fi

exit $EXIT_CODE
