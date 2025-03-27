import 'package:gn_mobile_monitoring/domain/repository/observation_details_repository.dart';

/// Cas d'utilisation pour supprimer tous les détails liés à une observation
abstract class DeleteObservationDetailsByObservationIdUseCase {
  Future<bool> execute(int observationId);
}

/// Implémentation du cas d'utilisation pour supprimer tous les détails d'une observation
class DeleteObservationDetailsByObservationIdUseCaseImpl
    implements DeleteObservationDetailsByObservationIdUseCase {
  final ObservationDetailsRepository _repository;

  DeleteObservationDetailsByObservationIdUseCaseImpl(this._repository);

  @override
  Future<bool> execute(int observationId) {
    return _repository.deleteObservationDetailsByObservationId(observationId);
  }
}
