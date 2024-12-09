import 'package:drift/drift.dart';

@DataClassName('TObservationComplement')
class TObservationComplements extends Table {
  IntColumn get idObservation => integer().autoIncrement()();
  TextColumn get data => text().nullable()();
}
