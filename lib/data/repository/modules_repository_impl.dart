import 'package:gn_mobile_monitoring/data/datasource/interface/api/global_api.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/modules_api.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/datasets_database.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/modules_database.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/nomenclatures_database.dart';
import 'package:gn_mobile_monitoring/data/entity/dataset_entity.dart';
import 'package:gn_mobile_monitoring/data/entity/nomenclature_entity.dart';
import 'package:gn_mobile_monitoring/data/mapper/dataset_entity_mapper.dart';
import 'package:gn_mobile_monitoring/data/mapper/module_entity_mapper.dart';
import 'package:gn_mobile_monitoring/data/mapper/nomenclature_entity_mapper.dart';
import 'package:gn_mobile_monitoring/domain/model/module.dart';
import 'package:gn_mobile_monitoring/domain/repository/modules_repository.dart';

class ModulesRepositoryImpl implements ModulesRepository {
  final GlobalApi globalApi;
  final ModulesApi api;
  final ModulesDatabase database;
  final NomenclaturesDatabase nomenclaturesDatabase;
  final DatasetsDatabase datasetsDatabase;

  ModulesRepositoryImpl(this.globalApi, this.api, this.database,
      this.nomenclaturesDatabase, this.datasetsDatabase);

  @override
  Future<List<Module>> getModulesFromLocal() async {
    // Fetch from the database and return as domain models
    return await database.getAllModules();
  }

  @override
  Future<void> fetchAndSyncModulesFromApi(String token) async {
    try {
      // Fetch from API, map to domain models
      final apiModules = await api.getModules(token);
      final modules = apiModules.map((e) => e.toDomain()).toList();

      // Clear existing database entries and insert new data
      await database.clearModules();
      await database.insertModules(modules);
    } catch (e) {
      throw Exception("Failed to sync modules: ${e.toString()}");
    }
  }

  @override
  Future<void> downloadModuleData(int moduleId) async {
    try {
      // Fetch the module code using the provided module ID
      final moduleCode = await database.getModuleCodeFromIdModule(moduleId);

      final data = await globalApi.getNomenclaturesAndDatasets(moduleCode);

      // Process nomenclatures
      final nomenclatures = (data['nomenclatures'] as List<NomenclatureEntity>)
          .map((e) => e.toDomain())
          .toList();

      await nomenclaturesDatabase.clearNomenclatures();
      await nomenclaturesDatabase.insertNomenclatures(nomenclatures);

      // Process datasets
      final datasets = (data['datasets'] as List<DatasetEntity>)
          .map((e) => e.toDomain())
          .toList();

      await datasetsDatabase.clearDatasets();
      await datasetsDatabase.insertDatasets(datasets);
    } catch (e) {
      throw Exception('Failed to download module data: $e');
    }
  }
}
