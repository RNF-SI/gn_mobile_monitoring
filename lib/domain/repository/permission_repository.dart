import '../model/permission.dart';
import '../model/user.dart';

abstract class PermissionRepository {
  Future<Permission?> getPermission(String moduleCode);
  Future<void> syncPermissions(String moduleCode);
  Future<User?> getCurrentUser();
  Future<void> clearPermissions();
  Future<List<Permission>> getAllPermissions();
}