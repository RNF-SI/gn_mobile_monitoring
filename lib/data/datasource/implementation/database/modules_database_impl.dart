import 'package:gn_mobile_monitoring/data/datasource/implementation/database/db.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/modules_database.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/domain/model/module.dart';

class ModulesDatabaseImpl implements ModulesDatabase {
  Future<AppDatabase> get database async {
    return await DB.instance.database;
  }

  @override
  Future<List<Module>> getModules() async {
    final db = await database;
    //  return empty list
    return [];
    // final result = await db.query('modules');
    // return result.map((json) => Module.fromJson(json)).toList();
  }
}
