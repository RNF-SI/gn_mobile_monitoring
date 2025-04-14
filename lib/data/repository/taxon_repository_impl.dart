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
  Future<List<Taxon>> searchTaxonsByListId(String searchTerm, int idListe) {
    return _taxonDatabase.searchTaxonsByListId(searchTerm, idListe);
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
  Future<void> downloadModuleTaxons(int moduleId) async {
    // 1. Récupérer l'id_list_taxonomy du module
    final moduleComplement =
        await _modulesDatabase.getModuleComplementById(moduleId);
    if (moduleComplement?.idListTaxonomy == null) return;

    final idListTaxonomy = moduleComplement!.idListTaxonomy!;

    // 2. Télécharger la liste taxonomique
    final taxonList = await _taxonApi.getTaxonList(idListTaxonomy);
    await _taxonDatabase.saveTaxonLists([taxonList]);

    // 3. Télécharger les taxons associés à cette liste
    final taxons = await _taxonApi.getTaxonsByList(idListTaxonomy);

    // 4. Sauvegarder en local
    await _taxonDatabase.saveTaxons(taxons);

    // 5. Enregistrer les associations entre les taxons et la liste
    final cdNoms = taxons.map((t) => t.cdNom).toList();
    await _taxonDatabase.saveTaxonsToList(idListTaxonomy, cdNoms);
  }

  /// Télécharge toutes les listes taxonomiques mentionnées dans la configuration
  ///
  /// Analyse la configuration pour trouver les champs de type 'taxonomy' avec un 'id_list'
  /// et télécharge les taxons correspondants
  @override
  Future<void> downloadTaxonsFromConfig(Map<String, dynamic> config) async {
    try {
      // Extraire tous les IDs de listes taxonomiques de la configuration
      final Set<int> taxonomyListIds = _extractTaxonomyListIds(config);

      // Pour chaque liste taxonomique trouvée dans la configuration
      for (final listId in taxonomyListIds) {
        try {
          // Télécharger et sauvegarder la liste
          final taxonList = await _taxonApi.getTaxonList(listId);
          await _taxonDatabase.saveTaxonLists([taxonList]);

          // Télécharger les taxons associés à cette liste
          final taxons = await _taxonApi.getTaxonsByList(listId);
          await _taxonDatabase.saveTaxons(taxons);

          // Enregistrer les associations entre les taxons et la liste
          final cdNoms = taxons.map((t) => t.cdNom).toList();
          await _taxonDatabase.saveTaxonsToList(listId, cdNoms);

          print('Taxons for list $listId downloaded and saved successfully.');
        } catch (e) {
          print('Error downloading taxons for list $listId: $e');
          // Continue with other lists even if one fails
        }
      }
    } catch (e) {
      print('Error processing taxonomy lists from configuration: $e');
    }
  }

  /// Extrait tous les IDs de listes taxonomiques de la configuration
  Set<int> _extractTaxonomyListIds(Map<String, dynamic> config) {
    final Set<int> listIds = {};

    void searchForTaxonomyFields(dynamic obj) {
      if (obj is Map<String, dynamic>) {
        // Si c'est un champ de taxonomie avec un id_list
        if (obj['type_util'] == 'taxonomy' && obj.containsKey('id_list')) {
          // La propriété id_list peut être un entier ou une chaîne
          dynamic rawListId = obj['id_list'];
          int? listId;
          
          if (rawListId is int) {
            listId = rawListId;
          } else if (rawListId is String) {
            // Tenter de convertir en entier
            listId = int.tryParse(rawListId);
          }
          
          if (listId != null) {
            listIds.add(listId);
          }
        }

        // Recherche récursive dans tous les sous-objets
        obj.values.forEach(searchForTaxonomyFields);
      } else if (obj is List) {
        // Recherche dans les tableaux
        obj.forEach(searchForTaxonomyFields);
      }
    }

    searchForTaxonomyFields(config);
    return listIds;
  }
}
