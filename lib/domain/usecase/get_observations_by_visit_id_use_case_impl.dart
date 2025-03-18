import 'package:gn_mobile_monitoring/domain/model/observation.dart';
import 'package:gn_mobile_monitoring/domain/repository/observations_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_observations_by_visit_id_use_case.dart';

/// Implémentation du cas d'utilisation pour récupérer les observations d'une visite
class GetObservationsByVisitIdUseCaseImpl implements GetObservationsByVisitIdUseCase {
  final ObservationsRepository _observationsRepository;

  GetObservationsByVisitIdUseCaseImpl(this._observationsRepository);

  @override
  Future<List<Observation>> execute(int visitId) async {
    return _observationsRepository.getObservationsByVisitId(visitId);
  }
}