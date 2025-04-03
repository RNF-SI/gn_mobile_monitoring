import '../model/taxon.dart';
import '../model/taxon_list.dart';

abstract class TaxonRepository {
  // Taxons
  Future<List<Taxon>> getAllTaxons();
  Future<List<Taxon>> getTaxonsByListId(int idListe);
  Future<Taxon?> getTaxonByCdNom(int cdNom);
  Future<List<Taxon>> searchTaxons(String searchTerm);
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

  // Module specific
  Future<List<Taxon>> getTaxonsByModuleId(int moduleId);
  Future<void> downloadModuleTaxons(int moduleId);
}
