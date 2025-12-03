import 'package:gn_mobile_monitoring/data/entity/permission_entity.dart';
import 'package:gn_mobile_monitoring/domain/model/permission.dart';

class PermissionMapper {
  static Permission toModel(PermissionEntity entity) {
    return Permission(
      idPermission: entity.idPermission,
      idRole: entity.idRole,
      idAction: entity.idAction,
      idModule: entity.idModule,
      idObject: entity.idObject,
      scopeValue: entity.scopeValue,
      sensitivityFilter: entity.sensitivityFilter,
    );
  }

  static PermissionEntity fromModel(Permission model) {
    return PermissionEntity(
      idPermission: model.idPermission,
      idRole: model.idRole,
      idAction: model.idAction,
      idModule: model.idModule,
      idObject: model.idObject,
      scopeValue: model.scopeValue,
      sensitivityFilter: model.sensitivityFilter,
    );
  }

  static PermissionObject toObjectModel(PermissionObjectEntity entity) {
    return PermissionObject(
      idObject: entity.idObject,
      codeObject: entity.codeObject,
      descriptionObject: entity.descriptionObject,
    );
  }

  static PermissionAction toActionModel(PermissionActionEntity entity) {
    return PermissionAction(
      idAction: entity.idAction,
      codeAction: entity.codeAction,
      descriptionAction: entity.descriptionAction,
    );
  }
}