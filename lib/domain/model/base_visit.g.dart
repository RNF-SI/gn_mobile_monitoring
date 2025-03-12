// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_visit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BaseVisitImpl _$$BaseVisitImplFromJson(Map<String, dynamic> json) =>
    _$BaseVisitImpl(
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
    );

Map<String, dynamic> _$$BaseVisitImplToJson(_$BaseVisitImpl instance) =>
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
    };
