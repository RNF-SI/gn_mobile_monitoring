import 'package:drift/drift.dart';

@DataClassName('TUserRole')
class TUserRoles extends Table {
  IntColumn get idRole => integer().autoIncrement()();
  TextColumn get identifiant => text().unique()();
  TextColumn get nomRole => text()();
  TextColumn get prenomRole => text()();
  IntColumn get idOrganisme => integer().nullable()();
  BoolColumn get active => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => 
      dateTime().nullable().withDefault(currentDateAndTime)();
}