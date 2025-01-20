import 'package:gn_mobile_monitoring/domain/model/dataset.dart';

abstract class DatasetsDatabase {
  Future<void> insertDatasets(List<Dataset> datasets);
  Future<List<Dataset>> getAllDatasets();
  Future<void> clearDatasets();
}
