import 'package:gn_mobile_monitoring/data/entity/dataset_entity.dart';
import 'package:gn_mobile_monitoring/data/entity/nomenclature_entity.dart';
import 'package:gn_mobile_monitoring/domain/model/sync_result.dart';

abstract class GlobalApi {
  /// Récupère les nomenclatures et datasets d'un module
  Future<
      ({
        List<NomenclatureEntity> nomenclatures,
        List<DatasetEntity> datasets,
        List<Map<String, dynamic>> nomenclatureTypes
      })> getNomenclaturesAndDatasets(String moduleName);

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
  Future<Map<String, dynamic>> getNomenclatureTypeByMnemonique(
      String mnemonique);

  // Methods added for synchronization

  /// Vérifie la connectivité avec le serveur
  Future<bool> checkConnectivity();

  /// Récupère les nomenclatures modifiées depuis la dernière synchronisation
  @Deprecated('Use syncNomenclaturesAndDatasets instead')
  Future<SyncResult> syncNomenclatures(String token, List<String> moduleCodes,
      {DateTime? lastSync});

  /// Récupère et synchronise la configuration globale du serveur
  Future<SyncResult> syncConfiguration(String token, List<String> moduleCodes);

  /// Récupère et synchronise les datasets des modules
  @Deprecated('Use syncNomenclaturesAndDatasets instead')
  Future<SyncResult> syncDatasets(String token, List<String> moduleCodes);

  /// Récupère et synchronise à la fois les nomenclatures et les datasets des modules
  Future<SyncResult> syncNomenclaturesAndDatasets(
    String token,
    List<String> moduleCodes, {
    DateTime? lastSync,
  });
}
