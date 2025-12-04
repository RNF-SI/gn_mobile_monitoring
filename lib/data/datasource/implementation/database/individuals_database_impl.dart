import 'package:gn_mobile_monitoring/data/datasource/implementation/database/db.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/individuals_database.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/domain/model/individual.dart';
import 'package:gn_mobile_monitoring/domain/model/individual_module.dart';

class IndividualsDatabaseImpl implements IndividualsDatabase {
  Future<AppDatabase> get _database async => await DB.instance.database;

  @override
  Future<void> clearIndividuals() async {
    final db = await _database;
    await db.individualsDao.clearIndividuals();
  }

  @override
  Future<void> insertIndividuals(List<Individual> individuals) async {
    final db = await _database;
    await db.individualsDao.insertIndividuals(individuals);
  }
  
  @override
  Future<void> updateIndividual(Individual individuals) async {
    final db = await _database;
    await db.individualsDao.updateIndividual(individuals);
  }
  
  @override
  Future<void> deleteIndividual(int individualsId) async {
    final db = await _database;
    await db.individualsDao.deleteIndividual(individualsId);
  }

  @override
  Future<List<Individual>> getAllIndividuals() async {
    final db = await _database;
    return await db.individualsDao.getAllIndividuals();
  }

  @override
  Future<List<Individual>> getIndividualsByModuleId(int moduleId) async {
    final db = await _database;
    return await db.individualsDao.getIndividualsByModuleId(moduleId);
  }

  @override
  Future<List<IndividualModule>> getAllIndividualModules() async {
    final db = await _database;
    return await db.individualsDao.getAllIndividualModules();
  }

  @override
  Future<void> clearAllIndividualModules() async {
    final db = await _database;
    await db.individualsDao.clearIndividualModules();
  }

  @override
  Future<void> insertIndividualModules(List<IndividualModule> modules) async {
    final db = await _database;
    await db.individualsDao.insertIndividualModules(modules);
  }
  
  @override
  Future<void> deleteIndividualModule(int individualsId, int moduleId) async {
    final db = await _database;
    await db.individualsDao.deleteIndividualModule(individualsId, moduleId);
  }
  
  @override
  Future<List<IndividualModule>> getIndividualModulesByIndividualId(int individualId) async {
    final db = await _database;
    return await db.individualsDao.getIndividualModulesByIndividualId(individualId);
  }
}