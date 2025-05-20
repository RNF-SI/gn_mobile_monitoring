enum LoginStatus {
  initial,
  authenticating,
  savingUserData,
  // Module sync only (sites are now downloaded with each module)
  fetchingModules,
  incrementalSyncModules,
  complete,
  error
}

class LoginStatusInfo {
  final LoginStatus status;
  final String message;
  final String? errorDetails;

  const LoginStatusInfo({
    required this.status,
    required this.message,
    this.errorDetails,
  });

  static const initial = LoginStatusInfo(
    status: LoginStatus.initial,
    message: 'Prêt',
  );

  static const authenticating = LoginStatusInfo(
    status: LoginStatus.authenticating,
    message: 'Authentification...',
  );

  static const savingUserData = LoginStatusInfo(
    status: LoginStatus.savingUserData,
    message: 'Sauvegarde des données utilisateur...',
  );

  static const fetchingModules = LoginStatusInfo(
    status: LoginStatus.fetchingModules,
    message: 'Chargement initial des modules...',
  );

  static const incrementalSyncModules = LoginStatusInfo(
    status: LoginStatus.incrementalSyncModules,
    message: 'Synchronisation des modules...',
  );

  static const complete = LoginStatusInfo(
    status: LoginStatus.complete,
    message: 'Connexion réussie',
  );

  factory LoginStatusInfo.error(String details) => LoginStatusInfo(
        status: LoginStatus.error,
        message: 'Erreur de connexion',
        errorDetails: details,
      );
}