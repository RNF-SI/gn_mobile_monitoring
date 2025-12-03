import 'package:gn_mobile_monitoring/domain/model/individual.dart';
import 'package:gn_mobile_monitoring/domain/model/sync_result.dart';

abstract class IndividualsRepository {
  /// Fetches sites for a specific module
  Future<void> fetchAllIndividuals(String token);

  /// Fetches sites for a specific module
  // Future<void> fetchIndividualsForModule(String moduleCode, String token);

  /// Récupère une individual par son ID
  Future<Individual?> getIndividualById(int individualId);

  /// Met à jour l'ID serveur d'une individual
  Future<bool> updateIndividualServerId(int localIndividualId, int serverIndividualId);
}