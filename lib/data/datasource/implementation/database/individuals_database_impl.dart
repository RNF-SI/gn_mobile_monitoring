import 'package:gn_mobile_monitoring/data/datasource/implementation/database/db.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/individuals_database.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/domain/model/individual.dart';
import 'package:gn_mobile_monitoring/domain/model/individual_module.dart';

class IndividualsDatabaseImpl implements IndividualsDatabase {
  Future<AppDatabase> get _database async => await DB.instance.database;

  // @override
  // Future<void> clearIndividuals() async {
  //   // final db = await _database;
  //   // await db.individualsDao.clearIndividual();
  // }

  // @override
  // Future<void> insertIndividuals(List<Individual> individualGroups) async {
  //   // final db = await _database;
  //   // await db.individualsDao.insertGroups(individualGroups);
  // }
  
  // @override
  // Future<void> updateIndividual(Individual individualGroup) async {
  //   // final db = await _database;
  //   // await db.individualsDao.updateIndividual(individualGroup);
  // }
  
  // @override
  // Future<void> deleteIndividual(int individualGroupId) async {
  //   // final db = await _database;
  //   // await db.individualsDao.deleteIndividual(individualGroupId);
  // }

  @override
  Future<List<Individual>> getAllIndividuals() async {
    final db = await _database;
    return await db.individualsDao.getAllIndividuals();
    // return [];
  }

  // @override
  // Future<List<Individual>> getIndividualsForModule(int moduleId) async {
  //   // final db = await _database;
  //   // return await db.individualsDao.getGroupsForModule(moduleId);
  //   return [];
  // }

  // @override
  // Future<void> clearAllIndividualModules() async {
  //   // final db = await _database;
  //   // await db.individualsDao.clearIndividualModules();
  // }

  // @override
  // Future<void> insertIndividualModules(List<IndividualModule> modules) async {
  //   // final db = await _database;
  //   // await db.individualsDao.insertIndividualModules(modules);
  // }
  
  // @override
  // Future<void> deleteIndividualModule(int individualGroupId, int moduleId) async {
  //   // final db = await _database;
  //   // await db.individualsDao.deleteIndividualModule(individualGroupId, moduleId);
  // }
  
  // @override
  // Future<List<IndividualModule>> getAllIndividualModules() async {
  //   // final db = await _database;
  //   // return await db.individualsDao.getAllIndividualModules();
  //   return [];
  // }

  // @override
  // Future<List<Individual>> getIndividualsByModuleId(int moduleId) async {
  //   // final db = await _database;
  //   // return await db.individualsDao.getGroupsByModuleId(moduleId);
  //   return [];
  // }
  
  // @override
  // Future<List<IndividualModule>> getIndividualModulesByIndividualId(int individualGroupId) async {
  //   // final db = await _database;
  //   // return await db.individualsDao.getIndividualModulesByIndividualId(individualId);
  //   return [];
  // }


}
