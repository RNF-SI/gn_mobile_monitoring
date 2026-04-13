import 'package:gn_mobile_monitoring/domain/model/observation.dart';

/// Interface du repository pour les opérations liées aux observations
abstract class ObservationsRepository {
  /// Récupère toutes les observations associées à une visite par son ID
  Future<List<Observation>> getObservationsByVisitId(int visitId);

  /// Récupère une observation par son ID
  Future<Observation?> getObservationById(int observationId);

  /// Sauvegarde ou met à jour une observation
  Future<int> createObservation(Observation observation);

  /// Supprime une observation
  Future<bool> updateObservation(Observation observation);

  /// Supprime une observation
  Future<bool> deleteObservation(int observationId);

  /// Met à jour l'ID serveur d'une observation
  Future<bool> updateObservationServerId(int localObservationId, int serverObservationId);
}
