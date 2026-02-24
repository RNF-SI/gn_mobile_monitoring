import 'package:gn_mobile_monitoring/core/helpers/form_config_parser.dart';
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
    try {
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

      // 4. Sauvegarder chaque taxon individuellement pour éviter les erreurs de contrainte
      for (final taxon in taxons) {
        try {
          await _taxonDatabase.saveTaxon(taxon);
        } catch (e) {
          print('Erreur lors de la sauvegarde du taxon ${taxon.cdNom}: $e');
          // Continuer avec le taxon suivant
        }
      }

      // 5. Enregistrer les associations entre les taxons et la liste
      final cdNoms = taxons.map((t) => t.cdNom).toList();
      await _taxonDatabase.saveTaxonsToList(idListTaxonomy, cdNoms);
      
      print('Taxons for module $moduleId downloaded and saved successfully.');
    } catch (e) {
      print('Error downloading taxons for module $moduleId: $e');
    }
  }

  /// Télécharge toutes les listes taxonomiques mentionnées dans la configuration
  ///
  /// Utilise la méthode unifiée FormConfigParser.extractAllTaxonomyListIds
  /// qui extrait à la fois les IDs des champs taxonomy (id_list) et
  /// le id_list_taxonomy au niveau module.
  @override
  Future<void> downloadTaxonsFromConfig(Map<String, dynamic> config) async {
    try {
      // Extraire tous les IDs de listes taxonomiques de la configuration
      // (champs taxonomy avec id_list + id_list_taxonomy au niveau module)
      final Set<int> taxonomyListIds =
          FormConfigParser.extractAllTaxonomyListIds(config);

      print(
          'downloadTaxonsFromConfig - ${taxonomyListIds.length} listes taxonomiques trouvées: $taxonomyListIds');

      // Pour chaque liste taxonomique trouvée dans la configuration
      for (final listId in taxonomyListIds) {
        try {
          // Télécharger et sauvegarder la liste
          final taxonList = await _taxonApi.getTaxonList(listId);
          await _taxonDatabase.saveTaxonLists([taxonList]);

          // Télécharger les taxons associés à cette liste
          final taxons = await _taxonApi.getTaxonsByList(listId);

          // Sauvegarder chaque taxon individuellement pour éviter les erreurs de contrainte
          for (final taxon in taxons) {
            try {
              await _taxonDatabase.saveTaxon(taxon);
            } catch (e) {
              print('Erreur lors de la sauvegarde du taxon ${taxon.cdNom}: $e');
              // Continuer avec le taxon suivant
            }
          }

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
}
