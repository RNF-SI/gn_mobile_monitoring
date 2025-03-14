import 'package:freezed_annotation/freezed_annotation.dart';

part 'base_visit.freezed.dart';
part 'base_visit.g.dart';

@freezed
class BaseVisit with _$BaseVisit {
  const factory BaseVisit({
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
    List<int>? observers, // Liste des ID des observateurs
    Map<String, dynamic>? data, // Données spécifiques au module
  }) = _BaseVisit;

  factory BaseVisit.fromJson(Map<String, dynamic> json) =>
      _$BaseVisitFromJson(json);
}
