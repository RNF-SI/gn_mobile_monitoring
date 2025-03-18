import 'package:gn_mobile_monitoring/domain/repository/observations_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/delete_observation_use_case.dart';

/// Implémentation du cas d'utilisation pour supprimer une observation
class DeleteObservationUseCaseImpl implements DeleteObservationUseCase {
  final ObservationsRepository _observationsRepository;

  DeleteObservationUseCaseImpl(this._observationsRepository);

  @override
  Future<bool> execute(int observationId) async {
    // Vérifier que l'observation existe
    final existingObservation = await _observationsRepository.getObservationById(observationId);
    
    if (existingObservation == null) {
      throw Exception('Observation introuvable');
    }
    
    // Supprimer l'observation
    return _observationsRepository.deleteObservation(observationId);
  }
}