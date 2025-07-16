import 'package:drift/drift.dart';
import '../../domain/model/permission.dart';
import '../db/database.dart';

class PermissionMapper {
  static Permission fromEntity(TModulePermission entity) {
    return Permission(
      moduleCode: entity.moduleCode,
      visits: PermissionLevel(
        create: entity.visitCreate,
        read: entity.visitRead,
        update: entity.visitUpdate,
        delete: entity.visitDelete,
      ),
      sites: PermissionLevel(
        create: entity.siteCreate,
        read: entity.siteRead,
        update: entity.siteUpdate,
        delete: entity.siteDelete,
      ),
      lastSync: entity.lastSync,
    );
  }

  static TModulePermissionsCompanion toCompanion(Permission permission) {
    return TModulePermissionsCompanion(
      moduleCode: Value(permission.moduleCode),
      visitCreate: Value(permission.visits.create),
      visitRead: Value(permission.visits.read),
      visitUpdate: Value(permission.visits.update),
      visitDelete: Value(permission.visits.delete),
      siteCreate: Value(permission.sites.create),
      siteRead: Value(permission.sites.read),
      siteUpdate: Value(permission.sites.update),
      siteDelete: Value(permission.sites.delete),
      lastSync: Value(permission.lastSync),
    );
  }
}