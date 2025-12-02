import 'package:drift/drift.dart';

@DataClassName('CorIndividualModule')
class CorIndividualModuleTable extends Table {
  IntColumn get idIndividual => integer()();
  IntColumn get idModule => integer()();

  @override
  Set<Column> get primaryKey => {idIndividual, idModule};
}
