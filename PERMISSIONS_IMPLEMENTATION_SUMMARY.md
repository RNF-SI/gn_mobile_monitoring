# Implémentation des Permissions CRUVED - Résumé

## Vue d'ensemble

L'implémentation des permissions CRUVED a été ajoutée à l'application mobile GeoNature Monitoring selon l'architecture Clean Architecture existante. Le système respecte la structure des permissions du backend GeoNature web.

## Composants Implémentés

### 1. Modèles de Domaine (`lib/domain/model/`)

#### UserRole
- **Fichier**: `user_role.dart`
- **Description**: Modèle représentant un utilisateur avec ses rôles et organismes
- **Champs**: `idRole`, `identifiant`, `nomRole`, `prenomRole`, `idOrganisme`, `active`

#### Permission Models
- **Fichier**: `permission.dart`
- **Modèles**: `Permission`, `PermissionObject`, `PermissionAction`
- **Description**: Modèles pour représenter les permissions, objets et actions CRUVED

#### MonitoringObjectMixin
- **Fichier**: `monitoring_object_mixin.dart`
- **Description**: Mixin pour ajouter facilement les vérifications de permissions aux objets monitoring

### 2. Infrastructure de Base de Données (`lib/data/db/`)

#### Table TUserRoles
- **Fichier**: `tables/t_user_roles.dart`
- **Migration**: `migrations/025_create_user_roles_table.dart`
- **Description**: Table pour stocker les informations des utilisateurs

#### DAOs
- **PermissionDao** (`dao/permission_dao.dart`): Accès aux permissions
- **UserRoleDao** (`dao/user_role_dao.dart`): Gestion des utilisateurs
- **Fonctionnalités**: CRUD, requêtes par scope, filtrage

#### Entités et Mappers
- Entités pour la couche data
- Mappers pour convertir entre entités et modèles domain

### 3. Services (`lib/data/service/`)

#### PermissionService
- **Fichier**: `permission_service.dart`
- **Responsabilités**:
  - Vérification des permissions générales et d'instance
  - Gestion des scopes (aucun, mes données, mon organisme, toutes)
  - Filtrage des objets selon les permissions
  - Gestion de l'utilisateur actuel

#### PermissionSyncService
- **Fichier**: `permission_sync_service.dart`
- **Responsabilités**:
  - Synchronisation avec le serveur GeoNature
  - Récupération des permissions utilisateur
  - Mise à jour des données locales

### 4. Use Cases (`lib/domain/usecase/`)

- **CheckPermissionUseCase**: Vérifier une permission générale
- **CheckObjectPermissionUseCase**: Vérifier une permission sur un objet spécifique
- **FilterByPermissionUseCase**: Filtrer une liste d'objets selon les permissions
- **GetCurrentUserUseCase**: Récupérer l'utilisateur actuel
- **SyncPermissionsUseCase**: Synchroniser les permissions

### 5. Constantes (`lib/core/constants/`)

#### PermissionConstants
- **Fichier**: `permission_constants.dart`
- **Contenu**:
  - Codes d'objets CRUVED (MONITORINGS_SITES, MONITORINGS_VISITES, etc.)
  - Codes d'actions (C, R, U, V, E, D)
  - Valeurs de scopes (0-3)
  - Méthodes utilitaires pour descriptions et validations

### 6. Widgets UI (`lib/presentation/widgets/`)

#### PermissionWrapper
- **Fichier**: `permission_wrapper.dart`
- **Composants**:
  - `PermissionWrapper`: Wrapper conditionnel pour les widgets
  - `PermissionButton`: Bouton qui ne s'affiche que si permission accordée
  - `SitePermissionButtons`: Boutons spécifiques aux sites
  - Extension `withPermission()` pour faciliter l'usage

### 7. Exemple d'Usage (`lib/presentation/view/`)

#### ExamplePermissionUsage
- **Fichier**: `example_permission_usage.dart`
- **Contenu**: Page de démonstration complète montrant:
  - Affichage de l'utilisateur actuel
  - Vérification des permissions générales
  - Boutons conditionnels selon permissions
  - Test de permissions sur objets spécifiques

## Architecture des Permissions

### Scopes CRUVED
```
0 = Aucun accès
1 = Mes données (données créées par l'utilisateur ou qu'il observe)
2 = Mon organisme (données de l'organisme de l'utilisateur)
3 = Toutes les données
```

### Actions Disponibles par Objet
```
MONITORINGS_MODULES: [R, U, E]
MONITORINGS_SITES: [C, R, U, D]
MONITORINGS_GRP_SITES: [C, R, U, D]
MONITORINGS_VISITES: [C, R, U, D]
MONITORINGS_INDIVIDUALS: [C, R, U, D]
MONITORINGS_MARKINGS: [C, R, U, D]
```

### Critères de Propriétaire
- **Sites**: `idDigitiser`, `idInventor` + organisme
- **Visites**: `idDigitiser`, `observers` + héritage du site parent
- **Observations**: `idDigitiser` + héritage de la visite parent

## Intégration avec les Modèles Existants

### BaseSite et BaseVisit
- Ajout des champs de permissions (`idDigitiser`, `idInventor`, `organismeActors`, `observers`)
- Implémentation de `MonitoringObjectMixin`
- Constructeur privé ajouté pour les getters Freezed

## Usage Recommandé

### Vérification Simple
```dart
final hasPermission = await ref.read(
  checkPermissionUseCaseProvider(
    moduleId, 
    PermissionConstants.monitoringSites, 
    PermissionConstants.actionRead
  ).future
);
```

### Widget Conditionnel
```dart
Widget().withPermission(
  idModule: moduleId,
  objectCode: PermissionConstants.monitoringSites,
  actionCode: PermissionConstants.actionRead,
  fallback: Text('Accès non autorisé'),
)
```

### Filtrage de Liste
```dart
final filteredSites = await ref.read(
  filterByPermissionUseCaseProvider(
    sites,
    moduleId,
    PermissionConstants.monitoringSites,
    PermissionConstants.actionRead,
  ).future
);
```

## Synchronisation avec le Backend

Le service de synchronisation récupère:
1. Les informations utilisateur
2. Les permissions accordées
3. Les objets et actions disponibles

Format attendu de l'API:
```json
{
  "user": {
    "idRole": 123,
    "identifiant": "user@example.com",
    "nomRole": "Doe",
    "prenomRole": "John",
    "idOrganisme": 1,
    "active": true
  },
  "permissions": [
    {
      "idPermission": 1,
      "idRole": 123,
      "idAction": 1,
      "idModule": 1,
      "idObject": 1,
      "scopeValue": 2,
      "sensitivityFilter": false
    }
  ]
}
```

## Points d'Extension

1. **Nouvelles Actions**: Ajouter dans `PermissionConstants.objectActions`
2. **Nouveaux Objets**: Ajouter dans les constantes et tables
3. **Nouveaux Critères**: Étendre `MonitoringObject` et `PermissionService`
4. **Cache**: Implémenter un cache pour les permissions fréquentes
5. **Offline**: Gérer les permissions en mode hors ligne

## Tests

La structure permet facilement:
- Mock des DAOs avec `mockito`
- Tests unitaires des use cases
- Tests d'intégration du service de permissions
- Tests widgets pour les composants UI

## Migration

- **Version de schéma**: 25
- **Migration automatique**: Ajout de la table `t_user_roles`
- **Rétrocompatibilité**: Assurée par défauts et champs nullable