#!/usr/bin/env python3
"""Convertit les dépendances Dart/Flutter (pub) en SBOM CycloneDX 1.6 JSON.

Appelé par scripts/generate-sbom.sh, dans le venv .sbom-tools/ (PyYAML et
cyclonedx-python-lib pour la validation du schéma).

Sources :
- la sortie de `flutter pub deps --json` : graphe complet des dépendances
  (qui dépend de qui), indispensable pour que Dependency-Track affiche un
  arbre correct et pour isoler les dépendances de production ;
- pubspec.lock : empreintes SHA-256 des archives et dépôt d'origine.

Par défaut seules les dépendances atteignables depuis les `dependencies` du
pubspec.yaml sont retenues ; `--avec-dev` ajoute les `dev_dependencies`
(build_runner, drift_dev, mockito…) et leurs dépendances, marquées avec le
scope `excluded` puisqu'elles ne sont pas embarquées dans l'application.
"""

import argparse
import json
import sys
import uuid
from datetime import datetime, timezone
from urllib.parse import quote

import yaml
from cyclonedx.schema import SchemaVersion
from cyclonedx.validation.json import JsonStrictValidator

PUB_DEV = "https://pub.dev"


def purl_pub(nom, version, url_depot):
    """PURL d'un paquet pub ; qualificatif repository_url hors pub.dev."""
    purl = f"pkg:pub/{nom}@{quote(version, safe='')}"
    if url_depot and url_depot.rstrip("/") != PUB_DEV:
        purl += f"?repository_url={quote(url_depot, safe='')}"
    return purl


def atteignables(paquets, depart):
    """Ensemble des paquets atteignables depuis la liste `depart`."""
    vus = set()
    pile = list(depart)
    while pile:
        nom = pile.pop()
        if nom in vus or nom not in paquets:
            continue
        vus.add(nom)
        pile.extend(paquets[nom].get("dependencies", []))
    return vus


def main():
    p = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    p.add_argument("--deps", required=True, help="sortie de `flutter pub deps --json`")
    p.add_argument("--lock", required=True, help="chemin du pubspec.lock")
    p.add_argument("--sortie", required=True, help="fichier SBOM à écrire")
    p.add_argument("--app-version", required=True, help="version applicative du composant racine")
    p.add_argument("--flutter-version", default="", help="version du SDK Flutter (paquets `sdk`)")
    p.add_argument("--dart-version", default="", help="version du SDK Dart")
    p.add_argument("--avec-dev", action="store_true", help="inclure les dev_dependencies")
    args = p.parse_args()

    with open(args.deps, encoding="utf-8") as f:
        deps = json.load(f)
    with open(args.lock, encoding="utf-8") as f:
        verrou = (yaml.safe_load(f) or {}).get("packages", {}) or {}

    paquets = {pq["name"]: pq for pq in deps["packages"]}
    racine = paquets[deps["root"]]

    directes_prod = racine.get("directDependencies", [])
    directes_dev = racine.get("devDependencies", [])
    prod = atteignables(paquets, directes_prod)
    retenus = set(prod)
    directes = list(directes_prod)
    if args.avec_dev:
        retenus |= atteignables(paquets, directes_dev)
        directes += [d for d in directes_dev if d not in directes]
    retenus.discard(racine["name"])

    ref_racine = f"{racine['name']}@{args.app_version}"
    refs = {}
    composants = []
    for nom in sorted(retenus):
        pq = paquets[nom]
        entree = verrou.get(nom, {})
        desc = entree.get("description") if isinstance(entree.get("description"), dict) else {}
        source = pq.get("source") or entree.get("source", "")
        version = pq.get("version", "")

        comp = {"type": "library", "name": nom}
        if source == "sdk":
            # Paquets fournis par le SDK Flutter (flutter, sky_engine…) : pas
            # publiés sur pub.dev, leur vraie version est celle du SDK.
            version = args.flutter_version or version
            comp["version"] = version
            comp["description"] = "Paquet fourni par le SDK Flutter"
            comp["properties"] = [{"name": "pub:source", "value": "sdk"}]
        else:
            comp["version"] = version
            url_depot = desc.get("url", PUB_DEV) if source == "hosted" else ""
            if source == "hosted":
                comp["purl"] = purl_pub(nom, version, url_depot)
                comp["externalReferences"] = [{
                    "type": "distribution",
                    "url": f"{url_depot.rstrip('/')}/packages/{nom}/versions/{version}",
                }]
            if desc.get("sha256"):
                comp["hashes"] = [{"alg": "SHA-256", "content": desc["sha256"]}]
            comp["properties"] = [{"name": "pub:source", "value": source}]
        comp["scope"] = "required" if nom in prod else "excluded"
        comp["bom-ref"] = comp.get("purl") or f"{nom}@{version}"
        refs[nom] = comp["bom-ref"]
        composants.append(comp)

    dependances = [{
        "ref": ref_racine,
        "dependsOn": sorted(refs[d] for d in directes if d in refs),
    }]
    for nom in sorted(retenus):
        enfants = [refs[d] for d in paquets[nom].get("dependencies", []) if d in refs]
        dependances.append({"ref": refs[nom], "dependsOn": sorted(set(enfants))})

    proprietes = [{"name": "sbom:perimetre", "value": "prod+dev" if args.avec_dev else "prod"}]
    if args.flutter_version:
        proprietes.append({"name": "flutter:version", "value": args.flutter_version})
    if args.dart_version:
        proprietes.append({"name": "dart:version", "value": args.dart_version})

    bom = {
        "$schema": "http://cyclonedx.org/schema/bom-1.6.schema.json",
        "bomFormat": "CycloneDX",
        "specVersion": "1.6",
        "serialNumber": f"urn:uuid:{uuid.uuid4()}",
        "version": 1,
        "metadata": {
            "timestamp": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
            "tools": {"components": [{
                "type": "application",
                "name": "generate-sbom.sh",
                "description": "Conversion pubspec.lock / pub deps vers CycloneDX",
            }]},
            "component": {
                "type": "application",
                "bom-ref": ref_racine,
                "name": racine["name"],
                "version": args.app_version,
            },
            "properties": proprietes,
        },
        "components": composants,
        "dependencies": dependances,
    }

    texte = json.dumps(bom, indent=2, ensure_ascii=False)
    erreur = JsonStrictValidator(SchemaVersion.V1_6).validate_str(texte)
    if erreur is not None:
        print(f"SBOM invalide au regard du schéma CycloneDX 1.6 : {erreur}", file=sys.stderr)
        return 1
    with open(args.sortie, "w", encoding="utf-8") as f:
        f.write(texte + "\n")
    print(f"{len(composants)} composants ({len(prod - {racine['name']})} de production)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
