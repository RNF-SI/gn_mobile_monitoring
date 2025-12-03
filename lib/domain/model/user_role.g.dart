// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_role.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserRoleImpl _$$UserRoleImplFromJson(Map<String, dynamic> json) =>
    _$UserRoleImpl(
      idRole: (json['idRole'] as num).toInt(),
      identifiant: json['identifiant'] as String,
      nomRole: json['nomRole'] as String,
      prenomRole: json['prenomRole'] as String,
      idOrganisme: (json['idOrganisme'] as num?)?.toInt(),
      active: json['active'] as bool? ?? true,
    );

Map<String, dynamic> _$$UserRoleImplToJson(_$UserRoleImpl instance) =>
    <String, dynamic>{
      'idRole': instance.idRole,
      'identifiant': instance.identifiant,
      'nomRole': instance.nomRole,
      'prenomRole': instance.prenomRole,
      'idOrganisme': instance.idOrganisme,
      'active': instance.active,
    };
