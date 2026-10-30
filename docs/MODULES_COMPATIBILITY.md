# Compatibilité des modules de suivi

Ce tableau indique, pour chaque protocole GeoNature Monitoring connu, si l'application mobile sait le saisir, ce qui a été testé automatiquement, et les retours du terrain.

> Sources analysées : [PnX-SI/protocoles_suivi](https://github.com/PnX-SI/protocoles_suivi) (`master`, `3ef22ad`) et les branches `dev/cmr_cistude` et `dev/popanomaloglossus` du fork [Geomaticien-shf/protocoles_suivi](https://github.com/Geomaticien-shf/protocoles_suivi). Application : branche `develop` d'octobre 2026 (après la v1.2.0). Analyse : `scripts/protocoles_audit/analyse_configs.py`.

## Légende

| Colonne | Signification |
|---|---|
| **Configuration** | Analyse automatique des fichiers du protocole (`site.json`, `visit.json`…) : types de champs, objets, expressions. ✅ tout est géré, hors [limites communes](#limites-communes) · ⚠️ un ou plusieurs champs mal pris en charge · ❌ saisie impossible |
| **Tests automatisés** | 🧪 scénario sur émulateur rejouant un extrait réel de la configuration (`integration_test/scenarios/audit_bugs_e2e_test.dart`) · 🔬 test unitaire ou de widget avec la configuration réelle · Toutes les expressions `hidden`/`required` des protocoles sont en outre comparées à JavaScript (`test/fixtures/js_expressions_corpus.json`) |
| **Retour terrain** | Essai réel par un utilisateur : ✅ utilisable · ⚠️ utilisable avec réserves · ❌ bloquant · — pas encore de retour. Indiquer la version de l'app et la date |

## Tableau

| Module | Libellé | Configuration | Tests automatisés | Retour terrain | Limites connues |
|---|---|---|---|---|---|
| POPAmphibien | POPAmphibien | ✅ | 🧪 🔬 | ✅ avant 09/2026 (à revalider après les correctifs d'expressions) | — |
| POPReptile | POPReptile | ✅ | 🔬 | ✅ avant 09/2026 (à revalider) | — |
| RHOMEOAmphibien | RHOMEOAmphibien | ✅ | — | — | — |
| RHOMEOFlore | RHOMEOFlore | ✅ | 🧪 🔬 | — | — |
| RHOMEOOdonate | RHOMEOOdonate | ✅ | — | — | — |
| RHOMEOOrthoptere | RHOMEOOrthoptère | ✅ | — | — | — |
| apollons | Apollons | ✅ | — | — | — |
| arbres_interet_ecologique | Arbres d'intérêt écologique | ✅ | — | — | — |
| cheveches | Chevêches | ✅ | — | — | — |
| chiro | Chiroptères | ✅ | — | — | — |
| chronocapture | ChronoCapture | ✅ | — | — | — |
| chronoventaire | ChronoVentaire | ⚠️ | — | — | Codes habitat du site (4 champs) : liste d'habitats vide (champs facultatifs) |
| craves | Craves | ✅ | — | — | — |
| ecrevisses_pattes_blanches | Écrevisses à pattes blanches | ✅ | 🔬 | — | — |
| flore_biotope | Suivis botaniques de site | ✅ | — | — | — |
| lichens_bio_indicateurs | Lichens bio-indicateurs | ⚠️ | — | — | Habitat principal / associé (visite) : liste d'habitats vide (facultatifs) ; Descripteur : l'utilisateur connecté, sans choix possible |
| ligne_lecture | Ligne de lecture | ✅ | — | — | — |
| micromam_analyse_pelotes_rejection_gmb | Pelotes de réjection | ❌ | — | — | Déterminateurs (visite) : liste d'utilisateurs vide alors que le champ est obligatoire, la visite ne peut pas être enregistrée (déduit du code, à confirmer sur téléphone) |
| nidif_gypa | Nidification du Gypaète barbu | ✅ | 🔬 | — | — |
| oedic | Œdicnèmes | ✅ | — | — | — |
| osmodermes | Osmodermes | ✅ | — | — | — |
| petite_chouette_montagne | Petite chouette de montagne | ✅ | 🧪 🔬 | — | Expressions qui comparent le taxon à un entier : même comportement que sur le web, à corriger dans la configuration |
| piegeages_passifs | Pièges à interception passifs | ⚠️ | — | — | Déterminateur (observation) : l'utilisateur connecté, sans choix possible |
| prairies_fleuries | Prairies fleuries | ✅ | — | — | — |
| pt_ecoute_avifaune | Point d'écoute avifaune | ✅ | 🧪 | — | — |
| pyrales | Pyrales du buis | ⚠️ | — | — | Habitat du groupe de sites : liste d'habitats vide (facultatif) |
| sterf | STERF | ⚠️ | — | — | Déterminateur (observation) : l'utilisateur connecté, sans choix possible |
| stom | STOM | ✅ | 🧪 🔬 | — | — |
| suivi_Camphi_gmb | Campagnol amphibie régional | ✅ | — | — | — |
| suivi_colo_chiro_gmb | Chiroptères au gîte | ✅ | — | — | — |
| suivi_loutre_SACs_gmb | Loutre local | ✅ | 🧪 🔬 | — | — |
| suivi_loutre_UICN_gmb | Loutre régional | ✅ | — | — | — |
| suivi_nardaie | Suivi nardaie | ✅ | 🔬 | — | — |
| suivi_phytosocio | Suivi phytosociologique | ✅ | — | — | — |
| suivi_terriers_blaireau_gmb | Blaireautières | ✅ | 🧪 🔬 | ❌ en v1.1.1 : erreur à l'enregistrement d'une visite (corrigée en 09/2026, à retester) | — |
| cmr_cistude *(fork)* | CMR Cistude | ❌ | — | — | Formulaires « Individus » et « Marquage », widget `individuals` ; habitat du site ; opérateur du marquage |
| popanomaloglossus *(fork)* | POPAnomaloglossus | ✅ | 🧪 🔬 | — | — |

**Bilan** : hors limites communes (photos, observateurs multiples), 30 protocoles se saisissent entièrement, 5 avec réserves (habitats, déterminateur imposé), 2 ne peuvent pas être saisis (CMR Cistude, Pelotes de réjection). Seuls POPAmphibien et POPReptile ont un retour terrain positif.

## Limites communes

Elles touchent tous les protocoles, ou presque, et ne sont pas reprises dans le tableau :

- **Photos** (`medias`) : le formulaire web propose un champ Médias sur chaque objet ; 35 protocoles sur 37 l'affichent (pas Pyrales du buis ni Suivi nardaie). L'app ne permet pas d'ajouter de photo ou de document (#232).
- **Observateurs** : sur le web, la visite accepte plusieurs observateurs (37 protocoles). L'app enregistre l'utilisateur connecté, sans en ajouter d'autres (#230).
- **Fond de carte** : la saisie fonctionne hors ligne, mais le fond de carte OpenStreetMap nécessite une connexion.
- **Listes chargées depuis une API** autres que nomenclatures, taxons, jeux de données et groupes de sites (habitats `habref`, listes d'utilisateurs `users/menu`) : liste vide (#202).

Le détail des limites et le fonctionnement des champs sont décrits dans [FEATURES_OVERVIEW.md](FEATURES_OVERVIEW.md).

## Mettre à jour ce tableau

- **Retour terrain** : remplir la colonne avec le verdict, la version de l'app (écran d'accueil) et la date, et décrire le problème éventuel dans une issue GitHub.
- **Nouveau protocole ou nouvelle version** :
  1. relancer la comparaison des expressions : `scripts/protocoles_audit/generate_corpus.sh <dossier_protocoles>` puis `flutter test test/core/helpers/js_expression_interpreter_test.dart` ;
  2. relancer l'analyse des champs : `python3 scripts/protocoles_audit/analyse_configs.py <dossier_generic_monitoring> <dossier_protocoles>…` ;
  3. ajouter une ligne au tableau.

---

Dernière mise à jour : octobre 2026
