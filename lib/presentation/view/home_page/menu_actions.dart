import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/auth/auth_viewmodel.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/database/database_service.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/modules_utilisateur_viewmodel.dart';

class MenuActions extends ConsumerWidget {
  const MenuActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authViewModel = ref.read(authenticationViewModelProvider);
    final databaseService = ref.read(databaseServiceProvider.notifier);

    return PopupMenuButton<String>(
      icon: const Icon(Icons.menu), // Menu icon
      onSelected: (value) => _handleMenuSelection(
        value,
        ref,
        context,
        authViewModel,
        databaseService,
      ),
      itemBuilder: (BuildContext context) => [
        _buildMenuItem(Icons.sync, 'Synchroniser les modules', 'sync'),
        _buildMenuItem(Icons.refresh, 'Rafraîchir la liste', 'refresh'),
        _buildMenuItem(Icons.delete, 'Supprimer la base de données', 'delete'),
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
    databaseService,
  ) async {
    switch (value) {
      case 'refresh':
        await ref
            .read(userModuleListeViewModelStateNotifierProvider.notifier)
            .loadModules(); // Updated function
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Liste des modules rafraîchie.')),
        );
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
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmation'),
        content: const Text(
            'Êtes-vous sûr de vouloir supprimer et réinitialiser la base de données ?'),
        actions: [
          TextButton(
            child: const Text('Annuler'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: const Text('Supprimer'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await databaseService.deleteAndReinitializeDatabase();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Base de données réinitialisée avec succès.')),
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
}
