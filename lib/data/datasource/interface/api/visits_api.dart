import 'package:gn_mobile_monitoring/domain/model/base_visit.dart';

abstract class VisitsApi {
  /// Envoie une visite au serveur
  /// Returns the created visit's server ID if successful
  Future<Map<String, dynamic>> sendVisit(
    String token,
    String moduleCode,
    BaseVisit visit,
  );
}