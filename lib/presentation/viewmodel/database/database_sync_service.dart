import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/domain/domain_module.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/auth/auth_viewmodel.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/database/database_service.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/modules_utilisateur_viewmodel.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/site_groups_utilisateur_viewmodel.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/sites_utilisateur_viewmodel.dart';

final databaseSyncServiceProvider =
    Provider.autoDispose<DatabaseSyncService>((ref) {
  return DatabaseSyncService(
    ref.watch(databaseServiceProvider.notifier),
    ref.watch(authenticationViewModelProvider),
    ref.watch(userModuleListeViewModelStateNotifierProvider.notifier),
    ref.watch(userSitesViewModelStateNotifierProvider.notifier),
    ref.watch(siteGroupViewModelStateNotifierProvider.notifier),
    ref,
  );
});

class DatabaseSyncService {
  final DatabaseService _databaseService;
  final AuthenticationViewModel _authViewModel;
  final UserModulesViewModel _modulesViewModel;
  final UserSitesViewModel _sitesViewModel;
  final SiteGroupsViewModel _siteGroupsViewModel;
  final Ref _ref;

  DatabaseSyncService(
    this._databaseService,
    this._authViewModel,
    this._modulesViewModel,
    this._sitesViewModel,
    this._siteGroupsViewModel,
    this._ref,
  );

  Future<void> deleteAndReinitializeDatabase(String token) async {
    // Delete and reinitialize database
    await _databaseService.deleteAndReinitializeDatabase();

    // Perform full sync in order
    await _ref.read(fetchModulesUseCaseProvider).execute(token);
    await _ref.read(fetchSitesUseCaseProvider).execute(token);
    await _ref.read(fetchSiteGroupsUseCaseProvider).execute(token);

    // Refresh all lists in order
    await _modulesViewModel.loadModules();
    await _sitesViewModel.loadSites();
    await _siteGroupsViewModel.refreshSiteGroups();
  }

  Future<void> refreshAllLists() async {
    await _modulesViewModel.loadModules();
    await _sitesViewModel.loadSites();
    await _siteGroupsViewModel.refreshSiteGroups();
  }
}
