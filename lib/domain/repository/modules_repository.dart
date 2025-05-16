import 'package:gn_mobile_monitoring/domain/model/dataset.dart';
import 'package:gn_mobile_monitoring/domain/model/module.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/domain/model/nomenclature.dart';

abstract class ModulesRepository {
  /// Fetches modules from the local database
  Future<List<Module>> getModulesFromLocal();

  /// Fetches modules from the API, clears the local database, and inserts all new data
  Future<void> fetchAndSyncModulesFromApi(String token);

  /// Fetches modules from the API and adds only new modules without clearing existing ones
  Future<void> incrementalSyncModulesFromApi(String token);

  /// Downloads additional data for a specific module
  Future<void> downloadModuleData(int moduleId);

  /// Récupère un module avec sa configuration complète
  /// Retourne un Future qui complète seulement lorsque la configuration est disponible
  /// Si la configuration n'est pas disponible, retourne un Module avec les données initiales
  /// Si la configuration est disponible, retourne un Module avec les données complètes
  /// Si la configuration n'est pas disponible, retourne un Module avec les données initiales
  Future<Module> getModuleWithConfig(int moduleId);
  
  /// Récupère un module par son code
  Future<Module?> getModuleByCode(String moduleCode);
  
  /// Récupère l'ID de la liste taxonomique associée à un module
  Future<int?> getModuleTaxonomyListId(int moduleId);
  
  /// Récupère les identifiants de datasets associés à un module
  Future<List<int>> getDatasetIdsForModule(int moduleId);
  
  /// Récupère les datasets par leurs identifiants
  Future<List<Dataset>> getDatasetsByIds(List<int> datasetIds);
  
  /// Récupère toutes les nomenclatures stockées localement
  Future<List<Nomenclature>> getNomenclatures();
  
  /// Récupère le mapping entre les codes de type de nomenclature et leurs identifiants
  /// Par exemple: {'TYPE_MEDIA': 117, 'TYPE_SITE': 116}
  Future<Map<String, int>> getNomenclatureTypeMapping();
  
  /// Récupère l'ID du type de nomenclature à partir de sa mnémonique
  /// Retourne null si la mnémonique n'est pas trouvée
  Future<int?> getNomenclatureTypeIdByMnemonique(String mnemonique);
  
  /// Récupère la configuration complète d'un module
  Future<ModuleConfiguration> getModuleConfiguration(String moduleCode);
}
