import 'package:drift/drift.dart';

@DataClassName('TPermissionAvailable')
class TPermissionsAvailable extends Table {
  IntColumn get idModule => integer()();
  IntColumn get idObject => integer()();
  IntColumn get idAction => integer()();
  TextColumn get label => text().nullable()();
  BoolColumn get scopeFilter => boolean().withDefault(const Constant(false))();
  BoolColumn get sensitivityFilter =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {idModule, idObject, idAction};
}
