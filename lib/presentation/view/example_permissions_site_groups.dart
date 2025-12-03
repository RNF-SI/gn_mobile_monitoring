import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';
import 'package:gn_mobile_monitoring/domain/model/cruved_response.dart';
import 'package:go_router/go_router.dart';

/// Exemple d'utilisation des permissions CRUVED pour les groupes de sites
class SiteGroupsWithPermissionsExample extends ConsumerWidget {
  const SiteGroupsWithPermissionsExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Exemple de groupes de sites avec différentes permissions
    final siteGroups = [
      SiteGroup(
        idSitesGroup: 1,
        sitesGroupName: 'Zone Humide Nord',
        sitesGroupCode: 'ZH_NORD',
        cruved: const CruvedResponse(
          create: true,
          read: true,
          update: true,
          delete: true,
          validate: true,
          export: true,
        ),
      ),
      SiteGroup(
        idSitesGroup: 2,
        sitesGroupName: 'Forêt de Chênes',
        sitesGroupCode: 'FOR_CHENE',
        cruved: const CruvedResponse(
          create: false,
          read: true,
          update: true,
          delete: false,
          validate: false,
          export: true,
        ),
      ),
      SiteGroup(
        idSitesGroup: 3,
        sitesGroupName: 'Prairie Alpine',
        sitesGroupCode: 'PR_ALPINE',
        cruved: const CruvedResponse(
          create: false,
          read: true,
          update: false,
          delete: false,
          validate: false,
          export: false,
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Groupes de Sites'),
        actions: [
          // Bouton global pour créer un nouveau groupe
          // (nécessite les permissions globales de l'utilisateur)
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreateGroupDialog(context),
            tooltip: 'Créer un nouveau groupe',
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: siteGroups.length,
        itemBuilder: (context, index) {
          final group = siteGroups[index];
          return _buildSiteGroupCard(context, group);
        },
      ),
    );
  }

  Widget _buildSiteGroupCard(BuildContext context, SiteGroup group) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        title: Text(
          group.sitesGroupName ?? 'Sans nom',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Code: ${group.sitesGroupCode ?? '-'}'),
            const SizedBox(height: 4),
            _buildPermissionChips(group),
          ],
        ),
        trailing: _buildActionMenu(context, group),
        onTap: group.canRead()
            ? () => context.push('/site-groups/${group.idSitesGroup}')
            : null,
      ),
    );
  }

  Widget _buildPermissionChips(SiteGroup group) {
    return Wrap(
      spacing: 4,
      children: [
        if (group.canCreate())
          Chip(
            label: const Text('C'),
            backgroundColor: Colors.green[100],
            padding: EdgeInsets.zero,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        if (group.canRead())
          Chip(
            label: const Text('R'),
            backgroundColor: Colors.blue[100],
            padding: EdgeInsets.zero,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        if (group.canUpdate())
          Chip(
            label: const Text('U'),
            backgroundColor: Colors.orange[100],
            padding: EdgeInsets.zero,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        if (group.canDelete())
          Chip(
            label: const Text('D'),
            backgroundColor: Colors.red[100],
            padding: EdgeInsets.zero,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        if (group.canValidate())
          Chip(
            label: const Text('V'),
            backgroundColor: Colors.purple[100],
            padding: EdgeInsets.zero,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        if (group.canExport())
          Chip(
            label: const Text('E'),
            backgroundColor: Colors.teal[100],
            padding: EdgeInsets.zero,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
      ],
    );
  }

  Widget _buildActionMenu(BuildContext context, SiteGroup group) {
    // Si aucune action n'est disponible, ne pas afficher le menu
    if (!group.canUpdate() && !group.canDelete() && !group.canExport()) {
      return const SizedBox.shrink();
    }

    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      onSelected: (value) => _handleAction(context, value, group),
      itemBuilder: (context) => [
        if (group.canUpdate())
          const PopupMenuItem(
            value: 'edit',
            child: ListTile(
              leading: Icon(Icons.edit, color: Colors.orange),
              title: Text('Modifier'),
              contentPadding: EdgeInsets.zero,
            ),
          ),
        if (group.canExport())
          const PopupMenuItem(
            value: 'export',
            child: ListTile(
              leading: Icon(Icons.download, color: Colors.teal),
              title: Text('Exporter'),
              contentPadding: EdgeInsets.zero,
            ),
          ),
        if (group.canDelete())
          const PopupMenuItem(
            value: 'delete',
            child: ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text('Supprimer'),
              contentPadding: EdgeInsets.zero,
            ),
          ),
      ],
    );
  }

  void _handleAction(BuildContext context, String action, SiteGroup group) {
    switch (action) {
      case 'edit':
        context.push('/site-groups/${group.idSitesGroup}/edit');
        break;
      case 'export':
        _exportGroup(context, group);
        break;
      case 'delete':
        _confirmDeleteGroup(context, group);
        break;
    }
  }

  void _showCreateGroupDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nouveau groupe de sites'),
        content: const Text(
          'Cette action nécessite les permissions de création globales.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.push('/site-groups/new');
            },
            child: const Text('Créer'),
          ),
        ],
      ),
    );
  }

  void _exportGroup(BuildContext context, SiteGroup group) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Export du groupe "${group.sitesGroupName}"...'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _confirmDeleteGroup(BuildContext context, SiteGroup group) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text(
          'Voulez-vous vraiment supprimer le groupe "${group.sitesGroupName}" ?\n\n'
          'Cette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteGroup(context, group);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  void _deleteGroup(BuildContext context, SiteGroup group) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Groupe "${group.sitesGroupName}" supprimé'),
        backgroundColor: Colors.red,
      ),
    );
  }
}