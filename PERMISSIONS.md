# Système de Permissions CRUVED - Application Mobile

Ce document explique le système de permissions CRUVED adapté pour l'application mobile de GeoNature Monitoring.

## Architecture Simplifiée

Contrairement à l'application web qui gère plusieurs utilisateurs simultanément, l'application mobile est conçue pour **un seul utilisateur connecté**. Cela permet de simplifier considérablement la gestion des permissions.

### Principes clés

1. **Utilisateur unique** : Une seule session utilisateur active
2. **Permissions statiques** : Les permissions sont récupérées au login et restent valides pour toute la session
3. **Permissions embarquées** : Chaque objet (site, visite, observation) contient ses propres permissions CRUVED
4. **Pattern monitoring web** : Reprend les mêmes concepts que l'application web mais simplifiés

## Types de Permissions

### Permissions globales utilisateur (`UserPermissions`)

Stockées pour l'utilisateur connecté, organisées par type d'objet :
- `MONITORINGS_MODULES` : Permissions sur les modules
- `MONITORINGS_SITES` : Permissions sur les sites 
- `MONITORINGS_GRP_SITES` : Permissions sur les groupes de sites
- `MONITORINGS_VISITES` : Permissions sur les visites
- `MONITORINGS_INDIVIDUALS` : Permissions sur les individus
- `MONITORINGS_MARKINGS` : Permissions sur les marquages

### Permissions d'objet (`CruvedResponse`)

Chaque objet métier embarque ses permissions spécifiques :
- **C**reate : Peut créer des objets enfants
- **R**ead : Peut lire l'objet
- **U**pdate : Peut modifier l'objet
- **V**alidate : Peut valider l'objet
- **E**xport : Peut exporter l'objet
- **D**elete : Peut supprimer l'objet

## Utilisation dans le code

### 1. Use Cases pour les permissions utilisateur

```dart
// Récupérer les permissions de l'utilisateur connecté
final userPermissions = await ref.read(getUserPermissionsUseCaseProvider.future);

// Synchroniser les permissions au login
await ref.read(syncUserPermissionsUseCaseProvider.notifier).syncPermissions(
  baseUrl: apiUrl,
  authToken: token,
  idRole: userId,
  username: username,
);
```

### 2. Vérifications directes sur les objets

```dart
final site = BaseSite(
  idBaseSite: 1,
  baseSiteName: 'Mon Site',
  cruved: CruvedResponse(read: true, update: true, delete: false),
);

// Vérifications directes (comme dans le monitoring web)
if (site.canRead()) {
  // Afficher le site
}

if (site.canUpdate()) {
  // Permettre la modification
}
```

### 3. Widgets de permissions

#### PermissionWidget
Affiche ou cache un widget selon les permissions :

```dart
PermissionWidget(
  objectType: 'site',
  action: 'create',
  child: FloatingActionButton(
    onPressed: () => _createSite(),
    child: Icon(Icons.add),
  ),
  fallback: SizedBox.shrink(), // Ne rien afficher si pas de permission
)
```

#### PermissionButton
Bouton qui se désactive automatiquement :

```dart
PermissionButton(
  objectType: 'site',
  action: 'update',
  objectPermissions: site.cruved, // Permissions spécifiques à cet objet
  onPressed: () => _editSite(),
  disabledTooltip: 'Vous ne pouvez pas modifier ce site',
  child: Text('Modifier'),
)
```

#### PermissionIcon
Icône qui change d'apparence selon les permissions :

```dart
PermissionIcon(
  objectType: 'site',
  action: 'delete',
  icon: Icons.delete,
  objectPermissions: site.cruved,
  onTap: () => _deleteSite(),
  tooltip: 'Supprimer',
  disabledTooltip: 'Suppression interdite',
  color: Colors.red,
)
```

### 4. Permissions globales vs permissions d'objet

```dart
// Utilisation des permissions globales (pour les actions générales)
PermissionWidget(
  objectType: 'site',
  action: 'create',
  child: CreateButton(),
)

// Utilisation des permissions d'objet (pour les actions sur un objet spécifique)
PermissionWidget(
  objectType: 'site',
  action: 'update',
  objectPermissions: site.cruved, // Important : permissions de l'objet
  child: EditButton(),
)
```

## Workflow de synchronisation

### 1. Au login
```dart
// 1. Authentification
final loginResponse = await authService.login(username, password);

// 2. Synchronisation des permissions
final userPermissions = await permissionSyncUseCase.syncPermissions(
  baseUrl: apiUrl,
  authToken: loginResponse.token,
  idRole: loginResponse.idRole,
  username: username,
);

// 3. Stockage local pour utilisation hors ligne (optionnel)
await permissionRepository.saveUserPermissions(userPermissions);
```

### 2. Utilisation dans l'app
Les permissions sont automatiquement récupérées par les widgets via Riverpod.

### 3. Rafraîchissement
```dart
// Forcer le rechargement des permissions
ref.read(getUserPermissionsUseCaseProvider.notifier).refresh();
```

## Correspondance avec le monitoring web

| Monitoring Web | Application Mobile |
|---|---|
| `canCreateChild` | `userPermissions.canCreate('site')` |
| `row.cruved['U']` | `site.canUpdate()` |
| `currentUser?.moduleCruved[type]['C']` | `userPermissions.canCreate(type)` |
| Service `PermissionService` | Use cases `GetUserPermissions` + `SyncUserPermissions` |
| Permissions multi-utilisateurs | Permissions utilisateur unique |

## Patterns d'utilisation recommandés

### 1. Listes d'objets
```dart
// Filtrage automatique côté serveur (les objets non lisibles ne sont pas retournés)
// Boutons d'action conditionnels pour chaque objet
ListView.builder(
  itemBuilder: (context, index) {
    final site = sites[index];
    return ListTile(
      title: Text(site.baseSiteName),
      trailing: Row(
        children: [
          PermissionIcon(
            objectType: 'site',
            action: 'update',
            icon: Icons.edit,
            objectPermissions: site.cruved,
            onTap: () => _editSite(site),
          ),
          PermissionIcon(
            objectType: 'site', 
            action: 'delete',
            icon: Icons.delete,
            objectPermissions: site.cruved,
            onTap: () => _deleteSite(site),
          ),
        ],
      ),
    );
  },
)
```

### 2. Pages de détail
```dart
// Vérifications conditionnelles pour les actions
class SiteDetailPage extends ConsumerWidget {
  final BaseSite site;
  
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PermissionWidget(
            objectType: 'site',
            action: 'export',
            objectPermissions: site.cruved,
            child: IconButton(
              icon: Icon(Icons.download),
              onPressed: () => _export(),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Contenu du site
          Text(site.baseSiteName),
          
          // Actions conditionnelles
          PermissionWidget(
            objectType: 'visit',
            action: 'create', 
            child: ElevatedButton(
              onPressed: () => _createVisit(),
              child: Text('Nouvelle visite'),
            ),
          ),
        ],
      ),
    );
  }
}
```

## Debugging et développement

### Affichage des permissions
```dart
// Pour débugger les permissions d'un objet
print('Site permissions: ${site.getPermissionsSummary()}'); // Affiche "CRUD" ou "R" etc.

// Pour voir toutes les permissions utilisateur
final userPerms = await ref.read(getUserPermissionsUseCaseProvider.future);
print('User permissions: ${userPerms?.getAllPermissions()}');
```

### Tests
Les widgets de permissions peuvent être testés en mockant les providers Riverpod avec des permissions spécifiques.

Ce système suit fidèlement les patterns du monitoring web tout en étant adapté aux spécificités de l'application mobile mono-utilisateur.