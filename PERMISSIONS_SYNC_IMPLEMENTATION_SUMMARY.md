# Résumé de l'implémentation des permissions CRUVED lors de la synchronisation

## Vue d'ensemble

Les permissions CRUVED sont maintenant intégrées dans tous les objets principaux lors de la synchronisation :
- **Modules** : Permissions récupérées via `/monitorings/modules`
- **Groupes de sites** : Permissions récupérées via `/monitorings/object/{module_code}/module`
- **Sites** : Permissions récupérées via le même endpoint
- **Visites** : Support ajouté, permissions à récupérer via l'API

## Format des permissions

L'API renvoie deux formats de permissions CRUVED :

### 1. Format numérique (modules, listes)
```json
"cruved": {
    "C": 0,    // 0 = pas d'accès
    "R": 3,    // 1 = mes données, 2 = mon organisme, 3 = toutes
    "U": 3,
    "V": 0,
    "E": 3,
    "D": 0
}
```

### 2. Format booléen (objets individuels)
```json
"cruved": {
    "C": true,
    "R": true,
    "U": true,
    "V": false,
    "E": false,
    "D": false
}
```

## Conversion automatique

Le `CruvedJsonConverter` dans `cruved_response.dart` gère automatiquement la conversion :
- Valeur numérique > 0 → `true`
- Valeur numérique = 0 → `false`
- Valeur booléenne → conservée telle quelle

## Objets modifiés

### 1. Module
- ✅ Champ `CruvedResponse? cruved` ajouté
- ✅ Mixin `CruvedObjectMixin` implémenté
- ✅ Mapper mis à jour pour convertir les permissions

### 2. SiteGroup
- ✅ Champ `CruvedResponse? cruved` ajouté
- ✅ Mixin `CruvedObjectMixin` implémenté
- ✅ Entity et mapper mis à jour
- ✅ Extraction depuis l'API dans `fetchSiteGroupsForModule`

### 3. BaseSite
- ✅ Déjà équipé du champ `cruved` et du mixin
- ✅ Extraction depuis l'API dans `fetchEnrichedSitesForModule`

### 4. BaseVisit
- ✅ Déjà équipé du champ `cruved` et du mixin
- ✅ Entity et mapper mis à jour
- ⚠️ L'API doit renvoyer les permissions lors de la récupération des visites

## Utilisation dans l'interface

### Méthodes disponibles sur chaque objet
```dart
// Vérifications individuelles
if (site.canUpdate()) { /* Afficher bouton modifier */ }
if (visit.canDelete()) { /* Afficher bouton supprimer */ }

// Résumé des permissions
Text('Permissions: ${module.getPermissionsSummary()}') // "RUE"

// Vérifications globales
if (siteGroup.hasAnyPermission()) { /* Au moins une permission */ }
if (site.hasFullCRUD()) { /* Toutes les permissions CRUD */ }
```

### Exemples d'utilisation
- `example_simple_permissions.dart` : Exemples généraux
- `example_permissions_site_groups.dart` : Groupes de sites avec actions
- `example_sync_permissions.dart` : Permissions après synchronisation

## Points d'attention

1. **Synchronisation** : Les permissions sont récupérées à chaque synchronisation et peuvent changer
2. **Format mixte** : L'API utilise deux formats selon le contexte (numérique/booléen)
3. **Null safety** : Les permissions peuvent être null si non définies
4. **Performance** : Les permissions sont stockées avec chaque objet, pas de requête supplémentaire

## Prochaines étapes recommandées

1. **Backend** : S'assurer que tous les endpoints renvoient les permissions CRUVED
2. **Visites** : Implémenter la récupération des permissions lors du fetch des visites
3. **Observations** : Ajouter le support des permissions si nécessaire
4. **Tests** : Ajouter des tests d'intégration pour vérifier la récupération des permissions