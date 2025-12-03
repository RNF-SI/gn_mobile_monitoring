import 'package:freezed_annotation/freezed_annotation.dart';

part 'permission.freezed.dart';
part 'permission.g.dart';

@freezed
class Permission with _$Permission {
  const factory Permission({
    required int idPermission,
    required int idRole,
    required int idAction,
    required int idModule,
    required int idObject,
    int? scopeValue,
    @Default(false) bool sensitivityFilter,
  }) = _Permission;

  factory Permission.fromJson(Map<String, dynamic> json) =>
      _$PermissionFromJson(json);
}

@freezed
class PermissionObject with _$PermissionObject {
  const factory PermissionObject({
    required int idObject,
    required String codeObject,
    String? descriptionObject,
  }) = _PermissionObject;

  factory PermissionObject.fromJson(Map<String, dynamic> json) =>
      _$PermissionObjectFromJson(json);
}

@freezed
class PermissionAction with _$PermissionAction {
  const factory PermissionAction({
    required int idAction,
    String? codeAction,
    String? descriptionAction,
  }) = _PermissionAction;

  factory PermissionAction.fromJson(Map<String, dynamic> json) =>
      _$PermissionActionFromJson(json);
}