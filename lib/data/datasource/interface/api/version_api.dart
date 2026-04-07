/// Interface pour récupérer la version du module monitoring depuis le serveur.
abstract class VersionApi {
  /// Récupère la version du module MONITORINGS installé sur le serveur.
  /// Retourne null si le module n'est pas trouvé ou si l'endpoint n'existe pas.
  Future<String?> fetchMonitoringVersion(String token);
}
