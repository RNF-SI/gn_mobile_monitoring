import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/presentation/state/sync_status.dart';
import 'package:gn_mobile_monitoring/presentation/view/home_page/menu_actions.dart';
import 'package:gn_mobile_monitoring/presentation/view/home_page/module_list_widget.dart';
import 'package:gn_mobile_monitoring/presentation/view/home_page/site_group_list_widget.dart';
import 'package:gn_mobile_monitoring/presentation/view/home_page/site_list_widget.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/database/database_sync_service.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/sync_service.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/sync_status_widget.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Observer le statut de synchronisation
    final syncStatus = ref.watch(syncServiceProvider);
    //Rafraichir les status de téléchargement des modules
    ref.read(databaseSyncServiceProvider).refreshAllLists();

    final isSyncing = syncStatus.state == SyncState.inProgress;

    // Détermine si l'overlay doit être affiché
    final showOverlay = syncStatus.state == SyncState.inProgress;

    return DefaultTabController(
      length: 3,
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              backgroundColor: const Color(0xFF598979), // Brand color
              title: const Text("Mes Données"),
              actions: [
                MenuActions(),
              ],
              bottom: TabBar(
                tabs: const [
                  Tab(icon: Icon(Icons.list), text: "Modules"),
                  Tab(icon: Icon(Icons.list), text: "Groupes de Sites"),
                  Tab(icon: Icon(Icons.map), text: "Sites"),
                ],
                onTap: isSyncing
                    ? (_) => false
                    : null, // Désactiver les onglets pendant la synchronisation
              ),
            ),
            body: Column(
              children: [
                const SyncStatusWidget(), // Ajout du widget de statut de synchronisation
                const Expanded(
                  child: TabBarView(
                    children: [
                      ModuleListWidget(),
                      SiteGroupListWidget(),
                      SiteListWidget(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Overlay pour bloquer les interactions pendant la synchronisation
          // Nous plaçons le ModalBarrier en-dessous du widget de synchronisation
          if (showOverlay)
            Positioned(
              top: MediaQuery.of(context).padding.top +
                  kToolbarHeight + // AppBar height
                  kTextTabBarHeight + // TabBar height
                  96, // Hauteur approximative du SyncStatusWidget
              left: 0,
              right: 0,
              bottom: 0,
              child: ModalBarrier(
                key: const Key('sync-modal-barrier'),
                color: Colors.black.withOpacity(0.1),
                dismissible: false,
              ),
            ),
        ],
      ),
    );
  }
}
