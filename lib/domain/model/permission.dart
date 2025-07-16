import 'package:freezed_annotation/freezed_annotation.dart';

part 'permission.freezed.dart';
part 'permission.g.dart';

@freezed
class Permission with _$Permission {
  const factory Permission({
    required String moduleCode,
    required PermissionLevel visits,
    required PermissionLevel sites,
    required DateTime lastSync,
  }) = _Permission;

  factory Permission.fromJson(Map<String, dynamic> json) =>
      _$PermissionFromJson(json);
}

@freezed
class PermissionLevel with _$PermissionLevel {
  const factory PermissionLevel({
    @Default(0) int create,
    @Default(0) int read,
    @Default(0) int update,
    @Default(0) int delete,
  }) = _PermissionLevel;

  factory PermissionLevel.fromJson(Map<String, dynamic> json) =>
      _$PermissionLevelFromJson(json);
}

@freezed
class PermissionScope with _$PermissionScope {
  const factory PermissionScope.none() = _PermissionScopeNone;
  const factory PermissionScope.personal() = _PermissionScopePersonal;
  const factory PermissionScope.organization() = _PermissionScopeOrganization;
  const factory PermissionScope.all() = _PermissionScopeAll;

  factory PermissionScope.fromLevel(int level) {
    switch (level) {
      case 0:
        return const PermissionScope.none();
      case 1:
        return const PermissionScope.personal();
      case 2:
        return const PermissionScope.organization();
      case 3:
        return const PermissionScope.all();
      default:
        return const PermissionScope.none();
    }
  }
}

extension PermissionLevelExtensions on PermissionLevel {
  PermissionScope get createScope => PermissionScope.fromLevel(create);
  PermissionScope get readScope => PermissionScope.fromLevel(read);
  PermissionScope get updateScope => PermissionScope.fromLevel(update);
  PermissionScope get deleteScope => PermissionScope.fromLevel(delete);
}