import 'package:gn_mobile_monitoring/domain/model/individual.dart';
import 'package:gn_mobile_monitoring/data/entity/individual_entity.dart';

abstract class IndividualsApi {
  /// Fetches individuals for a specific module with detailed information
  Future<List<IndividualEntity>> fetchAllIndividuals(
    String token);

  // /// Fetches individuals for a specific module with detailed information
  // Future<Map<String, dynamic>> fetchEnrichedIndividualsForModule(
  //   String moduleCode, String token);

  // /// Envoie un individu au serveur
  // /// Returns the created individual's server ID if successful
  // Future<Map<String, dynamic>> sendIndividual(
  //   String token,
  //   String moduleCode,
  //   Individual individual,
  // );

  // /// Met à jour un individu existant sur le serveur (PATCH)
  // /// Returns the updated individual data if successful
  // Future<Map<String, dynamic>> updateIndividual(
  //   String token,
  //   String moduleCode,
  //   int individualId,
  //   Individual individual,
  // );
}