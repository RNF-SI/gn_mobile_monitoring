abstract class GlobalApi {
  /// Récupère les nomenclatures et datasets d'un module
  Future<Map<String, dynamic>> getNomenclaturesAndDatasets(String moduleName);
  
  /// Renvoie la configuration complète d'un module
  Future<Map<String, dynamic>> getModuleConfiguration(String moduleCode);
  
  /// Renvoie les types de sites disponibles
  Future<List<Map<String, dynamic>>> getSiteTypes();
  
  /// Renvoie un type de site par son identifiant
  Future<Map<String, dynamic>> getSiteTypeById(int idNomenclatureTypeSite);
  
  /// Renvoie un type de site par son label
  Future<Map<String, dynamic>> getSiteTypeByLabel(String label);
  
  /// Récupère les types de nomenclatures
  Future<List<Map<String, dynamic>>> getNomenclatureTypes();
  
  /// Récupère un type de nomenclature par son mnémonique
  Future<Map<String, dynamic>> getNomenclatureTypeByMnemonique(String mnemonique);
}
