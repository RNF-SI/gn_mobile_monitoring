import 'package:gn_mobile_monitoring/domain/model/individual.dart';
import 'package:gn_mobile_monitoring/domain/model/individual_module.dart';

abstract class IndividualsDatabase {
  /// Methods for handling `TIndividuals`.
  Future<void> clearIndividuals();
  Future<void> insertIndividuals(List<Individual> individuals);
  Future<void> updateIndividual(Individual individual);
  Future<void> deleteIndividual(int individualId);
  Future<List<Individual>> getAllIndividuals();

  Future<List<Individual>> getIndividualsByModuleId(int moduleId);
  Future<bool> individualHasOtherModuleReferences(int individualId, int excludeModuleId);

  /// Methods for handling CorIndividualModules
  Future<void> clearAllIndividualModules();
  Future<void> insertIndividualModules(List<IndividualModule> modules);
  Future<void> deleteIndividualModule(int individualId, int moduleId);
  Future<List<IndividualModule>> getAllIndividualModules();
  Future<List<IndividualModule>> getIndividualModulesByIndividualId(int individualId);
}