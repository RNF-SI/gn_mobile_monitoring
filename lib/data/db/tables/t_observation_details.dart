import 'package:drift/drift.dart';

@DataClassName('TObservationDetail')
class TObservationDetails extends Table {
  IntColumn get idObservationDetail => integer().autoIncrement()();
  IntColumn get idObservation => integer().nullable()();
  TextColumn get uuidObservationDetail => text()
      .withDefault(const Constant('randomblob(16)'))
      .unique()(); // Added UUID
  TextColumn get data => text().nullable()();
}
