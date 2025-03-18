import 'package:gn_mobile_monitoring/domain/repository/observations_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/delete_observation_use_case.dart';

/// Implémentation du cas d'utilisation pour supprimer une observation
class DeleteObservationUseCaseImpl implements DeleteObservationUseCase {
  final ObservationsRepository _repository;

  DeleteObservationUseCaseImpl(this._repository);

  @override
  Future<bool> execute(int observationId) {
    return _repository.deleteObservation(observationId);
  }
}
