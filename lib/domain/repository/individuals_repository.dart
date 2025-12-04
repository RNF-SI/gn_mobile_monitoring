import 'package:gn_mobile_monitoring/domain/model/individual.dart';
import 'package:gn_mobile_monitoring/domain/model/sync_result.dart';

abstract class IndividualsRepository {
   /// Fetches individuals for all modules and replaces existing data
  Future<void> fetchIndividualsAndIndividualModules(String token);

  /// Gets all individuals from local database
  Future<List<Individual>> getIndividuals();
  
  /// Fetches individuals for a specific module
  Future<void> fetchIndividualsForModule(String moduleCode, String token);

  /// Fetches individuals with conflict management and returns a SyncResult
  Future<SyncResult> incrementalSyncIndividualsWithConflictHandling(String token);
 }