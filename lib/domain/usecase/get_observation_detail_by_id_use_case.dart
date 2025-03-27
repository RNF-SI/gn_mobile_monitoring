import 'package:gn_mobile_monitoring/domain/model/observation_detail.dart';
import 'package:gn_mobile_monitoring/domain/repository/observation_details_repository.dart';

/// Cas d'utilisation pour récupérer un détail d'observation par son ID
abstract class GetObservationDetailByIdUseCase {
  Future<ObservationDetail?> execute(int detailId);
}

/// Implémentation du cas d'utilisation pour récupérer un détail d'observation
class GetObservationDetailByIdUseCaseImpl
    implements GetObservationDetailByIdUseCase {
  final ObservationDetailsRepository _repository;

  GetObservationDetailByIdUseCaseImpl(this._repository);

  @override
  Future<ObservationDetail?> execute(int detailId) {
    return _repository.getObservationDetailById(detailId);
  }
}
