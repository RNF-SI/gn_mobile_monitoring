import 'package:drift/drift.dart';

@DataClassName('CorSitesGroupModule')
class CorSitesGroupModules extends Table {
  IntColumn get idSitesGroup => integer()();
  IntColumn get idModule => integer()();

  @override
  Set<Column> get primaryKey => {idSitesGroup, idModule};
}
