import 'package:drift/drift.dart';

@DataClassName('CorSiteModule')
class CorSiteModules extends Table {
  IntColumn get idBaseSite => integer()();
  IntColumn get idModule => integer()();

  @override
  Set<Column> get primaryKey => {idBaseSite, idModule};
}
