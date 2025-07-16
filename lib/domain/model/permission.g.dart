// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permission.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PermissionImpl _$$PermissionImplFromJson(Map<String, dynamic> json) =>
    _$PermissionImpl(
      moduleCode: json['moduleCode'] as String,
      visits: PermissionLevel.fromJson(json['visits'] as Map<String, dynamic>),
      sites: PermissionLevel.fromJson(json['sites'] as Map<String, dynamic>),
      lastSync: DateTime.parse(json['lastSync'] as String),
    );

Map<String, dynamic> _$$PermissionImplToJson(_$PermissionImpl instance) =>
    <String, dynamic>{
      'moduleCode': instance.moduleCode,
      'visits': instance.visits,
      'sites': instance.sites,
      'lastSync': instance.lastSync.toIso8601String(),
    };

_$PermissionLevelImpl _$$PermissionLevelImplFromJson(
        Map<String, dynamic> json) =>
    _$PermissionLevelImpl(
      create: (json['create'] as num?)?.toInt() ?? 0,
      read: (json['read'] as num?)?.toInt() ?? 0,
      update: (json['update'] as num?)?.toInt() ?? 0,
      delete: (json['delete'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$PermissionLevelImplToJson(
        _$PermissionLevelImpl instance) =>
    <String, dynamic>{
      'create': instance.create,
      'read': instance.read,
      'update': instance.update,
      'delete': instance.delete,
    };
