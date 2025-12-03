// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permission.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PermissionImpl _$$PermissionImplFromJson(Map<String, dynamic> json) =>
    _$PermissionImpl(
      idPermission: (json['idPermission'] as num).toInt(),
      idRole: (json['idRole'] as num).toInt(),
      idAction: (json['idAction'] as num).toInt(),
      idModule: (json['idModule'] as num).toInt(),
      idObject: (json['idObject'] as num).toInt(),
      scopeValue: (json['scopeValue'] as num?)?.toInt(),
      sensitivityFilter: json['sensitivityFilter'] as bool? ?? false,
    );

Map<String, dynamic> _$$PermissionImplToJson(_$PermissionImpl instance) =>
    <String, dynamic>{
      'idPermission': instance.idPermission,
      'idRole': instance.idRole,
      'idAction': instance.idAction,
      'idModule': instance.idModule,
      'idObject': instance.idObject,
      'scopeValue': instance.scopeValue,
      'sensitivityFilter': instance.sensitivityFilter,
    };

_$PermissionObjectImpl _$$PermissionObjectImplFromJson(
        Map<String, dynamic> json) =>
    _$PermissionObjectImpl(
      idObject: (json['idObject'] as num).toInt(),
      codeObject: json['codeObject'] as String,
      descriptionObject: json['descriptionObject'] as String?,
    );

Map<String, dynamic> _$$PermissionObjectImplToJson(
        _$PermissionObjectImpl instance) =>
    <String, dynamic>{
      'idObject': instance.idObject,
      'codeObject': instance.codeObject,
      'descriptionObject': instance.descriptionObject,
    };

_$PermissionActionImpl _$$PermissionActionImplFromJson(
        Map<String, dynamic> json) =>
    _$PermissionActionImpl(
      idAction: (json['idAction'] as num).toInt(),
      codeAction: json['codeAction'] as String?,
      descriptionAction: json['descriptionAction'] as String?,
    );

Map<String, dynamic> _$$PermissionActionImplToJson(
        _$PermissionActionImpl instance) =>
    <String, dynamic>{
      'idAction': instance.idAction,
      'codeAction': instance.codeAction,
      'descriptionAction': instance.descriptionAction,
    };
