import 'package:gn_mobile_monitoring/domain/model/observation.dart';
import 'package:gn_mobile_monitoring/domain/repository/observations_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/create_observation_use_case.dart';

/// Implémentation du cas d'utilisation pour créer une nouvelle observation
class CreateObservationUseCaseImpl implements CreateObservationUseCase {
  final ObservationsRepository _observationsRepository;

  CreateObservationUseCaseImpl(this._observationsRepository);

  @override
  Future<int> execute(Observation observation) async {
    return _observationsRepository.saveObservation(observation);
  }
}