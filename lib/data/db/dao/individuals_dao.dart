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

  // Fetch all site groups for a specific module
  Future<List<Individual>> getIndividualsByModuleId(int moduleId) async {
    // TODO: Implement this
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

  Future<List<Individual>> getGroupsByModuleId(int moduleId) async {
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
}
