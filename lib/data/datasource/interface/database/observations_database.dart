import 'package:gn_mobile_monitoring/data/entity/observation_entity.dart';

/// Interface pour les opérations de base de données liées aux observations
abstract class ObservationsDatabase {
  /// Récupère toutes les observations liées à une visite par son ID
  Future<List<ObservationEntity>> getObservationsByVisitId(int visitId);
  
  /// Récupère une observation par son ID
  Future<ObservationEntity?> getObservationById(int observationId);
  
  /// Crée une nouvelle observation
  Future<int> createObservation(ObservationEntity observation);
  
  /// Met à jour une observation existante
  Future<bool> updateObservation(ObservationEntity observation);
  
  /// Supprime une observation
  Future<bool> deleteObservation(int observationId);

  /// Met à jour l'ID serveur d'une observation
  Future<bool> updateObservationServerId(int localObservationId, int serverObservationId);
}