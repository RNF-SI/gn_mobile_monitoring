class PermissionConstants {
  // Object codes selon la structure CRUVED
  static const String monitoringModules = 'MONITORINGS_MODULES';
  static const String monitoringSites = 'MONITORINGS_SITES';
  static const String monitoringGrpSites = 'MONITORINGS_GRP_SITES';
  static const String monitoringVisites = 'MONITORINGS_VISITES';
  static const String monitoringIndividuals = 'MONITORINGS_INDIVIDUALS';
  static const String monitoringMarkings = 'MONITORINGS_MARKINGS';

  // Action codes
  static const String actionCreate = 'C';
  static const String actionRead = 'R';
  static const String actionUpdate = 'U';
  static const String actionValidate = 'V';
  static const String actionExport = 'E';
  static const String actionDelete = 'D';

  // Scopes
  static const int scopeNone = 0;
  static const int scopeMyData = 1;
  static const int scopeMyOrganisme = 2;
  static const int scopeAllData = 3;

  // Actions disponibles par objet
  static const Map<String, List<String>> objectActions = {
    monitoringModules: [actionRead, actionUpdate, actionExport],
    monitoringGrpSites: [actionCreate, actionRead, actionUpdate, actionDelete],
    monitoringSites: [actionCreate, actionRead, actionUpdate, actionDelete],
    monitoringVisites: [actionCreate, actionRead, actionUpdate, actionDelete],
    monitoringIndividuals: [actionCreate, actionRead, actionUpdate, actionDelete],
    monitoringMarkings: [actionCreate, actionRead, actionUpdate, actionDelete],
  };

  // Helper methods
  static bool isValidAction(String objectCode, String actionCode) {
    final actions = objectActions[objectCode];
    return actions?.contains(actionCode) ?? false;
  }

  static List<String> getActionsForObject(String objectCode) {
    return objectActions[objectCode] ?? [];
  }

  static String getScopeDescription(int scope) {
    switch (scope) {
      case scopeNone:
        return 'Aucun accès';
      case scopeMyData:
        return 'Mes données';
      case scopeMyOrganisme:
        return 'Mon organisme';
      case scopeAllData:
        return 'Toutes les données';
      default:
        return 'Scope inconnu';
    }
  }

  static String getActionDescription(String actionCode) {
    switch (actionCode) {
      case actionCreate:
        return 'Créer';
      case actionRead:
        return 'Consulter';
      case actionUpdate:
        return 'Modifier';
      case actionValidate:
        return 'Valider';
      case actionExport:
        return 'Exporter';
      case actionDelete:
        return 'Supprimer';
      default:
        return 'Action inconnue';
    }
  }

  static String getObjectDescription(String objectCode) {
    switch (objectCode) {
      case monitoringModules:
        return 'Modules de monitoring';
      case monitoringSites:
        return 'Sites de monitoring';
      case monitoringGrpSites:
        return 'Groupes de sites';
      case monitoringVisites:
        return 'Visites et observations';
      case monitoringIndividuals:
        return 'Individus';
      case monitoringMarkings:
        return 'Marquages';
      default:
        return 'Objet inconnu';
    }
  }
}