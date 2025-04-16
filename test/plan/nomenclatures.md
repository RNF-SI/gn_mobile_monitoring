Réponse Monitoring:
Voici maintenant ma réponse à votre question. Pour télécharger les
nomenclatures et taxons liés à un module dans votre application mobile,
vous pouvez utiliser la route suivante:

GET /monitorings/util/init_data/<module_code>

Cette route renvoie toutes les données préchargées pour un module
spécifique, notamment:

1. Nomenclatures: Les nomenclatures définies dans la configuration du
   module
2. Utilisateurs: Les observateurs liés au module
3. Groupes de sites: Les groupes de sites associés au module
4. Datasets: Les jeux de données liés au module

{
"dataset": [
{
"active": true,
"bbox_east": null,
"bbox_north": null,
"bbox_south": null,
"bbox_west": null,
"dataset_desc": "Apollons : suivis des dalles à orpins",
"dataset_name": "Apollons : Dalles à orpins",
"dataset_shortname": "Apollons : Dalles à orpins",
"id_acquisition_framework": 1,
"id_dataset": 206,
"id_digitizer": 142,
"id_nomenclature_collecting_method": 403,
"id_nomenclature_data_origin": 78,
"id_nomenclature_data_type": 577,
"id_nomenclature_dataset_objectif": 417,
"id_nomenclature_resource_type": 324,
"id_nomenclature_source_status": 75,
"id_taxa_list": null,
"keywords": null,
"marine_domain": false,
"meta_create_date": "2021-05-31 11:46:42.087107",
"meta_update_date": "2025-01-24 11:47:57.430863",
"terrestrial_domain": true,
"unique_dataset_id": "75850f90-b437-498d-9a5f-a2bf24a0c187",
"validable": true
}
],
"nomenclature": [
{
"active": true,
"cd_nomenclature": "2",
"code_type": "TYPE_MEDIA",
"definition_default": "Média de type image",
"definition_fr": "Média de type image",
"hierarchy": "117.002",
"id_broader": 0,
"id_nomenclature": 467,
"id_type": 117,
"label_default": "Photo",
"label_fr": "Photo",
"mnemonique": "Photo",
"source": "GEONATURE",
"statut": "Non validé"
},
{
"active": true,
"cd_nomenclature": "3",
"code_type": "TYPE_MEDIA",
"definition_default": "Média de type page web",
"definition_fr": "Média de type page web",
"hierarchy": "117.003",
"id_broader": 0,
"id_nomenclature": 468,
"id_type": 117,
"label_default": "Page web",
"label_fr": "Page web",
"mnemonique": "Page web",
"source": "GEONATURE",
"statut": "Non validé"
},
...
],
"sites_group": [
{
"altitude_max": null,
"altitude_min": null,
"comments": null,
"data": null,
"geometry": {
"coordinates": [
[
[
3.4022052,
44.4090398
],
[
3.3991211,
44.4097094
],
[
3.3986406,
44.4098456
],
[
3.4012734,
44.4148217
],
[
3.4162206,
44.4208646
],
[
3.4166714,
44.4199678
],
[
3.4143934,
44.4163309
],
[
3.409781,
44.4103103
],
[
3.4022052,
44.4090398
]
]
],
"type": "Polygon"
},
"id_digitiser": null,
"id_sites_group": 29,
"is_geom_from_child": true,
"medias": [],
"meta_update_date": "2022-03-11T16:02:54.100964",
"modules": [
21
],
"nb_sites": 28,
"nb_visits": 106,
"pk": "id_sites_group",
"sites_group_code": "Champerboux",
"sites_group_description": null,
"sites_group_name": "Champerboux",
"uuid_sites_group": "45611492-e166-414a-a458-7b4ef41eff63"
},
...
],
"user": [
{
"id_menu": 1,
"id_role": 265,
"nom_complet": "CAREL Yves",
"nom_role": "CAREL",
"prenom_role": "Yves"
},
],
}

TAXONS:
Si vous avez besoin de récupérer des taxons, vous devriez vérifier si
id_list_taxonomy est défini dans le module. Si c'est le cas, vous
pourriez avoir besoin d'une requête supplémentaire pour récupérer les
taxons.

Pour les taxons, il n'y a pas de route spécifique dans ce projet, mais
vous pourriez utiliser les routes standard de GeoNature pour récupérer
les taxons d'une liste:

GET
/taxref/allnamebylist/68

Pour récupérer des informations spécifiques sur une nomenclature:

GET
/monitorings/util/nomenclature/<code_nomenclature_type>/<cd_nomenclature>

Pour récupérer des informations sur un taxon, une nomenclature ou autre
élément par ID:

GET /monitorings/util/<type_util>/<id>

Où <type_util> peut être "nomenclature", "taxonomy", "user", etc.
Ex taxonomy:
{{url_local}}/monitorings/util/taxonomy/54496

