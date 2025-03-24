import 'package:gn_mobile_monitoring/domain/model/module.dart';

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
}
