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

@DriftAccessor(tables: [
  TTaxrefs,
  BibListesTable,
  CorTaxonListeTable,
])
class TaxonDao extends DatabaseAccessor<AppDatabase> with _$TaxonDaoMixin {
  TaxonDao(super.db);

  // Taxons CRUD
  Future<void> insertTaxon(Taxon taxon) async {
    try {
      // Vérifier si le taxon existe déjà
      final existingTaxon = await (select(tTaxrefs)
            ..where((t) => t.cdNom.equals(taxon.cdNom)))
          .getSingleOrNull();

      if (existingTaxon != null) {
        // Mettre à jour le taxon existant
        await (update(tTaxrefs)..where((t) => t.cdNom.equals(taxon.cdNom)))
            .write(taxon.toDatabaseEntity());
      } else {
        // Insérer un nouveau taxon
        await into(tTaxrefs).insert(taxon.toDatabaseEntity());
      }
    } catch (e) {
      print('Erreur dans insertTaxon pour cd_nom ${taxon.cdNom}: $e');
      // Tenter une insertion avec conflit update en dernier recours
      await into(tTaxrefs).insertOnConflictUpdate(taxon.toDatabaseEntity());
    }
  }

  Future<void> insertTaxons(List<Taxon> taxons) async {
    // Traiter chaque taxon individuellement pour éviter les erreurs de batch
    for (final taxon in taxons) {
      try {
        await insertTaxon(taxon);
      } catch (e) {
        print('Erreur dans insertTaxons pour cd_nom ${taxon.cdNom}: $e');
        // Continuer avec les autres taxons
      }
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

  Future<List<Taxon>> getAllTaxons() async {
    final results = await select(tTaxrefs).get();
    return results.map((t) => t.toDomain()).toList();
  }

  // BibListesTable CRUD
  Future<void> insertTaxonList(TaxonList list) async {
    try {
      // Vérifier si la liste existe déjà
      final existingList = await (select(bibListesTable)
            ..where((t) => t.idListe.equals(list.idListe)))
          .getSingleOrNull();

      if (existingList != null) {
        // Mettre à jour la liste existante
        await (update(bibListesTable)
              ..where((t) => t.idListe.equals(list.idListe)))
            .write(list.toDatabaseEntity());
      } else {
        // Insérer une nouvelle liste
        await into(bibListesTable).insert(list.toDatabaseEntity());
      }
    } catch (e) {
      print('Erreur dans insertTaxonList pour id_liste ${list.idListe}: $e');
      // Tenter une insertion avec conflit update en dernier recours
      await into(bibListesTable)
          .insertOnConflictUpdate(list.toDatabaseEntity());
    }
  }

  Future<void> insertTaxonLists(List<TaxonList> lists) async {
    // Traiter chaque liste individuellement pour éviter les erreurs de batch
    for (final list in lists) {
      try {
        await insertTaxonList(list);
      } catch (e) {
        print('Erreur dans insertTaxonLists pour id_liste ${list.idListe}: $e');
        // Continuer avec les autres listes
      }
    }
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
    try {
      // Vérifier si la relation existe déjà
      final existingRelation = await (select(corTaxonListeTable)
            ..where((t) => t.idListe.equals(idListe) & t.cdNom.equals(cdNom)))
          .getSingleOrNull();

      if (existingRelation == null) {
        // Insérer seulement si la relation n'existe pas
        await into(corTaxonListeTable).insert(
          CorTaxonListeTableCompanion(
            idListe: Value(idListe),
            cdNom: Value(cdNom),
          ),
          mode: InsertMode.insertOrIgnore,
        );
      }
    } catch (e) {
      print(
          'Erreur dans linkTaxonToList pour liste $idListe et cd_nom $cdNom: $e');
    }
  }

  Future<void> linkTaxonsToList(int idListe, List<int> cdNoms) async {
    for (final cdNom in cdNoms) {
      try {
        // Vérifier si la relation existe déjà
        final existingRelation = await (select(corTaxonListeTable)
              ..where((t) => t.idListe.equals(idListe) & t.cdNom.equals(cdNom)))
            .getSingleOrNull();

        if (existingRelation == null) {
          // Insérer seulement si la relation n'existe pas
          await into(corTaxonListeTable).insert(
              CorTaxonListeTableCompanion(
                idListe: Value(idListe),
                cdNom: Value(cdNom),
              ),
              mode: InsertMode.insertOrIgnore);
        }
      } catch (e) {
        print(
            'Erreur dans linkTaxonsToList pour liste $idListe et cd_nom $cdNom: $e');
        // Continuer avec les autres relations
      }
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

  /// Récupère les taxons correspondant à une liste d'identifiants
  Future<List<Taxon>> getTaxonsByCdNoms(List<int> cdNoms) async {
    if (cdNoms.isEmpty) {
      return [];
    }
    
    final query = select(tTaxrefs)..where((t) => t.cdNom.isIn(cdNoms));
    final results = await query.get();
    
    // Trier les résultats selon l'ordre de la liste initiale
    final resultMap = {for (var taxon in results) taxon.cdNom: taxon};
    return cdNoms
        .where((cdNom) => resultMap.containsKey(cdNom))
        .map((cdNom) => resultMap[cdNom]!.toDomain())
        .toList();
  }
}
