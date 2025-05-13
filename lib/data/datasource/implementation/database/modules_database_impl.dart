import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/database/db.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/modules_database.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/domain/model/module.dart';
import 'package:gn_mobile_monitoring/domain/model/module_complement.dart';
import 'package:gn_mobile_monitoring/domain/model/sites_group_module.dart';

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
  Future<void> updateModule(Module module) async {
    final db = await _database;
    await db.modulesDao.updateModule(module);
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
  Future<ModuleComplement?> getModuleComplementByModuleCode(String moduleCode) async {
    final db = await _database;
    // Trouver d'abord le module par son code
    final module = await db.modulesDao.getModuleByCode(moduleCode);
    
    if (module == null) {
      return null;
    }
    
    // Récupérer ensuite le complément par l'ID du module
    return await db.modulesDao.getModuleComplementById(module.id);
  }

  @override
  Future<List<ModuleComplement>> getAllModuleComplements() async {
    final db = await _database;
    return await db.modulesDao.getAllModuleComplements();
  }
  
  @override
  Future<int?> getModuleTaxonomyListId(int moduleId) async {
    try {
      final db = await _database;
      return await db.modulesDao.getModuleTaxonomyListId(moduleId);
    } catch (e) {
      debugPrint('Erreur lors de la récupération de l\'ID de liste taxonomique: $e');
      return null;
    }
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

  // @override
  // Future<void> insertCorSiteModules(List<CorSiteModule> sites) async {
  //   final db = await _database;
  //   await db.modulesDao.insertCorSiteModule(sites);
  // }

  @override
  Future<void> clearSitesGroupModules(int moduleId) async {
    final db = await _database;
    await db.modulesDao.clearSitesGroupModules(moduleId);
  }

  @override
  Future<void> insertSitesGroupModules(
      List<SitesGroupModule> siteGroups) async {
    final db = await _database;
    await db.modulesDao.insertSitesGroupModules(siteGroups);
  }

  @override
  Future<Module?> getModuleById(int moduleId) async {
    final db = await _database;
    return await db.modulesDao.getModuleById(moduleId);
  }

  @override
  Future<List<Module>> getModules() async {
    final db = await _database;
    return await db.modulesDao.getAllModules();
  }

  @override
  Future<Module?> getModuleIdByLabel(String moduleLabel) async {
    final db = await _database;
    return await db.modulesDao.getModuleIdByLabel(moduleLabel);
  }
  
  @override
  Future<Module?> getModuleByCode(String moduleCode) async {
    final db = await _database;
    return await db.modulesDao.getModuleByCode(moduleCode);
  }

  // Module-Dataset relationship operations
  @override
  Future<void> associateModuleWithDataset(int moduleId, int datasetId) async {
    final db = await _database;
    await db.modulesDao.associateModuleWithDataset(moduleId, datasetId);
  }

  @override
  Future<List<int>> getDatasetIdsForModule(int moduleId) async {
    final db = await _database;
    return await db.modulesDao.getDatasetIdsForModule(moduleId);
  }
}
