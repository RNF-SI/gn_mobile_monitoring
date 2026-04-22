abstract class GetLastDismissedAppVersionUseCase {
  /// Retourne la dernière version d'APK que l'utilisateur a refusée via le
  /// bouton "Plus tard" du dialog de mise à jour, ou null s'il n'en a jamais
  /// refusé une. Persisté entre relances (issue #170).
  Future<String?> execute();
}
