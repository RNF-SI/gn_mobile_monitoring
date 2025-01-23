import 'package:drift/drift.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/data/db/mapper/t_module_complement_mapper.dart';
import 'package:gn_mobile_monitoring/data/db/mapper/t_module_mapper.dart';
import 'package:gn_mobile_monitoring/data/db/tables/cor_site_module.dart';
import 'package:gn_mobile_monitoring/data/db/tables/cor_sites_group_module.dart';
import 'package:gn_mobile_monitoring/data/db/tables/t_module_complements.dart';
import 'package:gn_mobile_monitoring/data/db/tables/t_modules.dart';
import 'package:gn_mobile_monitoring/domain/model/module.dart';
import 'package:gn_mobile_monitoring/domain/model/module_complement.dart';

part 'modules_dao.g.dart'; // Updated file name

@DriftAccessor(tables: [
  TModules,
  TModuleComplements,
  CorSiteModules,
  CorSitesGroupModules
])
class ModulesDao extends DatabaseAccessor<AppDatabase> with _$ModulesDaoMixin {
  ModulesDao(super.db);

  Future<List<Module>> getAllModules() async {
    final dbModules = await select(tModules).get();
    return dbModules.map((e) => e.toDomain()).toList(); // Use mapper
  }

  Future<void> insertModules(List<Module> modules) async {
    final dbEntities = modules.map((e) => e.toDatabaseEntity()).toList();
    await batch((batch) {
      batch.insertAll(tModules, dbEntities);
    });
  }

  Future<void> insertAllModules(List<TModule> modules) async {
    await batch((batch) {
      batch.insertAll(tModules, modules);
    });
  }

  Future<void> clearModules() async {
    try {
      await delete(tModules).go();
    } catch (e) {
      throw Exception("Failed to clear modules: ${e.toString()}");
    }
  }

  // New method to fetch a module by its ID
  Future<TModule> getModuleById(int moduleId) async {
    final query = select(tModules)
      ..where((tbl) => tbl.idModule.equals(moduleId));
    final result = await query.getSingleOrNull();

    if (result == null) {
      throw Exception("Module with ID $moduleId not found");
    }

    return result;
  }

  Future<void> markModuleAsDownloaded(int moduleId) async {
    await (update(tModules)..where((tbl) => tbl.idModule.equals(moduleId)))
        .write(TModulesCompanion(
      downloaded: Value(true),
    ));
  }

  Future<List<Module>> getDownloadedModules() async {
    final dbModules = await (select(tModules)
          ..where((tbl) => tbl.downloaded.equals(true)))
        .get();
    return dbModules.map((e) => e.toDomain()).toList();
  }

  // Module Complement operations
  Future<ModuleComplement?> getModuleComplementById(int moduleId) async {
    final query = select(tModuleComplements)
      ..where((tbl) => tbl.idModule.equals(moduleId));
    final result = await query.getSingleOrNull();
    return result?.toDomain();
  }

  Future<void> insertModuleComplement(ModuleComplement moduleComplement) async {
    await into(tModuleComplements).insert(moduleComplement.toDatabaseEntity());
  }

  Future<void> updateModuleComplement(ModuleComplement moduleComplement) async {
    await (update(tModuleComplements)
          ..where((tbl) => tbl.idModule.equals(moduleComplement.idModule)))
        .write(moduleComplement.toDatabaseEntity().toCompanion(true));
  }

  Future<void> updateModuleComplementConfiguration(
      int moduleId, String configuration) async {
    await (update(tModuleComplements)
          ..where((tbl) => tbl.idModule.equals(moduleId)))
        .write(TModuleComplementsCompanion(
      configuration: Value(configuration),
    ));
  }

  Future<void> deleteModuleComplement(int moduleId) async {
    await (delete(tModuleComplements)
          ..where((tbl) => tbl.idModule.equals(moduleId)))
        .go();
  }

  // Combined operations
  Future<void> deleteModuleWithComplement(int moduleId) async {
    await transaction(() async {
      await deleteModuleComplement(moduleId);
      await (delete(tModules)..where((tbl) => tbl.idModule.equals(moduleId)))
          .go();
    });
  }

  Future<void> clearAllData() async {
    await transaction(() async {
      await delete(tModuleComplements).go();
      await delete(tModules).go();
    });
  }

  // Clear CorSiteModule
  Future<void> clearCorSiteModule(int moduleId) async {
    try {
      await (delete(corSiteModules)..where((t) => t.idModule.equals(moduleId)))
          .go();
    } catch (e) {
      throw Exception("Failed to clear module sites: ${e.toString()}");
    }
  }

  // Insert CorSiteModule
  Future<void> insertCorSiteModule(List<CorSiteModule> sites) async {
    final dbEntities = sites
        .map((e) => CorSiteModulesCompanion(
              idBaseSite: Value(e.idBaseSite),
              idModule: Value(e.idModule),
            ))
        .toList();

    await batch((batch) {
      batch.insertAll(corSiteModules, dbEntities);
    });
  }

  // Clear module site groups
  Future<void> clearCorSitesGroupModules(int moduleId) async {
    try {
      await (delete(corSitesGroupModules)
            ..where((t) => t.idModule.equals(moduleId)))
          .go();
    } catch (e) {
      throw Exception("Failed to clear module site groups: ${e.toString()}");
    }
  }

  // Insert module site groups
  Future<void> insertCorSitesGroupModules(
      List<CorSitesGroupModule> siteGroups) async {
    final dbEntities = siteGroups
        .map((e) => CorSitesGroupModulesCompanion(
              idSitesGroup: Value(e.idSitesGroup),
              idModule: Value(e.idModule),
            ))
        .toList();

    await batch((batch) {
      batch.insertAll(corSitesGroupModules, dbEntities);
    });
  }
}
