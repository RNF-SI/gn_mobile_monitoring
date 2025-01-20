import 'package:drift/drift.dart';

@DataClassName('TDataset')
class TDatasets extends Table {
  IntColumn get idDataset => integer().autoIncrement()();
  TextColumn get uniqueDatasetId => text()(); // UUID stored as text
  IntColumn get idAcquisitionFramework => integer()();
  TextColumn get datasetName => text()();
  TextColumn get datasetShortname => text()();
  TextColumn get datasetDesc => text()();
  IntColumn get idNomenclatureDataType => integer()();
  TextColumn get keywords => text().nullable()();
  BoolColumn get marineDomain => boolean()();
  BoolColumn get terrestrialDomain => boolean()();
  IntColumn get idNomenclatureDatasetObjectif => integer()();
  RealColumn get bboxWest => real().nullable()();
  RealColumn get bboxEast => real().nullable()();
  RealColumn get bboxSouth => real().nullable()();
  RealColumn get bboxNorth => real().nullable()();
  IntColumn get idNomenclatureCollectingMethod => integer()();
  IntColumn get idNomenclatureDataOrigin => integer()();
  IntColumn get idNomenclatureSourceStatus => integer()();
  IntColumn get idNomenclatureResourceType => integer()();
  BoolColumn get active => boolean().withDefault(Constant(true))();
  BoolColumn get validable =>
      boolean().nullable().withDefault(Constant(true))();
  IntColumn get idDigitizer => integer().nullable()();
  IntColumn get idTaxaList => integer().nullable()();
  DateTimeColumn get metaCreateDate => dateTime().nullable()();
  DateTimeColumn get metaUpdateDate => dateTime().nullable()();
}
