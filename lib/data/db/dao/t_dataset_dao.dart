import 'package:drift/drift.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/data/db/mapper/t_dataset_mapper.dart';
import 'package:gn_mobile_monitoring/data/db/tables/t_datasets.dart';
import 'package:gn_mobile_monitoring/domain/model/dataset.dart';

part 't_dataset_dao.g.dart';

@DriftAccessor(tables: [TDatasets])
class TDatasetsDao extends DatabaseAccessor<AppDatabase>
    with _$TDatasetsDaoMixin {
  final AppDatabase db;

  TDatasetsDao(this.db) : super(db);

  Future<void> insertDatasets(List<Dataset> datasets) async {
    // Insert datasets one by one with the onConflict strategy
    for (final dataset in datasets) {
      final entity = dataset.toDatabaseEntity();
      await into(db.tDatasets).insert(
        entity,
        onConflict: DoUpdate((old) => 
          TDatasetsCompanion(
            // Update all fields except primary key in case of conflict
            uniqueDatasetId: Value(entity.uniqueDatasetId),
            idAcquisitionFramework: Value(entity.idAcquisitionFramework),
            datasetName: Value(entity.datasetName),
            datasetShortname: Value(entity.datasetShortname),
            datasetDesc: Value(entity.datasetDesc),
            idNomenclatureDataType: Value(entity.idNomenclatureDataType),
            keywords: Value(entity.keywords),
            marineDomain: Value(entity.marineDomain),
            terrestrialDomain: Value(entity.terrestrialDomain),
            idNomenclatureDatasetObjectif: Value(entity.idNomenclatureDatasetObjectif),
            bboxWest: Value(entity.bboxWest),
            bboxEast: Value(entity.bboxEast),
            bboxSouth: Value(entity.bboxSouth),
            bboxNorth: Value(entity.bboxNorth),
            idNomenclatureCollectingMethod: Value(entity.idNomenclatureCollectingMethod),
            idNomenclatureDataOrigin: Value(entity.idNomenclatureDataOrigin),
            idNomenclatureSourceStatus: Value(entity.idNomenclatureSourceStatus),
            idNomenclatureResourceType: Value(entity.idNomenclatureResourceType),
            active: Value(entity.active),
            validable: Value(entity.validable),
            idDigitizer: Value(entity.idDigitizer),
            idTaxaList: Value(entity.idTaxaList),
            // Keep existing metadata rather than overwriting
          ),
          target: [db.tDatasets.idDataset],
        ),
      );
    }
  }

  Future<List<Dataset>> getAllDatasets() async {
    final dbDatasets = await select(db.tDatasets).get();
    return dbDatasets.map((e) => e.toDomain()).toList();
  }

  Future<void> clearDatasets() async {
    await delete(db.tDatasets).go();
  }
}
