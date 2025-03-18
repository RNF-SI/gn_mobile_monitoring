import 'package:gn_mobile_monitoring/domain/model/observation.dart';
import 'package:gn_mobile_monitoring/domain/repository/observations_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/update_observation_use_case.dart';

/// Implémentation du cas d'utilisation pour mettre à jour une observation existante
class UpdateObservationUseCaseImpl implements UpdateObservationUseCase {
  final ObservationsRepository _observationsRepository;

  UpdateObservationUseCaseImpl(this._observationsRepository);

  @override
  Future<bool> execute(Observation observation) async {
    // Vérifier que l'observation existe
    final existingObservation = await _observationsRepository.getObservationById(observation.idObservation);
    
    if (existingObservation == null) {
      throw Exception('Observation introuvable');
    }
    
    // Mettre à jour l'observation
    final observationId = await _observationsRepository.saveObservation(observation);
    
    return observationId > 0;
  }
}