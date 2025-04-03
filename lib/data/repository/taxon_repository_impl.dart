import 'package:gn_mobile_monitoring/data/datasource/interface/api/taxon_api.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/modules_database.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/taxon_database.dart';
import 'package:gn_mobile_monitoring/domain/model/taxon.dart';
import 'package:gn_mobile_monitoring/domain/model/taxon_list.dart';
import 'package:gn_mobile_monitoring/domain/repository/taxon_repository.dart';

class TaxonRepositoryImpl implements TaxonRepository {
  final TaxonDatabase _taxonDatabase;
  final TaxonApi _taxonApi;
  final ModulesDatabase _modulesDatabase;

  TaxonRepositoryImpl(
      this._taxonDatabase, this._taxonApi, this._modulesDatabase);

  @override
  Future<List<Taxon>> getAllTaxons() {
    return _taxonDatabase.getAllTaxons();
  }

  @override
  Future<List<Taxon>> getTaxonsByListId(int idListe) {
    return _taxonDatabase.getTaxonsByListId(idListe);
  }

  @override
  Future<Taxon?> getTaxonByCdNom(int cdNom) {
    return _taxonDatabase.getTaxonByCdNom(cdNom);
  }

  @override
  Future<List<Taxon>> searchTaxons(String searchTerm) {
    return _taxonDatabase.searchTaxons(searchTerm);
  }

  @override
  Future<void> saveTaxons(List<Taxon> taxons) {
    return _taxonDatabase.saveTaxons(taxons);
  }

  @override
  Future<void> clearTaxons() {
    return _taxonDatabase.clearTaxons();
  }

  @override
  Future<List<TaxonList>> getAllTaxonLists() {
    return _taxonDatabase.getAllTaxonLists();
  }

  @override
  Future<TaxonList?> getTaxonListById(int idListe) {
    return _taxonDatabase.getTaxonListById(idListe);
  }

  @override
  Future<void> saveTaxonLists(List<TaxonList> lists) {
    return _taxonDatabase.saveTaxonLists(lists);
  }

  @override
  Future<void> clearTaxonLists() {
    return _taxonDatabase.clearTaxonLists();
  }

  @override
  Future<void> saveTaxonsToList(int idListe, List<int> cdNoms) {
    return _taxonDatabase.saveTaxonsToList(idListe, cdNoms);
  }

  @override
  Future<void> clearCorTaxonListe() {
    return _taxonDatabase.clearCorTaxonListe();
  }

  @override
  Future<List<Taxon>> getTaxonsByModuleId(int moduleId) async {
    final moduleComplement =
        await _modulesDatabase.getModuleComplementById(moduleId);
    if (moduleComplement?.idListTaxonomy == null) return [];

    return _taxonDatabase.getTaxonsByListId(moduleComplement!.idListTaxonomy!);
  }

  @override
  Future<void> downloadModuleTaxons(int moduleId, String token) async {
    // 1. Récupérer l'id_list_taxonomy du module
    final moduleComplement =
        await _modulesDatabase.getModuleComplementById(moduleId);
    if (moduleComplement?.idListTaxonomy == null) return;

    final idListTaxonomy = moduleComplement!.idListTaxonomy!;

    // 2. Télécharger la liste taxonomique
    final taxonList = await _taxonApi.getTaxonList(idListTaxonomy, token);
    await _taxonDatabase.saveTaxonLists([taxonList]);

    // 3. Télécharger les taxons associés à cette liste
    final taxons = await _taxonApi.getTaxonsByList(idListTaxonomy, token);

    // 4. Sauvegarder en local
    await _taxonDatabase.saveTaxons(taxons);

    // 5. Enregistrer les associations entre les taxons et la liste
    final cdNoms = taxons.map((t) => t.cdNom).toList();
    await _taxonDatabase.saveTaxonsToList(idListTaxonomy, cdNoms);
  }
}
