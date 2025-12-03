import 'package:gn_mobile_monitoring/domain/model/cruved_response.dart';

/// Interface simplifiée pour les objets qui ont des permissions CRUVED
abstract class CruvedObject {
  CruvedResponse? get cruved;
}

/// Mixin qui fournit les méthodes helper pour vérifier les permissions
mixin CruvedObjectMixin implements CruvedObject {
  // Méthodes pour vérifier les permissions individuelles
  bool canCreate() => cruved?.create ?? false;
  bool canRead() => cruved?.read ?? false;
  bool canUpdate() => cruved?.update ?? false;
  bool canDelete() => cruved?.delete ?? false;
  bool canValidate() => cruved?.validate ?? false;
  bool canExport() => cruved?.export ?? false;
  
  /// Retourne un résumé des permissions sous forme de string
  /// Par exemple: "CRUD" si l'utilisateur peut Create, Read, Update, Delete
  /// ou "R" si l'utilisateur peut seulement lire
  String getPermissionsSummary() {
    if (cruved == null) return '-';
    
    final summary = StringBuffer();
    if (cruved!.create) summary.write('C');
    if (cruved!.read) summary.write('R');
    if (cruved!.update) summary.write('U');
    if (cruved!.delete) summary.write('D');
    if (cruved!.validate) summary.write('V');
    if (cruved!.export) summary.write('E');
    
    return summary.isEmpty ? '-' : summary.toString();
  }
  
  /// Vérifie si au moins une permission est accordée
  bool hasAnyPermission() {
    if (cruved == null) return false;
    return cruved!.create || 
           cruved!.read || 
           cruved!.update || 
           cruved!.delete || 
           cruved!.validate || 
           cruved!.export;
  }
  
  /// Vérifie si toutes les permissions CRUD sont accordées
  bool hasFullCRUD() {
    if (cruved == null) return false;
    return cruved!.create && 
           cruved!.read && 
           cruved!.update && 
           cruved!.delete;
  }
}