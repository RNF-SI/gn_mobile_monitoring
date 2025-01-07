import 'package:gn_mobile_monitoring/data/datasource/interface/api/modules_api.dart';
import 'package:gn_mobile_monitoring/data/db/dao/t_modules_dao.dart';
import 'package:gn_mobile_monitoring/data/mapper/module_entity_mapper.dart';
import 'package:gn_mobile_monitoring/domain/model/module.dart';
import 'package:gn_mobile_monitoring/domain/repository/modules_repository.dart';

class ModulesRepositoryImpl implements ModulesRepository {
  final ModulesApi api;
  final TModulesDao dao;

  ModulesRepositoryImpl(this.api, this.dao);

  @override
  Future<List<Module>> getModulesFromLocal() async {
    return await dao.getAllModules();
  }

  @override
  Future<void> fetchAndSyncModulesFromApi(String token) async {
    final apiModules = await api.getModules(token);
    final modules = apiModules.map((e) => e.toDomain()).toList();

    await dao.clearModules(); // Efface les anciens modules
    await dao.insertModules(modules); // Insère les nouveaux
  }
}