Avec ce résultat:
{
"cd_nom": 54496,
"cd_ref": 54496,
"cd_sup": 608453,
"cd_taxsup": 195855,
"classe": "Insecta",
"famille": "Papilionidae",
"group1_inpn": "Arthropodes",
"group2_inpn": "Insectes",
"group3_inpn": "Lépidoptères",
"id_habitat": 3,
"id_rang": "ES",
"id_statut": "P",
"lb_auteur": "(Linnaeus, 1758)",
"lb_nom": "Parnassius apollo",
"nom_complet": "Parnassius apollo (Linnaeus, 1758)",
"nom_complet_html": "<i>Parnassius apollo</i> (Linnaeus, 1758)",
"nom_valide": "Parnassius apollo (Linnaeus, 1758)",
"nom_vern": "Apollon (L'), Parnassien apollon (Le)",
"nom_vern_eng": "Apollo",
"ordre": "Lepidoptera",
"phylum": "Arthropoda",
"regne": "Animalia",
"sous_famille": "Parnassiinae",
"tribu": "Parnassiini",
"url": "https://inpn.mnhn.fr/espece/cd_nom/54496"
}

Ex nomenclature:
{{url_local}}/monitorings/util/nomenclature/TYPE_SITE/APO_DALLES
{
"active": true,
"cd_nomenclature": "APO_DALLES",
"definition_default": "Dalles à orpins",
"definition_fr": "Dalles à orpins",
"hierarchy": null,
"id_broader": null,
"id_nomenclature": 686,
"id_type": 116,
"label_default": "Dalles à orpins",
"label_fr": "Dalles à orpins",
"mnemonique": "Dalles à orpins",
"source": "monitoring",
"statut": "Validation en cours"
}

Réponse Géonature:
● Après avoir effectué ces recherches, je peux fournir une réponse à votre question sur comment gérer les nomenclatures et les taxons dans votre application mobile liée au module
monitoring.

Pour télécharger les nomenclatures et les taxons liés à un module au moment du téléchargement de ce module dans l'application mobile, voici les API que vous pouvez utiliser :

1. Pour les nomenclatures :
   GET /api/nomenclatures/nomenclature/{code_type}
1. où {code_type} est le code mnémonique du type de nomenclature.
   Ex:
   {{url_local}}/nomenclatures/nomenclatures?orderby=label_default&code_type=TYPE_MEDIA

[
{
"definition_de": null,
"definition_default": "Nomenclature des types de médias.",
"definition_en": null,
"definition_es": null,
"definition_fr": "Nomenclature des types de médias.",
"definition_it": null,
"id_type": 117,
"label_de": null,
"label_default": "Type de médias",
"label_en": null,
"label_es": null,
"label_fr": "Type de médias",
"label_it": null,
"meta_create_date": "2018-10-19 10:49:32.023250",
"meta_update_date": "2018-10-19 10:49:32.029870",
"mnemonique": "TYPE_MEDIA",
"source": "GEONATURE",
"statut": "Non validé",
"values": [
{
"active": true,
"cd_nomenclature": "5",
"definition_default": "Média de type fichier audio mp3",
"definition_fr": "Média de type fichier audio mp3",
"hierarchy": "117.005",
"id_broader": 0,
"id_nomenclature": 470,
"id_type": 117,
"label_default": "Audio",
"label_fr": "Audio",
"mnemonique": "Audio",
"source": "GEONATURE",
"statut": "Non validé"
},
{
"active": true,
"cd_nomenclature": "3",
"definition_default": "Média de type page web",
"definition_fr": "Média de type page web",
"hierarchy": "117.003",
"id_broader": 0,
"id_nomenclature": 468,
"id_type": 117,
"label_default": "Page web",
"label_fr": "Page web",
"mnemonique": "Page web",
"source": "GEONATURE",
"statut": "Non validé"
},
....
]
}

1. Vous pouvez également récupérer plusieurs nomenclatures en une seule requête :
   GET /api/nomenclatures?code_type={code_type1}&code_type={code_type2}
1. Pour les taxons :
   GET /api/taxref/{cd_nom}
1. pour récupérer un taxon spécifique par son code cd_nom.
1. Pour les nomenclatures spécifiques à un module de monitoring :
   Chaque module de monitoring a un fichier nomenclature.json dans /media/monitorings/{nom_module}/ qui définit les nomenclatures spécifiques au module. Vous pouvez consulter ce
   fichier pour connaître les types de nomenclatures utilisés par le module, puis utiliser les API ci-dessus pour les récupérer.
1. Pour les applications mobiles :
   Les applications mobiles sont gérées via l'API :
   GET /api/gn_commons/t_mobile_apps
1. qui retourne la liste des applications mobiles enregistrées avec leurs URL de configuration.

Une approche pour votre application mobile serait :

1. Récupérer la configuration du module de monitoring via son fichier nomenclature.json
2. Extraire les codes des nomenclatures nécessaires
3. Utiliser l'API nomenclature pour télécharger toutes les nomenclatures requises
4. Si des taxons spécifiques sont nécessaires, les récupérer via l'API taxref

Il n'existe pas d'API unique qui renvoie à la fois les nomenclatures et les taxons pour un module spécifique, vous devrez donc faire plusieurs requêtes pour récupérer toutes les
données nécessaires.
