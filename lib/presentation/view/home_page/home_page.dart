import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/presentation/view/home_page/menu_actions.dart';
import 'package:gn_mobile_monitoring/presentation/view/home_page/module_list_widget.dart';
import 'package:gn_mobile_monitoring/presentation/view/home_page/site_group_list_widget.dart';
import 'package:gn_mobile_monitoring/presentation/view/home_page/site_list_widget.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/sync_status_widget.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Observer le statut de synchronisation
    final syncStatus = ref.watch(syncStatusProvider);
    final isSyncing = syncStatus.isInProgress;
    
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
                onTap: isSyncing ? (_) => false : null, // Désactiver les onglets pendant la synchronisation
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
          if (isSyncing)
            Positioned.fill(
              child: ModalBarrier(
                color: Colors.black.withOpacity(0.1),
                dismissible: false,
              ),
            ),
        ],
      ),
    );
  }
}
