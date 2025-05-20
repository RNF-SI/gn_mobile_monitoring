import 'package:gn_mobile_monitoring/data/datasource/interface/api/global_api.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/taxon_api.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/datasets_database.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/global_database.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/nomenclatures_database.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/observations_database.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/taxon_database.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/visites_database.dart';
import 'package:gn_mobile_monitoring/data/repository/composite_sync_repository_impl.dart';
import 'package:gn_mobile_monitoring/data/repository/downstream_sync_repository_impl.dart';
import 'package:gn_mobile_monitoring/data/repository/upstream_sync_repository_impl.dart';
import 'package:gn_mobile_monitoring/domain/model/sync_result.dart';
import 'package:gn_mobile_monitoring/domain/repository/modules_repository.dart';
import 'package:gn_mobile_monitoring/domain/repository/observation_details_repository.dart';
import 'package:gn_mobile_monitoring/domain/repository/observations_repository.dart';
import 'package:gn_mobile_monitoring/domain/repository/sites_repository.dart';
import 'package:gn_mobile_monitoring/domain/repository/sync_repository.dart';
import 'package:gn_mobile_monitoring/domain/repository/visit_repository.dart';

/// Implémentation simplifiée du repository de synchronisation
/// Utilise le pattern Composite pour déléguer aux repositories spécialisés
/// et éviter la duplication de code
class SyncRepositoryImpl implements SyncRepository {
  final CompositeSyncRepositoryImpl _compositeSync;

  SyncRepositoryImpl(
    GlobalApi globalApi,
    TaxonApi taxonApi,
    GlobalDatabase globalDatabase,
    NomenclaturesDatabase nomenclaturesDatabase,
    DatasetsDatabase datasetsDatabase,
    TaxonDatabase taxonDatabase, {
    required ModulesRepository modulesRepository,
    required SitesRepository sitesRepository,
    required VisitRepository visitRepository,
    required ObservationsRepository observationsRepository,
    required ObservationDetailsRepository observationDetailsRepository,
    required VisitesDatabase visitesDatabase,
    required ObservationsDatabase observationsDatabase,
  }) : _compositeSync = CompositeSyncRepositoryImpl(
          downstreamRepo: DownstreamSyncRepositoryImpl(
            globalApi,
            taxonApi,
            globalDatabase,
            nomenclaturesDatabase,
            datasetsDatabase,
            taxonDatabase,
            visitesDatabase: visitesDatabase,
            observationsDatabase: observationsDatabase,
            modulesRepository: modulesRepository,
            sitesRepository: sitesRepository,
          ),
          upstreamRepo: UpstreamSyncRepositoryImpl(
            globalApi,
            globalDatabase,
            visitRepository: visitRepository,
            observationsRepository: observationsRepository,
            observationDetailsRepository: observationDetailsRepository,
          ),
        );

  // ===== Méthodes communes =====

  @override
  Future<bool> checkConnectivity() => _compositeSync.checkConnectivity();

  @override
  Future<DateTime?> getLastSyncDate(String entityType) =>
      _compositeSync.getLastSyncDate(entityType);

  @override
  Future<void> updateLastSyncDate(String entityType, DateTime syncDate) =>
      _compositeSync.updateLastSyncDate(entityType, syncDate);

  // ===== Méthodes de synchronisation descendante =====

  @override
  Future<SyncResult> syncConfiguration(String token) =>
      _compositeSync.syncConfiguration(token);

  @override
  Future<SyncResult> syncNomenclatures(String token, {DateTime? lastSync}) =>
      _compositeSync.syncNomenclatures(token, lastSync: lastSync);

  @override
  Future<SyncResult> syncNomenclaturesAndDatasets(String token,
          {DateTime? lastSync}) =>
      _compositeSync.syncNomenclaturesAndDatasets(token, lastSync: lastSync);

  @override
  Future<SyncResult> syncObservers(String token, {DateTime? lastSync}) =>
      _compositeSync.syncObservers(token, lastSync: lastSync);

  @override
  Future<SyncResult> syncTaxons(String token, {DateTime? lastSync}) =>
      _compositeSync.syncTaxons(token, lastSync: lastSync);

  @override
  Future<SyncResult> syncModules(String token, {DateTime? lastSync}) =>
      _compositeSync.syncModules(token, lastSync: lastSync);

  @override
  Future<SyncResult> syncSites(String token, {DateTime? lastSync}) =>
      _compositeSync.syncSites(token, lastSync: lastSync);

  @override
  Future<SyncResult> syncSiteGroups(String token, {DateTime? lastSync}) =>
      _compositeSync.syncSiteGroups(token, lastSync: lastSync);

  // ===== Méthodes de synchronisation ascendante =====

  @override
  Future<SyncResult> syncVisitsToServer(String token, String moduleCode) =>
      _compositeSync.syncVisitsToServer(token, moduleCode);

  @override
  Future<SyncResult> syncObservationsToServer(
          String token, String moduleCode, int visitId, {int? serverVisitId}) =>
      _compositeSync.syncObservationsToServer(token, moduleCode, visitId,
          serverVisitId: serverVisitId);

  @override
  Future<SyncResult> syncObservationDetailsToServer(
          String token, String moduleCode, int observationId,
          {int? serverObservationId}) =>
      _compositeSync.syncObservationDetailsToServer(
          token, moduleCode, observationId,
          serverObservationId: serverObservationId);
}
