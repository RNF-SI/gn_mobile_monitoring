import 'package:gn_mobile_monitoring/data/datasource/interface/database/taxon_database.dart';
import 'package:gn_mobile_monitoring/data/db/dao/taxon_dao.dart';
import 'package:gn_mobile_monitoring/domain/model/taxon.dart';
import 'package:gn_mobile_monitoring/domain/model/taxon_list.dart';

class TaxonDatabaseImpl implements TaxonDatabase {
  final TaxonDao _taxonDao;

  TaxonDatabaseImpl(this._taxonDao);

  @override
  Future<List<Taxon>> getAllTaxons() {
    return _taxonDao.getAllTaxons();
  }

  @override
  Future<List<Taxon>> getTaxonsByListId(int idListe) {
    return _taxonDao.getTaxonsByListId(idListe);
  }

  @override
  Future<Taxon?> getTaxonByCdNom(int cdNom) {
    return _taxonDao.getTaxonByCdNom(cdNom);
  }

  @override
  Future<List<Taxon>> searchTaxons(String searchTerm) {
    return _taxonDao.searchTaxons(searchTerm);
  }

  @override
  Future<void> saveTaxons(List<Taxon> taxons) {
    return _taxonDao.insertTaxons(taxons);
  }

  @override
  Future<void> clearTaxons() {
    return _taxonDao.clearTaxons();
  }

  @override
  Future<List<TaxonList>> getAllTaxonLists() {
    return _taxonDao.getAllTaxonLists();
  }

  @override
  Future<TaxonList?> getTaxonListById(int idListe) {
    return _taxonDao.getTaxonListById(idListe);
  }

  @override
  Future<void> saveTaxonLists(List<TaxonList> lists) {
    return _taxonDao.insertTaxonLists(lists);
  }

  @override
  Future<void> clearTaxonLists() {
    return _taxonDao.clearTaxonLists();
  }

  @override
  Future<void> saveTaxonsToList(int idListe, List<int> cdNoms) {
    return _taxonDao.linkTaxonsToList(idListe, cdNoms);
  }

  @override
  Future<void> clearCorTaxonListe() {
    return _taxonDao.clearCorTaxonListe();
  }
}