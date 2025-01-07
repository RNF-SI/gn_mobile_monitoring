import 'package:gn_mobile_monitoring/data/entity/module_entity.dart';

abstract class ModulesApi {
  Future<List<ModuleEntity>> getModules(String token);
}
