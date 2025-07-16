import '../../../db/dao/permissions_dao.dart';
import '../../../mapper/permission_mapper.dart';
import '../../../../domain/model/permission.dart';
import '../../interface/permission_db_datasource.dart';

class PermissionDbImpl implements PermissionDbDataSource {
  final PermissionsDao permissionsDao;

  PermissionDbImpl({required this.permissionsDao});

  @override
  Future<Permission?> getPermissionByModuleCode(String moduleCode) async {
    final entity = await permissionsDao.getPermissionByModuleCode(moduleCode);
    return entity != null ? PermissionMapper.fromEntity(entity) : null;
  }

  @override
  Future<List<Permission>> getAllPermissions() async {
    final entities = await permissionsDao.getAllPermissions();
    return entities.map((entity) => PermissionMapper.fromEntity(entity)).toList();
  }

  @override
  Future<void> savePermission(Permission permission) async {
    final companion = PermissionMapper.toCompanion(permission);
    await permissionsDao.insertOrUpdatePermission(companion);
  }

  @override
  Future<void> deletePermission(String moduleCode) async {
    await permissionsDao.deletePermission(moduleCode);
  }

  @override
  Future<void> deleteAllPermissions() async {
    await permissionsDao.deleteAllPermissions();
  }
}