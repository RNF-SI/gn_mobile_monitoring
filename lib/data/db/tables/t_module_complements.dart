import 'package:drift/drift.dart';

@DataClassName('TModuleComplement')
class TModuleComplements extends Table {
  IntColumn get idModule => integer().autoIncrement()();
  TextColumn get uuidModuleComplement => text()
      .nullable()
      .unique()
      .withDefault(const Constant('randomblob(16)'))(); // Added UUID
  IntColumn get idListObserver => integer().nullable()();
  IntColumn get idListTaxonomy => integer().nullable()();
  BoolColumn get bSynthese => boolean().withDefault(const Constant(true))();
  TextColumn get taxonomyDisplayFieldName =>
      text().withDefault(const Constant('nom_vern,lb_nom'))();
  BoolColumn get bDrawSitesGroup => boolean().nullable()();
  TextColumn get data => text().nullable()();
}
