abstract class SetLastDismissedAppVersionUseCase {
  /// Persiste la version d'APK que l'utilisateur vient de refuser via le
  /// bouton "Plus tard" du dialog de mise à jour (issue #170).
  Future<void> execute(String versionCode);
}
