import 'package:gn_mobile_monitoring/domain/model/taxon.dart';
import 'package:gn_mobile_monitoring/domain/model/taxon_list.dart';

abstract class TaxonDatabase {
  // Taxons
  Future<List<Taxon>> getAllTaxons();
  Future<List<Taxon>> getTaxonsByListId(int idListe);
  Future<Taxon?> getTaxonByCdNom(int cdNom);
  Future<List<Taxon>> searchTaxons(String searchTerm);
  Future<List<Taxon>> searchTaxonsByListId(String searchTerm, int idListe);
  Future<void> saveTaxon(Taxon taxon);
  Future<void> saveTaxons(List<Taxon> taxons);
  Future<void> clearTaxons();

  // Taxon Lists
  Future<List<TaxonList>> getAllTaxonLists();
  Future<TaxonList?> getTaxonListById(int idListe);
  Future<void> saveTaxonLists(List<TaxonList> lists);
  Future<void> clearTaxonLists();

  // Relations
  Future<void> saveTaxonsToList(int idListe, List<int> cdNoms);
  Future<void> clearCorTaxonListe();
  
  // Statistics and recommendations
  /// Récupère les taxons les plus fréquemment utilisés pour un module et site donnés
  /// 
  /// [idListe] Identifiant de la liste taxonomique à filtrer
  /// [moduleId] Identifiant du module (protocole)
  /// [siteId] Identifiant du site (optionnel)
  /// [visitId] Identifiant de la visite en cours (optionnel)
  /// [limit] Nombre maximum de taxons à retourner
  Future<List<Taxon>> getMostUsedTaxons({
    required int idListe,
    required int moduleId,
    int? siteId,
    int? visitId,
    int limit = 10,
  });
}
