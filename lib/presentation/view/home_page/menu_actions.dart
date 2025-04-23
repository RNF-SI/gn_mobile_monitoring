import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/presentation/state/sync_status.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/auth/auth_viewmodel.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/sync_service.dart';

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
        value,
        ref,
        context,
        authViewModel,
        syncNotifier,
      ),
      itemBuilder: (BuildContext context) => [
        _buildMenuItem(Icons.sync, 'Synchroniser les données', 'sync'),
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
  ) async {
    switch (value) {
      case 'sync':
        await _startSync(context, syncService, ref);
        break;
      case 'delete':
        await _confirmDelete(context, syncService);
        break;
      case 'version':
        _showVersionAlert(context);
        break;
      case 'logout':
        await _confirmLogout(context, authViewModel, ref);
        break;
    }
  }

  Future<void> _confirmDelete(BuildContext context, SyncService syncService) async {
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

    // La logique de suppression de base de données n'est plus implémentée dans le service
    // Elle devrait être réimplémentée avec le nouveau système de synchronisation
    if (confirmed == true) {
      // Cette fonctionnalité devra être réimplémentée
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cette fonctionnalité a été temporairement désactivée avec le nouveau système de synchronisation.'),
        ),
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
        title: const Text('Déconnexion'),
        content: const Text(
            'Êtes-vous sûr de vouloir vous déconnecter ? Vous aurez besoin d\'une connexion internet pour vous reconnecter.'),
        actions: [
          TextButton(
            child: const Text('Annuler'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: const Text('Se déconnecter'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await authViewModel.signOut(ref, context);
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

  Future<void> _startSync(
      BuildContext context, SyncService syncService, WidgetRef ref) async {
    // Vérifier si une synchronisation est déjà en cours
    final currentStatus = ref.read(syncServiceProvider);
    if (currentStatus.state == SyncState.inProgress) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Une synchronisation est déjà en cours.')),
      );
      return;
    }

    // Démarrer la synchronisation avec tous les types de données
    await syncService.syncAll(
      syncConfiguration: true,
      syncNomenclatures: true,
      syncTaxons: true,
      syncObservers: true,
    );
  }
}
