import 'package:gn_mobile_monitoring/domain/utils/version_utils.dart';

/// Exception levée lorsque la version du module Monitoring installé sur le
/// serveur GeoNature est inférieure à la version minimale requise par l'application.
class VersionIncompatibleException implements Exception {
  /// Version détectée sur le serveur (null si indéterminée)
  final String? detectedVersion;

  /// Version minimale requise
  final MonitoringVersion requiredVersion;

  /// URL du serveur GeoNature concerné
  final String serverUrl;

  VersionIncompatibleException({
    this.detectedVersion,
    required this.requiredVersion,
    required this.serverUrl,
  });

  @override
  String toString() {
    if (detectedVersion != null) {
      return 'Le module Monitoring installé sur le serveur GeoNature '
          '($serverUrl) est en version $detectedVersion, '
          'inférieure à la version minimale requise ($requiredVersion).\n\n'
          'Veuillez mettre à jour le module Monitoring sur le serveur.';
    }
    return 'Impossible de déterminer la version du module Monitoring '
        'sur le serveur GeoNature ($serverUrl).\n\n'
        'La version minimale requise est $requiredVersion. '
        'Veuillez vérifier que le module Monitoring est installé et à jour.';
  }
}
