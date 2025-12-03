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
  /// A RESOUDRE DEMAIN

  Future<List<Individual>> getIndividualsByModuleId(int moduleId) async {
  //   final query = select(corIndividualModuleTable).join([
  //     leftOuterJoin(tIndividuals,
  //         tIndividuals.idIndividual.equalsExp(corIndividualModuleTable.idIndividual))
  //   ]);
  //   query.where(corIndividualModuleTable.idModule.equals(moduleId));
  //   final results = await query.map((row) => row.readTable(tIndividuals)).get();
  //   return results.map((e) => e.toDomain()).toList();
    return [];
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

  /// Met à jour l'ID serveur d'une individual
  Future<bool> updateIndividualServerId(int localIndividualId, int serverIndividualId) async {
    debugPrint('🔄 [INDIVIDUAL_DAO] DÉBUT mise à jour ID serveur: local=$localIndividualId, serveur=$serverIndividualId');
    
    // Vérifier que l'individual existe avant la mise à jour
    final existingIndividual = await (select(tIndividuals)
      ..where((tbl) => tbl.idIndividual.equals(localIndividualId)))
      .getSingleOrNull();
    
    if (existingIndividual == null) {
      debugPrint('❌ [INDIVIDUAL_DAO] Individual $localIndividualId introuvable pour mise à jour ID serveur');
      return false;
    }
    
    debugPrint('✅ [INDIVIDUAL_DAO] Individual trouvée: ID=${existingIndividual.idIndividual}, currentServerID=${existingIndividual.serverIndividualId}');
    
    final updated = await (update(tIndividuals)
      ..where((tbl) => tbl.idIndividual.equals(localIndividualId)))
      .write(TIndividualsCompanion(
        serverIndividualId: Value(serverIndividualId),
      ));
    
    debugPrint('🔄 [INDIVIDUAL_DAO] Résultat mise à jour: $updated lignes affectées');
    
    // Vérifier que la mise à jour a bien fonctionné
    final updatedIndividual = await (select(tIndividuals)
      ..where((tbl) => tbl.idIndividual.equals(localIndividualId)))
      .getSingleOrNull();
    
    if (updatedIndividual != null) {
      debugPrint('✅ [INDIVIDUAL_DAO] Vérification: serverIndividualId après mise à jour = ${updatedIndividual.serverIndividualId}');
    }
    
    return updated > 0;
  }

}
