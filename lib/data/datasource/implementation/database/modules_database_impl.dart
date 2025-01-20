import 'package:gn_mobile_monitoring/data/datasource/implementation/database/db.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/modules_database.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/domain/model/module.dart';

class ModuleDatabaseImpl implements ModulesDatabase {
  Future<AppDatabase> get _database async => await DB.instance.database;

  @override
  Future<void> clearModules() async {
    final db = await _database;
    await db.tModulesDao.clearModules();
  }

  @override
  Future<void> insertModules(List<Module> modules) async {
    final db = await _database;
    await db.tModulesDao.insertModules(modules);
  }

  @override
  Future<List<Module>> getAllModules() async {
    final db = await _database;
    return await db.tModulesDao.getAllModules();
  }

  @override
  Future<String> getModuleCodeFromIdModule(int moduleId) async {
    final db = await _database;
    final module = await db.tModulesDao.getModuleById(moduleId);
    return module.moduleCode ?? ''; // Ensure non-null string
  }

  @override
  Future<void> markModuleAsDownloaded(int moduleId) async {
    final db = await _database;
    await db.tModulesDao.markModuleAsDownloaded(moduleId);
  }
}
