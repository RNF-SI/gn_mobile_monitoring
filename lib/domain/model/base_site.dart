import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gn_mobile_monitoring/domain/model/monitoring_object_mixin.dart';
import 'package:gn_mobile_monitoring/domain/model/cruved_response.dart';

part 'base_site.freezed.dart';

@freezed
class BaseSite with _$BaseSite, MonitoringObjectMixin implements MonitoringObject {
  const factory BaseSite({
    required int idBaseSite,
    String? baseSiteName,
    String? baseSiteDescription,
    String? baseSiteCode,
    DateTime? firstUseDate,
    String? geom, // GeoJSON representation
    String? uuidBaseSite,
    int? altitudeMin,
    int? altitudeMax,
    DateTime? metaCreateDate,
    DateTime? metaUpdateDate,
    int? idDigitiser,
    int? idInventor,
    @Default([]) List<int> organismeActors,
    // Permissions CRUVED pour ce site spécifique (pattern monitoring web)
    CruvedResponse? cruved,
  }) = _BaseSite;

  const BaseSite._();

  // Implementation of MonitoringObject getters for mixin
  @override
  List<int> get observers => [];
}
