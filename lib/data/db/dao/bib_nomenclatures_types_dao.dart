import 'package:drift/drift.dart';

import '../database.dart';
import '../tables/bib_nomenclatures_types.dart';

part 'bib_nomenclatures_types_dao.g.dart';

@DriftAccessor(tables: [BibNomenclaturesTypesTable])
class BibNomenclaturesTypesDao extends DatabaseAccessor<AppDatabase>
    with _$BibNomenclaturesTypesDaoMixin {
  BibNomenclaturesTypesDao(super.db);

  Future<List<BibNomenclatureType>> getAllNomenclatureTypes() {
    return select(bibNomenclaturesTypesTable).get();
  }

  Future<BibNomenclatureType?> getNomenclatureTypeByMnemonique(
      String mnemonique) {
    return (select(bibNomenclaturesTypesTable)
          ..where((t) => t.mnemonique.equals(mnemonique)))
        .getSingleOrNull();
  }

  Future<BibNomenclatureType?> getNomenclatureTypeById(int idType) {
    return (select(bibNomenclaturesTypesTable)
          ..where((t) => t.idType.equals(idType)))
        .getSingleOrNull();
  }

  Future<int> insertNomenclatureType(
      BibNomenclaturesTypesTableCompanion entry) {
    return into(bibNomenclaturesTypesTable).insert(entry);
  }

  Future<void> insertNomenclatureTypes(
      List<BibNomenclaturesTypesTableCompanion> entries) async {
    await batch((batch) {
      batch.insertAll(bibNomenclaturesTypesTable, entries);
    });
  }

  Future<bool> updateNomenclatureType(
      BibNomenclaturesTypesTableCompanion entry) {
    return update(bibNomenclaturesTypesTable).replace(entry);
  }

  Future<void> deleteNomenclatureType(int idType) async {
    await (delete(bibNomenclaturesTypesTable)
          ..where((t) => t.idType.equals(idType)))
        .go();
  }

  Future<void> clearNomenclatureTypes() async {
    await delete(bibNomenclaturesTypesTable).go();
  }
}
