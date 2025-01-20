import 'package:gn_mobile_monitoring/data/datasource/implementation/database/db.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/datasets_database.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/domain/model/dataset.dart';

class DatasetsDatabaseImpl implements DatasetsDatabase {
  Future<AppDatabase> get _database async => await DB.instance.database;

  @override
  Future<void> insertDatasets(List<Dataset> datasets) async {
    final db = await _database;
    await db.tDatasetsDao.insertDatasets(datasets);
  }

  @override
  Future<List<Dataset>> getAllDatasets() async {
    final db = await _database;
    return await db.tDatasetsDao.getAllDatasets();
  }

  @override
  Future<void> clearDatasets() async {
    final db = await _database;
    await db.tDatasetsDao.clearDatasets();
  }
}
