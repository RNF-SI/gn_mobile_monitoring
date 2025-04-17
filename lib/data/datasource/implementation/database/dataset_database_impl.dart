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
  Future<Dataset?> getDatasetById(int datasetId) async {
    final db = await _database;
    return await db.tDatasetsDao.getDatasetById(datasetId);
  }
  
  @override
  Future<List<Dataset>> getDatasetsByIds(List<int> datasetIds) async {
    final db = await _database;
    return await db.tDatasetsDao.getDatasetsByIds(datasetIds);
  }

  @override
  Future<void> clearDatasets() async {
    final db = await _database;
    await db.tDatasetsDao.clearDatasets();
  }
}
