import 'package:freezed_annotation/freezed_annotation.dart';

part 'site_group.freezed.dart';

@freezed
class SiteGroup with _$SiteGroup {
  const factory SiteGroup({
    required int idSitesGroup,
    String? sitesGroupName,
    String? sitesGroupCode,
    String? sitesGroupDescription,
    String? uuidSitesGroup,
    String? comments,
    String? data,
    DateTime? metaCreateDate,
    DateTime? metaUpdateDate,
    int? idDigitiser,
    String? geom,
    int? altitudeMin,
    int? altitudeMax,
  }) = _SiteGroup;
}
