import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/core/theme/app_colors.dart';
import 'package:gn_mobile_monitoring/data/data_module.dart';
import 'package:gn_mobile_monitoring/domain/domain_module.dart';
import 'package:gn_mobile_monitoring/presentation/state/sync_status.dart';
import 'package:gn_mobile_monitoring/presentation/view/funders_page.dart';
import 'package:gn_mobile_monitoring/presentation/view/home_page/module_item_card_widget.dart'
    show unsyncedModuleIdsProvider;
import 'package:gn_mobile_monitoring/presentation/viewmodel/app_update_service.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/auth/auth_viewmodel.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/sync_service.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/log_export_widget.dart';

class MenuActions extends ConsumerWidget {
  const MenuActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authViewModel = ref.read(authenticationViewModelProvider);
    final syncNotifier = ref.read(syncServiceProvider.notifier);

    // Observer le statut de synchronisation
    final syncStatus = ref.watch(syncServiceProvider);
    final isSyncing = syncStatus.state == SyncState.inProgress;

    return PopupMenuButton<String>(
      icon: const Icon(Icons.menu), // Menu icon
      enabled: !isSyncing, // Désactiver le menu pendant la synchronisation
      onSelected: (value) => _handleMenuSelection(
          value, ref, context, authViewModel, syncNotifier),
      itemBuilder: (BuildContext context) => [
        _buildMenuItem(
            Icons.download, 'Mettre à jour les données', 'sync_download'),
        _buildMenuItem(
            Icons.upload, 'Téléversement', 'sync_upload'),
        const PopupMenuDivider(),
        _buildMenuItem(
            Icons.system_update, 'Mise à jour de l\'application', 'app_update'),
        _buildMenuItem(
            Icons.bug_report, 'Export des logs', 'export_logs'),
        _buildMenuItem(
            Icons.info_outline, 'Informations sur la version', 'version'),
        _buildMenuItem(
            Icons.account_circle, 'Informations de connexion', 'connection_info'),
        _buildMenuItem(
            Icons.attach_money, 'Financeurs du projet', 'funders'),
        _buildMenuItem(Icons.logout, 'Déconnexion', 'logout'),
      ],
    );
  }

  PopupMenuItem<String> _buildMenuItem(
      IconData icon, String text, String value) {
    return PopupMenuItem<String>(
      key: Key('menu-$value'),
      value: value,
      child: ListTile(
        leading: Icon(icon, color: Colors.black),
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
  ) async {
    switch (value) {
      case 'sync_download':
        await _performDownloadSync(context, syncService, ref);
        break;
      case 'sync_upload':
        await _performUploadSync(context, syncService, ref);
        break;
      case 'export_logs':
        await LogExportDialog.show(context);
        break;
      case 'app_update':
        await _checkAppUpdate(context, ref);
        break;
      case 'version':
        _showVersionAlert(context);
        break;
      case 'connection_info':
        await _showConnectionInfoDialog(context, ref);
        break;
      case 'funders':
        _navigateToFundersPage(context);
        break;
      case 'logout':
        await _confirmLogout(context, authViewModel, ref);
        break;
    }
  }

  /// Vérifie manuellement la disponibilité d'une nouvelle version de l'APK.
  /// Utile pour un utilisateur qui a cliqué "Plus tard" dans la session et
  /// veut reprendre le téléchargement sans redémarrer l'app (#170).
  /// Si une MAJ est disponible, le dialog s'ouvre via le listener déjà actif
  /// sur appUpdateServiceProvider dans HomePage ; sinon on informe
  /// l'utilisateur via une SnackBar.
  Future<void> _checkAppUpdate(BuildContext context, WidgetRef ref) async {
    await ref.read(appUpdateServiceProvider.notifier).checkForUpdateManually();
    if (!context.mounted) return;
    final status = ref.read(appUpdateServiceProvider);
    if (status.state != AppUpdateState.updateAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('L\'application est à jour.')),
      );
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
              backgroundColor: AppColors.red,
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
            backgroundColor: AppColors.red,
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

  /// Effectue une mise à jour des données (téléchargement depuis le serveur)
  Future<void> _performDownloadSync(
      BuildContext context, SyncService syncService, WidgetRef ref) async {
    // Vérifier si une synchronisation est déjà en cours
    final currentStatus = ref.read(syncServiceProvider);
    if (currentStatus.state == SyncState.inProgress) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Une synchronisation est déjà en cours.')),
      );
      return;
    }

    // Afficher un dialogue de confirmation avec explication
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.download, color: Colors.green),
              SizedBox(width: 8),
              Expanded(child: Text('Mise à jour des données')),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Cette synchronisation va télécharger depuis le serveur :',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const Text('📥 Sites et groupes de sites'),
                const Text('📥 Taxons et listes taxonomiques'),
                const Text('📥 Nomenclatures et types'),
                const Text('📥 Configuration des modules'),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.withOpacity(0.3)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.info, color: Colors.green, size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Met à jour les données de référence sans affecter vos observations locales.',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('Mettre à jour'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      // Lancer la mise à jour des données
      await syncService.syncFromServer(ref);
    }
  }

  /// Effectue un téléversement (envoi vers le serveur)
  Future<void> _performUploadSync(
      BuildContext context, SyncService syncService, WidgetRef ref) async {
    // Vérifier si une synchronisation est déjà en cours
    final currentStatus = ref.read(syncServiceProvider);
    if (currentStatus.state == SyncState.inProgress) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Une synchronisation est déjà en cours.')),
      );
      return;
    }

    // Vérifier si la mise à jour des données est récente (< 7 jours)
    final isFullSyncNeeded = syncService.isFullSyncNeeded();
    if (isFullSyncNeeded) {
      // Afficher un dialogue expliquant pourquoi c'est bloqué
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.warning, color: Colors.orange),
                SizedBox(width: 8),
                Expanded(child: Text('Synchronisation requise')),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Téléversement impossible :',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                      '• La dernière mise à jour des données date de plus de 7 jours'),
                  const Text('• Ou c\'est votre première utilisation'),
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
                        Icon(Icons.info, color: Colors.orange, size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Effectuez d\'abord une mise à jour des données pour mettre à jour vos données de référence.',
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Compris'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _performDownloadSync(context, syncService, ref);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text('Mettre à jour les données'),
              ),
            ],
          );
        },
      );
      return;
    }

    // Afficher un dialogue de confirmation avec explication
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.upload, color: Colors.blue),
              SizedBox(width: 8),
              Expanded(child: Text('Envoi vers serveur')),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Cette synchronisation va envoyer vers le serveur :',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const Text('📤 Vos visites saisies'),
                const Text('📤 Vos observations et détails'),
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
                          'Les données seront supprimées localement après confirmation de réception par le serveur.',
                          style: TextStyle(
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
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text('Envoyer'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      try {
        // Récupérer la liste des modules téléchargés
        final getModulesUseCase = ref.read(getModulesUseCaseProvider);
        final modules = await getModulesUseCase.execute();

        // Filtrer les modules téléchargés qui ont un code
        final availableModules = modules
            .where((m) =>
                m.downloaded == true &&
                m.moduleCode != null &&
                m.moduleCode!.isNotEmpty)
            .toList();

        if (availableModules.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Aucun module téléchargé disponible pour la synchronisation.'),
              backgroundColor: Colors.orange,
            ),
          );
          return;
        }

        // Modules ayant au moins une visite locale non téléversée. Permet de
        // mettre en avant les modules réellement concernés et de couper court
        // si tout est déjà à jour (cf. #179).
        final unsyncedModuleIds =
            await ref.read(visitDatabaseProvider).getModuleIdsWithUnsyncedVisits();
        final modulesWithData = availableModules
            .where((m) => unsyncedModuleIds.contains(m.id))
            .toList();
        final modulesUpToDate = availableModules
            .where((m) => !unsyncedModuleIds.contains(m.id))
            .toList();

        if (modulesWithData.isEmpty) {
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Aucune donnée à téléverser : tous les modules sont à jour.'),
              backgroundColor: Colors.green,
            ),
          );
          return;
        }

        // Un seul module concerné → sync direct, pas de choix à faire.
        String? selectedModuleCode;
        if (modulesWithData.length == 1 && modulesUpToDate.isEmpty) {
          selectedModuleCode = modulesWithData.first.moduleCode;
        } else {
          if (!context.mounted) return;
          selectedModuleCode = await showDialog<String>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Choisir un module à téléverser'),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (modulesWithData.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.only(left: 4, bottom: 4),
                          child: Text(
                            'Avec saisies à téléverser',
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        ...modulesWithData.map((module) => ListTile(
                              dense: true,
                              title: Text(
                                  module.moduleLabel ?? module.moduleCode!),
                              subtitle: const Text('Saisies à téléverser'),
                              trailing: Container(
                                width: 10,
                                height: 10,
                                decoration: const BoxDecoration(
                                  color: Colors.orange,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              onTap: () => Navigator.of(context)
                                  .pop(module.moduleCode),
                            )),
                      ],
                      if (modulesUpToDate.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.only(left: 4, bottom: 4),
                          child: Text(
                            'À jour',
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(color: Colors.grey),
                          ),
                        ),
                        ...modulesUpToDate.map((module) => ListTile(
                              dense: true,
                              enabled: false,
                              title: Text(
                                  module.moduleLabel ?? module.moduleCode!),
                              subtitle: const Text('Aucune donnée à envoyer'),
                            )),
                      ],
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Annuler'),
                  ),
                ],
              );
            },
          );
        }

        if (selectedModuleCode != null) {
          await syncService.syncToServer(ref, moduleCode: selectedModuleCode);
          // Le badge "saisies non téléversées" doit refléter l'état après
          // upload, qu'il ait réussi ou non (en cas d'échec partiel, certains
          // items peuvent avoir été poussés).
          ref.invalidate(unsyncedModuleIdsProvider);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la récupération des modules: $e'),
            backgroundColor: AppColors.red,
          ),
        );
      }
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
                                .surfaceContainerHighest
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
              children: const [
                Text(
                  'Une synchronisation complète est nécessaire car:',
                ),
                SizedBox(height: 8),
                Text(
                  '• La dernière synchronisation complète date de plus d\'une semaine',
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  '• Ou c\'est la première utilisation de l\'application',
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 16),
                Text(
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
  
  /// Navigue vers la page des financeurs
  void _navigateToFundersPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const FundersPage(),
      ),
    );
  }

  /// Affiche les informations de connexion (utilisateur et instance)
  Future<void> _showConnectionInfoDialog(BuildContext context, WidgetRef ref) async {
    try {
      // Essayer d'abord de récupérer depuis authState
      final authState = ref.read(authStateProvider).value;
      
      // Récupérer les informations depuis le local storage
      final getApiUrlUseCase = ref.read(getApiUrlFromLocalStorageUseCaseProvider);
      final getUserNameUseCase = ref.read(getUserNameFromLocalStorageUseCaseProvider);
      final getUserIdUseCase = ref.read(getUserIdFromLocalStorageUseCaseProvider);
      
      // Récupérer l'URL de l'API
      final apiUrl = await getApiUrlUseCase.execute();
      
      // Utiliser authState si disponible, sinon local storage
      String? userName = authState?.name;
      String? userEmail = authState?.email;
      int? userId = authState?.id;
      
      // Si authState n'est pas disponible, utiliser le local storage
      if (userName == null || userId == null) {
        userName = await getUserNameUseCase.execute();
        try {
          userId = await getUserIdUseCase.execute();
        } catch (e) {
          // L'ID pourrait ne pas être disponible
          userId = null;
        }
      }

      if (!context.mounted) return;

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.account_circle, color: AppColors.dark),
                SizedBox(width: 8),
                Expanded(child: Text('Informations de connexion')),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Informations utilisateur
                  _buildInfoSection(
                    context,
                    'Utilisateur connecté',
                    Icons.person,
                    [
                      _buildInfoRow('Nom', userName ?? 'Non disponible'),
                      if (userEmail != null && userEmail != 'No email provided')
                        _buildInfoRow('Email', userEmail),
                      _buildInfoRow('ID', userId?.toString() ?? 'Non disponible'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Informations instance
                  _buildInfoSection(
                    context,
                    'Instance GeoNature',
                    Icons.cloud,
                    [
                      _buildInfoRow(
                        'URL', 
                        apiUrl ?? 'Non disponible',
                        copyable: true,
                      ),
                      _buildInfoRow(
                        'Domaine', 
                        apiUrl != null ? Uri.tryParse(apiUrl)?.host ?? 'Non disponible' : 'Non disponible',
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.dark.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.dark.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info, color: AppColors.dark, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Ces informations sont utiles pour le débogage et le support technique.',
                            style: TextStyle(
                              color: AppColors.dark,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Fermer"),
              ),
            ],
          );
        },
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la récupération des informations: $e'),
            backgroundColor: AppColors.red,
          ),
        );
      }
    }
  }

  /// Construit une section d'informations avec titre et icône
  Widget _buildInfoSection(
    BuildContext context,
    String title,
    IconData icon,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: AppColors.dark),
            const SizedBox(width: 6),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.dark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ],
    );
  }

  /// Construit une ligne d'information avec possibilité de copie
  Widget _buildInfoRow(String label, String value, {bool copyable = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: copyable && value != 'Non disponible'
                ? GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: value));
                      // Feedback visuel sans ScaffoldMessenger qui pourrait causer des problèmes
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            value,
                            style: const TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        const Icon(Icons.copy, size: 16, color: Colors.blue),
                      ],
                    ),
                  )
                : Text(
                    value,
                    style: const TextStyle(color: Colors.black54),
                  ),
          ),
        ],
      ),
    );
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
