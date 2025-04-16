import 'package:drift/drift.dart';

@DataClassName('TTaxref')
class TTaxrefs extends Table {
  IntColumn get cdNom => integer().named('cd_nom')();
  IntColumn get cdRef => integer().named('cd_ref').nullable()();
  TextColumn get idStatut => text().named('id_statut').nullable()();
  IntColumn get idHabitat => integer().named('id_habitat').nullable()();
  TextColumn get idRang => text().named('id_rang').nullable()();
  TextColumn get regne => text().nullable()();
  TextColumn get phylum => text().nullable()();
  TextColumn get classe => text().nullable()();
  TextColumn get ordre => text().nullable()();
  TextColumn get famille => text().nullable()();
  TextColumn get sousFamille => text().named('sous_famille').nullable()();
  TextColumn get tribu => text().nullable()();
  IntColumn get cdTaxsup => integer().named('cd_taxsup').nullable()();
  IntColumn get cdSup => integer().named('cd_sup').nullable()();
  TextColumn get lbNom => text().named('lb_nom').nullable()();
  TextColumn get lbAuteur => text().named('lb_auteur').nullable()();
  TextColumn get nomComplet => text().named('nom_complet')();
  TextColumn get nomCompletHtml =>
      text().named('nom_complet_html').nullable()();
  TextColumn get nomVern => text().named('nom_vern').nullable()();
  TextColumn get nomValide => text().named('nom_valide').nullable()();
  TextColumn get nomVernEng => text().named('nom_vern_eng').nullable()();
  TextColumn get group1Inpn => text().named('group1_inpn').nullable()();
  TextColumn get group2Inpn => text().named('group2_inpn').nullable()();
  TextColumn get group3Inpn => text().named('group3_inpn').nullable()();
  TextColumn get url => text().nullable()();

  @override
  Set<Column> get primaryKey => {cdNom};
}
