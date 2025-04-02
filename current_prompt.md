Prompt pour la génération du formulaire “Visite” à partir de la configuration GeoNature Monitoring
Contexte et objectif
Nous développons une application mobile Flutter pour GeoNature Monitoring.

Nous stockons la configuration des modules (exemple : apollons) sous forme d’objet JSON brut dans la base de données locale.
Nous voulons construire un formulaire de saisie “Visite” en Flutter de manière dynamique en analysant la configuration JSON.
Données d’entrée
Nous fournissons au LLM :

Le JSON complet d’une configuration de module (voir “Exemple de structure de départ”).
Quelques informations contextuelles sur le module (ID, nom, etc.).
Les règles de transformation (ex. comment fusionner generic et specific, comment extraire les attributs à afficher).
Exemple de structure de départ
json5
Copier
Modifier
{
"custom": { /_ ... _/ },
"data": { /_ ... _/ },
"default*display_field_names": { /* ... _/ },
"display_field_names": { /_ ... \_/ },

    "module": { /* ... */ },

    "site": { /* ... */ },

    "sites_group": { /* ... */ },

    "synthese": true,
    "synthese_object": "visit",
    "tree": { /* ... */ },

    "visit": {
       "chain_show": [
          "visit_date_min",
          "id_base_site",
          "num_passage"
       ],
       "chained": true,
       "display_form": [],
       "display_list": [
          "id_base_site",
          "visit_date_min",
          "num_passage",
          "time_start",
          "count_stade_l1",
          "count_stade_l2",
          "count_stade_l3",
          "count_stade_l4",
          "count_stade_l5",
          "observers"
       ],
       "generic": {
         "comments": {
             "attribut_label": "Commentaires",
             "type_widget": "text"
         },
         "id_base_site": {
             "api": "monitorings/list/apollons/site",
             "application": "GeoNature",
             "attribut_label": "Site",
             "hidden": "({meta, value}) => !meta.bChainInput && value.id_base_site",
             "required": true,
             "type_util": "site",
             "type_widget": "datalist"
         },
         /* etc. */
       },
       "specific": {
          "count_stade_l1": {
             "attribut_label": "Nb L1",
             "default": 0,
             "description": "Chenille entièrement noire de <1,5mm",
             "type_widget": "number"
          },
          /* etc. */
       }
       /* ... */
    }

}
(Le JSON détaillé est plus long ; on le laisse en annexe.)

Tâches attendues de l’IA
Analyser le JSON brut pour localiser l’objet de configuration du “visit” (ou autre type d’objet, selon le paramètre).
Fusionner les champs generic et specific (les propriétés se trouvant dans l’un ou l’autre) en un seul schéma unifié.
Appliquer les éventuelles substitutions de variables (ex. \_\_MODULE.MODULE_CODE) si nécessaire.
Interpréter les champs (ex. attribut_label, type_widget, required, values, min, max, etc.) et en déduire les informations dont on a besoin pour construire un formulaire Flutter.
Expliquer (en langage clair) quelles sont les règles pour générer :
Un TextField, un DatePicker, un DropdownButton, etc.
Les validations obligatoires (required, min, max, etc.).
Les champs “cachés” (hidden == true) ou conditionnels.
Fournir un exemple de pseudo-code ou de code Dart pour construire le formulaire Flutter à partir de ce schéma unifié.
Format de la réponse souhaité
Un résumé de la logique appliquée (où on retrouve la fusion generic + specific, le parsing, etc.).

Un objet final JSON (ou un pseudo-objet Dart) représentant le schéma unifié pour visit. Par exemple :

json5
Copier
Modifier
{
"id*base_site": {
"attribut_label": "Site",
"type_widget": "datalist",
"required": true
/* etc. _/
},
"comments": {
"attribut_label": "Commentaires",
"type_widget": "text"
/_ etc. _/
},
"count_stade_l1": {
"attribut_label": "Nb L1",
"type_widget": "number",
"default": 0,
"description": "Chenille noire de <1,5 mm"
/_ etc. \_/
}
}
Un exemple d’implémentation (pseudo-code Dart/Flutter) qui itère sur ces champs pour générer un formulaire.

Pourquoi ?
Pour générer dynamiquement le formulaire de saisie de visite (ou site, ou autre) dans l’application mobile.
Pour réutiliser les mêmes règles de configuration que dans l’application web (GeoNature).
Conclusion
Avec ces instructions, l’IA saura :

Quelles parties du JSON lire (ex. visit.generic, visit.specific)
Comment merger ces parties
Comment convertir chaque champ (ex. type_widget: "text" -> TextField, type_widget: "date" -> un datePicker, etc.)
Comment expliquer ou justifier la logique.

Annexe : JSON complet pour le module “apollons”
Voir le fichier config_example.json