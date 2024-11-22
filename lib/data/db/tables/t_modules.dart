import 'package:drift/drift.dart';

@DataClassName('TModule')
class TModules extends Table {
  IntColumn get idModule => integer().autoIncrement()();
  TextColumn get moduleCode => text().nullable()();
  TextColumn get moduleLabel => text().nullable()();
  TextColumn get modulePicto => text().nullable()();
  TextColumn get moduleDesc => text().nullable()();
  TextColumn get moduleGroup => text().nullable()();
  TextColumn get modulePath => text().nullable()();
  TextColumn get moduleExternalUrl => text().nullable()();
  TextColumn get moduleTarget => text().nullable()();
  TextColumn get moduleComment => text().nullable()();
  BoolColumn get activeFrontend => boolean().nullable()();
  BoolColumn get activeBackend => boolean().nullable()();
  TextColumn get moduleDocUrl => text().nullable()();
  IntColumn get moduleOrder => integer().nullable()();
  TextColumn get ngModule => text().nullable()();
  DateTimeColumn get metaCreateDate => dateTime().nullable()();
  DateTimeColumn get metaUpdateDate => dateTime().nullable()();
}
