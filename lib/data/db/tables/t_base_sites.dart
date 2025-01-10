import 'package:drift/drift.dart';

@DataClassName('TBaseSite')
class TBaseSites extends Table {
  IntColumn get idBaseSite => integer().autoIncrement()(); // Primary Key
  IntColumn get idInventor => integer().nullable()(); // Foreign Key to roles
  IntColumn get idDigitiser => integer().nullable()(); // Foreign Key to roles
  TextColumn get baseSiteName => text().nullable()();
  TextColumn get baseSiteDescription => text().nullable()();
  TextColumn get baseSiteCode => text().nullable()();
  DateTimeColumn get firstUseDate => dateTime().nullable()();
  TextColumn get geom => text().nullable()(); // GeoJSON representation
  TextColumn get uuidBaseSite => text().nullable()(); // UUID
  DateTimeColumn get metaCreateDate => dateTime().nullable()();
  DateTimeColumn get metaUpdateDate => dateTime().nullable()();
  IntColumn get altitudeMin => integer().nullable()();
  IntColumn get altitudeMax => integer().nullable()();
}
