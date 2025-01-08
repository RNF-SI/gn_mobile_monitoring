import 'package:gn_mobile_monitoring/data/datasource/implementation/database/db.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/module_database.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/domain/model/module.dart';

class ModuleDatabaseImpl implements ModuleDatabase {
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
}
