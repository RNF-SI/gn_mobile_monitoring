import 'package:gn_mobile_monitoring/data/datasource/implementation/database/db.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/observation_details_database.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/data/entity/observation_detail_entity.dart';
import 'package:gn_mobile_monitoring/data/mapper/observation_detail_entity_mapper.dart';

/// Implémentation de l'interface ObservationDetailsDatabase utilisant Drift
class ObservationDetailsDatabaseImpl implements ObservationDetailsDatabase {
  Future<AppDatabase> get _database async => await DB.instance.database;

  @override
  Future<List<ObservationDetailEntity>> getObservationDetailsByObservationId(
      int observationId) async {
    final db = await _database;
    final detailsDao = db.observationDetailDao;
    final details =
        await detailsDao.getObservationDetailsByObservationId(observationId);

    return details.map((detail) => detail.toEntity()).toList();
  }

  @override
  Future<ObservationDetailEntity?> getObservationDetailById(
      int detailId) async {
    final db = await _database;
    final detailsDao = db.observationDetailDao;
    final detail = await detailsDao.getObservationDetailById(detailId);

    if (detail != null) {
      return detail.toEntity();
    }
    return null;
  }

  @override
  Future<int> saveObservationDetail(ObservationDetailEntity detail) async {
    final db = await _database;
    final detailsDao = db.observationDetailDao;
    final companion = detail.toCompanion();

    return await detailsDao.insertOrUpdateObservationDetail(companion);
  }

  @override
  Future<int> deleteObservationDetail(int detailId) async {
    final db = await _database;
    final detailsDao = db.observationDetailDao;
    return await detailsDao.deleteObservationDetail(detailId);
  }

  @override
  Future<int> deleteObservationDetailsByObservationId(int observationId) async {
    final db = await _database;
    final detailsDao = db.observationDetailDao;
    return await detailsDao
        .deleteObservationDetailsByObservationId(observationId);
  }
}
