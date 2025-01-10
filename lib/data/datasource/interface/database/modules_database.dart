import 'package:gn_mobile_monitoring/domain/model/module.dart';

abstract class ModulesDatabase {
  Future<void> clearModules();
  Future<void> insertModules(List<Module> modules);
  Future<List<Module>> getAllModules();
}
