import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/domain/model/user_permissions.dart';
import 'package:go_router/go_router.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/base_visit.dart';
import 'package:gn_mobile_monitoring/domain/model/cruved_response.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_user_permissions_usecase.dart';

/// Exemples simples d'utilisation des permissions dans l'interface
class SimplePermissionsExamples extends ConsumerWidget {
  const SimplePermissionsExamples({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exemples Permissions'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle('1. Permissions sur les objets'),
          _buildObjectPermissionsExample(),
          const SizedBox(height: 24),
          
          _buildSectionTitle('2. Permissions globales utilisateur'),
          _buildUserPermissionsExample(ref),
          const SizedBox(height: 24),
          
          _buildSectionTitle('3. Boutons conditionnels'),
          _buildConditionalButtonsExample(),
          const SizedBox(height: 24),
          
          _buildSectionTitle('4. Liste avec actions'),
          _buildListWithActionsExample(context),
        ],
      ),
    );
  }
  
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  
  /// Exemple 1: Utiliser les permissions directement sur l'objet
  Widget _buildObjectPermissionsExample() {
    final site = BaseSite(
      idBaseSite: 1,
      baseSiteName: 'Site exemple',
      cruved: const CruvedResponse(
        create: false,
        read: true,
        update: true,
        delete: false,
        validate: false,
        export: true,
      ),
    );
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Site: ${site.baseSiteName}'),
            const SizedBox(height: 8),
            
            // Utilisation directe des méthodes
            Text('Peut lire: ${site.canRead()}'),
            Text('Peut modifier: ${site.canUpdate()}'),
            Text('Peut supprimer: ${site.canDelete()}'),
            Text('Peut exporter: ${site.canExport()}'),
            const SizedBox(height: 16),
            
            // Boutons conditionnels
            Row(
              children: [
                if (site.canUpdate())
                  ElevatedButton.icon(
                    onPressed: () => _showMessage('Modification du site'),
                    icon: const Icon(Icons.edit),
                    label: const Text('Modifier'),
                  ),
                
                const SizedBox(width: 8),
                
                // Bouton désactivé avec tooltip
                Tooltip(
                  message: site.canDelete() 
                    ? 'Supprimer le site' 
                    : 'Vous ne pouvez pas supprimer ce site',
                  child: ElevatedButton.icon(
                    onPressed: site.canDelete() 
                      ? () => _showMessage('Suppression du site')
                      : null,
                    icon: const Icon(Icons.delete),
                    label: const Text('Supprimer'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: site.canDelete() ? Colors.red : null,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  /// Exemple 2: Utiliser les permissions globales de l'utilisateur
  Widget _buildUserPermissionsExample(WidgetRef ref) {
    final userPermissionsAsync = ref.watch(getUserPermissionsUseCaseProvider);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: userPermissionsAsync.when(
          data: (permissions) {
            if (permissions == null) {
              return const Text('Aucune permission disponible');
            }
            
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Permissions globales:'),
                const SizedBox(height: 8),
                
                // Vérifier si peut créer des sites
                Row(
                  children: [
                    Icon(
                      permissions.canCreate('site') ? Icons.check : Icons.close,
                      color: permissions.canCreate('site') ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    const Text('Créer des sites'),
                  ],
                ),
                
                // Vérifier si peut créer des visites
                Row(
                  children: [
                    Icon(
                      permissions.canCreate('visit') ? Icons.check : Icons.close,
                      color: permissions.canCreate('visit') ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    const Text('Créer des visites'),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Bouton de création conditionnel
                if (permissions.canCreate('site'))
                  ElevatedButton.icon(
                    onPressed: () => _showMessage('Création d\'un nouveau site'),
                    icon: const Icon(Icons.add),
                    label: const Text('Nouveau site'),
                  ),
              ],
            );
          },
          loading: () => const CircularProgressIndicator(),
          error: (error, _) => Text('Erreur: $error'),
        ),
      ),
    );
  }
  
  /// Exemple 3: Boutons avec états conditionnels
  Widget _buildConditionalButtonsExample() {
    final visit = BaseVisit(
      idBaseVisit: 1,
      idBaseSite: 1,
      idDataset: 1,
      idModule: 1,
      visitDateMin: '2024-01-15',
      cruved: const CruvedResponse(
        read: true,
        update: true,
        delete: false,
        validate: true,
        export: true,
      ),
    );
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Visite du ${visit.visitDateMin}'),
            const SizedBox(height: 16),
            
            // Boutons avec icônes et couleurs conditionnelles
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                // Bouton Modifier
                _buildActionButton(
                  icon: Icons.edit,
                  label: 'Modifier',
                  enabled: visit.canUpdate(),
                  color: Colors.orange,
                  onPressed: () => _showMessage('Modification de la visite'),
                ),
                
                // Bouton Valider
                _buildActionButton(
                  icon: Icons.check_circle,
                  label: 'Valider',
                  enabled: visit.canValidate(),
                  color: Colors.green,
                  onPressed: () => _showMessage('Validation de la visite'),
                ),
                
                // Bouton Supprimer (désactivé)
                _buildActionButton(
                  icon: Icons.delete,
                  label: 'Supprimer',
                  enabled: visit.canDelete(),
                  color: Colors.red,
                  onPressed: () => _showMessage('Suppression de la visite'),
                  disabledTooltip: 'Vous ne pouvez pas supprimer cette visite',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  /// Exemple 4: Liste avec actions par ligne
  Widget _buildListWithActionsExample(BuildContext context) {
    final sites = [
      BaseSite(
        idBaseSite: 1,
        baseSiteName: 'Site A - Tous droits',
        cruved: const CruvedResponse(
          read: true,
          update: true,
          delete: true,
          export: true,
        ),
      ),
      BaseSite(
        idBaseSite: 2,
        baseSiteName: 'Site B - Lecture seule',
        cruved: const CruvedResponse(
          read: true,
          update: false,
          delete: false,
          export: true,
        ),
      ),
      BaseSite(
        idBaseSite: 3,
        baseSiteName: 'Site C - Modification seulement',
        cruved: const CruvedResponse(
          read: true,
          update: true,
          delete: false,
          export: false,
        ),
      ),
    ];
    
    return Card(
      child: Column(
        children: sites.map((site) => ListTile(
          title: Text(site.baseSiteName ?? 'Sans nom'),
          subtitle: Text('Permissions: ${site.getPermissionsSummary()}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icône Voir
              IconButton(
                icon: Icon(
                  Icons.visibility,
                  color: site.canRead() ? Colors.blue : Colors.grey,
                ),
                onPressed: site.canRead() 
                  ? () => context.push('/sites/${site.idBaseSite}')
                  : null,
                tooltip: site.canRead() 
                  ? 'Voir le site' 
                  : 'Vous ne pouvez pas voir ce site',
              ),
              
              // Icône Modifier
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: site.canUpdate() ? Colors.orange : Colors.grey,
                ),
                onPressed: site.canUpdate() 
                  ? () => context.push('/sites/${site.idBaseSite}/edit')
                  : null,
                tooltip: site.canUpdate() 
                  ? 'Modifier le site' 
                  : 'Vous ne pouvez pas modifier ce site',
              ),
              
              // Icône Supprimer
              IconButton(
                icon: Icon(
                  Icons.delete,
                  color: site.canDelete() ? Colors.red : Colors.grey,
                ),
                onPressed: site.canDelete() 
                  ? () => _confirmDelete(context, site)
                  : null,
                tooltip: site.canDelete() 
                  ? 'Supprimer le site' 
                  : 'Vous ne pouvez pas supprimer ce site',
              ),
            ],
          ),
        )).toList(),
      ),
    );
  }
  
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required bool enabled,
    required Color color,
    required VoidCallback onPressed,
    String? disabledTooltip,
  }) {
    final button = ElevatedButton.icon(
      onPressed: enabled ? onPressed : null,
      icon: Icon(icon),
      label: Text(label),
      style: enabled 
        ? ElevatedButton.styleFrom(backgroundColor: color)
        : null,
    );
    
    if (!enabled && disabledTooltip != null) {
      return Tooltip(
        message: disabledTooltip,
        child: button,
      );
    }
    
    return button;
  }
  
  void _showMessage(String message) {
    debugPrint(message);
  }
  
  void _confirmDelete(BuildContext context, BaseSite site) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text('Voulez-vous vraiment supprimer "${site.baseSiteName}" ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
    
    if (confirm == true) {
      _showMessage('Site "${site.baseSiteName}" supprimé');
    }
  }
}