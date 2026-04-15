# Historique des versions publiées

Ce document liste les versions de l'app mobile publiées officiellement, avec les informations nécessaires au déploiement côté serveur GeoNature.

## Comment utiliser ce document

Chaque entrée décrit une release :

- **Tag** : le tag Git + GitHub Release qui contient l'APK.
- **Code de version** : valeur à saisir dans **Administration > Autres > Applications mobiles** du serveur GeoNature, champ « Code de version ». Correspond au `buildNumber` de `pubspec.yaml` (partie après le `+`). Le serveur ne notifie l'utilisateur d'une mise à jour que si le code distant est **strictement supérieur** au code installé.
- **GeoNature core** : lignes majeures GeoNature sur lesquelles l'APK est validé.
- **Module `gn_module_monitoring`** : version minimale du module serveur. Vérifiée automatiquement par l'app avant chaque téléchargement de module.

## Versions

### v1.0.0-geonature-2.17

- **Date** : 2026-04-14
- **Code de version** : `1`
- **GeoNature core** : 2.17.x
- **Module `gn_module_monitoring`** : ≥ 1.2.6
- **Release GitHub** : [v1.0.0-geonature-2.17](https://github.com/RNF-SI/gn_mobile_monitoring/releases/tag/v1.0.0-geonature-2.17)
- **Branche de support** : `support/geonature-2.17`

Première release stable de l'app mobile monitoring. Saisie hors-ligne des sites, groupes de sites, visites et observations, avec géométries Point / LineString / Polygon éditables sur carte et synchronisation manuelle vers GeoNature.

### v1.0.0-geonature-2.16

- **Date** : 2026-04-13
- **Code de version** : `1`
- **GeoNature core** : 2.16.x
- **Module `gn_module_monitoring`** : ≥ 1.2.0
- **Tag Git uniquement** : [v1.0.0-geonature-2.16](https://github.com/RNF-SI/gn_mobile_monitoring/releases/tag/v1.0.0-geonature-2.16) (pas d'APK publié — voir note ci-dessous)
- **Branche de support** : `support/geonature-2.16`

Tag figeant l'état du code avant la bascule `develop` vers la compat GeoNature 2.17. Aucune évolution majeure de code entre ce tag et `v1.0.0-geonature-2.17` ne remet en cause la compatibilité avec un serveur GeoNature 2.16 : les changements apportés sont soit client-side (picker de géométrie, calcul de distance), soit des correctifs de synchronisation qui bénéficient aux deux lignes majeures. Un serveur en GeoNature 2.16.x peut utiliser `v1.0.0-geonature-2.17` sans incompatibilité identifiée à ce jour (non testé en conditions réelles contre une instance 2.16).

## Bonnes pratiques pour une future release

1. Incrémenter `version:` dans `pubspec.yaml` **y compris le `buildNumber`** (partie après `+`). Si la version installée chez un utilisateur est `1.0.0+1` et que la nouvelle release reste à `1.0.0+1`, l'update in-app ne sera **pas** proposée.
2. Mettre à jour la matrice de compat dans `README.md` et ce document.
3. Publier l'APK en tant que **GitHub Release** (pas seulement un tag Git), avec :
   - Nom de l'asset : `monitoring-v<X.Y.Z>-geonature-<M.m>.apk`
   - Rappel du code de version dans la description.
4. Communiquer aux admins GeoNature le nouveau code de version à saisir côté admin.
