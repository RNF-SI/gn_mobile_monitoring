import 'package:drift/drift.dart';
import 'package:gn_mobile_monitoring/data/db/mapper/bib_liste_mapper.dart';
import 'package:gn_mobile_monitoring/data/db/mapper/taxon_mapper.dart';
import 'package:gn_mobile_monitoring/domain/model/taxon.dart';
import 'package:gn_mobile_monitoring/domain/model/taxon_list.dart';

import '../database.dart';
import '../tables/bib_listes.dart';
import '../tables/cor_taxon_liste.dart';
import '../tables/t_taxrefs.dart';

part 'taxon_dao.g.dart';

@DriftAccessor(tables: [TTaxrefs, BibListesTable, CorTaxonListeTable])
class TaxonDao extends DatabaseAccessor<AppDatabase> with _$TaxonDaoMixin {
  TaxonDao(super.db);

  // Taxons CRUD
  Future<void> insertTaxon(Taxon taxon) async {
    await into(tTaxrefs).insert(taxon.toDatabaseEntity());
  }

  Future<void> insertTaxons(List<Taxon> taxons) async {
    final dbEntities = taxons.map((e) => e.toDatabaseEntity()).toList();

    await batch((batch) {
      batch.insertAll(tTaxrefs, dbEntities);
    });
  }

  Future<Taxon?> getTaxonByCdNom(int cdNom) async {
    final result = await (select(tTaxrefs)..where((t) => t.cdNom.equals(cdNom)))
        .getSingleOrNull();
    return result?.toDomain();
  }

  Future<List<Taxon>> getTaxonsByListId(int idListe) async {
    final query = select(tTaxrefs).join([
      innerJoin(corTaxonListeTable,
          corTaxonListeTable.cdNom.equalsExp(tTaxrefs.cdNom)),
    ])
      ..where(corTaxonListeTable.idListe.equals(idListe));

    final results = await query.get();
    return results.map((row) => row.readTable(tTaxrefs).toDomain()).toList();
  }

  Future<List<Taxon>> searchTaxons(String searchTerm) async {
    final query = select(tTaxrefs)
      ..where((t) =>
          t.nomComplet.like('%$searchTerm%') |
          t.lbNom.like('%$searchTerm%') |
          t.nomVern.like('%$searchTerm%'))
      ..limit(50); // Limit results to improve performance

    final results = await query.get();
    return results.map((t) => t.toDomain()).toList();
  }

  /// Recherche des taxons dans une liste taxonomique spécifique
  Future<List<Taxon>> searchTaxonsByListId(
      String searchTerm, int idListe) async {
    final query = select(tTaxrefs).join([
      innerJoin(corTaxonListeTable,
          corTaxonListeTable.cdNom.equalsExp(tTaxrefs.cdNom)),
    ])
      ..where(corTaxonListeTable.idListe.equals(idListe) &
          (tTaxrefs.nomComplet.like('%$searchTerm%') |
              tTaxrefs.lbNom.like('%$searchTerm%') |
              tTaxrefs.nomVern.like('%$searchTerm%')))
      ..limit(50); // Limit results to improve performance

    final results = await query.get();
    return results.map((row) => row.readTable(tTaxrefs).toDomain()).toList();
  }

  Future<List<Taxon>> getAllTaxons() async {
    final results = await select(tTaxrefs).get();
    return results.map((t) => t.toDomain()).toList();
  }

  // BibListesTable CRUD
  Future<void> insertTaxonList(TaxonList list) async {
    await into(bibListesTable).insert(list.toDatabaseEntity());
  }

  Future<void> insertTaxonLists(List<TaxonList> lists) async {
    final dbEntities = lists.map((e) => e.toDatabaseEntity()).toList();

    await batch((batch) {
      batch.insertAll(bibListesTable, dbEntities);
    });
  }

  Future<List<TaxonList>> getAllTaxonLists() async {
    final results = await select(bibListesTable).get();
    return results.map((t) => t.toDomain()).toList();
  }

  Future<TaxonList?> getTaxonListById(int idListe) async {
    final result = await (select(bibListesTable)
          ..where((t) => t.idListe.equals(idListe)))
        .getSingleOrNull();
    return result?.toDomain();
  }

  // CorTaxonListeTable CRUD
  Future<void> linkTaxonToList(int idListe, int cdNom) async {
    await into(corTaxonListeTable).insert(CorTaxonListeTableCompanion(
      idListe: Value(idListe),
      cdNom: Value(cdNom),
    ));
  }

  Future<void> linkTaxonsToList(int idListe, List<int> cdNoms) async {
    await batch((batch) {
      for (final cdNom in cdNoms) {
        batch.insert(
            corTaxonListeTable,
            CorTaxonListeTableCompanion(
              idListe: Value(idListe),
              cdNom: Value(cdNom),
            ));
      }
    });
  }

  Future<void> clearTaxons() async {
    try {
      await delete(tTaxrefs).go();
    } catch (e) {
      throw Exception("Failed to clear taxons: ${e.toString()}");
    }
  }

  Future<void> clearTaxonLists() async {
    try {
      await delete(bibListesTable).go();
    } catch (e) {
      throw Exception("Failed to clear taxon lists: ${e.toString()}");
    }
  }

  Future<void> clearCorTaxonListe() async {
    try {
      await delete(corTaxonListeTable).go();
    } catch (e) {
      throw Exception("Failed to clear cor_taxon_liste: ${e.toString()}");
    }
  }
}
