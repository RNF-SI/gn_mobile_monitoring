import 'package:drift/drift.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/data/db/mapper/permission_mapper.dart';
import 'package:gn_mobile_monitoring/data/db/tables/t_actions.dart';
import 'package:gn_mobile_monitoring/data/db/tables/t_objects.dart';
import 'package:gn_mobile_monitoring/data/db/tables/t_permissions.dart';
import 'package:gn_mobile_monitoring/data/db/tables/t_user_roles.dart';
import 'package:gn_mobile_monitoring/data/entity/permission_entity.dart';
import 'package:gn_mobile_monitoring/domain/model/permission.dart';

part 'permission_dao.g.dart';

@DriftAccessor(tables: [TPermissions, TObjects, TActions, TUserRoles])
class PermissionDao extends DatabaseAccessor<AppDatabase>
    with _$PermissionDaoMixin {
  PermissionDao(AppDatabase attachedDatabase) : super(attachedDatabase);

  Future<List<Permission>> getPermissionsForUser(int idRole, int idModule) async {
    final query = select(tPermissions)
      ..where((p) => p.idRole.equals(idRole))
      ..where((p) => p.idModule.equals(idModule));

    final permissions = await query.get();
    return permissions
        .map((p) => PermissionMapper.toModel(
            PermissionEntity.fromTPermission(p)))
        .toList();
  }

  Future<Permission?> getPermissionForAction(
      int idRole, int idModule, String objectCode, String actionCode) async {
    
    final objectQuery = select(tObjects)
      ..where((o) => o.codeObject.equals(objectCode));
    final object = await objectQuery.getSingleOrNull();
    
    final actionQuery = select(tActions)
      ..where((a) => a.codeAction.equals(actionCode));
    final action = await actionQuery.getSingleOrNull();

    if (object == null || action == null) return null;

    final permissionQuery = select(tPermissions)
      ..where((p) => p.idRole.equals(idRole))
      ..where((p) => p.idModule.equals(idModule))
      ..where((p) => p.idObject.equals(object.idObject))
      ..where((p) => p.idAction.equals(action.idAction));

    final permission = await permissionQuery.getSingleOrNull();
    return permission != null
        ? PermissionMapper.toModel(PermissionEntity.fromTPermission(permission))
        : null;
  }

  Future<int> getScope(
      int idRole, int idModule, String objectCode, String actionCode) async {
    final permission = await getPermissionForAction(
        idRole, idModule, objectCode, actionCode);
    return permission?.scopeValue ?? 0;
  }

  Future<bool> hasPermission(
      int idRole, int idModule, String objectCode, String actionCode) async {
    final scope = await getScope(idRole, idModule, objectCode, actionCode);
    return scope > 0;
  }

  Future<void> insertPermission(Permission permission) async {
    await into(tPermissions).insert(TPermissionsCompanion(
      idRole: Value(permission.idRole),
      idAction: Value(permission.idAction),
      idModule: Value(permission.idModule),
      idObject: Value(permission.idObject),
      scopeValue: Value(permission.scopeValue),
      sensitivityFilter: Value(permission.sensitivityFilter),
    ));
  }

  Future<void> insertPermissions(List<Permission> permissions) async {
    await batch((batch) {
      for (final permission in permissions) {
        batch.insert(
            tPermissions,
            TPermissionsCompanion(
              idRole: Value(permission.idRole),
              idAction: Value(permission.idAction),
              idModule: Value(permission.idModule),
              idObject: Value(permission.idObject),
              scopeValue: Value(permission.scopeValue),
              sensitivityFilter: Value(permission.sensitivityFilter),
            ));
      }
    });
  }

  Future<void> clearPermissionsForUser(int idRole, int idModule) async {
    await (delete(tPermissions)
          ..where((p) => p.idRole.equals(idRole))
          ..where((p) => p.idModule.equals(idModule)))
        .go();
  }

  Future<List<PermissionObject>> getAllObjects() async {
    final objects = await select(tObjects).get();
    return objects
        .map((o) => PermissionMapper.toObjectModel(
            PermissionObjectEntity.fromTObject(o)))
        .toList();
  }

  Future<List<PermissionAction>> getAllActions() async {
    final actions = await select(tActions).get();
    return actions
        .map((a) => PermissionMapper.toActionModel(
            PermissionActionEntity.fromTAction(a)))
        .toList();
  }
}