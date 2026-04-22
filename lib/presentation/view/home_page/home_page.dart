import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/core/theme/app_colors.dart';
import 'package:gn_mobile_monitoring/presentation/state/sync_status.dart';
import 'package:gn_mobile_monitoring/presentation/view/home_page/menu_actions.dart';
import 'package:gn_mobile_monitoring/presentation/view/home_page/module_list_widget.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/app_update_service.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/database/database_sync_service.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/sync_service.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/app_update_dialog.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/sync_status_widget.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> {
  bool _syncServiceInitialized = false;

  // Recherche modules (issue #163)
  bool _isSearchActive = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearchActive = !_isSearchActive;
      if (!_isSearchActive) {
        _searchController.clear();
        _searchQuery = '';
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // Initialiser le service de synchronisation après le premier build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_syncServiceInitialized) {
        ref.read(syncServiceProvider.notifier).initialize(ref);
        _syncServiceInitialized = true;

        // Vérifier les mises à jour de l'app au lancement
        ref.read(appUpdateServiceProvider.notifier).checkForUpdate();
      }

      // Écouter les changements de mise à jour pour afficher le dialog
      ref.listenManual(appUpdateServiceProvider, (previous, next) {
        if (next.state == AppUpdateState.updateAvailable &&
            previous?.state != AppUpdateState.updateAvailable) {
          _showUpdateDialog();
        }
      });

      // Vérifier les mises à jour après une synchronisation réussie
      ref.listenManual(syncServiceProvider, (previous, next) {
        if (next.state == SyncState.success &&
            previous?.state != SyncState.success) {
          ref.read(appUpdateServiceProvider.notifier).checkForUpdate();
        }
      });
    });
  }

  void _showUpdateDialog() {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (_) => const AppUpdateDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Observer le statut de synchronisation
    final syncStatus = ref.watch(syncServiceProvider);
    // Ne PAS appeler refreshAllLists() ici : c'est un side-effect qui recharge
    // les modules depuis la DB à chaque rebuild (ex: keystroke dans la barre
    // de recherche #163) et écrase le state éphémère d'un téléchargement en
    // cours (moduleDownloading → moduleDownloaded trop tôt). Le ViewModel est
    // déjà tenu à jour via loadModules() au boot, le pull-to-refresh,
    // startDownloadModule et deleteAndReinitializeDatabase.

    final isSyncing = syncStatus.state == SyncState.inProgress;

    // Détermine si l'overlay doit être affiché
    final showOverlay = syncStatus.state == SyncState.inProgress;

    // Si on veut garder l'overlay pendant la sync, on doit utiliser un Stack
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.dark, // Brand color
            title: _isSearchActive
                ? TextField(
                    key: const Key('module-list-search-field'),
                    controller: _searchController,
                    autofocus: true,
                    style: const TextStyle(color: AppColors.white),
                    cursorColor: AppColors.white,
                    decoration: const InputDecoration(
                      hintText: 'Rechercher un module…',
                      hintStyle: TextStyle(color: Colors.white70),
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      setState(() => _searchQuery = value);
                    },
                  )
                : const Text("Mes Modules"),
            actions: [
              IconButton(
                key: const Key('module-list-search-toggle'),
                icon: Icon(_isSearchActive ? Icons.close : Icons.search),
                tooltip: _isSearchActive ? 'Fermer la recherche' : 'Rechercher',
                onPressed: isSyncing ? null : _toggleSearch,
              ),
              const MenuActions(),
            ],
          ),
          body: Column(
            children: [
              const SyncStatusWidget(), // Widget de statut de synchronisation
              Expanded(
                child: ModuleListWidget(
                  searchQuery: _isSearchActive ? _searchQuery : null,
                ),
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
