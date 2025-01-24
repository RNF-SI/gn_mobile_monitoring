import 'package:gn_mobile_monitoring/data/datasource/implementation/database/db.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/modules_database.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/domain/model/module.dart';
import 'package:gn_mobile_monitoring/domain/model/module_complement.dart';

class ModuleDatabaseImpl implements ModulesDatabase {
  Future<AppDatabase> get _database async => await DB.instance.database;

  // Module operations
  @override
  Future<void> clearModules() async {
    final db = await _database;
    await db.modulesDao.clearModules();
  }

  @override
  Future<void> insertModules(List<Module> modules) async {
    final db = await _database;
    await db.modulesDao.insertModules(modules);
  }

  @override
  Future<List<Module>> getAllModules() async {
    final db = await _database;
    return await db.modulesDao.getAllModules();
  }

  @override
  Future<String> getModuleCodeFromIdModule(int moduleId) async {
    final db = await _database;
    final module = await db.modulesDao.getModuleById(moduleId);
    return module.moduleCode ?? ''; // Ensure non-null string
  }

  @override
  Future<void> markModuleAsDownloaded(int moduleId) async {
    final db = await _database;
    await db.modulesDao.markModuleAsDownloaded(moduleId);
  }

  // Module Complement operations
  @override
  Future<void> insertModuleComplements(
      List<ModuleComplement> moduleComplements) async {
    final db = await _database;
    for (var complement in moduleComplements) {
      await db.modulesDao.insertModuleComplement(complement);
    }
  }

  @override
  Future<ModuleComplement?> getModuleComplementById(int moduleId) async {
    final db = await _database;
    return await db.modulesDao.getModuleComplementById(moduleId);
  }

  @override
  Future<void> updateModuleComplement(ModuleComplement moduleComplement) async {
    final db = await _database;
    await db.modulesDao.updateModuleComplement(moduleComplement);
  }

  @override
  Future<void> updateModuleComplementConfiguration(
      int moduleId, String configuration) async {
    final db = await _database;
    await db.modulesDao
        .updateModuleComplementConfiguration(moduleId, configuration);
  }

  // Combined operations
  @override
  Future<void> clearAllData() async {
    final db = await _database;
    await db.modulesDao.clearAllData();
  }

  @override
  Future<void> deleteModuleWithComplement(int moduleId) async {
    final db = await _database;
    await db.modulesDao.deleteModuleWithComplement(moduleId);
  }

  @override
  Future<void> clearCorSiteModules(int moduleId) async {
    final db = await _database;
    await db.modulesDao.clearCorSiteModule(moduleId);
  }

  @override
  Future<void> insertCorSiteModules(List<CorSiteModule> sites) async {
    final db = await _database;
    await db.modulesDao.insertCorSiteModule(sites);
  }

  @override
  Future<void> clearCorSitesGroupModules(int moduleId) async {
    final db = await _database;
    await db.modulesDao.clearCorSitesGroupModules(moduleId);
  }

  @override
  Future<void> insertCorSitesGroupModules(
      List<CorSitesGroupModule> siteGroups) async {
    final db = await _database;
    await db.modulesDao.insertCorSitesGroupModules(siteGroups);
  }

  @override
  Future<Module?> getModuleById(int moduleId) {
    // TODO: implement getModuleById
    throw UnimplementedError();
  }

  @override
  Future<List<Module>> getModules() {
    // TODO: implement getModules
    throw UnimplementedError();
  }

  @override
  Future<Module?> getModuleIdByLabel(String moduleLabel) async {
    final db = await _database;
    return await db.modulesDao.getModuleIdByLabel(moduleLabel);
  }
}
