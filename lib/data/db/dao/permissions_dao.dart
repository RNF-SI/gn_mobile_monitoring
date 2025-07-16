import 'package:drift/drift.dart';
import '../database.dart';
import '../tables/t_module_permissions.dart';

part 'permissions_dao.g.dart';

@DriftAccessor(tables: [TModulePermissions])
class PermissionsDao extends DatabaseAccessor<AppDatabase>
    with _$PermissionsDaoMixin {
  PermissionsDao(AppDatabase db) : super(db);

  Future<TModulePermission?> getPermissionByModuleCode(String moduleCode) {
    return (select(tModulePermissions)
          ..where((tbl) => tbl.moduleCode.equals(moduleCode)))
        .getSingleOrNull();
  }

  Future<List<TModulePermission>> getAllPermissions() {
    return select(tModulePermissions).get();
  }

  Future<int> insertOrUpdatePermission(TModulePermissionsCompanion permission) {
    return into(tModulePermissions).insertOnConflictUpdate(permission);
  }

  Future<int> deletePermission(String moduleCode) {
    return (delete(tModulePermissions)
          ..where((tbl) => tbl.moduleCode.equals(moduleCode)))
        .go();
  }

  Future<int> deleteAllPermissions() {
    return delete(tModulePermissions).go();
  }
}