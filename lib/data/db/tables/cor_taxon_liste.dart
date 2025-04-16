import 'package:drift/drift.dart';

import 'bib_listes.dart';
import 't_taxrefs.dart';

@DataClassName('CorTaxonListe')
class CorTaxonListeTable extends Table {
  IntColumn get idListe =>
      integer().named('id_liste').references(BibListesTable, #idListe)();
  IntColumn get cdNom =>
      integer().named('cd_nom').references(TTaxrefs, #cdNom)();

  @override
  Set<Column> get primaryKey => {idListe, cdNom};
}
