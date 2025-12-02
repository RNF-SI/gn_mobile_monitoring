import 'package:drift/drift.dart';

@DataClassName('CorModuleDataset')
class CorModuleDatasetTable extends Table {
  @override
  String get tableName => 'cor_module_dataset_table';

  IntColumn get idModule => integer()();
  IntColumn get idDataset => integer()();

  @override
  Set<Column> get primaryKey => {idModule, idDataset};
}