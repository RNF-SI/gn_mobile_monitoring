import 'package:gn_mobile_monitoring/domain/model/module.dart';

abstract class ModuleDatabase {
  Future<void> clearModules();
  Future<void> insertModules(List<Module> modules);
  Future<List<Module>> getAllModules();
}
