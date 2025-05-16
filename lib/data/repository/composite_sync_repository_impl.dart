import 'package:gn_mobile_monitoring/domain/model/sync_result.dart';
import 'package:gn_mobile_monitoring/domain/repository/downstream_sync_repository.dart';
import 'package:gn_mobile_monitoring/domain/repository/sync_repository.dart';
import 'package:gn_mobile_monitoring/domain/repository/upstream_sync_repository.dart';

/// Implémentation composite du repository de synchronisation
/// Cette classe délègue les opérations aux repositories spécialisés
class CompositeSyncRepositoryImpl implements SyncRepository {
  final DownstreamSyncRepository _downstreamRepo;
  final UpstreamSyncRepository _upstreamRepo;

  CompositeSyncRepositoryImpl({
    required DownstreamSyncRepository downstreamRepo,
    required UpstreamSyncRepository upstreamRepo,
  })  : _downstreamRepo = downstreamRepo,
        _upstreamRepo = upstreamRepo;

  // ===== Méthodes communes =====
  
  @override
  Future<bool> checkConnectivity() {
    // On utilise l'implémentation downstream par défaut
    return _downstreamRepo.checkConnectivity();
  }

  @override
  Future<DateTime?> getLastSyncDate(String entityType) {
    // On utilise l'implémentation downstream par défaut
    return _downstreamRepo.getLastSyncDate(entityType);
  }

  @override
  Future<void> updateLastSyncDate(String entityType, DateTime syncDate) {
    // On utilise l'implémentation downstream par défaut
    return _downstreamRepo.updateLastSyncDate(entityType, syncDate);
  }

  // ===== Délégation des méthodes descendantes =====

  @override
  Future<SyncResult> syncConfiguration(String token) {
    return _downstreamRepo.syncConfiguration(token);
  }

  @override
  Future<SyncResult> syncNomenclatures(String token, {DateTime? lastSync}) {
    return _downstreamRepo.syncNomenclatures(token, lastSync: lastSync);
  }

  @override
  Future<SyncResult> syncNomenclaturesAndDatasets(String token, {DateTime? lastSync}) {
    return _downstreamRepo.syncNomenclaturesAndDatasets(token, lastSync: lastSync);
  }

  @override
  Future<SyncResult> syncObservers(String token, {DateTime? lastSync}) {
    return _downstreamRepo.syncObservers(token, lastSync: lastSync);
  }

  @override
  Future<SyncResult> syncTaxons(String token, {DateTime? lastSync}) {
    return _downstreamRepo.syncTaxons(token, lastSync: lastSync);
  }

  @override
  Future<SyncResult> syncModules(String token, {DateTime? lastSync}) {
    return _downstreamRepo.syncModules(token, lastSync: lastSync);
  }

  @override
  Future<SyncResult> syncSites(String token, {DateTime? lastSync}) {
    return _downstreamRepo.syncSites(token, lastSync: lastSync);
  }

  @override
  Future<SyncResult> syncSiteGroups(String token, {DateTime? lastSync}) {
    return _downstreamRepo.syncSiteGroups(token, lastSync: lastSync);
  }

  // ===== Délégation des méthodes ascendantes =====

  @override
  Future<SyncResult> syncVisitsToServer(String token, String moduleCode) {
    return _upstreamRepo.syncVisitsToServer(token, moduleCode);
  }

  @override
  Future<SyncResult> syncObservationsToServer(
    String token, 
    String moduleCode, 
    int visitId, 
    {int? serverVisitId}
  ) {
    return _upstreamRepo.syncObservationsToServer(token, moduleCode, visitId, serverVisitId: serverVisitId);
  }

  @override
  Future<SyncResult> syncObservationDetailsToServer(
    String token, 
    String moduleCode, 
    int observationId, 
    {int? serverObservationId}
  ) {
    return _upstreamRepo.syncObservationDetailsToServer(
      token, 
      moduleCode, 
      observationId,
      serverObservationId: serverObservationId
    );
  }
}