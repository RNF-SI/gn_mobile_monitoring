import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/presentation/model/moduleInfo.dart';
import 'package:gn_mobile_monitoring/presentation/model/moduleInfo_liste.dart';
import 'package:gn_mobile_monitoring/presentation/view/module_download_button.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/auth/auth_viewmodel.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/database/database_service.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/modules_utilisateur_viewmodel.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authViewModel = ref.read(authenticationViewModelProvider);
    final databaseService = ref.read(databaseServiceProvider.notifier);
    final userModuleListProv = ref.watch(userModuleListeProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF598979), // Brand color
        title: const Text("Mes Modules"),
        actions: [
          PopupMenuButton<String>(
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
              _buildMenuItem(
                  Icons.delete, 'Supprimer la base de données', 'delete'),
              _buildMenuItem(
                  Icons.info_outline, 'Informations sur la version', 'version'),
              _buildMenuItem(Icons.logout, 'Déconnexion', 'logout'),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: userModuleListProv.when(
              init: () => const Center(child: Text('Initialisation...')),
              success: (data) => RefreshIndicator(
                color: const Color(0xFF8AAC3E),
                onRefresh: () async {
                  await ref
                      .read(userModuleListeViewModelStateNotifierProvider
                          .notifier)
                      .refreshModules();
                },
                child: _buildModuleListWidget(context, data),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e) => Center(
                child: Text(
                  'Erreur: $e',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),
          ),
        ],
      ),
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
      case 'sync':
        await ref
            .read(userModuleListeViewModelStateNotifierProvider.notifier)
            .syncModules();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Modules synchronized successfully')),
        );
        break;
      case 'refresh':
        await ref
            .read(userModuleListeViewModelStateNotifierProvider.notifier)
            .refreshModules();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Liste des modules rafraîchie.')),
        );
        break;
      case 'delete':
        await _confirmDelete(context, databaseService, ref);
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
      BuildContext context, databaseService, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmation'),
        content: const Text(
            'Êtes-vous sûr de vouloir supprimer la base de données ?'),
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
      await ref.read(databaseService.notifier).deleteLocalMonitoringDatabase();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Base de données supprimée avec succès.')),
      );
    }
  }

  Future<void> _confirmLogout(BuildContext context,
      AuthenticationViewModel authViewModel, WidgetRef ref) async {
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
      // Implement logout logic here
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

  Widget _buildModuleListWidget(
      BuildContext context, ModuleInfoListe moduleInfoList) {
    if (moduleInfoList.isEmpty()) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Aucun module disponible.',
                style: TextStyle(
                    fontSize: 16, color: Color(0xFF598979)), // Brand color
              ),
            ),
          ),
        ],
      );
    } else {
      return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: moduleInfoList.length,
        itemBuilder: (BuildContext context, int index) {
          return ModuleItemCardWidget(moduleInfo: moduleInfoList[index]);
        },
      );
    }
  }
}

class ModuleItemCardWidget extends ConsumerWidget {
  const ModuleItemCardWidget({super.key, required this.moduleInfo});

  final ModuleInfo moduleInfo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    moduleInfo.module.moduleLabel ?? 'Module sans nom',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: const Color(0xFF598979)), // Brand color
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    moduleInfo.module.moduleDesc ??
                        'Pas de description disponible',
                    style: Theme.of(context).textTheme.bodyMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            ModuleDownloadButton(moduleInfo: moduleInfo),
          ],
        ),
      ),
    );
  }
}
