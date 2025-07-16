import '../../../domain/model/permission.dart';

abstract class PermissionApiDataSource {
  Future<Permission> getPermissions(String moduleCode);
}