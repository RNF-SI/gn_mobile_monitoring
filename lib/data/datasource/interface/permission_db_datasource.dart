import '../../../domain/model/permission.dart';

abstract class PermissionDbDataSource {
  Future<Permission?> getPermissionByModuleCode(String moduleCode);
  Future<List<Permission>> getAllPermissions();
  Future<void> savePermission(Permission permission);
  Future<void> deletePermission(String moduleCode);
  Future<void> deleteAllPermissions();
}