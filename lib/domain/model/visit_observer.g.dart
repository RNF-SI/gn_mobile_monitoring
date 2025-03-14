// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visit_observer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VisitObserverImpl _$$VisitObserverImplFromJson(Map<String, dynamic> json) =>
    _$VisitObserverImpl(
      idBaseVisit: (json['idBaseVisit'] as num).toInt(),
      idRole: (json['idRole'] as num).toInt(),
      uniqueId: json['uniqueId'] as String,
    );

Map<String, dynamic> _$$VisitObserverImplToJson(_$VisitObserverImpl instance) =>
    <String, dynamic>{
      'idBaseVisit': instance.idBaseVisit,
      'idRole': instance.idRole,
      'uniqueId': instance.uniqueId,
    };
