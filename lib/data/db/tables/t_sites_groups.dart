import 'package:drift/drift.dart';

@DataClassName('TSitesGroup')
class TSitesGroups extends Table {
  IntColumn get idSitesGroup => integer().autoIncrement()();
  TextColumn get sitesGroupName => text().nullable()();
  TextColumn get sitesGroupCode => text().nullable()();
  TextColumn get sitesGroupDescription => text().nullable()();
  TextColumn get uuidSitesGroup => text().nullable().unique()();
  TextColumn get comments => text().nullable()();
  TextColumn get data => text().nullable()();
  DateTimeColumn get metaCreateDate => dateTime().nullable()();
  DateTimeColumn get metaUpdateDate => dateTime().nullable()();

  IntColumn get idDigitiser => integer().nullable()(); // Added for consistency
  TextColumn get geom => text().nullable()(); // Geometry support
  IntColumn get altitudeMin => integer().nullable()(); // Altitude min
  IntColumn get altitudeMax => integer().nullable()(); // Altitude max
}
