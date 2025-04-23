import 'package:gn_mobile_monitoring/domain/model/sync_result.dart';
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
  
  // Methods added for synchronization
  
  /// Sauvegarde les taxons avec gestion des résultats de synchronisation
  Future<SyncResult> saveTaxonsWithSync(List<Map<String, dynamic>> taxons);
  
  /// Récupère les taxons qui n'ont pas encore été synchronisés
  Future<List<Taxon>> getPendingTaxons();
  
  /// Marque un taxon comme synchronisé
  Future<void> markTaxonSynced(int cdNom, DateTime syncDate);
}
