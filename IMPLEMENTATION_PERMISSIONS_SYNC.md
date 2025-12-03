# Implémentation des permissions CRUVED lors de la synchronisation

## Vue d'ensemble

Les permissions CRUVED doivent être importées pour chaque objet lors de la synchronisation des modules. L'API doit renvoyer les permissions dans la structure de chaque objet (sites, groupes de sites, visites).

## Modifications effectuées

### 1. Modèle SiteGroup
- Ajout du champ `CruvedResponse? cruved` au modèle de domaine
- Implémentation du mixin `MonitoringObjectMixin` pour les méthodes helper

### 2. Entité SiteGroupEntity  
- Ajout du champ `Map<String, dynamic>? cruved`
- Mise à jour des méthodes `fromJson` et `toJson`

### 3. Mapper SiteGroupEntity
- Conversion des permissions depuis/vers `CruvedResponse`
- Import de `CruvedResponse` pour la conversion

### 4. API Sites (SitesApiImpl)
- Extraction des permissions CRUVED dans `fetchSiteGroupsForModule`
- Extraction des permissions CRUVED dans `fetchEnrichedSitesForModule`
- Préservation des permissions lors de `_fetchAdditionalSiteDetails`

## Structure attendue de l'API

L'API doit renvoyer les permissions dans chaque objet :

```json
{
  "children": {
    "sites_group": [
      {
        "id_sites_group": 1,
        "properties": {
          "sites_group_name": "Groupe A",
          "sites_group_code": "GRP_A"
        },
        "cruved": {
          "C": true,
          "R": true,
          "U": true,
          "V": false,
          "E": true,
          "D": false
        }
      }
    ],
    "site": [
      {
        "id_base_site": 1,
        "properties": {
          "base_site_name": "Site 1"
        },
        "cruved": {
          "C": false,
          "R": true,
          "U": true,
          "V": false,
          "E": true,
          "D": false
        }
      }
    ]
  }
}
```

## Points d'intégration

### Sites
- **Endpoint**: `/monitorings/object/$moduleCode/module`
- **Extraction**: Dans `fetchEnrichedSitesForModule`, ligne 215
- **Sauvegarde**: Via `BaseSiteEntity.fromJson` → `toDomain()`

### Groupes de sites
- **Endpoint**: `/monitorings/object/$moduleCode/module`  
- **Extraction**: Dans `fetchSiteGroupsForModule`, ligne 403
- **Sauvegarde**: Via `SiteGroupEntity.fromJson` → `toDomain()`

### Visites
- **À implémenter**: Les visites doivent suivre le même pattern
- **Endpoint probable**: `/monitorings/object/$moduleCode/visits`

## Prochaines étapes

1. **Backend** : S'assurer que l'API renvoie les permissions CRUVED dans chaque objet
2. **Visites** : Implémenter l'extraction des permissions pour les visites
3. **Observations** : Ajouter le support des permissions pour les observations
4. **Tests** : Vérifier que les permissions sont correctement importées et sauvegardées

## Utilisation dans l'UI

Une fois les permissions importées, elles sont disponibles sur chaque objet :

```dart
// Site avec permissions
if (site.canUpdate()) {
  // Afficher le bouton modifier
}

// Groupe de sites avec permissions  
if (siteGroup.canDelete()) {
  // Afficher le bouton supprimer
}
```

## Points d'attention

1. Les permissions doivent être récupérées depuis l'API à chaque synchronisation
2. Les permissions sont stockées avec chaque objet, pas globalement
3. Le backend doit calculer les permissions en fonction de l'utilisateur connecté
4. Les permissions peuvent changer entre les synchronisations