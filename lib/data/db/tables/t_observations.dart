import 'package:drift/drift.dart';

@DataClassName('TObservation')
class TObservations extends Table {
  IntColumn get idObservation => integer().autoIncrement()();
  IntColumn get idBaseVisit => integer().nullable()();
  IntColumn get cdNom => integer().nullable()();
  TextColumn get comments => text().nullable()();
  TextColumn get uuidObservation => text().nullable().unique()();
  IntColumn get serverObservationId => integer().nullable()();
}
