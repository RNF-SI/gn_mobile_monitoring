import 'package:gn_mobile_monitoring/domain/model/observation.dart';
import 'package:gn_mobile_monitoring/domain/repository/observations_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_observation_by_id_use_case.dart';

/// Implémentation du use case pour récupérer une observation par son ID
class GetObservationByIdUseCaseImpl implements GetObservationByIdUseCase {
  final ObservationsRepository _repository;

  GetObservationByIdUseCaseImpl(this._repository);

  @override
  Future<Observation?> execute(int observationId) async {
    return await _repository.getObservationById(observationId);
  }
}
