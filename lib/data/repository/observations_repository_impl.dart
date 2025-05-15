import 'package:gn_mobile_monitoring/data/datasource/interface/database/observations_database.dart';
import 'package:gn_mobile_monitoring/data/mapper/observation_entity_mapper.dart';
import 'package:gn_mobile_monitoring/domain/model/observation.dart';
import 'package:gn_mobile_monitoring/domain/repository/observations_repository.dart';

/// Implémentation du repository pour les observations
class ObservationsRepositoryImpl implements ObservationsRepository {
  final ObservationsDatabase _observationsDatabase;

  ObservationsRepositoryImpl(this._observationsDatabase);

  @override
  Future<List<Observation>> getObservationsByVisitId(int visitId) async {
    final entities =
        await _observationsDatabase.getObservationsByVisitId(visitId);
    return entities.map((entity) => entity.toDomain()).toList();
  }

  @override
  Future<Observation?> getObservationById(int observationId) async {
    final entity =
        await _observationsDatabase.getObservationById(observationId);
    return entity?.toDomain();
  }

  @override
  Future<int> createObservation(Observation observation) async {
    final entity = observation.toEntity();
    return _observationsDatabase.saveObservation(entity);
  }

  @override
  Future<bool> updateObservation(Observation observation) async {
    try {
      final entity = observation.toEntity();
      final result = await _observationsDatabase.saveObservation(entity);
      return result > 0; // Return true only if at least one row was affected
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteObservation(int observationId) async {
    return _observationsDatabase.deleteObservation(observationId);
  }
}
