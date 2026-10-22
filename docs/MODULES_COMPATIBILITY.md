# Compatibilité des modules de suivi

Ce tableau indique, pour chaque protocole GeoNature Monitoring connu, si l'application mobile sait le saisir, ce qui a été testé automatiquement, et les retours du terrain.

> Sources analysées : [PnX-SI/protocoles_suivi](https://github.com/PnX-SI/protocoles_suivi) (`master`, septembre 2026) et les branches `dev/*` du fork [Geomaticien-shf/protocoles_suivi](https://github.com/Geomaticien-shf/protocoles_suivi). Version de l'application : `v1.1.1+3` + correctifs de septembre 2026 (non publiés).

## Légende

| Colonne | Signification |
|---|---|
| **Configuration** | Analyse automatique des fichiers du protocole (`site.json`, `visit.json`…) : types de champs, objets, expressions. ✅ tout est géré · ⚠️ un ou plusieurs champs ne peuvent pas être saisis · ❌ module non supporté |
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
| chiro | Chiroptères | ⚠️ | — | — | Médias (visite, observation) : pas d'ajout de photo |
| chronocapture | ChronoCapture | ✅ | — | — | — |
| chronoventaire | ChronoVentaire | ⚠️ | — | — | Codes habitat du site (4 champs) : liste d'habitats vide |
| craves | Craves | ✅ | — | — | — |
| ecrevisses_pattes_blanches | Écrevisses à pattes blanches | ✅ | 🔬 | — | — |
| flore_biotope | Suivis botaniques de site | ✅ | — | — | — |
| lichens_bio_indicateurs | Lichens bio-indicateurs | ⚠️ | — | — | Habitat principal / associé (visite) : liste d'habitats vide |
| ligne_lecture | Ligne de lecture | ⚠️ | — | — | Médias (détail d'observation) |
| micromam_analyse_pelotes_rejection_gmb | Pelotes de réjection | ⚠️ | — | — | Déterminateur et observateurs multiples : seul l'utilisateur connecté est enregistré |
| nidif_gypa | Nidification du Gypaète barbu | ✅ | 🔬 | — | — |
| oedic | Œdicnèmes | ✅ | — | — | — |
| osmodermes | Osmodermes | ✅ | — | — | — |
| petite_chouette_montagne | Petite chouette de montagne | ✅ | 🧪 🔬 | — | Expressions qui comparent le taxon à un entier : même comportement que sur le web, à corriger dans la configuration |
| piegeages_passifs | Pièges à interception passifs | ⚠️ | — | — | Observateurs multiples : seul l'utilisateur connecté est enregistré |
| prairies_fleuries | Prairies fleuries | ✅ | — | — | — |
| pt_ecoute_avifaune | Point d'écoute avifaune | ⚠️ | 🧪 | — | Médias (observation) |
| pyrales | Pyrales du buis | ⚠️ | — | — | Habitat du groupe de sites : liste d'habitats vide |
| sterf | STERF | ✅ | — | — | — |
| stom | STOM | ⚠️ | 🧪 🔬 | — | Médias (observation) |
| suivi_Camphi_gmb | Campagnol amphibie régional | ✅ | — | — | — |
| suivi_colo_chiro_gmb | Chiroptères au gîte | ✅ | — | — | — |
| suivi_loutre_SACs_gmb | Loutre local | ✅ | 🧪 🔬 | — | — |
| suivi_loutre_UICN_gmb | Loutre régional | ✅ | — | — | — |
| suivi_nardaie | Suivi nardaie | ✅ | 🔬 | — | — |
| suivi_phytosocio | Suivi phytosociologique | ✅ | — | — | — |
| suivi_terriers_blaireau_gmb | Blaireautières | ✅ | 🧪 🔬 | ❌ en v1.1.1 : erreur à l'enregistrement d'une visite (corrigée en 09/2026, à retester) | — |
| cmr_cistude *(fork)* | CMR Cistude | ❌ | — | — | Formulaires « Individus » et « Marquage », widget `individuals`, médias, habitats |
| popanomaloglossus *(fork)* | POPAnomaloglossus | ✅ | 🧪 🔬 | — | — |

**Bilan** : 27 modules sans limite détectée dans leur configuration, 9 utilisables avec réserves (médias, habitats, observateurs multiples), 1 non supporté. Seuls POPAmphibien et POPReptile ont un retour terrain positif.

## Limites communes

- **Fond de carte** : la saisie fonctionne hors ligne, mais le fond de carte OpenStreetMap nécessite une connexion.
- **Médias** (`medias`) : pas d'ajout de photo ou de document ; le champ s'affiche comme un champ texte.
- **Listes chargées depuis une API** autres que nomenclatures, taxons, jeux de données et groupes de sites (habitats `habref`, listes d'utilisateurs) : liste vide.
- **Observateurs** : l'utilisateur connecté est ajouté automatiquement ; on ne peut pas en choisir d'autres.
- **Nombres décimaux** : refusés dans les champs numériques.

Le détail des limites et le fonctionnement des champs sont décrits dans [FEATURES_OVERVIEW.md](FEATURES_OVERVIEW.md).

## Mettre à jour ce tableau

- **Retour terrain** : remplir la colonne avec le verdict, la version de l'app (écran d'accueil) et la date, et décrire le problème éventuel dans une issue GitHub.
- **Nouveau protocole ou nouvelle version** :
  1. relancer la comparaison des expressions : `scripts/protocoles_audit/generate_corpus.sh <dossier_protocoles>` puis `flutter test test/core/helpers/js_expression_interpreter_test.dart` ;
  2. vérifier les types de champs utilisés (widgets `medias`, listes sur API, objets autres que site / groupe / visite / observation / détail) ;
  3. ajouter une ligne au tableau.

---

Dernière mise à jour : septembre 2026
