import 'package:drift/drift.dart';

@DataClassName('TSiteComplement')
class TSiteComplements extends Table {
  IntColumn get idBaseSite => integer()();
  IntColumn get idSitesGroup => integer().nullable()();
  TextColumn get data => text().nullable()();
  
  @override
  Set<Column> get primaryKey => {idBaseSite};
}
