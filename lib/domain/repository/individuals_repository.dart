import 'package:gn_mobile_monitoring/domain/model/individual.dart';
import 'package:gn_mobile_monitoring/domain/model/sync_result.dart';

abstract class IndividualsRepository {
  /// Fetches site groups for all modules and replaces existing data
  Future<void> fetchIndividualsAndIndividualModules(String token);

  /// Gets all site groups from local database
  Future<List<Individual>> getIndividuals();

  /// Fetches site groups for a specific module
  Future<void> fetchEnrichedIndividualsForModule(String moduleCode, String token);
}