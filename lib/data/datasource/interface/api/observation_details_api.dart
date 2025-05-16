import 'package:gn_mobile_monitoring/domain/model/observation_detail.dart';

abstract class ObservationDetailsApi {
  /// Envoie un détail d'observation au serveur
  /// Returns the created observation detail's server ID if successful
  Future<Map<String, dynamic>> sendObservationDetail(
    String token,
    String moduleCode,
    ObservationDetail detail,
  );
}