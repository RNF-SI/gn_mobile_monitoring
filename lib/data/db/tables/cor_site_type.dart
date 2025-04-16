import 'package:drift/drift.dart';

@DataClassName('CorSiteType')
class CorSiteTypeTable extends Table {
  IntColumn get idBaseSite => integer()();
  IntColumn get idNomenclatureTypeSite => integer()();

  @override
  Set<Column> get primaryKey => {idBaseSite, idNomenclatureTypeSite};
}
