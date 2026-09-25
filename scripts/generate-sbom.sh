#!/usr/bin/env bash
# Génère les SBOM CycloneDX 1.6 (JSON) du dépôt dans sbom/ et, avec --envoi,
# les dépose dans Dependency-Track.
#
# Chaîne couverte : dépendances Dart/Flutter (pubspec.yaml + pubspec.lock),
# projet Dependency-Track "$DT_PROJET-dart".
# Les dépendances natives Android (Gradle) ne sont pas couvertes.
#
# Usage : scripts/generate-sbom.sh [--avec-dev] [--envoi] [--aide]
#
# Variables :
#   DT_URL       URL de Dependency-Track (API), requise avec --envoi
#   DT_API_KEY   clé d'API (permission BOM_UPLOAD), requise avec --envoi
#   DT_PROJET    préfixe des projets (défaut : nom du dépôt)
#   DT_VERSION   version du projet Dependency-Track = environnement (défaut : prod)
#   APP_VERSION  version applicative inscrite dans les SBOM
#                (défaut : champ version du pubspec.yaml)

set -euo pipefail

# Versions épinglées de l'outillage Python installé dans .sbom-tools/
PYYAML_VERSION="6.0.3"
CYCLONEDX_LIB_VERSION="11.12.0"

RACINE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUTILS="$RACINE/.sbom-tools"
SORTIE="$RACINE/sbom"

AVEC_DEV=0
ENVOI=0

aide() {
  sed -n '2,19p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'
}

erreur() {
  echo "ERREUR : $*" >&2
  exit 1
}

for arg in "$@"; do
  case "$arg" in
    --avec-dev) AVEC_DEV=1 ;;
    --envoi) ENVOI=1 ;;
    -h|--aide|--help) aide; exit 0 ;;
    *) erreur "option inconnue : $arg (voir --aide)" ;;
  esac
done

nom_depot() {
  local url
  url="$(git -C "$RACINE" remote get-url origin 2>/dev/null || true)"
  if [ -n "$url" ]; then
    basename "$url" .git
  else
    basename "$RACINE"
  fi
}

DT_PROJET="${DT_PROJET:-$(nom_depot)}"
DT_VERSION="${DT_VERSION:-prod}"
DT_URL="${DT_URL:-}"
DT_URL="${DT_URL%/}"

# --- Outillage isolé -------------------------------------------------------

preparer_outils() {
  local marqueur="$OUTILS/.versions"
  local attendu="pyyaml=$PYYAML_VERSION cyclonedx-python-lib=$CYCLONEDX_LIB_VERSION"
  if [ -f "$marqueur" ] && [ "$(cat "$marqueur")" = "$attendu" ]; then
    return
  fi
  echo "Installation de l'outillage dans .sbom-tools/…"
  python3 -m venv "$OUTILS"
  "$OUTILS/bin/pip" install --quiet --disable-pip-version-check \
    "pyyaml==$PYYAML_VERSION" \
    "cyclonedx-python-lib[json-validation]==$CYCLONEDX_LIB_VERSION"
  echo "$attendu" > "$marqueur"
}

# --- Chaîne Dart / Flutter -------------------------------------------------

generer_dart() {
  local fichier="$SORTIE/$DT_PROJET-dart.cdx.json"
  local deps version_machine flutter_version dart_version app_version
  local options=()

  if ! command -v flutter >/dev/null 2>&1; then
    erreur "flutter introuvable dans le PATH (nécessaire pour le graphe de dépendances)"
  fi

  app_version="${APP_VERSION:-$(sed -n 's/^version:[[:space:]]*//p' "$RACINE/pubspec.yaml" | tr -d '"'"'"' ')}"
  if [ -z "$app_version" ]; then
    erreur "APP_VERSION non définie et aucune version dans pubspec.yaml"
  fi

  # Graphe complet : pubspec.lock indique direct/transitif mais pas qui
  # dépend de qui, ni quelles transitives ne servent qu'aux dev_dependencies.
  deps="$(mktemp)"
  version_machine="$(mktemp)"
  (cd "$RACINE" && flutter pub deps --json) > "$deps"
  flutter --version --machine 2>/dev/null > "$version_machine" || true
  flutter_version="$("$OUTILS/bin/python" -c 'import json,sys; print(json.load(open(sys.argv[1])).get("frameworkVersion",""))' "$version_machine" 2>/dev/null || true)"
  dart_version="$("$OUTILS/bin/python" -c 'import json,sys; print(json.load(open(sys.argv[1])).get("dartSdkVersion",""))' "$version_machine" 2>/dev/null || true)"

  if [ "$AVEC_DEV" -eq 1 ]; then
    options+=(--avec-dev)
  fi

  echo "Dart/Flutter → $(basename "$fichier") (version applicative $app_version)"
  "$OUTILS/bin/python" "$RACINE/scripts/sbom_pub_cyclonedx.py" \
    --deps "$deps" \
    --lock "$RACINE/pubspec.lock" \
    --sortie "$fichier" \
    --app-version "$app_version" \
    --flutter-version "$flutter_version" \
    --dart-version "$dart_version" \
    "${options[@]}"
  rm -f "$deps" "$version_machine"
  GENERES+=("dart:$fichier")
}

# --- Envoi vers Dependency-Track -------------------------------------------

verifier_dependency_track() {
  local reponse
  if [ -z "$DT_URL" ] || [ -z "${DT_API_KEY:-}" ]; then
    erreur "DT_URL et DT_API_KEY sont requises avec --envoi"
  fi
  # Le frontend renvoie index.html en repli sur les routes inconnues, et ce
  # HTML contient le nom du produit : on teste donc le champ JSON exact.
  reponse="$(curl -sS --fail "$DT_URL/api/version" || true)"
  if ! printf '%s' "$reponse" | "$OUTILS/bin/python" -c \
      'import json,sys; sys.exit(0 if json.load(sys.stdin).get("application") == "Dependency-Track" else 1)' \
      2>/dev/null; then
    erreur "$DT_URL/api/version ne répond pas comme l'API Dependency-Track ; vérifier DT_URL (URL de l'API, pas du frontend)"
  fi
  echo "Dependency-Track joignable : $DT_URL"
}

envoyer() {
  local composant="$1" fichier="$2" projet code corps
  projet="$DT_PROJET-$composant"
  corps="$(mktemp)"
  code="$(curl -sS -o "$corps" -w '%{http_code}' -X POST "$DT_URL/api/v1/bom" \
    -H "X-Api-Key: $DT_API_KEY" \
    -F "projectName=$projet" \
    -F "projectVersion=$DT_VERSION" \
    -F "autoCreate=true" \
    -F "bom=@$fichier")" || true
  if [ "$code" != "200" ]; then
    echo "ERREUR : envoi de $projet@$DT_VERSION refusé (HTTP $code)" >&2
    cat "$corps" >&2
    echo >&2
    rm -f "$corps"
    exit 1
  fi
  echo "Envoyé : $projet@$DT_VERSION ($(cat "$corps"))"
  rm -f "$corps"
}

# --- Programme principal ---------------------------------------------------

GENERES=()
mkdir -p "$SORTIE"
preparer_outils

if [ -f "$RACINE/pubspec.yaml" ] && [ -f "$RACINE/pubspec.lock" ]; then
  generer_dart
fi

if [ "${#GENERES[@]}" -eq 0 ]; then
  erreur "aucune chaîne de dépendances reconnue dans le dépôt"
fi

if [ "$ENVOI" -eq 1 ]; then
  verifier_dependency_track
  for entree in "${GENERES[@]}"; do
    envoyer "${entree%%:*}" "${entree#*:}"
  done
fi
