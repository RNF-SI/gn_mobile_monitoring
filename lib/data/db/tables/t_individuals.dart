import 'package:drift/drift.dart';

@DataClassName('TIndividual')
class TIndividuals extends Table {
  IntColumn get idIndividual => integer().autoIncrement()();
  IntColumn get idDigitiser => integer().nullable()();
  IntColumn get cdNom => integer().nullable()();
  TextColumn get comment => text().nullable()();
  TextColumn get individualName => text().nullable()();
  IntColumn get idNomenclatureSex => integer().nullable()();
  BoolColumn get activeIndividual => boolean().nullable()();
  TextColumn get uuidIndividual => text().nullable().unique()();
  IntColumn get serverIndividualId => integer().nullable()();
  DateTimeColumn get metaCreateDate => dateTime().nullable()();
  DateTimeColumn get metaUpdateDate => dateTime().nullable()();
}
