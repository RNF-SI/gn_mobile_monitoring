import 'package:drift/drift.dart';

@DataClassName('TBaseVisit')
class TBaseVisits extends Table {
  IntColumn get idBaseVisit => integer().autoIncrement()();
  IntColumn get idBaseSite => integer().nullable()();
  IntColumn get idDataset => integer()();
  IntColumn get idModule => integer()();
  IntColumn get idDigitiser => integer().nullable()();
  TextColumn get visitDateMin => text()();
  TextColumn get visitDateMax => text().nullable()();
  IntColumn get idNomenclatureTechCollectCampanule => integer().nullable()();
  IntColumn get idNomenclatureGrpTyp => integer().nullable()();
  TextColumn get comments => text().nullable()();
  TextColumn get uuidBaseVisit => text().nullable()();
  IntColumn get serverVisitId => integer().nullable()();
  TextColumn get metaCreateDate =>
      text().withDefault(const Constant('CURRENT_TIMESTAMP'))();
  TextColumn get metaUpdateDate =>
      text().withDefault(const Constant('CURRENT_TIMESTAMP'))();
}
