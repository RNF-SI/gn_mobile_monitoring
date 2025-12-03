import 'package:gn_mobile_monitoring/domain/model/permission.dart';
import 'package:gn_mobile_monitoring/domain/model/user_role.dart';

/// Repository interface pour la gestion des permissions CRUVED
abstract class PermissionRepository {
  // === Gestion des permissions ===
  
  /// Récupère toutes les permissions d'un utilisateur pour un module
  Future<List<Permission>> getUserPermissions(int idRole, int idModule);
  
  /// Vérifie si un utilisateur a une permission spécifique
  Future<bool> hasPermission(
    int idRole, 
    int idModule, 
    String objectCode, 
    String actionCode
  );
  
  /// Récupère le scope d'une permission (0-3)
  Future<int> getPermissionScope(
    int idRole, 
    int idModule, 
    String objectCode, 
    String actionCode
  );
  
  /// Synchronise les permissions en base locale
  Future<void> syncPermissions(List<Permission> permissions);
  
  /// Supprime les permissions d'un utilisateur pour un module
  Future<void> clearUserPermissions(int idRole, int idModule);
  
  // === Gestion des utilisateurs ===
  
  /// Récupère l'utilisateur actuel
  Future<UserRole?> getCurrentUser();
  
  /// Définit l'utilisateur actuel
  Future<void> setCurrentUser(UserRole user);
  
  /// Supprime l'utilisateur actuel
  Future<void> clearCurrentUser();
  
  // === Objets et actions ===
  
  /// Récupère tous les objets de permission disponibles
  Future<List<PermissionObject>> getAvailableObjects();
  
  /// Récupère toutes les actions de permission disponibles
  Future<List<PermissionAction>> getAvailableActions();
}