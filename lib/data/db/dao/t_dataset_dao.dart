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
    await batch((batch) {
      batch.insertAll(
        db.tDatasets,
        datasets.map((dataset) => dataset.toDatabaseEntity()).toList(),
      );
    });
  }

  Future<List<Dataset>> getAllDatasets() async {
    final dbDatasets = await select(db.tDatasets).get();
    return dbDatasets.map((e) => e.toDomain()).toList();
  }

  Future<void> clearDatasets() async {
    await delete(db.tDatasets).go();
  }
}
