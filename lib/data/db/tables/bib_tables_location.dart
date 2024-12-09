import 'package:drift/drift.dart';

@DataClassName('BibTablesLocation')
class BibTablesLocation extends Table {
  IntColumn get idTableLocation => integer().autoIncrement()();
  TextColumn get tableDesc => text().nullable()();
  TextColumn get schemaName => text().nullable()();
  TextColumn get tableNameLabel => text().nullable()();
  TextColumn get pkField => text().nullable()();
  TextColumn get uuidFieldName => text().nullable()();
}
