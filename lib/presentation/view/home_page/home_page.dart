import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/presentation/state/sync_status.dart';
import 'package:gn_mobile_monitoring/presentation/view/home_page/menu_actions.dart';
import 'package:gn_mobile_monitoring/presentation/view/home_page/module_list_widget.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/database/database_sync_service.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/sync_service.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/sync_status_widget.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> {
  bool _syncServiceInitialized = false;

  @override
  void initState() {
    super.initState();
    // Initialiser le service de synchronisation après le premier build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_syncServiceInitialized) {
        ref.read(syncServiceProvider.notifier).initialize(ref);
        _syncServiceInitialized = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Observer le statut de synchronisation
    final syncStatus = ref.watch(syncServiceProvider);
    //Rafraichir les status de téléchargement des modules
    ref.read(databaseSyncServiceProvider).refreshAllLists();

    final isSyncing = syncStatus.state == SyncState.inProgress;

    // Détermine si l'overlay doit être affiché
    final showOverlay = syncStatus.state == SyncState.inProgress;

    // Si on veut garder l'overlay pendant la sync, on doit utiliser un Stack
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFF598979), // Brand color
            title: const Text("Mes Données"),
            actions: [
              MenuActions(),
            ],
          ),
          body: Column(
            children: [
              const SyncStatusWidget(), // Widget de statut de synchronisation
              const Expanded(
                child: ModuleListWidget(),
              ),
            ],
          ),
        ),
        // Overlay pour bloquer les interactions pendant la synchronisation
        if (showOverlay)
          Positioned(
            top: MediaQuery.of(context).padding.top +
                kToolbarHeight + // AppBar height
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
    );
  }
}
