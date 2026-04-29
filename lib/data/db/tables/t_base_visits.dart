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
  // Pas de `withDefault` : `Constant('CURRENT_TIMESTAMP')` insérait la chaîne
  // littérale au lieu d'évaluer la fonction SQL. Le mapper Dart fournit
  // toujours une vraie date ISO via `toCompanion[ForUpdate]()`.
  TextColumn get metaCreateDate => text().nullable()();
  TextColumn get metaUpdateDate => text().nullable()();
}
