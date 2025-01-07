import 'package:drift/drift.dart';

@DataClassName('TModule')
class TModules extends Table {
  IntColumn get idModule => integer().autoIncrement()();
  TextColumn get moduleCode => text().nullable()();
  TextColumn get moduleLabel => text().nullable()();
  TextColumn get moduleDesc => text().nullable()();
  BoolColumn get activeFrontend => boolean().nullable()();
  BoolColumn get activeBackend => boolean().nullable()();
}
