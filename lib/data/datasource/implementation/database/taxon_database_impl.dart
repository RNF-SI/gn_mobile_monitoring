import 'package:gn_mobile_monitoring/data/datasource/implementation/database/db.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/taxon_database.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';
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
}
