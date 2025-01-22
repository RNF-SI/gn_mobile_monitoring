import 'package:gn_mobile_monitoring/domain/model/module.dart';
import 'package:gn_mobile_monitoring/domain/model/module_complement.dart';

abstract class ModulesDatabase {
  // Module operations
  Future<void> clearModules();
  Future<void> insertModules(List<Module> modules);
  Future<List<Module>> getAllModules();
  Future<String> getModuleCodeFromIdModule(int moduleId);
  Future<void> markModuleAsDownloaded(int moduleId);

  // Module Complement operations
  Future<void> insertModuleComplements(
      List<ModuleComplement> moduleComplements);
  Future<ModuleComplement?> getModuleComplementById(int moduleId);
  Future<void> updateModuleComplement(ModuleComplement moduleComplement);

  // Combined operations
  Future<void> clearAllData();
  Future<void> deleteModuleWithComplement(int moduleId);
}
