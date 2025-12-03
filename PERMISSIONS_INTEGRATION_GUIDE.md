# Guide d'intégration des permissions dans l'interface

Ce guide montre comment utiliser concrètement les permissions CRUVED pour contrôler l'affichage des boutons et actions dans vos pages.

## Principes de base

### 1. Permissions globales vs permissions d'objet

- **Permissions globales** : Pour créer de nouveaux objets (basées sur les permissions utilisateur)
- **Permissions d'objet** : Pour les actions sur des objets existants (basées sur `object.cruved`)

### 2. Widgets disponibles

#### PermissionWidget
Cache ou affiche un widget selon les permissions :
```dart
PermissionWidget(
  objectType: 'site',
  action: 'create',
  child: FloatingActionButton(...),
  fallback: SizedBox.shrink(), // Optionnel
)
```

#### PermissionButton
Bouton qui se désactive automatiquement :
```dart
PermissionButton(
  objectType: 'visit',
  action: 'update',
  objectPermissions: visit.cruved, // Pour un objet spécifique
  onPressed: () => _editVisit(),
  child: Text('Modifier'),
)
```

#### PermissionIcon
Icône conditionnelle avec tooltip :
```dart
PermissionIcon(
  objectType: 'site',
  action: 'delete',
  objectPermissions: site.cruved,
  icon: Icons.delete,
  color: Colors.red,
  onTap: () => _deleteSite(),
  tooltip: 'Supprimer',
  disabledTooltip: 'Suppression interdite',
)
```

## Intégration dans vos pages existantes

### Page de liste (ex: Liste des sites)

```dart
class SiteListPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sites = ref.watch(sitesProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Sites'),
      ),
      
      body: ListView.builder(
        itemCount: sites.length,
        itemBuilder: (context, index) {
          final site = sites[index];
          
          return ListTile(
            title: Text(site.baseSiteName),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icônes conditionnelles basées sur site.cruved
                PermissionIcon(
                  objectType: 'site',
                  action: 'update',
                  objectPermissions: site.cruved,
                  icon: Icons.edit,
                  onTap: () => _editSite(site),
                ),
                SizedBox(width: 8),
                PermissionIcon(
                  objectType: 'site',
                  action: 'delete',
                  objectPermissions: site.cruved,
                  icon: Icons.delete,
                  color: Colors.red,
                  onTap: () => _deleteSite(site),
                ),
              ],
            ),
          );
        },
      ),
      
      // Bouton de création basé sur permissions globales
      floatingActionButton: PermissionWidget(
        objectType: 'site',
        action: 'create',
        child: FloatingActionButton(
          onPressed: () => _createSite(),
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
```

### Page de détail (ex: Détail d'une visite)

```dart
class VisitDetailPage extends ConsumerWidget {
  final BaseVisit visit;
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Visite'),
        actions: [
          // Menu contextuel avec options conditionnelles
          PopupMenuButton(
            itemBuilder: (context) => [
              if (visit.canUpdate())
                PopupMenuItem(
                  value: 'edit',
                  child: Text('Modifier'),
                ),
              if (visit.canDelete())
                PopupMenuItem(
                  value: 'delete',
                  child: Text('Supprimer'),
                ),
              if (visit.canExport())
                PopupMenuItem(
                  value: 'export',
                  child: Text('Exporter'),
                ),
            ].whereType<PopupMenuItem>().toList(),
            onSelected: (value) => _handleAction(value),
          ),
        ],
      ),
      
      body: Column(
        children: [
          // Contenu de la visite...
          
          // Bouton d'action principal conditionnel
          if (visit.canUpdate())
            Padding(
              padding: EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () => _editVisit(),
                child: Text('Modifier cette visite'),
              ),
            ),
        ],
      ),
    );
  }
}
```

### Formulaires (ex: Création/Modification)

