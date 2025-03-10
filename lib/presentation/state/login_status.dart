enum LoginStatus {
  initial,
  authenticating,
  savingUserData,
  fetchingModules,
  fetchingSites,
  fetchingSiteGroups,
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
    message: 'Chargement des modules...',
  );

  static const fetchingSites = LoginStatusInfo(
    status: LoginStatus.fetchingSites,
    message: 'Chargement des sites...',
  );

  static const fetchingSiteGroups = LoginStatusInfo(
    status: LoginStatus.fetchingSiteGroups,
    message: 'Chargement des groupes de sites...',
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