import 'package:drift/drift.dart';

@DataClassName('TBibListe')
class BibListesTable extends Table {
  IntColumn get idListe => integer().named('id_liste')();
  TextColumn get codeListe => text().named('code_liste').nullable()();
  TextColumn get nomListe => text().named('nom_liste')();
  TextColumn get descListe => text().named('desc_liste').nullable()();
  TextColumn get regne => text().nullable()();
  TextColumn get group2Inpn => text().named('group2_inpn').nullable()();

  @override
  Set<Column> get primaryKey => {idListe};
}
