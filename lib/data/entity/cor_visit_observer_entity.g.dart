// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cor_visit_observer_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CorVisitObserverEntityImpl _$$CorVisitObserverEntityImplFromJson(
        Map<String, dynamic> json) =>
    _$CorVisitObserverEntityImpl(
      idBaseVisit: (json['idBaseVisit'] as num).toInt(),
      idRole: (json['idRole'] as num).toInt(),
      uniqueIdCoreVisitObserver: json['uniqueIdCoreVisitObserver'] as String,
    );

Map<String, dynamic> _$$CorVisitObserverEntityImplToJson(
        _$CorVisitObserverEntityImpl instance) =>
    <String, dynamic>{
      'idBaseVisit': instance.idBaseVisit,
      'idRole': instance.idRole,
      'uniqueIdCoreVisitObserver': instance.uniqueIdCoreVisitObserver,
    };
