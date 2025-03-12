import 'package:freezed_annotation/freezed_annotation.dart';

part 'base_visit_entity.freezed.dart';
part 'base_visit_entity.g.dart';

@freezed
class BaseVisitEntity with _$BaseVisitEntity {
  const factory BaseVisitEntity({
    required int idBaseVisit,
    int? idBaseSite,
    required int idDataset,
    required int idModule,
    int? idDigitiser,
    required String visitDateMin,
    String? visitDateMax,
    int? idNomenclatureTechCollectCampanule,
    int? idNomenclatureGrpTyp,
    String? comments,
    String? uuidBaseVisit,
    String? metaCreateDate,
    String? metaUpdateDate,
  }) = _BaseVisitEntity;

  factory BaseVisitEntity.fromJson(Map<String, dynamic> json) =>
      _$BaseVisitEntityFromJson(json);
}
