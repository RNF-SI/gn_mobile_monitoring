import 'package:gn_mobile_monitoring/data/db/database.dart';

class PermissionEntity {
  final int idPermission;
  final int idRole;
  final int idAction;
  final int idModule;
  final int idObject;
  final int? scopeValue;
  final bool sensitivityFilter;

  PermissionEntity({
    required this.idPermission,
    required this.idRole,
    required this.idAction,
    required this.idModule,
    required this.idObject,
    this.scopeValue,
    required this.sensitivityFilter,
  });

  factory PermissionEntity.fromTPermission(TPermission permission) {
    return PermissionEntity(
      idPermission: permission.idPermission,
      idRole: permission.idRole,
      idAction: permission.idAction,
      idModule: permission.idModule,
      idObject: permission.idObject,
      scopeValue: permission.scopeValue,
      sensitivityFilter: permission.sensitivityFilter,
    );
  }
}

class PermissionObjectEntity {
  final int idObject;
  final String codeObject;
  final String? descriptionObject;

  PermissionObjectEntity({
    required this.idObject,
    required this.codeObject,
    this.descriptionObject,
  });

  factory PermissionObjectEntity.fromTObject(TObject object) {
    return PermissionObjectEntity(
      idObject: object.idObject,
      codeObject: object.codeObject,
      descriptionObject: object.descriptionObject,
    );
  }
}

class PermissionActionEntity {
  final int idAction;
  final String? codeAction;
  final String? descriptionAction;

  PermissionActionEntity({
    required this.idAction,
    this.codeAction,
    this.descriptionAction,
  });

  factory PermissionActionEntity.fromTAction(TAction action) {
    return PermissionActionEntity(
      idAction: action.idAction,
      codeAction: action.codeAction,
      descriptionAction: action.descriptionAction,
    );
  }
}