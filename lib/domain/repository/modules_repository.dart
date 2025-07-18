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

  /// Télécharge toutes les données d'un module depuis le serveur.
  ///
  /// Cette méthode récupère et stocke localement :
  /// - La configuration complète du module
  /// - Les datasets associés
  /// - Les nomenclatures utilisées
  /// - Les sites du module
  /// - Les groupes de sites
  /// - Les taxons (si applicables)
  ///
  /// [moduleId] L'identifiant du module à télécharger
  /// [token] Le token d'authentification pour l'API
  /// [onProgressUpdate] Callback optionnel pour suivre la progression
  /// [onStepUpdate] Callback optionnel pour informer sur l'étape en cours
  Future<void> downloadCompleteModule(
    int moduleId, 
    String token, {
    Function(double)? onProgressUpdate,
    Function(String)? onStepUpdate,
  });

  /// Récupère un module complet depuis la base de données locale avec toutes ses données.
  ///
  /// Cette méthode est la plus complète et retourne toutes les données du module :
  /// - Les informations de base du module
  /// - La configuration complète (si disponible)
  /// - Les sites associés
  /// - Les groupes de sites
  /// - Les données complémentaires
  ///
  /// Use case : Pages détaillées, écrans principaux, préparation de formulaires
  ///
  /// [moduleId] L'identifiant du module à récupérer
  ///
  /// Retourne un [Module] avec toutes ses données associées.
  /// Lève une exception si le module n'existe pas en base locale.
  Future<Module> getCompleteModule(int moduleId);

  /// Récupère uniquement les informations de base d'un module par son ID.
  ///
  /// Cette méthode est optimisée pour la performance car elle :
  /// - Ne charge que les métadonnées du module (id, code, nom, etc.)
  /// - Ne récupère PAS les sites ni groupes de sites associés
  /// - Est beaucoup plus rapide que getCompleteModule ou getModuleWithRelationsById
  ///
  /// Use case : Récupération d'attributs spécifiques, vérifications d'existence, recherches
  ///
  /// [moduleId] L'identifiant du module à récupérer
  ///
  /// Retourne un [Module] avec uniquement ses métadonnées de base.
  /// Lève une exception si le module n'existe pas en base locale.
  Future<Module> getModuleById(int moduleId);

  /// Récupère un module avec toutes ses relations (sites et groupes de sites)
  ///
  /// Cette méthode offre un compromis entre performance et complétude :
  /// - Charge le module avec ses sites et groupes de sites
  /// - Ne charge pas forcément la configuration complète détaillée
  ///
  /// Use case : Affichage des sites associés à un module, navigation entre entités reliées
  ///
  /// [moduleId] L'identifiant du module à récupérer
  ///

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
