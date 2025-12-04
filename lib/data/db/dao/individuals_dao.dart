import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/data/db/mapper/cor_individual_module_mapper.dart';
import 'package:gn_mobile_monitoring/data/db/mapper/t_individual_mapper.dart';
import 'package:gn_mobile_monitoring/data/db/tables/cor_individual_module.dart';
import 'package:gn_mobile_monitoring/data/db/tables/t_individuals.dart';
import 'package:gn_mobile_monitoring/domain/model/individual.dart';
import 'package:gn_mobile_monitoring/domain/model/individual_module.dart';

part 'individuals_dao.g.dart';

@DriftAccessor(tables: [
  TIndividuals,
  CorIndividualModuleTable
])
class IndividualsDao extends DatabaseAccessor<AppDatabase> with _$IndividualsDaoMixin {
  IndividualsDao(super.db);

  /// Operations for TIndividuals

  // Clear all site groups
  Future<void> clearIndividuals() async {
    try {
      await delete(tIndividuals).go();
    } catch (e) {
      throw Exception("Failed to clear individuals: ${e.toString()}");
    }
  }

  // Insert multiple site groups
  Future<void> insertIndividuals(List<Individual> groups) async {
    final dbEntities = groups.map((e) => e.toDatabaseEntity()).toList();
    await batch((batch) {
      batch.insertAll(tIndividuals, dbEntities);
    });
  }

  // Update a single site group
  Future<void> updateIndividual(Individual individual) async {
    final dbEntity = individual.toDatabaseEntity();
    await update(tIndividuals).replace(dbEntity);
  }

  // Delete a single site group
  Future<void> deleteIndividual(int individualId) async {
    await (delete(tIndividuals)
          ..where((tbl) => tbl.idIndividual.equals(individualId)))
        .go();
  }

  // Fetch all individuals
  Future<List<Individual>> getAllIndividuals() async {
    final dbIndividuals = await select(tIndividuals).get();
    return dbIndividuals.map((e) => e.toDomain()).toList();
  }

  // Fetch all site groups for a specific module
  Future<List<Individual>> getIndividualsByModuleId(int moduleId) async {
    final query = select(corIndividualModuleTable).join([
      leftOuterJoin(
          tIndividuals,
          tIndividuals.idIndividual
              .equalsExp(corIndividualModuleTable.idIndividual))
    ]);
    query.where(corIndividualModuleTable.idModule.equals(moduleId));
    final results = await query.map((row) => row.readTable(tIndividuals)).get();
    return results.map((e) => e.toDomain()).toList();
  }

  Future<List<IndividualModule>> getAllIndividualModules() async {
    final results = await select(corIndividualModuleTable).get();
    return results
        .map((e) => IndividualModule(
              idIndividual: e.idIndividual,
              idModule: e.idModule,
            ))
        .toList();
  }

  Future<void> clearIndividualModules() async {
    try {
      await delete(corIndividualModuleTable).go();
    } catch (e) {
      throw Exception("Failed to clear site group modules: ${e.toString()}");
    }
  }

  Future<void> insertIndividualModules(List<IndividualModule> modules) async {
    final dbEntities = modules.map((e) => e.toDatabaseEntity()).toList();
    await batch((batch) {
      batch.insertAll(corIndividualModuleTable, dbEntities);
    });
  }

  Future<void> deleteIndividualModule(int individualId, int moduleId) async {
    await (delete(corIndividualModuleTable)
          ..where((tbl) =>
              tbl.idIndividual.equals(individualId) &
              tbl.idModule.equals(moduleId)))
        .go();
  }
  
  Future<List<IndividualModule>> getIndividualModulesByIndividualId(int individualId) async {
    final query = select(corIndividualModuleTable)
      ..where((tbl) => tbl.idIndividual.equals(individualId));
    final results = await query.get();
    return results
        .map((e) => IndividualModule(
              idIndividual: e.idIndividual,
              idModule: e.idModule,
            ))
        .toList();
  }
}