import 'package:gn_mobile_monitoring/data/datasource/implementation/database/db.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/individuals_database.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/data/entity/individual_entity.dart';
import 'package:gn_mobile_monitoring/domain/model/individual.dart';
import 'package:gn_mobile_monitoring/domain/model/individual_module.dart';

class IndividualsDatabaseImpl implements IndividualsDatabase {
  Future<AppDatabase> get _database async => await DB.instance.database;

  /// TIndividuals
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
  Future<void> updateIndividual(Individual individual) async {
    final db = await _database;
    await db.individualsDao.updateIndividual(individual);
  }
  
  @override
  Future<void> deleteIndividual(int individualId) async {
    final db = await _database;
    await db.individualsDao.deleteIndividual(individualId);
  }

  @override
  Future<List<Individual>> getAllIndividuals() async {
    final db = await _database;
    return await db.individualsDao.getAllIndividuals();
  }
  
  @override
  Future<Individual?> getIndividualById(int individualId) async {
    final db = await _database;
    return await db.individualsDao.getIndividualById(individualId);
  }

  /// CorIndividualsModules
  @override
  Future<void> clearAllIndividualModules() async {
    final db = await _database;
    await db.individualsDao.clearIndividualsModules();
  }

  @override
  Future<void> insertIndividualModules(List<IndividualModule> modules) async {
    final db = await _database;
    await db.individualsDao.insertIndividualsModules(modules);
  }
  
  @override
  Future<void> deleteIndividualModule(int individualId, int moduleId) async {
    final db = await _database;
    await db.individualsDao.deleteIndividualModule(individualId, moduleId);
  }

  @override
  Future<List<IndividualModule>> getAllIndividualModules() async {
    final db = await _database;
    return await db.individualsDao.getAllIndividualModules();
  }
  
  @override
  Future<List<Individual>> getIndividualsByModuleId(int moduleId) async {
    final db = await _database;
    return await db.individualsDao.getIndividualsByModuleId(moduleId);
  }
  
  @override
  Future<List<IndividualModule>> getIndividualModulesByIndividualId(int individualId) async {
    final db = await _database;
    return await db.individualsDao.getIndividualModulesByIndividualId(individualId);
  }
  
  @override
  Future<void> insertIndividual(Individual individual) async {
    final db = await _database;
    await db.individualsDao.insertIndividuals([individual]);
  }
  
  @override
  Future<List<IndividualModule>> getIndividualModulesByModuleId(int moduleId) async {
    final db = await _database;
    return await db.individualsDao.getIndividualModulesByModuleId(moduleId);
  }

  @override
  Future<void> insertIndividualModule(IndividualModule individualModule) async {
    final db = await _database;
    await db.individualsDao.insertIndividualModule(individualModule);
  }

  @override
  Future<bool> updateIndividualServerId(int localIndividualId, int serverIndividualId) async {
    final db = await _database;
    return await db.individualsDao.updateIndividualServerId(localIndividualId, serverIndividualId);
  }
}
