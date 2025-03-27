import 'package:gn_mobile_monitoring/domain/model/observation_detail.dart';

/// Interface pour le repository de détails d'observation
abstract class ObservationDetailsRepository {
  /// Récupère tous les détails liés à une observation
  Future<List<ObservationDetail>> getObservationDetailsByObservationId(int observationId);

  /// Récupère un détail d'observation par son ID
  Future<ObservationDetail?> getObservationDetailById(int detailId);

  /// Crée ou met à jour un détail d'observation
  Future<int> saveObservationDetail(ObservationDetail detail);

  /// Supprime un détail d'observation par son ID
  Future<bool> deleteObservationDetail(int detailId);

  /// Supprime tous les détails d'une observation
  Future<bool> deleteObservationDetailsByObservationId(int observationId);
}
