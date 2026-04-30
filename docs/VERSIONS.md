# Historique des versions publiées

Ce document liste les versions de l'app mobile publiées officiellement, avec les informations nécessaires au déploiement côté serveur GeoNature.

> 💡 **Tu cherches juste la valeur à saisir dans le champ « Code de version » de l'admin GeoNature ?** Elle est publiée pour chaque release dans la section [Versions](#versions) ci-dessous (colonne **Code de version**). Pour la dernière release `v1.1.0`, c'est `2`.

## Comment utiliser ce document

Chaque entrée décrit une release :

- **Nom de la release** : tel qu'affiché sur GitHub. Ne coïncide pas forcément avec le tag Git (ex. release `v1.0.0` publiée sur le tag `v1.0.0-geonature-2.17`).
- **Tag Git** : identifiant immuable de la release, utilisé dans les URLs GitHub et pour nommer l'APK attaché.
- **Code de version** : valeur à saisir dans **Administration > Autres > Applications mobiles** du serveur GeoNature, champ « Code de version ». Correspond au `buildNumber` de `pubspec.yaml` (partie après le `+`). Le serveur ne notifie l'utilisateur d'une mise à jour que si le code distant est **strictement supérieur** au code installé.
- **GeoNature core** : lignes majeures GeoNature sur lesquelles l'APK est validé.
- **Module `gn_module_monitoring`** : version minimale du module serveur. Vérifiée automatiquement par l'app avant chaque téléchargement de module.

## Versions

### v1.1.0

- **Date** : 2026-04-30
- **Code de version** : `2`
- **GeoNature core** : 2.17.x
- **Module `gn_module_monitoring`** : ≥ 1.2.6
- **Tag Git** : [`v1.1.0-geonature-2.17`](https://github.com/RNF-SI/gn_mobile_monitoring/releases/tag/v1.1.0-geonature-2.17)
- **APK** : `monitoring-v1.1.0-geonature-2.17.apk`
- **Branche de support** : `support/geonature-2.17`

Deuxième release sur la ligne GeoNature 2.17.x. Renommage de l'app en **Monitoring** avec nouveau logo, badges orange pour visualiser les saisies non synchronisées, désinstallation de modules depuis le menu détail, refonte des appels d'API de synchronisation (alignement sur les endpoints `/refacto/` du module serveur), et une trentaine de correctifs de saisie. Voir les [notes de release complètes](https://github.com/RNF-SI/gn_mobile_monitoring/releases/tag/v1.1.0-geonature-2.17).

### v1.0.0

- **Date** : 2026-04-14
- **Code de version** : `1`
- **GeoNature core** : ≥ 2.16.x
- **Module `gn_module_monitoring`** : ≥ 1.2.6
- **Tag Git** : [`v1.0.0-geonature-2.17`](https://github.com/RNF-SI/gn_mobile_monitoring/releases/tag/v1.0.0-geonature-2.17)
- **APK** : `monitoring-v1.0.0-geonature-2.17.apk`
- **Branche de support** : `support/geonature-2.17`

Première release stable de l'app mobile monitoring. Saisie hors-ligne des sites, groupes de sites, visites et observations, avec géométries Point / LineString / Polygon éditables sur carte et synchronisation manuelle vers GeoNature. Le suffixe `-geonature-2.17` du tag est un héritage du processus de build — la release elle-même est validée pour GeoNature ≥ 2.16.x.

### v1.0.0-geonature-2.16 (snapshot interne)

- **Date** : 2026-04-13
- **Code de version** : `1`
- **GeoNature core** : 2.16.x
- **Module `gn_module_monitoring`** : ≥ 1.2.0
- **Tag Git uniquement** : [`v1.0.0-geonature-2.16`](https://github.com/RNF-SI/gn_mobile_monitoring/releases/tag/v1.0.0-geonature-2.16) (pas d'APK publié — voir note ci-dessous)
- **Branche de support** : `support/geonature-2.16`

Tag figeant l'état du code avant la bascule `develop` vers la compat GeoNature 2.17. Aucune évolution majeure de code entre ce tag et la release `v1.0.0` ne remet en cause la compatibilité avec un serveur GeoNature 2.16 : les changements apportés sont soit client-side (picker de géométrie, calcul de distance), soit des correctifs de synchronisation qui bénéficient aux deux lignes majeures. Un serveur en GeoNature 2.16.x peut utiliser l'APK de la release `v1.0.0` sans incompatibilité identifiée à ce jour (non testé en conditions réelles contre une instance 2.16).

## Bonnes pratiques pour une future release

1. Incrémenter `version:` dans `pubspec.yaml` **y compris le `buildNumber`** (partie après `+`). Si la version installée chez un utilisateur est `1.0.0+1` et que la nouvelle release reste à `1.0.0+1`, l'update in-app ne sera **pas** proposée.
2. Mettre à jour la matrice de compat dans `README.md` et ce document.
3. Publier l'APK en tant que **GitHub Release** (pas seulement un tag Git), avec :
   - Tag Git : `v<X.Y.Z>-geonature-<M.m>` (convention interne de build)
   - Nom de la release : libre (ex. `v<X.Y.Z>`), à choisir selon la communication voulue côté utilisateur
   - Nom de l'asset APK : `monitoring-v<X.Y.Z>-geonature-<M.m>.apk`
   - Rappel du code de version dans la description.
4. Communiquer aux admins GeoNature le nouveau code de version à saisir côté admin.
