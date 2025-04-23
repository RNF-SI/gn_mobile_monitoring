import 'package:drift/drift.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/database/db.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/taxon_database.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/domain/model/sync_result.dart';
import 'package:gn_mobile_monitoring/domain/model/taxon.dart';
import 'package:gn_mobile_monitoring/domain/model/taxon_list.dart';

class TaxonDatabaseImpl implements TaxonDatabase {
  Future<AppDatabase> get _database async => await DB.instance.database;

  @override
  Future<List<Taxon>> getAllTaxons() async {
    final db = await _database;
    return db.taxonDao.getAllTaxons();
  }

  @override
  Future<List<Taxon>> getTaxonsByListId(int idListe) async {
    final db = await _database;
    return db.taxonDao.getTaxonsByListId(idListe);
  }

  @override
  Future<Taxon?> getTaxonByCdNom(int cdNom) async {
    final db = await _database;
    return db.taxonDao.getTaxonByCdNom(cdNom);
  }

  @override
  Future<List<Taxon>> searchTaxons(String searchTerm) async {
    final db = await _database;
    return db.taxonDao.searchTaxons(searchTerm);
  }

  @override
  Future<List<Taxon>> searchTaxonsByListId(
      String searchTerm, int idListe) async {
    final db = await _database;
    return db.taxonDao.searchTaxonsByListId(searchTerm, idListe);
  }

  @override
  Future<void> saveTaxon(Taxon taxon) async {
    final db = await _database;
    return db.taxonDao.insertTaxon(taxon);
  }

  @override
  Future<void> saveTaxons(List<Taxon> taxons) async {
    final db = await _database;
    return db.taxonDao.insertTaxons(taxons);
  }

  @override
  Future<void> clearTaxons() async {
    final db = await _database;
    return db.taxonDao.clearTaxons();
  }

  @override
  Future<List<TaxonList>> getAllTaxonLists() async {
    final db = await _database;
    return db.taxonDao.getAllTaxonLists();
  }

  @override
  Future<TaxonList?> getTaxonListById(int idListe) async {
    final db = await _database;
    return db.taxonDao.getTaxonListById(idListe);
  }

  @override
  Future<void> saveTaxonLists(List<TaxonList> lists) async {
    final db = await _database;
    return db.taxonDao.insertTaxonLists(lists);
  }

  @override
  Future<void> clearTaxonLists() async {
    final db = await _database;
    return db.taxonDao.clearTaxonLists();
  }

  @override
  Future<void> saveTaxonsToList(int idListe, List<int> cdNoms) async {
    final db = await _database;
    return db.taxonDao.linkTaxonsToList(idListe, cdNoms);
  }

  @override
  Future<void> clearCorTaxonListe() async {
    final db = await _database;
    return db.taxonDao.clearCorTaxonListe();
  }

  @override
  Future<SyncResult> saveTaxonsWithSync(
      List<Map<String, dynamic>> taxons) async {
    final db = await _database;
    int added = 0;
    int updated = 0;
    int skipped = 0;
    int failed = 0;

    for (final taxonData in taxons) {
      try {
        // Extraire cd_nom comme identifiant unique
        final cdNom = taxonData['cd_nom'] as int?;
        if (cdNom == null) {
          skipped++;
          continue;
        }

        // Vérifier si le taxon existe déjà
        final existingTaxon = await db.taxonDao.getTaxonByCdNom(cdNom);

        // Convertir les données en objet Taxon
        final taxon = Taxon(
          cdNom: cdNom,
          cdRef: taxonData['cd_ref'],
          idStatut: taxonData['id_statut'],
          idHabitat: taxonData['id_habitat'],
          idRang: taxonData['id_rang'],
          regne: taxonData['regne'],
          phylum: taxonData['phylum'],
          classe: taxonData['classe'],
          ordre: taxonData['ordre'],
          famille: taxonData['famille'],
          sousFamille: taxonData['sous_famille'],
          tribu: taxonData['tribu'],
          cdTaxsup: taxonData['cd_taxsup'],
          cdSup: taxonData['cd_sup'],
          lbNom: taxonData['lb_nom'],
          lbAuteur: taxonData['lb_auteur'],
          nomComplet: taxonData['nom_complet'] ?? 'Sans nom',
          nomCompletHtml: taxonData['nom_complet_html'],
          nomVern: taxonData['nom_vern'],
          nomValide: taxonData['nom_valide'],
          nomVernEng: taxonData['nom_vern_eng'],
          group1Inpn: taxonData['group1_inpn'],
          group2Inpn: taxonData['group2_inpn'],
          group3Inpn: taxonData['group3_inpn'],
          url: taxonData['url'],
        );

        if (existingTaxon != null) {
          // Mise à jour
          updated++;
        } else {
          // Ajout
          added++;
        }

        // Dans les deux cas, on utilise la même méthode pour sauvegarder
        await db.taxonDao.insertTaxon(taxon);
      } catch (e) {
        failed++;
        print('Erreur lors de la sauvegarde du taxon: $e');
      }
    }

    return SyncResult.success(
      itemsProcessed: taxons.length,
      itemsAdded: added,
      itemsUpdated: updated,
      itemsSkipped: skipped,
      itemsFailed: failed,
    );
  }

  @override
  Future<List<Taxon>> getPendingTaxons() async {
    // Cette méthode est pertinente uniquement si les taxons peuvent être modifiés localement
    // et doivent être synchronisés avec le serveur
    final db = await _database;

    // Pour cet exemple, on considère qu'il n'y a pas de taxons en attente de synchronisation
    // car ils sont généralement uniquement importés depuis le serveur
    return [];
  }

  @override
  Future<void> markTaxonSynced(int cdNom, DateTime syncDate) async {
    final db = await _database;

    // Mettre à jour le statut de synchronisation si nécessaire
    // Par exemple, si on ajoute un champ pour suivre la synchronisation:
    await db.customUpdate(
      'UPDATE t_taxrefs SET sync_date = ? WHERE cd_nom = ?',
      variables: [
        Variable(syncDate.toIso8601String()),
        Variable(cdNom),
      ],
    );
  }
}
