import 'package:gn_mobile_monitoring/domain/model/sync_result.dart';

/// Repository pour la synchronisation des données du serveur vers l'appareil (téléchargement)
abstract class DownstreamSyncRepository {
  /// Vérifie la connectivité avec le serveur
  Future<bool> checkConnectivity();

  /// Récupère la date de dernière synchronisation
  Future<DateTime?> getLastSyncDate(String entityType);

  /// Met à jour la date de dernière synchronisation
  Future<void> updateLastSyncDate(String entityType, DateTime syncDate);

  /// Synchronise la configuration (téléchargement)
  Future<SyncResult> syncConfiguration(String token);

  /// Synchronise les nomenclatures (téléchargement)
  Future<SyncResult> syncNomenclatures(String token, {DateTime? lastSync});

  /// Synchronise les nomenclatures et datasets (téléchargement)
  Future<SyncResult> syncNomenclaturesAndDatasets(String token, {DateTime? lastSync});

  /// Synchronise les taxons (téléchargement)
  Future<SyncResult> syncTaxons(String token, {DateTime? lastSync});

  /// Synchronise les observateurs (téléchargement)
  Future<SyncResult> syncObservers(String token, {DateTime? lastSync});

  /// Synchronise les modules (téléchargement)
  Future<SyncResult> syncModules(String token, {DateTime? lastSync});

  /// Synchronise les sites (téléchargement)
  Future<SyncResult> syncSites(String token, {DateTime? lastSync});

  /// Synchronise les groupes de sites (téléchargement)
  Future<SyncResult> syncSiteGroups(String token, {DateTime? lastSync});
}