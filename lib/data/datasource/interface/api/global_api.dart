abstract class GlobalApi {
  Future<Map<String, dynamic>> getNomenclaturesAndDatasets(String moduleName);
  Future<Map<String, dynamic>> getModuleConfiguration(String moduleCode);
}
