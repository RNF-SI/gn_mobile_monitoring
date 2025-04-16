import 'package:gn_mobile_monitoring/domain/model/observation.dart';

/// Cas d'utilisation pour créer une nouvelle observation
abstract class CreateObservationUseCase {
  /// Exécute le cas d'utilisation pour créer une nouvelle observation
  /// Retourne l'ID de l'observation créée
  Future<int> execute(Observation observation);
}
