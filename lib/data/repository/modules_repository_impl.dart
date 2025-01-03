import 'package:gn_mobile_monitoring/data/datasource/interface/api/modules_api.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/modules_database.dart';
import 'package:gn_mobile_monitoring/data/mapper/module_mapper.dart';
import 'package:gn_mobile_monitoring/domain/model/module.dart';
import 'package:gn_mobile_monitoring/domain/repository/modules_repository.dart';

class ModulesRepositoryImpl implements ModulesRepository {
  final ModulesApi api;
  final ModulesDatabase db;

  const ModulesRepositoryImpl(this.api, this.db);

  @override
  Future<List<Module>> getModulesFromLocal() async {
    try {
      // Fetch modules from the local database
      return await db.getModules();
    } catch (e) {
      print("Error in getModulesFromLocal: $e");
      rethrow;
    }
  }

  @override
  Future<List<Module>> fetchAndSyncModulesFromApi() async {
    try {
      // Fetch modules from the API
      final apiModules = await api.getModules();

      // Map API response to domain models
      final modules = apiModules.map(ModuleMapper.toDomain).toList();

      // Save modules to the local database
      await db.saveModules(modules);

      return modules;
    } catch (e) {
      print("Error in fetchAndSyncModulesFromApi: $e");
      rethrow;
    }
  }
}
