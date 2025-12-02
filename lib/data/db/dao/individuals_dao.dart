import 'package:drift/drift.dart';
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
class IndividualsDao extends DatabaseAccessor<AppDatabase> with _$IndividualDaoMixin {
  IndividualsDao(super.db);

  /// Operations for TIndividuals

  // Fetch all individuals
  Future<List<Individual>> getAllIndividuals() async {
    final dbIndividuals = await select(tIndividuals).get();
    return dbIndividuals.map((e) => e.toDomain()).toList();
  }
  
  // Get individual by ID
  Future<Individual?> getIndividualById(int individualId) async {
    final query = select(tIndividuals)
      ..where((tbl) => tbl.idIndividual.equals(individualId));
    final result = await query.getSingleOrNull();
    if (result == null) return null;
    return result.toDomain();
  }

  // Insert multiple individuals
  Future<void> insertIndividuals(List<Individual> individuals) async {
    final dbEntities = individuals.map((e) => e.toDatabaseEntity()).toList();
    await batch((batch) {
      batch.insertAll(tIndividuals, dbEntities);
    });
  }

  // Update a single individual
  Future<void> updateIndividual(Individual individual) async {
    final dbEntity = individual.toDatabaseEntity();
    await update(tIndividuals).replace(dbEntity);
  }

  // Delete a single individual
  Future<void> deleteIndividual(int individualId) async {
    await (delete(tIndividuals)..where((tbl) => tbl.idIndividual.equals(individualId)))
        .go();
  }

  // Clear all individuals
  Future<void> clearIndividuals() async {
    try {
      await delete(tIndividuals).go();
    } catch (e) {
      throw Exception("Failed to clear individuals: ${e.toString()}");
    }
  }

  /// Operations for CorIndividualModuleTable

  Future<List<Individual>> getIndividualsByModuleId(int moduleId) async {
    final query = select(corIndividualModuleTable).join([
      leftOuterJoin(tIndividuals,
          tIndividuals.idIndividual.equalsExp(corIndividualModuleTable.idIndividual))
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

  Future<void> insertIndividualsModules(List<IndividualModule> modules) async {
    final dbEntities = modules.map((e) => e.toDatabaseEntity()).toList();
    await batch((batch) {
      batch.insertAll(corIndividualModuleTable, dbEntities);
    });
  }
  
  Future<void> insertIndividualModule(IndividualModule module) async {
    final dbEntity = module.toDatabaseEntity();
    await into(corIndividualModuleTable).insert(dbEntity);
  }

  Future<void> deleteIndividualModule(int individualId, int moduleId) async {
    await (delete(corIndividualModuleTable)
          ..where((tbl) =>
              tbl.idIndividual.equals(individualId) & tbl.idModule.equals(moduleId)))
        .go();
  }

  Future<void> clearIndividualsModules() async {
    try {
      await delete(corIndividualModuleTable).go();
    } catch (e) {
      throw Exception("Failed to clear individual modules: ${e.toString()}");
    }
  }
  
  Future<List<IndividualModule>> getIndividualModulesByModuleId(int moduleId) async {
    final query = select(corIndividualModuleTable)
      ..where((tbl) => tbl.idModule.equals(moduleId));
    final results = await query.get();
    return results
        .map((e) => IndividualModule(
              idIndividual: e.idIndividual,
              idModule: e.idModule,
            ))
        .toList();
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

  /// Check if a individual belongs to other modules besides the specified one
  Future<bool> individualHasOtherModuleReferences(int individualId, int excludeModuleId) async {
    final query = select(corIndividualModuleTable)
      ..where((tbl) => tbl.idIndividual.equals(individualId) & tbl.idModule.isNotValue(excludeModuleId));
    final results = await query.get();
    return results.isNotEmpty;
  }

  /// Delete a individual completely with all its related data (respects FK constraints)
  Future<void> deleteIndividualCompletely(int individualId) async {
    // Delete individual complement first (FK constraint)
    await deleteIndividualComplement(individualId);
    
    // Then delete the individual itself
    await deleteIndividual(individualId);
  }

}
