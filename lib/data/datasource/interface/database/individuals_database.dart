import 'package:gn_mobile_monitoring/domain/model/individual.dart';
import 'package:gn_mobile_monitoring/domain/model/individual_module.dart';
import 'package:gn_mobile_monitoring/data/entity/individual_entity.dart';

abstract class IndividualsDatabase {
  /// Methods for handling `TIndividuals`.
  Future<void> clearIndividuals();
  Future<void> insertIndividuals(List<Individual> individuals);
  Future<void> updateIndividual(Individual individual);
  Future<void> deleteIndividual(int individualId);
  Future<List<Individual>> getAllIndividuals();

  /// Methods for handling CorIndividualsModules
  Future<void> clearAllIndividualModules();
  Future<void> insertIndividualModules(List<IndividualModule> modules);
  Future<void> deleteIndividualModule(int individualId, int moduleId);
  Future<List<IndividualModule>> getAllIndividualModules();
  Future<List<Individual>> getIndividualsByModuleId(int moduleId);
  Future<List<IndividualModule>> getIndividualModulesByIndividualId(int individualId);
  
  /// Insert a single individual
  Future<void> insertIndividual(Individual individual);

  /// Get individual modules by module ID
  Future<List<IndividualModule>> getIndividualModulesByModuleId(int moduleId);
  
  /// Insert a single individual-module relationship
  Future<void> insertIndividualModule(IndividualModule individualModule);
  
  /// Get a individual by its ID
  Future<Individual?> getIndividualById(int individualId);

  /// Met à jour l'ID serveur d'un individu
  Future<bool> updateIndividualServerId(int localIndividualId, int serverIndividualId);
}
