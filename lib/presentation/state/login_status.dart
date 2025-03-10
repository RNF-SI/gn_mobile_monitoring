enum LoginStatus {
  initial,
  authenticating,
  savingUserData,
  // Full replacement sync
  fetchingModules,
  fetchingSites,
  fetchingSiteGroups,
  // Incremental sync
  incrementalSyncModules,
  incrementalSyncSites,
  incrementalSyncSiteGroups,
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

  static const fetchingSites = LoginStatusInfo(
    status: LoginStatus.fetchingSites,
    message: 'Chargement initial des sites...',
  );

  static const fetchingSiteGroups = LoginStatusInfo(
    status: LoginStatus.fetchingSiteGroups,
    message: 'Chargement initial des groupes de sites...',
  );
  
  static const incrementalSyncModules = LoginStatusInfo(
    status: LoginStatus.incrementalSyncModules,
    message: 'Synchronisation des modules...',
  );
  
  static const incrementalSyncSites = LoginStatusInfo(
    status: LoginStatus.incrementalSyncSites,
    message: 'Synchronisation des sites...',
  );
  
  static const incrementalSyncSiteGroups = LoginStatusInfo(
    status: LoginStatus.incrementalSyncSiteGroups,
    message: 'Synchronisation des groupes de sites...',
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