import 'package:gn_mobile_monitoring/data/datasource/implementation/database/db.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/visites_database.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';

class VisitesDatabaseImpl implements VisitesDatabase {
  Future<AppDatabase> get _db async => await DB.instance.database;

  @override
  Future<List<TBaseVisit>> getAllVisits() async {
    final db = await _db;
    return db.visitesDao.getAllVisits();
  }

  @override
  Future<TBaseVisit> getVisitById(int id) async {
    final db = await _db;
    return db.visitesDao.getVisitById(id);
  }

  @override
  Future<int> insertVisit(TBaseVisitsCompanion visit) async {
    final db = await _db;
    return db.visitesDao.insertVisit(visit);
  }

  @override
  Future<bool> updateVisit(TBaseVisitsCompanion visit) async {
    final db = await _db;
    return db.visitesDao.updateVisit(visit);
  }

  @override
  Future<int> deleteVisit(int id) async {
    final db = await _db;
    return db.visitesDao.deleteVisit(id);
  }

  @override
  Future<TVisitComplement?> getVisitComplementById(int visitId) async {
    final db = await _db;
    return db.visitesDao.getVisitComplementById(visitId);
  }

  @override
  Future<int> insertVisitComplement(
      TVisitComplementsCompanion complement) async {
    final db = await _db;
    return db.visitesDao.insertVisitComplement(complement);
  }

  @override
  Future<bool> updateVisitComplement(
      TVisitComplementsCompanion complement) async {
    final db = await _db;
    return db.visitesDao.updateVisitComplement(complement);
  }

  @override
  Future<int> deleteVisitComplement(int visitId) async {
    final db = await _db;
    return db.visitesDao.deleteVisitComplement(visitId);
  }

  @override
  Future<void> deleteVisitWithComplement(int visitId) async {
    final db = await _db;
    return db.visitesDao.deleteVisitWithComplement(visitId);
  }
}
