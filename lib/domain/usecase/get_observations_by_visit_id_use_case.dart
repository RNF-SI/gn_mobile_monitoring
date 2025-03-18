import 'package:gn_mobile_monitoring/domain/model/observation.dart';

/// Cas d'utilisation pour récupérer les observations d'une visite
abstract class GetObservationsByVisitIdUseCase {
  /// Exécute le cas d'utilisation pour récupérer les observations
  /// associées à une visite par son identifiant
  Future<List<Observation>> execute(int visitId);
}
