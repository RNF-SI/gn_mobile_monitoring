/// Interface pour récupérer les informations des applications mobiles depuis le serveur.
abstract class MobileAppApi {
  /// Appelle GET /gn_commons/t_mobile_apps?app_code=[appCode]
  /// Retourne la liste des apps sous forme de maps JSON, ou null en cas d'erreur.
  Future<List<Map<String, dynamic>>?> fetchMobileApps(
      String token, String appCode);
}
