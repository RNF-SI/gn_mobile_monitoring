import 'package:gn_mobile_monitoring/data/datasource/interface/database/observation_details_database.dart';
import 'package:gn_mobile_monitoring/data/mapper/observation_detail_entity_mapper.dart';
import 'package:gn_mobile_monitoring/domain/model/observation_detail.dart';
import 'package:gn_mobile_monitoring/domain/repository/observation_details_repository.dart';

/// Implémentation du repository pour les détails d'observation
class ObservationDetailsRepositoryImpl implements ObservationDetailsRepository {
  final ObservationDetailsDatabase _localDataSource;

  ObservationDetailsRepositoryImpl(this._localDataSource);

  @override
  Future<List<ObservationDetail>> getObservationDetailsByObservationId(
      int observationId) async {
    final entityList = await _localDataSource
        .getObservationDetailsByObservationId(observationId);
    
    return entityList
        .map((entity) => entity.toDomain())
        .toList();
  }

  @override
  Future<ObservationDetail?> getObservationDetailById(int detailId) async {
    final entity = await _localDataSource.getObservationDetailById(detailId);
    if (entity != null) {
      return entity.toDomain();
    }
    return null;
  }

  @override
  Future<int> saveObservationDetail(ObservationDetail detail) async {
    final entity = detail.toEntity();
    return await _localDataSource.saveObservationDetail(entity);
  }

  @override
  Future<bool> deleteObservationDetail(int detailId) async {
    final result = await _localDataSource.deleteObservationDetail(detailId);
    return result > 0;
  }

  @override
  Future<bool> deleteObservationDetailsByObservationId(int observationId) async {
    final result = await _localDataSource
        .deleteObservationDetailsByObservationId(observationId);
    return result > 0;
  }
}
