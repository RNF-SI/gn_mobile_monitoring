import 'package:drift/drift.dart';

@DataClassName('BibTypeSite')
class BibTypeSitesTable extends Table {
  // On utilise l'ID de nomenclature comme clé primaire
  IntColumn get idNomenclatureTypeSite => integer()();
  TextColumn get config => text().nullable()(); // JSONB stocké en texte

  @override
  Set<Column> get primaryKey => {idNomenclatureTypeSite};
}
