import 'package:gn_mobile_monitoring/domain/model/module.dart';
import 'package:gn_mobile_monitoring/domain/model/module_complement.dart';
import 'package:gn_mobile_monitoring/domain/model/sites_group_module.dart';

abstract class ModulesDatabase {
  // Module operations
  Future<void> clearModules();
  Future<void> insertModules(List<Module> modules);
  Future<void> updateModule(Module module);
  Future<List<Module>> getAllModules();
  Future<String> getModuleCodeFromIdModule(int moduleId);
  Future<void> markModuleAsDownloaded(int moduleId);

  // Module Complement operations
  Future<void> insertModuleComplements(
      List<ModuleComplement> moduleComplements);
  Future<ModuleComplement?> getModuleComplementById(int moduleId);
  Future<ModuleComplement?> getModuleComplementByModuleCode(String moduleCode);
  Future<List<ModuleComplement>> getAllModuleComplements();
  Future<void> updateModuleComplement(ModuleComplement moduleComplement);
  Future<void> updateModuleComplementConfiguration(
      int moduleId, String configuration);

  // Combined operations
  Future<void> clearAllData();
  Future<void> deleteModuleWithComplement(int moduleId);

  // CorSiteModule operations
  Future<void> clearCorSiteModules(int moduleId);
  // Future<void> insertCorSiteModules(List<CorSiteModules> sites);

  // CorSitesGroupModule operations
  Future<void> clearSitesGroupModules(int moduleId);
  Future<void> insertSitesGroupModules(List<SitesGroupModule> siteGroups);

  // Module-Dataset relationship operations
  Future<void> associateModuleWithDataset(int moduleId, int datasetId);
  Future<List<int>> getDatasetIdsForModule(int moduleId);

  Future<List<Module>> getModules();
  Future<Module?> getModuleById(int moduleId);
  Future<Module?> getModuleIdByLabel(String moduleLabel);
}
