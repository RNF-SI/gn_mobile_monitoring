import 'package:gn_mobile_monitoring/data/datasource/implementation/database/db.dart';
import 'package:gn_mobile_monitoring/data/db/dao/permission_dao.dart';
import 'package:gn_mobile_monitoring/data/db/dao/user_role_dao.dart';
import 'package:gn_mobile_monitoring/domain/model/permission.dart';
import 'package:gn_mobile_monitoring/domain/model/user_role.dart';
import 'package:gn_mobile_monitoring/domain/repository/permission_repository.dart';

class PermissionRepositoryImpl implements PermissionRepository {
  PermissionDao? _permissionDao;
  UserRoleDao? _userRoleDao;

  Future<PermissionDao> _getPermissionDao() async {
    if (_permissionDao == null) {
      final database = await DB.instance.database;
      _permissionDao = database.permissionDao;
    }
    return _permissionDao!;
  }

  Future<UserRoleDao> _getUserRoleDao() async {
    if (_userRoleDao == null) {
      final database = await DB.instance.database;
      _userRoleDao = database.userRoleDao;
    }
    return _userRoleDao!;
  }

  // === Gestion des permissions ===

  @override
  Future<List<Permission>> getUserPermissions(int idRole, int idModule) async {
    final permissionDao = await _getPermissionDao();
    return await permissionDao.getPermissionsForUser(idRole, idModule);
  }

  @override
  Future<bool> hasPermission(
    int idRole,
    int idModule,
    String objectCode,
    String actionCode,
  ) async {
    final permissionDao = await _getPermissionDao();
    return await permissionDao.hasPermission(
      idRole,
      idModule,
      objectCode,
      actionCode,
    );
  }

  @override
  Future<int> getPermissionScope(
    int idRole,
    int idModule,
    String objectCode,
    String actionCode,
  ) async {
    final permissionDao = await _getPermissionDao();
    return await permissionDao.getScope(
      idRole,
      idModule,
      objectCode,
      actionCode,
    );
  }

  @override
  Future<void> syncPermissions(List<Permission> permissions) async {
    final database = await DB.instance.database;
    final permissionDao = await _getPermissionDao();
    
    await database.transaction(() async {
      // Supprimer les anciennes permissions par utilisateur/module
      final userModulePairs = permissions
          .map((p) => {'userId': p.idRole, 'moduleId': p.idModule})
          .toSet();

      for (final pair in userModulePairs) {
        await permissionDao.clearPermissionsForUser(
          pair['userId']! as int,
          pair['moduleId']! as int,
        );
      }

      // Insérer les nouvelles permissions
      await permissionDao.insertPermissions(permissions);
    });
  }

  @override
  Future<void> clearUserPermissions(int idRole, int idModule) async {
    final permissionDao = await _getPermissionDao();
    await permissionDao.clearPermissionsForUser(idRole, idModule);
  }

  // === Gestion des utilisateurs ===

  @override
  Future<UserRole?> getCurrentUser() async {
    final userRoleDao = await _getUserRoleDao();
    return await userRoleDao.getCurrentUser();
  }

  @override
  Future<void> setCurrentUser(UserRole user) async {
    final userRoleDao = await _getUserRoleDao();
    await userRoleDao.setCurrentUser(user);
  }

  @override
  Future<void> clearCurrentUser() async {
    final userRoleDao = await _getUserRoleDao();
    await userRoleDao.clearCurrentUser();
  }

  // === Objets et actions ===

  @override
  Future<List<PermissionObject>> getAvailableObjects() async {
    final permissionDao = await _getPermissionDao();
    return await permissionDao.getAllObjects();
  }

  @override
  Future<List<PermissionAction>> getAvailableActions() async {
    final permissionDao = await _getPermissionDao();
    return await permissionDao.getAllActions();
  }
}