/// Télécharge l'APK de mise à jour de l'application.
abstract class DownloadAppUpdateUseCase {
  /// Télécharge l'APK depuis [url] et retourne le chemin du fichier local.
  Future<String> execute(String url,
      {String? token, Function(double)? onProgress});
}
