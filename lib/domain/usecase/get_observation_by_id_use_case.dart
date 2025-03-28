import 'package:gn_mobile_monitoring/domain/model/observation.dart';

/// Use case pour récupérer une observation par son ID
abstract class GetObservationByIdUseCase {
  /// Récupère une observation par son ID
  Future<Observation?> execute(int observationId);
}
