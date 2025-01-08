import 'package:gn_mobile_monitoring/domain/model/module.dart';

abstract class ModulesRepository {
  /// Fetches modules from the local database
  Future<List<Module>> getModulesFromLocal();

  /// Fetches modules from the API, updates the local database, and returns the updated list
  Future<void> fetchAndSyncModulesFromApi(String token);

  Future<void> downloadModuleData(int moduleId);
}
