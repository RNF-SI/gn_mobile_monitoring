import 'package:gn_mobile_monitoring/data/datasource/implementation/database/db.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/nomenclatures_database.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/domain/model/nomenclature.dart';

class NomenclaturesDatabaseImpl implements NomenclaturesDatabase {
  Future<AppDatabase> get _database async => await DB.instance.database;

  @override
  Future<void> clearNomenclatures() async {
    final db = await _database;
    await db.tNomenclaturesDao.clearNomenclatures();
  }

  @override
  Future<void> insertNomenclatures(List<Nomenclature> nomenclatures) async {
    final db = await _database;
    await db.tNomenclaturesDao.insertNomenclatures(nomenclatures);
  }

  @override
  Future<List<Nomenclature>> getAllNomenclatures() async {
    final db = await _database;
    return await db.tNomenclaturesDao.getAllNomenclatures();
  }
}
