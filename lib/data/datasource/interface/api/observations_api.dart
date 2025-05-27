import 'package:gn_mobile_monitoring/domain/model/observation.dart';

abstract class ObservationsApi {
  /// Envoie une observation au serveur
  /// Returns the created observation's server ID if successful
  Future<Map<String, dynamic>> sendObservation(
    String token,
    String moduleCode,
    Observation observation,
  );

  /// Met à jour une observation existante sur le serveur (PATCH)
  /// Returns the updated observation data if successful
  Future<Map<String, dynamic>> updateObservation(
    String token,
    String moduleCode,
    int observationId,
    Observation observation,
  );
}