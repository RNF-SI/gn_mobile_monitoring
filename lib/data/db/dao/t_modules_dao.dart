import 'package:drift/drift.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/data/db/mapper/t_module_mapper.dart';
import 'package:gn_mobile_monitoring/data/db/tables/t_modules.dart';
import 'package:gn_mobile_monitoring/domain/model/module.dart';

part 't_modules_dao.g.dart'; // Updated file name

@DriftAccessor(tables: [TModules])
class TModulesDao extends DatabaseAccessor<AppDatabase>
    with _$TModulesDaoMixin {
  TModulesDao(super.db);

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
}
