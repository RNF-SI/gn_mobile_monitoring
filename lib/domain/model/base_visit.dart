import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gn_mobile_monitoring/domain/model/monitoring_object_mixin.dart';
import 'package:gn_mobile_monitoring/domain/model/cruved_response.dart';

part 'base_visit.freezed.dart';
part 'base_visit.g.dart';

@freezed
class BaseVisit with _$BaseVisit, MonitoringObjectMixin implements MonitoringObject {
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
    @Default([]) List<int> observers, // Liste des ID des observateurs
    Map<String, dynamic>? data, // Données spécifiques au module
    int? idInventor,
    @Default([]) List<int> organismeActors,
    // Permissions CRUVED pour cette visite spécifique (pattern monitoring web)
    CruvedResponse? cruved,
  }) = _BaseVisit;

  factory BaseVisit.fromJson(Map<String, dynamic> json) =>
      _$BaseVisitFromJson(json);

  const BaseVisit._();

  // Implementation of MonitoringObject getters for mixin - pas nécessaire car les champs existent déjà
}
