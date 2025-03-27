import 'package:gn_mobile_monitoring/domain/repository/observation_details_repository.dart';

/// Cas d'utilisation pour supprimer un détail d'observation
abstract class DeleteObservationDetailUseCase {
  Future<bool> execute(int detailId);
}

/// Implémentation du cas d'utilisation pour supprimer un détail d'observation
class DeleteObservationDetailUseCaseImpl implements DeleteObservationDetailUseCase {
  final ObservationDetailsRepository _repository;

  DeleteObservationDetailUseCaseImpl(this._repository);

  @override
  Future<bool> execute(int detailId) {
    return _repository.deleteObservationDetail(detailId);
  }
}
