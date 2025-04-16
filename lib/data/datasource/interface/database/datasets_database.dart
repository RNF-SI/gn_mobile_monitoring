import 'package:gn_mobile_monitoring/domain/model/dataset.dart';

abstract class DatasetsDatabase {
  Future<void> insertDatasets(List<Dataset> datasets);
  Future<List<Dataset>> getAllDatasets();
  Future<Dataset?> getDatasetById(int datasetId);
  Future<List<Dataset>> getDatasetsByIds(List<int> datasetIds);
  Future<void> clearDatasets();
}
