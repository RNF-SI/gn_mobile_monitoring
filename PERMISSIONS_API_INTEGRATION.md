# Intégration API CRUVED - Guide Complet

## Vue d'ensemble

L'implémentation finale intègre l'API GeoNature existante avec ses endpoints réels pour synchroniser les permissions CRUVED dans l'application mobile Flutter.

## Architecture de Synchronisation

### Stratégie Multi-Niveaux

1. **Synchronisation Globale** (Login/Refresh)
   - Endpoint: `GET /monitorings/modules`
   - Récupère les permissions de tous les modules
   - Mise en cache de 6 heures

2. **Synchronisation Spécifique** (Navigation)
   - Endpoints par module et type d'objet
   - Cache local avec invalidation intelligente
   - Validation offline

3. **Cache Optimisé**
   - SharedPreferences avec expiration
   - Clés par (userId, moduleId)
   - Nettoyage automatique

## Endpoints API Intégrés

### Modules
```
GET /monitorings/modules
GET /monitorings/module/{id}
```
**Permissions**: MONITORINGS_MODULES (C, R, U, E, V)

### Sites
```
GET /monitorings/sites/{module_code}
GET /monitorings/sites/{module_code}/{id}
GET /monitorings/refacto/{module_code}/sites
```
**Permissions**: MONITORINGS_SITES (C, R, U, D)

### Groupes de Sites
```
GET /monitorings/sites_groups/{module_code}
GET /monitorings/sites_groups/{module_code}/{id}
GET /monitorings/refacto/{module_code}/sites_groups
```
**Permissions**: MONITORINGS_GRP_SITES (C, R, U, D)

### Visites
```
GET /monitorings/visits/{module_code}
GET /monitorings/refacto/{module_code}/visits
```
**Permissions**: MONITORINGS_VISITES (C, R, U, D)

### Individus
```
GET /monitorings/individuals
GET /monitorings/refacto/{module_code}/individuals
```
**Permissions**: MONITORINGS_INDIVIDUALS (C, R, U, D)

### Endpoint Générique
```
GET /monitorings/object/{module_code}/{object_type}/{id?}
```
**Permissions**: Selon l'object_type

## Format des Réponses API

### Structure Standard
```json
{
  "id": 123,
  "properties": {
    "name": "Site Example",
    "description": "Description du site",
    "code": "SITE001"
  },
  "cruved": {
    "C": true,
    "R": true,
    "U": false,
    "D": false,
    "E": true,
    "V": false
  }
}
```

### Réponse Module
```json
{
  "id": 1,
  "name": "Module Générique",
  "code": "generic",
  "description": "Module de monitoring générique",
  "cruved": {
    "C": false,
    "R": true,
    "U": true,
    "E": true,
    "V": false
  },
  "properties": {
    "config": {...}
  }
}
```

## Nouveaux Composants

### Modèles de Réponse API

#### CruvedResponse
```dart
@freezed
class CruvedResponse with _$CruvedResponse {
  const factory CruvedResponse({
    @JsonKey(name: 'C') @Default(false) bool create,
    @JsonKey(name: 'R') @Default(false) bool read,
    @JsonKey(name: 'U') @Default(false) bool update,
    @JsonKey(name: 'V') @Default(false) bool validate,
    @JsonKey(name: 'E') @Default(false) bool export,
    @JsonKey(name: 'D') @Default(false) bool delete,
  }) = _CruvedResponse;

  factory CruvedResponse.fromJson(Map<String, dynamic> json) =>
      _$CruvedResponseFromJson(json);
}
```

#### Réponses Spécialisées
- **ModuleResponse**: Modules avec configuration
- **SiteResponse**: Sites avec géométrie
- **VisitResponse**: Visites avec observateurs
- **SiteGroupResponse**: Groupes avec sites associés

### Service de Synchronisation Mis à Jour

#### PermissionSyncService
```dart
// Synchronisation globale des modules
Future<void> syncUserPermissions(String baseUrl, String authToken)

// Synchronisation spécifique d'un module
Future<void> syncModuleSpecificPermissions(String baseUrl, String moduleCode)

// Récupération des permissions d'un objet spécifique
Future<CruvedResponse> getObjectPermissions(
  String baseUrl, 
  String moduleCode, 
  String objectType, 
  int? objectId
)
```

#### Conversion CRUVED → Permissions Locales
```dart
List<Permission> _convertCruvedToPermissions(
  CruvedResponse cruved, 
  int moduleId, 
  String objectCode
)
```

### Cache Optimisé

#### PermissionCacheService
```dart
// Cache avec expiration (6h)
Future<void> cachePermissions(int userId, int moduleId, List<Permission> permissions)

// Récupération avec validation d'expiration
Future<List<Permission>?> getCachedPermissions(int userId, int moduleId)

// Nettoyage automatique du cache expiré
Future<void> clearExpiredCache()

// Statistiques de performance
Future<Map<String, dynamic>> getCacheStats()
```

