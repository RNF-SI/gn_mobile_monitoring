import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/domain/domain_module.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_token_from_local_storage_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/incremental_sync_modules_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/incremental_sync_site_groups_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/incremental_sync_sites_usecase.dart';
import 'package:gn_mobile_monitoring/presentation/state/sync_status.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/database/database_sync_service.dart';

final syncStatusProvider = StateProvider<SyncStatus>((ref) {
  return SyncStatus.initial;
});

final syncServiceProvider = Provider<SyncService>((ref) {
  return SyncService(
    ref: ref,
    incrementalSyncModulesUseCase:
        ref.watch(incrementalSyncModulesUseCaseProvider),
    incrementalSyncSitesUseCase: ref.watch(incrementalSyncSitesUseCaseProvider),
    incrementalSyncSiteGroupsUseCase:
        ref.watch(incrementalSyncSiteGroupsUseCaseProvider),
    getTokenFromLocalStorageUseCase:
        ref.watch(getTokenFromLocalStorageUseCaseProvider),
    databaseSyncService: ref.watch(databaseSyncServiceProvider),
  );
});

class SyncService {
  final Ref ref;
  final IncrementalSyncModulesUseCase incrementalSyncModulesUseCase;
  final IncrementalSyncSitesUseCase incrementalSyncSitesUseCase;
  final IncrementalSyncSiteGroupsUseCase incrementalSyncSiteGroupsUseCase;
  final GetTokenFromLocalStorageUseCase getTokenFromLocalStorageUseCase;
  final DatabaseSyncService databaseSyncService;

  SyncService({
    required this.ref,
    required this.incrementalSyncModulesUseCase,
    required this.incrementalSyncSitesUseCase,
    required this.incrementalSyncSiteGroupsUseCase,
    required this.getTokenFromLocalStorageUseCase,
    required this.databaseSyncService,
  });

  void _updateSyncStatus(SyncStatus status) {
    ref.read(syncStatusProvider.notifier).state = status;
  }

  Future<bool> deleteAndReinitializeDatabase() async {
    try {
      // Récupérer le token d'authentification
      final token = await getTokenFromLocalStorageUseCase.execute();
      if (token == null || token.isEmpty) {
        _updateSyncStatus(
            SyncStatus.error("Token d'authentification non trouvé"));
        return false;
      }

      // Mettre à jour le statut pour la suppression
      _updateSyncStatus(SyncStatus.deletingDatabase);

      // Supprimer et réinitialiser la base de données
      await databaseSyncService.deleteAndReinitializeDatabase(token);

      // Synchronisation terminée
      _updateSyncStatus(SyncStatus.complete);
      return true;
    } catch (e) {
      _updateSyncStatus(SyncStatus.error(e.toString()));
      return false;
    }
  }

  Future<bool> syncAll() async {
    try {
      // Récupérer le token d'authentification
      final token = await getTokenFromLocalStorageUseCase.execute();
      if (token == null || token.isEmpty) {
        _updateSyncStatus(
            SyncStatus.error("Token d'authentification non trouvé"));
        return false;
      }

      // Synchronisation des modules
      _updateSyncStatus(SyncStatus.syncingModules);
      await incrementalSyncModulesUseCase.execute(token);

      // Synchronisation des sites
      _updateSyncStatus(SyncStatus.syncingSites);
      await incrementalSyncSitesUseCase.execute(token);

      // Synchronisation des groupes de sites
      _updateSyncStatus(SyncStatus.syncingSiteGroups);
      await incrementalSyncSiteGroupsUseCase.execute(token);

      // Rafraîchir toutes les listes
      await databaseSyncService.refreshAllLists();

      // Synchronisation terminée
      _updateSyncStatus(SyncStatus.complete);
      return true;
    } catch (e) {
      _updateSyncStatus(SyncStatus.error(e.toString()));
      return false;
    }
  }

  void resetStatus() {
    _updateSyncStatus(SyncStatus.initial);
  }
}
