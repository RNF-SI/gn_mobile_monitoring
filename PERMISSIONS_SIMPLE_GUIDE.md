# Guide Simple - Permissions dans l'interface

## Concept de base

Chaque objet (site, groupe de sites, visite, observation) contient ses propres permissions CRUVED :
- **C**reate : Peut créer
- **R**ead : Peut lire
- **U**pdate : Peut modifier  
- **V**alidate : Peut valider
- **E**xport : Peut exporter
- **D**elete : Peut supprimer

## Utilisation directe

### 1. Vérifier les permissions d'un objet

```dart
// Sur un site, une visite, etc.
if (site.canUpdate()) {
  // Afficher le bouton modifier
}

if (visit.canDelete()) {
  // Afficher le bouton supprimer
}
```

### 2. Boutons conditionnels

```dart
// Bouton visible seulement si permission
if (site.canUpdate())
  ElevatedButton(
    onPressed: () => _editSite(),
    child: Text('Modifier'),
  ),

// Bouton désactivé avec tooltip
Tooltip(
  message: site.canDelete() 
    ? 'Supprimer le site' 
    : 'Vous ne pouvez pas supprimer ce site',
  child: ElevatedButton(
    onPressed: site.canDelete() ? () => _deleteSite() : null,
    child: Text('Supprimer'),
  ),
),
```

### 3. Icônes conditionnelles dans une liste

```dart
ListTile(
  title: Text(site.baseSiteName),
  trailing: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      IconButton(
        icon: Icon(
          Icons.edit,
          color: site.canUpdate() ? Colors.orange : Colors.grey,
        ),
        onPressed: site.canUpdate() ? () => _editSite() : null,
        tooltip: site.canUpdate() 
          ? 'Modifier' 
          : 'Modification non autorisée',
      ),
      IconButton(
        icon: Icon(
          Icons.delete,
          color: site.canDelete() ? Colors.red : Colors.grey,
        ),
        onPressed: site.canDelete() ? () => _deleteSite() : null,
        tooltip: site.canDelete() 
          ? 'Supprimer' 
          : 'Suppression non autorisée',
      ),
    ],
  ),
)
```

### 4. Menu contextuel adaptatif

```dart
PopupMenuButton(
  itemBuilder: (context) => [
    if (visit.canUpdate())
      PopupMenuItem(
        value: 'edit',
        child: ListTile(
          leading: Icon(Icons.edit),
          title: Text('Modifier'),
        ),
      ),
    if (visit.canValidate())
      PopupMenuItem(
        value: 'validate',
        child: ListTile(
          leading: Icon(Icons.check_circle),
          title: Text('Valider'),
        ),
      ),
    if (visit.canDelete())
      PopupMenuItem(
        value: 'delete',
        child: ListTile(
          leading: Icon(Icons.delete, color: Colors.red),
          title: Text('Supprimer'),
        ),
      ),
  ],
  onSelected: (value) => _handleAction(value),
)
```

### 5. Permissions globales utilisateur

Pour créer de nouveaux objets, utilisez les permissions globales :

```dart
class MyPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userPermissionsAsync = ref.watch(getUserPermissionsUseCaseProvider);
    
    return userPermissionsAsync.when(
      data: (permissions) {
        if (permissions?.canCreate('site') ?? false) {
          return FloatingActionButton(
            onPressed: () => _createSite(),
            child: Icon(Icons.add),
          );
        }
        return SizedBox.shrink();
      },
      loading: () => CircularProgressIndicator(),
      error: (_, __) => SizedBox.shrink(),
    );
  }
}
```

## Exemples pratiques

### Page de liste avec actions

```dart
ListView.builder(
  itemCount: sites.length,
  itemBuilder: (context, index) {
    final site = sites[index];
    
    return Card(
      child: ListTile(
        title: Text(site.baseSiteName),
        subtitle: Text('Permissions: ${site.getPermissionsSummary()}'),
        onTap: site.canRead() ? () => _viewSite(site) : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (site.canUpdate())
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => _editSite(site),
              ),
            if (site.canDelete())
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deleteSite(site),
              ),
          ],
        ),
      ),
    );
  },
)
```

### Page de détail avec barre d'actions

```dart
Scaffold(
  appBar: AppBar(
    title: Text('Visite'),
    actions: [
      if (visit.canExport())
        IconButton(
          icon: Icon(Icons.download),
          onPressed: () => _exportVisit(),
        ),
    ],
  ),
  body: // Contenu...
  bottomNavigationBar: Container(
    padding: EdgeInsets.all(16),
    child: Row(
      children: [
        if (visit.canUpdate())
          Expanded(
            child: ElevatedButton(
              onPressed: () => _editVisit(),
              child: Text('Modifier'),
            ),
          ),
        if (visit.canUpdate() && visit.canValidate())
          SizedBox(width: 16),
        if (visit.canValidate())
          Expanded(
            child: ElevatedButton(
              onPressed: () => _validateVisit(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: Text('Valider'),
            ),
          ),
      ],
    ),
  ),
)
```

## Méthode helper

Pour afficher un résumé des permissions :

```dart
Text('Permissions: ${site.getPermissionsSummary()}')
// Affiche: "CRUD" ou "RU" etc.
```

## Points importants

1. **Toujours vérifier** : Utilisez `site.canUpdate()` avant d'afficher un bouton
2. **Feedback visuel** : Griser les icônes désactivées
3. **Tooltips** : Expliquer pourquoi une action est désactivée
4. **Cohérence** : Utiliser les mêmes patterns dans toute l'app

## Exemple complet

Voir les fichiers suivants pour des exemples concrets et fonctionnels :
- `lib/presentation/view/example_simple_permissions.dart` - Exemples généraux
- `lib/presentation/view/example_permissions_site_groups.dart` - Exemple spécifique pour les groupes de sites

## Import des permissions lors de la synchronisation

Les permissions CRUVED sont importées automatiquement lors de la synchronisation des modules :
- Les sites récupèrent leurs permissions via l'endpoint `/monitorings/object/$moduleCode/module`
- Les groupes de sites utilisent le même endpoint avec extraction du champ `cruved`
- Les visites doivent suivre le même pattern (à implémenter)

Chaque objet stocke ses propres permissions qui peuvent être différentes selon l'utilisateur et l'objet.