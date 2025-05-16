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
  /// 
  /// @param token Jeton d'authentification
  /// @param moduleCode Code du module
  /// @param visitId ID local de la visite pour récupérer les observations
  /// @param serverVisitId ID de la visite sur le serveur (différent de l'ID local)
  Future<SyncResult> syncObservationsToServer(
    String token, 
    String moduleCode, 
    int visitId, 
    {int? serverVisitId}
  );

  /// Envoie les détails d'observation locaux vers le serveur
  /// Puis les supprime localement après confirmation de réception par le serveur
  /// 
  /// @param token Jeton d'authentification
  /// @param moduleCode Code du module
  /// @param observationId ID local de l'observation pour récupérer les détails
  /// @param serverObservationId ID de l'observation sur le serveur (différent de l'ID local)
  Future<SyncResult> syncObservationDetailsToServer(
    String token, 
    String moduleCode, 
    int observationId, 
    {int? serverObservationId}
  );
}