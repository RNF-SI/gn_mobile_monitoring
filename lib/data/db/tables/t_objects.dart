import 'package:drift/drift.dart';

@DataClassName('TObject')
class TObjects extends Table {
  IntColumn get idObject => integer().autoIncrement()();
  TextColumn get codeObject => text().unique()();
  TextColumn get descriptionObject => text().nullable()();
}
