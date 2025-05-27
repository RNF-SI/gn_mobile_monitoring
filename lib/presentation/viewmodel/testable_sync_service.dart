import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/domain/domain_module.dart';
import 'package:gn_mobile_monitoring/presentation/state/sync_status.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/sync_service.dart';

/// Provider pour le service de synchronisation testable
final testableSyncServiceProvider =
    StateNotifierProvider<TestableSyncService, SyncStatus>((ref) {
  final getTokenUseCase = ref.read(getTokenFromLocalStorageUseCaseProvider);
  final syncUseCase = ref.read(incrementalSyncAllUseCaseProvider);
  final getLastSyncDateUseCase = ref.read(getLastSyncDateUseCaseProvider);
  final updateLastSyncDateUseCase = ref.read(updateLastSyncDateUseCaseProvider);
  final syncCompleteUseCase = ref.read(syncCompleteUseCaseProvider);

  return TestableSyncService(
    getTokenUseCase,
    syncUseCase,
    getLastSyncDateUseCase,
    updateLastSyncDateUseCase,
    ref.read(syncRepositoryProvider),
    syncCompleteUseCase,
  );
});

/// Service de synchronisation qui étend SyncService mais permet un meilleur test
class TestableSyncService extends SyncService {
  TestableSyncService(
    super.getTokenUseCase,
    super.syncUseCase,
    super.getLastSyncDateUseCase,
    super.updateLastSyncDateUseCase,
    super.syncRepository,
    super.syncCompleteUseCase,
  );

  // Override pour les tests - toujours retourne true
  @override
  bool isFullSyncNeeded() {
    return true;
  }

  // Méthode testable qui n'exige pas un WidgetRef réel, utilisée uniquement pour les tests
  Future<SyncStatus> testSyncFromServer({
    bool syncConfiguration = true,
    bool syncNomenclatures = true,
    bool syncTaxons = true,
    bool syncObservers = true,
    bool syncModules = true,
    bool syncSites = true,
    bool syncSiteGroups = true,
    bool isManualSync = true,
  }) async {
    // Créer un mock pour la partie qui nécessite un WidgetRef
    // Dans ce cas, nous allons simplement simuler le comportement de syncFromServer
    // sans utiliser la méthode read sur le WidgetRef

    // Simuler le début d'une synchronisation
    state = SyncStatus.inProgress(
      currentStep: SyncStep.configuration,
      completedSteps: [],
      itemsProcessed: 0,
      itemsTotal: 1,
    );

    // Retourner simplement un résultat de réussite
    return SyncStatus.success(
      completedSteps: [SyncStep.configuration],
      itemsProcessed: 1,
      additionalInfo: "Test de synchronisation réussie",
    );
  }

  // Méthode testable pour syncToServer
  Future<SyncStatus> testSyncToServer({
    required String moduleCode,
    bool isManualSync = true,
  }) async {
    // Simuler le début d'une synchronisation
    state = SyncStatus.inProgress(
      currentStep: SyncStep.visitsToServer,
      completedSteps: [],
      itemsProcessed: 0,
      itemsTotal: 1,
    );

    // Retourner simplement un résultat de réussite
    return SyncStatus.success(
      completedSteps: [SyncStep.visitsToServer],
      itemsProcessed: 1,
      additionalInfo: "Test d'envoi réussi",
    );
  }
}
