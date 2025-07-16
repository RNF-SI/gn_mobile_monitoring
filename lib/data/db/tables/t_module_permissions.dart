import 'package:drift/drift.dart';

@DataClassName('TModulePermission')
class TModulePermissions extends Table {
  TextColumn get moduleCode => text().withLength(min: 1, max: 50)();
  IntColumn get visitCreate => integer().withDefault(const Constant(0))();
  IntColumn get visitRead => integer().withDefault(const Constant(0))();
  IntColumn get visitUpdate => integer().withDefault(const Constant(0))();
  IntColumn get visitDelete => integer().withDefault(const Constant(0))();
  IntColumn get siteCreate => integer().withDefault(const Constant(0))();
  IntColumn get siteRead => integer().withDefault(const Constant(0))();
  IntColumn get siteUpdate => integer().withDefault(const Constant(0))();
  IntColumn get siteDelete => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastSync => dateTime()();

  @override
  Set<Column> get primaryKey => {moduleCode};
}