```dart
class SiteFormPage extends ConsumerWidget {
  final BaseSite? site; // null pour création, existant pour modification
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditMode = site != null;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Modifier le site' : 'Nouveau site'),
        actions: [
          // Bouton de suppression visible seulement en mode édition ET si permission
          if (isEditMode)
            PermissionIcon(
              objectType: 'site',
              action: 'delete',
              objectPermissions: site!.cruved,
              icon: Icons.delete,
              color: Colors.red,
              onTap: () => _deleteSite(),
            ),
        ],
      ),
      
      body: Form(
        // Formulaire...
      ),
      
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            // Bouton Enregistrer conditionnel
            Expanded(
              child: PermissionButton(
                objectType: 'site',
                action: isEditMode ? 'update' : 'create',
                objectPermissions: isEditMode ? site!.cruved : null,
                onPressed: () => _saveSite(),
                child: Text('Enregistrer'),
              ),
            ),
            
            // Bouton Valider (si applicable)
            if (isEditMode && site!.canValidate()) ...[
              SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _validateSite(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: Text('Valider'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
```

## Patterns courants

### 1. Masquer complètement une fonctionnalité
```dart
PermissionWidget(
  objectType: 'site',
  action: 'create',
  child: FloatingActionButton(...),
  fallback: SizedBox.shrink(), // Rien affiché si pas de permission
)
```

### 2. Désactiver avec explication
```dart
PermissionButton(
  objectType: 'visit',
  action: 'delete',
  objectPermissions: visit.cruved,
  onPressed: () => _delete(),
  disabledTooltip: 'Vous ne pouvez pas supprimer cette visite',
  child: Text('Supprimer'),
)
```

### 3. Adaptation du menu contextuel
```dart
PopupMenuButton(
  itemBuilder: (context) {
    final items = <PopupMenuItem>[];
    
    if (site.canUpdate()) {
      items.add(PopupMenuItem(
        value: 'edit',
        child: ListTile(
          leading: Icon(Icons.edit),
          title: Text('Modifier'),
        ),
      ));
    }
    
    if (site.canDelete()) {
      items.add(PopupMenuItem(
        value: 'delete',
        child: ListTile(
          leading: Icon(Icons.delete, color: Colors.red),
          title: Text('Supprimer'),
        ),
      ));
    }
    
    // Si aucune action disponible, afficher un message
    if (items.isEmpty) {
      items.add(PopupMenuItem(
        enabled: false,
        child: Text('Aucune action disponible'),
      ));
    }
    
    return items;
  },
  onSelected: _handleAction,
)
```

### 4. Message informatif pour les actions interdites
```dart
ListTile(
  title: Text(site.baseSiteName),
  trailing: site.canUpdate() 
    ? IconButton(
        icon: Icon(Icons.edit),
        onPressed: () => _editSite(),
      )
    : Tooltip(
        message: 'Modification non autorisée',
        child: Icon(Icons.edit, color: Colors.grey),
      ),
)
```

## Bonnes pratiques

1. **Cohérence** : Utilisez toujours les mêmes patterns dans toute l'app
2. **Feedback** : Donnez toujours une indication visuelle (grisé, tooltip) pour les actions non autorisées
3. **Progressive disclosure** : Cachez les fonctionnalités complexes si l'utilisateur n'a pas les permissions
4. **Test** : Testez votre UI avec différents profils de permissions

## Types d'objets supportés

- `'module'` ou `'MONITORINGS_MODULES'`
- `'site'` ou `'MONITORINGS_SITES'`
- `'sites_group'` ou `'MONITORINGS_GRP_SITES'`
- `'visit'` ou `'MONITORINGS_VISITES'`
- `'observation'` (utilise les permissions de visite)
- `'observation_detail'` (utilise les permissions de visite)

## Actions supportées

- `'create'` ou `'C'` : Créer
- `'read'` ou `'R'` : Lire
- `'update'` ou `'U'` : Modifier
- `'delete'` ou `'D'` : Supprimer
- `'validate'` ou `'V'` : Valider
- `'export'` ou `'E'` : Exporter