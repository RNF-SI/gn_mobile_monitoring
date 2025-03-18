import 'package:gn_mobile_monitoring/domain/model/observation.dart';

/// Cas d'utilisation pour mettre à jour une observation existante
abstract class UpdateObservationUseCase {
  /// Exécute le cas d'utilisation pour mettre à jour une observation
  /// Retourne true si la mise à jour a réussi
  Future<bool> execute(Observation observation);
}
