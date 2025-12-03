import 'package:gn_mobile_monitoring/domain/model/cruved_response.dart';

/// Interface pour les objets du monitoring qui supportent les permissions
/// Inspiré des patterns du monitoring web où chaque objet a ses permissions
abstract class MonitoringObject {
  // Données nécessaires pour le calcul des permissions d'instance
  int? get idDigitiser; // L'utilisateur qui a créé l'objet
  int? get idInventor;  // L'utilisateur qui a inventorié l'objet
  List<int> get observers; // Les observateurs de l'objet
  List<int> get organismeActors; // Les organismes liés à l'objet
  
  // Permissions CRUVED pour cet objet spécifique (vient de l'API)
  CruvedResponse? get cruved;
}

/// Mixin qui fournit des méthodes helper pour les permissions
/// Inspiré du monitoring web avec les méthodes de vérification d'instance
mixin MonitoringObjectMixin implements MonitoringObject {
  
  /// Vérifie si l'utilisateur connecté peut lire cet objet
  /// Utilise les permissions embarquées dans l'objet (pattern monitoring web)
  bool canRead() {
    return cruved?.read ?? false;
  }
  
  /// Vérifie si l'utilisateur connecté peut créer un objet de ce type
  bool canCreate() {
    return cruved?.create ?? false;
  }
  
  /// Vérifie si l'utilisateur connecté peut modifier cet objet
  bool canUpdate() {
    return cruved?.update ?? false;
  }
  
  /// Vérifie si l'utilisateur connecté peut supprimer cet objet
  bool canDelete() {
    return cruved?.delete ?? false;
  }
  
  /// Vérifie si l'utilisateur connecté peut valider cet objet
  bool canValidate() {
    return cruved?.validate ?? false;
  }
  
  /// Vérifie si l'utilisateur connecté peut exporter cet objet
  bool canExport() {
    return cruved?.export ?? false;
  }
  
  /// Vérifie si l'utilisateur connecté a un lien avec cet objet
  /// (créateur, inventeur, observateur)
  /// Inspiré de has_instance_permission du monitoring web
  bool hasInstanceRelation(int currentUserId, int currentUserOrganisme) {
    // L'utilisateur est le créateur
    if (idDigitiser == currentUserId) return true;
    
    // L'utilisateur est l'inventeur
    if (idInventor == currentUserId) return true;
    
    // L'utilisateur est un observateur
    if (observers.contains(currentUserId)) return true;
    
    // L'organisme de l'utilisateur est lié à l'objet
    if (organismeActors.contains(currentUserOrganisme)) return true;
    
    return false;
  }
  
  /// Helper pour le debug - affiche les permissions de l'objet
  String getPermissionsSummary() {
    if (cruved == null) return 'Aucune permission';
    
    final permissions = <String>[];
    if (cruved!.create) permissions.add('C');
    if (cruved!.read) permissions.add('R');
    if (cruved!.update) permissions.add('U');
    if (cruved!.validate) permissions.add('V');
    if (cruved!.export) permissions.add('E');
    if (cruved!.delete) permissions.add('D');
    
    return permissions.isEmpty ? 'Aucune permission' : permissions.join('');
  }
}