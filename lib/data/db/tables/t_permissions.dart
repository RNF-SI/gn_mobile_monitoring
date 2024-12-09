import 'package:drift/drift.dart';

@DataClassName('TPermission')
class TPermissions extends Table {
  IntColumn get idPermission => integer().autoIncrement()();
  IntColumn get idRole => integer()();
  IntColumn get idAction => integer()();
  IntColumn get idModule => integer()();
  IntColumn get idObject => integer()();
  IntColumn get scopeValue => integer().nullable()();
  BoolColumn get sensitivityFilter =>
      boolean().withDefault(const Constant(false))();
}
