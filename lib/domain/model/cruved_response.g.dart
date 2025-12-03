// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cruved_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CruvedResponseImpl _$$CruvedResponseImplFromJson(Map<String, dynamic> json) =>
    _$CruvedResponseImpl(
      create: json['C'] == null
          ? false
          : const CruvedJsonConverter().fromJson(json['C'] as Object),
      read: json['R'] == null
          ? false
          : const CruvedJsonConverter().fromJson(json['R'] as Object),
      update: json['U'] == null
          ? false
          : const CruvedJsonConverter().fromJson(json['U'] as Object),
      validate: json['V'] == null
          ? false
          : const CruvedJsonConverter().fromJson(json['V'] as Object),
      export: json['E'] == null
          ? false
          : const CruvedJsonConverter().fromJson(json['E'] as Object),
      delete: json['D'] == null
          ? false
          : const CruvedJsonConverter().fromJson(json['D'] as Object),
    );

Map<String, dynamic> _$$CruvedResponseImplToJson(
        _$CruvedResponseImpl instance) =>
    <String, dynamic>{
      'C': const CruvedJsonConverter().toJson(instance.create),
      'R': const CruvedJsonConverter().toJson(instance.read),
      'U': const CruvedJsonConverter().toJson(instance.update),
      'V': const CruvedJsonConverter().toJson(instance.validate),
      'E': const CruvedJsonConverter().toJson(instance.export),
      'D': const CruvedJsonConverter().toJson(instance.delete),
    };

_$MonitoringObjectResponseImpl _$$MonitoringObjectResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$MonitoringObjectResponseImpl(
      id: (json['id'] as num).toInt(),
      properties: json['properties'] as Map<String, dynamic>,
      cruved: CruvedResponse.fromJson(json['cruved'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$MonitoringObjectResponseImplToJson(
        _$MonitoringObjectResponseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'properties': instance.properties,
      'cruved': instance.cruved,
    };

_$ModuleResponseImpl _$$ModuleResponseImplFromJson(Map<String, dynamic> json) =>
    _$ModuleResponseImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      code: json['code'] as String,
      description: json['description'] as String?,
      cruved: CruvedResponse.fromJson(json['cruved'] as Map<String, dynamic>),
      properties: json['properties'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$ModuleResponseImplToJson(
        _$ModuleResponseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'code': instance.code,
      'description': instance.description,
      'cruved': instance.cruved,
      'properties': instance.properties,
    };

_$SiteResponseImpl _$$SiteResponseImplFromJson(Map<String, dynamic> json) =>
    _$SiteResponseImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String?,
      description: json['description'] as String?,
      code: json['code'] as String?,
      geometry: json['geometry'] as Map<String, dynamic>?,
      idDigitiser: (json['idDigitiser'] as num?)?.toInt(),
      idInventor: (json['idInventor'] as num?)?.toInt(),
      cruved: CruvedResponse.fromJson(json['cruved'] as Map<String, dynamic>),
      properties: json['properties'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$SiteResponseImplToJson(_$SiteResponseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'code': instance.code,
      'geometry': instance.geometry,
      'idDigitiser': instance.idDigitiser,
      'idInventor': instance.idInventor,
      'cruved': instance.cruved,
      'properties': instance.properties,
    };

_$VisitResponseImpl _$$VisitResponseImplFromJson(Map<String, dynamic> json) =>
    _$VisitResponseImpl(
      id: (json['id'] as num).toInt(),
      idBaseSite: (json['idBaseSite'] as num).toInt(),
      idDataset: (json['idDataset'] as num).toInt(),
      idModule: (json['idModule'] as num).toInt(),
      idDigitiser: (json['idDigitiser'] as num?)?.toInt(),
      visitDateMin: json['visitDateMin'] as String?,
      visitDateMax: json['visitDateMax'] as String?,
      comments: json['comments'] as String?,
      observers: (json['observers'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      cruved: CruvedResponse.fromJson(json['cruved'] as Map<String, dynamic>),
      data: json['data'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$VisitResponseImplToJson(_$VisitResponseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'idBaseSite': instance.idBaseSite,
      'idDataset': instance.idDataset,
      'idModule': instance.idModule,
      'idDigitiser': instance.idDigitiser,
      'visitDateMin': instance.visitDateMin,
      'visitDateMax': instance.visitDateMax,
      'comments': instance.comments,
      'observers': instance.observers,
      'cruved': instance.cruved,
      'data': instance.data,
    };

_$SiteGroupResponseImpl _$$SiteGroupResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$SiteGroupResponseImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String?,
      description: json['description'] as String?,
      idDigitiser: (json['idDigitiser'] as num?)?.toInt(),
      sites: (json['sites'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      geometry: json['geometry'] as Map<String, dynamic>?,
      cruved: CruvedResponse.fromJson(json['cruved'] as Map<String, dynamic>),
      properties: json['properties'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$SiteGroupResponseImplToJson(
        _$SiteGroupResponseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'idDigitiser': instance.idDigitiser,
      'sites': instance.sites,
      'geometry': instance.geometry,
      'cruved': instance.cruved,
      'properties': instance.properties,
    };
