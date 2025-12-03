// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_permissions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserPermissionsImpl _$$UserPermissionsImplFromJson(
        Map<String, dynamic> json) =>
    _$UserPermissionsImpl(
      idRole: (json['idRole'] as num).toInt(),
      username: json['username'] as String,
      idOrganisme: (json['idOrganisme'] as num?)?.toInt(),
      monitoringModules: CruvedResponse.fromJson(
          json['monitoringModules'] as Map<String, dynamic>),
      monitoringSites: CruvedResponse.fromJson(
          json['monitoringSites'] as Map<String, dynamic>),
      monitoringGrpSites: CruvedResponse.fromJson(
          json['monitoringGrpSites'] as Map<String, dynamic>),
      monitoringVisites: CruvedResponse.fromJson(
          json['monitoringVisites'] as Map<String, dynamic>),
      monitoringIndividuals: CruvedResponse.fromJson(
          json['monitoringIndividuals'] as Map<String, dynamic>),
      monitoringMarkings: CruvedResponse.fromJson(
          json['monitoringMarkings'] as Map<String, dynamic>),
      isConnected: json['isConnected'] as bool? ?? false,
    );

Map<String, dynamic> _$$UserPermissionsImplToJson(
        _$UserPermissionsImpl instance) =>
    <String, dynamic>{
      'idRole': instance.idRole,
      'username': instance.username,
      'idOrganisme': instance.idOrganisme,
      'monitoringModules': instance.monitoringModules,
      'monitoringSites': instance.monitoringSites,
      'monitoringGrpSites': instance.monitoringGrpSites,
      'monitoringVisites': instance.monitoringVisites,
      'monitoringIndividuals': instance.monitoringIndividuals,
      'monitoringMarkings': instance.monitoringMarkings,
      'isConnected': instance.isConnected,
    };
