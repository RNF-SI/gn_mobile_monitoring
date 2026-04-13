import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/domain/domain_module.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/auth/auth_viewmodel.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/database/database_service.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/modules_utilisateur_viewmodel.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/sync_service.dart';

final databaseSyncServiceProvider =
    Provider.autoDispose<DatabaseSyncService>((ref) {
  return DatabaseSyncService(
    ref.watch(databaseServiceProvider.notifier),
    ref.watch(authenticationViewModelProvider),
    ref.watch(userModuleListeViewModelStateNotifierProvider.notifier),
    ref,
  );
});

class DatabaseSyncService {
  final DatabaseService _databaseService;
  final AuthenticationViewModel _authViewModel;
  final UserModulesViewModel _modulesViewModel;
  final Ref _ref;

  DatabaseSyncService(
    this._databaseService,
    this._authViewModel,
    this._modulesViewModel,
    this._ref,
  );

  Future<void> deleteAndReinitializeDatabase(String token) async {
    // Delete and reinitialize database
    await _databaseService.deleteAndReinitializeDatabase();

    // Perform full sync in order
    await _ref.read(fetchModulesUseCaseProvider).execute(token);

    // Refresh all lists in order
    await _modulesViewModel.loadModules();
    
    // Incrémenter la version du cache pour forcer le rafraîchissement des providers family
    _ref.read(cacheVersionProvider.notifier).update((state) => state + 1);
  }

  Future<void> refreshAllLists() async {
    await _modulesViewModel.loadModules();
    
    // Incrémenter la version du cache pour forcer le rafraîchissement des providers family
    _ref.read(cacheVersionProvider.notifier).update((state) => state + 1);
  }
}
