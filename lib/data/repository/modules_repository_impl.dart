import 'package:gn_mobile_monitoring/data/datasource/interface/api/modules_api.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/modules_database.dart';
import 'package:gn_mobile_monitoring/data/mapper/module_entity_mapper.dart';
import 'package:gn_mobile_monitoring/domain/model/module.dart';
import 'package:gn_mobile_monitoring/domain/repository/modules_repository.dart';

class ModulesRepositoryImpl implements ModulesRepository {
  final ModulesApi api;
  final ModulesDatabase database;

  ModulesRepositoryImpl(this.api, this.database);

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
    // Fetch module data from API and save to database
    // final apiModuleData = await api.getModuleData(moduleId);
    // final moduleData = apiModuleData.toDomain();
    // await database.insertModuleData(moduleData);
  }
}
