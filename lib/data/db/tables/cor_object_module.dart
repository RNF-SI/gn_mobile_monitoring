import 'package:drift/drift.dart';

@DataClassName('CorObjectModule')
class CorObjectModules extends Table {
  IntColumn get idCorObjectModule => integer().autoIncrement()();
  IntColumn get idObject => integer()();
  IntColumn get idModule => integer()();
}
