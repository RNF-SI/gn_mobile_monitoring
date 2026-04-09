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
    await into(tTaxrefs).insertOnConflictUpdate(taxon.toDatabaseEntity());
  }

  Future<void> insertTaxons(List<Taxon> taxons) async {
    for (var i = 0; i < taxons.length; i += 500) {
      final chunk = taxons.sublist(i, (i + 500).clamp(0, taxons.length));
      final dbEntities = chunk.map((e) => e.toDatabaseEntity()).toList();
      await batch((b) {
        b.insertAll(tTaxrefs, dbEntities, mode: InsertMode.insertOrReplace);
      });
    }
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

  /// Vérifie si un taxon appartient à une liste taxonomique (requête légère, pas de chargement complet)
  Future<bool> isTaxonInList(int cdNom, int idListe) async {
    final query = select(corTaxonListeTable)
      ..where(
          (t) => t.cdNom.equals(cdNom) & t.idListe.equals(idListe));
    final result = await query.getSingleOrNull();
    return result != null;
  }

  /// Retourne un nombre limité de taxons pour les suggestions (évite le chargement complet)
  Future<List<Taxon>> getSuggestionTaxons(int idListe, {int limit = 10}) async {
    final query = select(tTaxrefs).join([
      innerJoin(corTaxonListeTable,
          corTaxonListeTable.cdNom.equalsExp(tTaxrefs.cdNom)),
    ])
      ..where(corTaxonListeTable.idListe.equals(idListe))
      ..limit(limit);

    final results = await query.get();
    return results.map((row) => row.readTable(tTaxrefs).toDomain()).toList();
  }

  Future<List<Taxon>> getAllTaxons() async {
    final results = await select(tTaxrefs).get();
    return results.map((t) => t.toDomain()).toList();
  }

  // BibListesTable CRUD
  Future<void> insertTaxonList(TaxonList list) async {
    await into(bibListesTable).insertOnConflictUpdate(list.toDatabaseEntity());
  }

  Future<void> insertTaxonLists(List<TaxonList> lists) async {
    final dbEntities = lists.map((e) => e.toDatabaseEntity()).toList();
    await batch((b) {
      b.insertAll(bibListesTable, dbEntities, mode: InsertMode.insertOrReplace);
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
    await into(corTaxonListeTable).insert(
      CorTaxonListeTableCompanion(
        idListe: Value(idListe),
        cdNom: Value(cdNom),
      ),
      mode: InsertMode.insertOrIgnore,
    );
  }

  Future<void> linkTaxonsToList(int idListe, List<int> cdNoms) async {
    for (var i = 0; i < cdNoms.length; i += 500) {
      final chunk = cdNoms.sublist(i, (i + 500).clamp(0, cdNoms.length));
      final companions = chunk.map((cdNom) => CorTaxonListeTableCompanion(
        idListe: Value(idListe),
        cdNom: Value(cdNom),
      )).toList();
      await batch((b) {
        b.insertAll(corTaxonListeTable, companions, mode: InsertMode.insertOrIgnore);
      });
    }
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
  
  /// Retourne l'ensemble des cd_nom de tous les taxons en base
  Future<Set<int>> getAllTaxonCdNoms() async {
    final query = selectOnly(tTaxrefs)..addColumns([tTaxrefs.cdNom]);
    final rows = await query.get();
    return rows.map((row) => row.read(tTaxrefs.cdNom)!).toSet();
  }

  /// Retourne l'ensemble des cd_nom associés à une liste taxonomique
  Future<Set<int>> getCdNomsByListId(int idListe) async {
    final query = selectOnly(corTaxonListeTable)
      ..addColumns([corTaxonListeTable.cdNom])
      ..where(corTaxonListeTable.idListe.equals(idListe));
    final rows = await query.get();
    return rows.map((row) => row.read(corTaxonListeTable.cdNom)!).toSet();
  }

  /// Retourne l'ensemble des id_liste distincts présents en base
  Future<Set<int>> getAllListIds() async {
    final query = selectOnly(bibListesTable)
      ..addColumns([bibListesTable.idListe]);
    final rows = await query.get();
    return rows.map((row) => row.read(bibListesTable.idListe)!).toSet();
  }

  /// Supprime un taxon par son cd_nom, ainsi que ses références
  Future<void> deleteTaxon(int cdNom) async {
    try {
      // Supprimer le taxon
      await (delete(tTaxrefs)..where((t) => t.cdNom.equals(cdNom))).go();
      
      // Supprimer les références dans cor_taxon_liste
      await (delete(corTaxonListeTable)..where((t) => t.cdNom.equals(cdNom))).go();
    } catch (e) {
      throw Exception("Failed to delete taxon with cd_nom $cdNom: ${e.toString()}");
    }
  }
}
