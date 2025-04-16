import 'package:gn_mobile_monitoring/domain/model/observation_detail.dart';
import 'package:gn_mobile_monitoring/domain/repository/observation_details_repository.dart';

/// Cas d'utilisation pour récupérer les détails d'une observation par son ID
abstract class GetObservationDetailsByObservationIdUseCase {
  Future<List<ObservationDetail>> execute(int observationId);
}

/// Implémentation du cas d'utilisation pour récupérer les détails d'une observation
class GetObservationDetailsByObservationIdUseCaseImpl
    implements GetObservationDetailsByObservationIdUseCase {
  final ObservationDetailsRepository _repository;

  GetObservationDetailsByObservationIdUseCaseImpl(this._repository);

  @override
  Future<List<ObservationDetail>> execute(int observationId) {
    return _repository.getObservationDetailsByObservationId(observationId);
  }
}
