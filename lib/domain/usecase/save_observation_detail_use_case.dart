import 'package:gn_mobile_monitoring/domain/model/observation_detail.dart';
import 'package:gn_mobile_monitoring/domain/repository/observation_details_repository.dart';

/// Cas d'utilisation pour sauvegarder un détail d'observation
abstract class SaveObservationDetailUseCase {
  Future<int> execute(ObservationDetail detail);
}

/// Implémentation du cas d'utilisation pour sauvegarder un détail d'observation
class SaveObservationDetailUseCaseImpl implements SaveObservationDetailUseCase {
  final ObservationDetailsRepository _repository;

  SaveObservationDetailUseCaseImpl(this._repository);

  @override
  Future<int> execute(ObservationDetail detail) {
    return _repository.saveObservationDetail(detail);
  }
}
