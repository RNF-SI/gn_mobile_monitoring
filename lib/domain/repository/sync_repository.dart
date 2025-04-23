import 'package:gn_mobile_monitoring/domain/model/sync_result.dart';

/// Repository pour la synchronisation des données
abstract class SyncRepository {
  /// Vérifie la connectivité avec le serveur
  Future<bool> checkConnectivity();

  /// Récupère la date de dernière synchronisation
  Future<DateTime?> getLastSyncDate(String entityType);

  /// Met à jour la date de dernière synchronisation
  Future<void> updateLastSyncDate(String entityType, DateTime syncDate);

  /// Synchronise les nomenclatures
  Future<SyncResult> syncNomenclaturesAndDatasets(String token,
      {DateTime? lastSync});

  /// Synchronise les taxons
  Future<SyncResult> syncTaxons(String token, {DateTime? lastSync});

  /// Synchronise les observateurs
  Future<SyncResult> syncObservers(String token, {DateTime? lastSync});

  /// Synchronise la configuration
  Future<SyncResult> syncConfiguration(String token);

  /// Synchronise les modules
  Future<SyncResult> syncModules(String token, {DateTime? lastSync});

  /// Synchronise les sites
  Future<SyncResult> syncSites(String token, {DateTime? lastSync});

  /// Synchronise les groupes de sites
  Future<SyncResult> syncSiteGroups(String token, {DateTime? lastSync});
}
