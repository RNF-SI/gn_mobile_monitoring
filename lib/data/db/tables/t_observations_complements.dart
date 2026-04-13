import 'package:drift/drift.dart';

@DataClassName('TObservationComplement')
class TObservationComplements extends Table {
  IntColumn get idObservation => integer()(); // Clé primaire ET clé étrangère
  TextColumn get data => text().nullable()();
  
  @override
  Set<Column> get primaryKey => {idObservation};
}
