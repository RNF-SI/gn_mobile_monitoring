import 'package:drift/drift.dart';

@DataClassName('TSiteComplement')
class TSiteComplements extends Table {
  IntColumn get idBaseSite => integer().autoIncrement()();
  IntColumn get idSitesGroup => integer().nullable()();
  TextColumn get data => text().nullable()();
}
