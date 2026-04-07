import 'package:gn_mobile_monitoring/domain/model/mobile_app_version.dart';

/// Interface du repository de mise à jour de l'application.
abstract class AppUpdateRepository {
  /// Récupère les informations de l'app MONITORING depuis le serveur.
  /// Retourne null si non trouvée ou endpoint indisponible.
  Future<MobileAppVersion?> fetchRemoteAppVersion(String token);

  /// Télécharge l'APK depuis [url] vers un fichier local.
  /// [onProgress] rapporte la progression de 0.0 à 1.0.
  /// Retourne le chemin du fichier APK téléchargé.
  Future<String> downloadApk(String url,
      {String? token, Function(double)? onProgress});
}
