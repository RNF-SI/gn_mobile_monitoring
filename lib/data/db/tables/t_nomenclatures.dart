import 'package:drift/drift.dart';

@DataClassName('TNomenclature')
class TNomenclatures extends Table {
  IntColumn get idNomenclature => integer().autoIncrement()();
  IntColumn get idType => integer()();
  TextColumn get cdNomenclature => text()();
  TextColumn get mnemonique => text().nullable()();
  TextColumn get codeType => text().nullable()();  // Ajout du champ code_type
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
  IntColumn get idBroader => integer().nullable()();
  TextColumn get hierarchy => text().nullable()();
  BoolColumn get active => boolean().withDefault(Constant(true))();
  DateTimeColumn get metaCreateDate => dateTime().nullable()();
  DateTimeColumn get metaUpdateDate => dateTime().nullable()();
}