### Use Cases Optimisés

#### GetCachedPermissionsUseCase
```dart
// Récupération avec cache automatique
Future<List<Permission>> build(int moduleId, {bool forceRefresh = false})

// Rafraîchissement depuis l'API
Future<void> refreshPermissions(String baseUrl, String moduleCode)
```

#### CheckCachedPermissionUseCase
```dart
// Vérification avec cache
Future<bool> build(
  int moduleId,
  String objectCode, 
  String actionCode, 
  {bool useCache = true}
)
```

## Interface de Démonstration

### PermissionSyncDemo
Page complète de test et configuration :
- **Configuration API** : URL, token, module code
- **Actions de sync** : Modules globaux, module spécifique
- **Gestion du cache** : Vidage, statistiques
- **Visualisation** : Permissions actuelles, erreurs, succès

## Utilisation Pratique

### 1. Configuration Initiale
```dart
// Au login de l'utilisateur
final syncService = ref.read(permissionSyncServiceProvider);
await syncService.syncUserPermissions(
  'https://your-geonature.com',
  authToken,
);
```

### 2. Synchronisation par Module
```dart
// Lors de l'accès à un module spécifique
await syncService.syncModuleSpecificPermissions(baseUrl, 'generic');
```

### 3. Vérification de Permission (avec Cache)
```dart
final hasPermission = ref.watch(
  checkCachedPermissionUseCaseProvider(
    moduleId,
    PermissionConstants.monitoringSites,
    PermissionConstants.actionRead,
  )
);
```

### 4. Widget Conditionnel
```dart
// Affichage conditionnel avec cache automatique
MyWidget().withPermission(
  idModule: moduleId,
  objectCode: PermissionConstants.monitoringSites,
  actionCode: PermissionConstants.actionCreate,
  fallback: Text('Pas autorisé'),
)
```

### 5. Permissions d'Objet Spécifique
```dart
final cruved = await syncService.getObjectPermissions(
  baseUrl,
  'generic',
  'sites',
  123, // ID du site
);

if (cruved.update) {
  // Autoriser modification
}
```

## Configuration de Production

### Headers d'Authentification
```dart
_dio.options.headers = {
  'Authorization': 'Bearer $authToken',
  'Content-Type': 'application/json',
};
```

### Gestion des Erreurs
```dart
try {
  await syncService.syncUserPermissions(baseUrl, token);
} on PermissionSyncException catch (e) {
  switch (e.statusCode) {
    case 401:
      // Token expiré, relancer l'auth
      break;
    case 403:
      // Pas autorisé
      break;
    case 404:
      // Module non trouvé
      break;
    default:
      // Erreur générale
  }
}
```

### Cache de Performance
- **Expiration** : 6 heures par défaut
- **Clés** : `permissions_cache_{userId}_{moduleId}`
- **Taille** : Optimisée avec compression JSON
- **Nettoyage** : Automatique au démarrage

## Monitoring et Debug

### Statistiques du Cache
```dart
final stats = await cacheService.getCacheStats();
print('Cache: ${stats['validEntries']} valides, ${stats['expiredEntries']} expirées');
```

### Logs de Synchronisation
```dart
// Activés en mode debug
print('Sync module $moduleCode: ${permissions.length} permissions');
```

## Évolutions Futures

### Possibles Améliorations
1. **Cache SQLite** pour de meilleures performances
2. **Delta sync** pour réduire la bande passante
3. **Background sync** avec WorkManager
4. **Compression** des permissions en cache
5. **Metrics** de performance et usage

### Extensibilité
- Ajout de nouveaux types d'objets via `PermissionConstants`
- Nouveaux endpoints via `PermissionSyncService`
- Cache personnalisé via interface `PermissionCacheService`
- Widgets custom via `PermissionWrapper`

## Tests Recommandés

### Tests Unitaires
```bash
# Service de synchronisation
flutter test test/data/service/permission_sync_service_test.dart

# Cache
flutter test test/data/service/permission_cache_service_test.dart

# Use cases
flutter test test/domain/usecase/permission_usecase_test.dart
```

### Tests d'Intégration
```bash
# API réelle (avec mocks)
flutter test test/integration/permission_sync_integration_test.dart

# Cache persistence
flutter test test/integration/permission_cache_integration_test.dart
```

### Tests Widget
```bash
# Composants UI
flutter test test/presentation/widgets/permission_wrapper_test.dart

# Pages de demo
flutter test test/presentation/view/permission_sync_demo_test.dart
```

Le système est maintenant prêt pour la production avec une intégration complète de l'API GeoNature existante ! 🚀