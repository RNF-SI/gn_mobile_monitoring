import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/presentation/state/sync_status.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/auth/auth_viewmodel.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/database/database_service.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/sync_service.dart';

class MenuActions extends ConsumerWidget {
  const MenuActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authViewModel = ref.read(authenticationViewModelProvider);
    final syncNotifier = ref.read(syncServiceProvider.notifier);
    final databaseService = ref.read(databaseServiceProvider.notifier);

    // Observer le statut de synchronisation
    final syncStatus = ref.watch(syncServiceProvider);
    final isSyncing = syncStatus.state == SyncState.inProgress;

    return PopupMenuButton<String>(
      icon: const Icon(Icons.menu), // Menu icon
      enabled: !isSyncing, // Désactiver le menu pendant la synchronisation
      onSelected: (value) => _handleMenuSelection(
          value, ref, context, authViewModel, syncNotifier, databaseService),
      itemBuilder: (BuildContext context) => [
        _buildMenuItem(Icons.sync, 'Synchronisation complète', 'sync_complete'),
        _buildMenuItem(
            Icons.delete,
            '[DEV] Suppression et rechargement de la base de données',
            'delete'),
        _buildMenuItem(
            Icons.info_outline, 'Informations sur la version', 'version'),
        _buildMenuItem(Icons.logout, 'Déconnexion', 'logout'),
      ],
    );
  }

  PopupMenuItem<String> _buildMenuItem(
      IconData icon, String text, String value) {
    return PopupMenuItem<String>(
      value: value,
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF1a1a18)),
        title: Text(text),
      ),
    );
  }

  void _handleMenuSelection(
    String value,
    WidgetRef ref,
    BuildContext context,
    authViewModel,
    SyncService syncService,
    DatabaseService databaseService,
  ) async {
    switch (value) {
      case 'sync_complete':
        await _performCompleteSyncBeta(context, syncService, ref);
        break;
      case 'delete':
        await _confirmDelete(context, databaseService);
        break;
      case 'version':
        _showVersionAlert(context);
        break;
      case 'logout':
        await _confirmLogout(context, authViewModel, ref);
        break;
    }
  }

  Future<void> _confirmDelete(
      BuildContext context, DatabaseService databaseService) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmation'),
        content: const Text(
            'Êtes-vous sûr de vouloir supprimer la base de données ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Confirmer'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await databaseService.deleteAndReinitializeDatabase();

      // Afficher un message à la fin de la suppression
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('La base de données a été supprimée.'),
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(bottom: 100.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ));
    }
  }

  Future<void> _confirmLogout(
    BuildContext context,
    AuthenticationViewModel authViewModel,
    WidgetRef ref,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmation de déconnexion'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Êtes-vous sûr de vouloir vous déconnecter ?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('⚠️ Cette action va :'),
            const SizedBox(height: 8),
            const Text('• Supprimer TOUTES les données locales'),
            const Text('• Effacer tous les modules téléchargés'),
            const Text('• Effacer toutes les observations non synchronisées'),
            const Text('• Vider tous les caches de l\'application'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.warning, color: Colors.orange, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Tout ce qui n\'a pas été synchronisé sera définitivement perdu !',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Vous aurez besoin d\'une connexion internet pour vous reconnecter et télécharger à nouveau les données.',
              style: TextStyle(fontSize: 13, fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Annuler'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Confirmer la déconnexion'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    if (confirm == true) {
      // Afficher un indicateur de progression pendant la suppression
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Expanded(
                child: Text('Suppression des données locales en cours...'),
              ),
            ],
          ),
        ),
      );

      try {
        // Utiliser la nouvelle méthode de déconnexion qui supprime tout
        await authViewModel.signOutAndClearAllData(ref, context);
        
        // Fermer le dialog de progression - la navigation se fait automatiquement
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      } catch (e) {
        // Fermer le dialog de progression
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
        
        // Afficher l'erreur
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la déconnexion: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  void _showVersionAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Informations sur la version'),
          content: const Text(
              "Cette application est conçue pour la version minimal 1.0.0 de monitoring."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Fermer"),
            ),
          ],
        );
      },
    );
  }

  /// Effectue une synchronisation complète (version BETA simplifiée)
  Future<void> _performCompleteSyncBeta(
      BuildContext context, SyncService syncService, WidgetRef ref) async {
    // Vérifier si une synchronisation est déjà en cours
    final currentStatus = ref.read(syncServiceProvider);
    if (currentStatus.state == SyncState.inProgress) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Une synchronisation est déjà en cours.')),
      );
      return;
    }

    // Afficher un dialogue de confirmation simple
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Synchronisation complète'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Cette opération va :',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('📥 Télécharger les dernières données du serveur'),
              const Text('📤 Envoyer vos données locales vers le serveur'),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info, color: Colors.blue, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Version BETA : Synchronisation complète simplifiée',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Synchroniser'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      // Lancer la synchronisation complète
      await syncService.syncComplete(ref);
    }
  }

  /// Affiche un dialogue pour sélectionner les éléments à synchroniser
  Future<void> _showSyncSelectionDialog(
      BuildContext context, SyncService syncService, WidgetRef ref) async {
    // Vérifier si une synchronisation est déjà en cours
    final currentStatus = ref.read(syncServiceProvider);
    if (currentStatus.state == SyncState.inProgress) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Une synchronisation est déjà en cours.')),
      );
      return;
    }

    // Vérifie si une synchronisation complète est nécessaire
    final isFullSyncRequired = syncService.isFullSyncNeeded();

    // Options de synchronisation avec états par défaut
    bool syncConfiguration = true; // Toujours activé
    bool syncNomenclatures = true;
    bool syncTaxons = true;
    bool syncObservers = true;
    bool syncModules = true;
    bool syncSites = true;
    bool syncSiteGroups = true;

    // Si une synchronisation complète est requise, on ne peut pas désactiver les options
    if (!isFullSyncRequired) {
      final result = await showDialog<Map<String, bool>>(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text('Synchronisation des données'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sélectionnez les éléments à synchroniser:',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    if (currentStatus.nextFullSyncInfo != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Theme.of(context).colorScheme.primary,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  currentStatus.nextFullSyncInfo!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    // Ajouter info sur dernière synchro complète
                    if (currentStatus.lastSync != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceVariant
                                .withOpacity(0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_circle_outline,
                                color: Theme.of(context).colorScheme.secondary,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Dernière synchronisation complète: ${_formatDate(currentStatus.lastSync!)}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    _buildSyncCheckboxTile(
                      context,
                      'Configuration',
                      Icons.settings,
                      true, // Toujours activé et sélectionné
                      (value) =>
                          setState(() => syncConfiguration = value ?? true),
                      isDisabled: true, // Toujours requis
                    ),
                    _buildSyncCheckboxTile(
                      context,
                      'Nomenclatures',
                      Icons.list_alt,
                      syncNomenclatures,
                      (value) =>
                          setState(() => syncNomenclatures = value ?? true),
                    ),
                    _buildSyncCheckboxTile(
                      context,
                      'Taxons',
                      Icons.eco,
                      syncTaxons,
                      (value) => setState(() => syncTaxons = value ?? true),
                    ),
                    _buildSyncCheckboxTile(
                      context,
                      'Observateurs',
                      Icons.person,
                      syncObservers,
                      (value) => setState(() => syncObservers = value ?? true),
                    ),
                    _buildSyncCheckboxTile(
                      context,
                      'Modules',
                      Icons.extension,
                      syncModules,
                      (value) => setState(() => syncModules = value ?? true),
                    ),
                    _buildSyncCheckboxTile(
                      context,
                      'Sites',
                      Icons.place,
                      syncSites,
                      (value) => setState(() => syncSites = value ?? true),
                    ),
                    _buildSyncCheckboxTile(
                      context,
                      'Groupes de sites',
                      Icons.folder,
                      syncSiteGroups,
                      (value) => setState(() => syncSiteGroups = value ?? true),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Annuler'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop({
                      'configuration': syncConfiguration,
                      'nomenclatures': syncNomenclatures,
                      'taxons': syncTaxons,
                      'observers': syncObservers,
                      'modules': syncModules,
                      'sites': syncSites,
                      'siteGroups': syncSiteGroups,
                    }),
                    child: const Text('Synchroniser'),
                  ),
                ],
              );
            },
          );
        },
      );

      if (result != null) {
        // Extraire les options sélectionnées
        syncConfiguration = result['configuration'] ?? true;
        syncNomenclatures = result['nomenclatures'] ?? true;
        syncTaxons = result['taxons'] ?? true;
        syncObservers = result['observers'] ?? true;
        syncModules = result['modules'] ?? true;
        syncSites = result['sites'] ?? true;
        syncSiteGroups = result['siteGroups'] ?? true;
      } else {
        // Annulation
        return;
      }
    } else {
      // Afficher un message indiquant qu'une synchronisation complète est nécessaire
      final doFullSync = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Synchronisation complète requise'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Une synchronisation complète est nécessaire car:',
                ),
                const SizedBox(height: 8),
                const Text(
                  '• La dernière synchronisation complète date de plus d\'une semaine',
                  style: TextStyle(fontSize: 14),
                ),
                const Text(
                  '• Ou c\'est la première utilisation de l\'application',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Tous les éléments seront synchronisés pour assurer la cohérence des données.',
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Annuler'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Lancer la synchronisation'),
              ),
            ],
          );
        },
      );

      if (doFullSync != true) {
        return; // L'utilisateur a annulé
      }
      // Tous les éléments seront synchronisés
    }

    // Démarrer la synchronisation avec les options sélectionnées
    await ref.read(syncServiceProvider.notifier).syncFromServer(
          ref,
          syncConfiguration: syncConfiguration,
          syncNomenclatures: syncNomenclatures,
          syncTaxons: syncTaxons,
          syncObservers: syncObservers,
          syncModules: syncModules,
          syncSites: syncSites,
          syncSiteGroups: syncSiteGroups,
        );
  }

  /// Formatte une date pour l'affichage
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      // Aujourd'hui
      return 'Aujourd\'hui à ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else {
      // Autre jour
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} à ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    }
  }

  /// Construit une checkbox pour la sélection d'éléments à synchroniser
  Widget _buildSyncCheckboxTile(
    BuildContext context,
    String title,
    IconData icon,
    bool value,
    Function(bool?) onChanged, {
    bool isDisabled = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: value
            ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3)
            : Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: CheckboxListTile(
        title: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: value
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: value ? FontWeight.bold : FontWeight.normal,
                color: value
                    ? Theme.of(context).colorScheme.onSurface
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
        value: value,
        onChanged: isDisabled ? null : onChanged,
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        activeColor: Theme.of(context).colorScheme.primary,
        checkColor: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }
}
