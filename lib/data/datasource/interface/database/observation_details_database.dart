import 'package:gn_mobile_monitoring/data/entity/observation_detail_entity.dart';

/// Interface pour l'accès aux données des détails d'observation dans la base de données
abstract class ObservationDetailsDatabase {
  /// Récupère tous les détails d'une observation par son ID
  Future<List<ObservationDetailEntity>> getObservationDetailsByObservationId(int observationId);

  /// Récupère un détail d'observation par son ID
  Future<ObservationDetailEntity?> getObservationDetailById(int detailId);

  /// Insère ou met à jour un détail d'observation
  Future<int> saveObservationDetail(ObservationDetailEntity detail);

  /// Supprime un détail d'observation par son ID
  Future<int> deleteObservationDetail(int detailId);

  /// Supprime tous les détails d'une observation par l'ID de l'observation
  Future<int> deleteObservationDetailsByObservationId(int observationId);
}
