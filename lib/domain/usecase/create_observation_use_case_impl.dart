import 'package:gn_mobile_monitoring/domain/model/observation.dart';
import 'package:gn_mobile_monitoring/domain/repository/observations_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/create_observation_use_case.dart';
import 'package:uuid/uuid.dart';

/// Implémentation du cas d'utilisation pour créer une nouvelle observation
class CreateObservationUseCaseImpl implements CreateObservationUseCase {
  final ObservationsRepository _repository;

  CreateObservationUseCaseImpl(this._repository);

  @override
  Future<int> execute(Observation observation) {
    // Générer un UUID si aucun n'est fourni
    final uuid = const Uuid();
    final observationWithUuid = observation.uuidObservation == null 
        ? observation.copyWith(uuidObservation: uuid.v4())
        : observation;
    
    return _repository.createObservation(observationWithUuid);
  }
}
