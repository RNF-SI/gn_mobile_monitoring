import 'package:gn_mobile_monitoring/domain/model/sync_result.dart';

/// Repository pour la synchronisation des données de l'appareil vers le serveur (envoi)
abstract class UpstreamSyncRepository {
  /// Vérifie la connectivité avec le serveur
  Future<bool> checkConnectivity();

  /// Récupère la date de dernière synchronisation
  Future<DateTime?> getLastSyncDate(String entityType);

  /// Met à jour la date de dernière synchronisation
  Future<void> updateLastSyncDate(String entityType, DateTime syncDate);
  
  /// Envoie les visites locales vers le serveur
  /// Envoie les visites avec toutes leurs observations et détails d'observation
  /// Puis les supprime localement après confirmation de réception par le serveur
  Future<SyncResult> syncVisitsToServer(String token, String moduleCode);

  /// Envoie les observations locales vers le serveur
  /// Envoie les observations avec tous leurs détails d'observation
  /// Puis les supprime localement après confirmation de réception par le serveur
  Future<SyncResult> syncObservationsToServer(String token, String moduleCode, int visitId);

  /// Envoie les détails d'observation locaux vers le serveur
  /// Puis les supprime localement après confirmation de réception par le serveur
  Future<SyncResult> syncObservationDetailsToServer(String token, String moduleCode, int observationId);
}