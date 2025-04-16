import 'package:drift/drift.dart';

@DataClassName('BibNomenclatureType')
class BibNomenclaturesTypesTable extends Table {
  IntColumn get idType => integer().autoIncrement()();
  TextColumn get mnemonique => text().nullable()();
  TextColumn get labelDefault => text().nullable()();
  TextColumn get definitionDefault => text().nullable()();
  TextColumn get labelFr => text().nullable()();
  TextColumn get definitionFr => text().nullable()();
  TextColumn get labelEn => text().nullable()();
  TextColumn get definitionEn => text().nullable()();
  TextColumn get labelEs => text().nullable()();
  TextColumn get definitionEs => text().nullable()();
  TextColumn get labelDe => text().nullable()();
  TextColumn get definitionDe => text().nullable()();
  TextColumn get labelIt => text().nullable()();
  TextColumn get definitionIt => text().nullable()();
  TextColumn get source => text().nullable()();
  TextColumn get statut => text().nullable()();
  DateTimeColumn get metaCreateDate => dateTime().nullable()();
  DateTimeColumn get metaUpdateDate => dateTime().nullable()();
}
