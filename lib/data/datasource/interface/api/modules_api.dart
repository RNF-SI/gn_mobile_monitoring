import 'package:gn_mobile_monitoring/data/entity/cor_site_module_entity.dart';
import 'package:gn_mobile_monitoring/data/entity/module_complement_entity.dart';
import 'package:gn_mobile_monitoring/data/entity/module_entity.dart';

abstract class ModulesApi {
  Future<(List<ModuleEntity>, List<ModuleComplementEntity>)> getModules(
      String token);
  Future<List<CorSiteModuleEntity>> getCorSiteModules(
      String token, String moduleCode);
}
