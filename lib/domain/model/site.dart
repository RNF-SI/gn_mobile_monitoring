import 'package:freezed_annotation/freezed_annotation.dart';

part 'site.freezed.dart';

@freezed
class Site with _$Site {
  const factory Site({
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
  }) = _Site;
}
