import 'package:gn_mobile_monitoring/domain/model/observation.dart';
import 'package:gn_mobile_monitoring/domain/repository/observations_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/update_observation_use_case.dart';

/// Implémentation du cas d'utilisation pour mettre à jour une observation existante
class UpdateObservationUseCaseImpl implements UpdateObservationUseCase {
  final ObservationsRepository _repository;

  UpdateObservationUseCaseImpl(this._repository);

  @override
  Future<bool> execute(Observation observation) {
    return _repository.updateObservation(observation);
  }
}
