// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_visit_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BaseVisitEntityImpl _$$BaseVisitEntityImplFromJson(
        Map<String, dynamic> json) =>
    _$BaseVisitEntityImpl(
      idBaseVisit: (json['idBaseVisit'] as num).toInt(),
      idBaseSite: (json['idBaseSite'] as num?)?.toInt(),
      idDataset: (json['idDataset'] as num).toInt(),
      idModule: (json['idModule'] as num).toInt(),
      idDigitiser: (json['idDigitiser'] as num?)?.toInt(),
      visitDateMin: json['visitDateMin'] as String,
      visitDateMax: json['visitDateMax'] as String?,
      idNomenclatureTechCollectCampanule:
          (json['idNomenclatureTechCollectCampanule'] as num?)?.toInt(),
      idNomenclatureGrpTyp: (json['idNomenclatureGrpTyp'] as num?)?.toInt(),
      comments: json['comments'] as String?,
      uuidBaseVisit: json['uuidBaseVisit'] as String?,
      metaCreateDate: json['metaCreateDate'] as String?,
      metaUpdateDate: json['metaUpdateDate'] as String?,
      observers: (json['observers'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      data: json['data'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$BaseVisitEntityImplToJson(
        _$BaseVisitEntityImpl instance) =>
    <String, dynamic>{
      'idBaseVisit': instance.idBaseVisit,
      'idBaseSite': instance.idBaseSite,
      'idDataset': instance.idDataset,
      'idModule': instance.idModule,
      'idDigitiser': instance.idDigitiser,
      'visitDateMin': instance.visitDateMin,
      'visitDateMax': instance.visitDateMax,
      'idNomenclatureTechCollectCampanule':
          instance.idNomenclatureTechCollectCampanule,
      'idNomenclatureGrpTyp': instance.idNomenclatureGrpTyp,
      'comments': instance.comments,
      'uuidBaseVisit': instance.uuidBaseVisit,
      'metaCreateDate': instance.metaCreateDate,
      'metaUpdateDate': instance.metaUpdateDate,
      'observers': instance.observers,
      'data': instance.data,
    };
