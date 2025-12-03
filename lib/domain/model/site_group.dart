import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gn_mobile_monitoring/domain/model/cruved_response.dart';
import 'package:gn_mobile_monitoring/domain/model/cruved_object_mixin.dart';

part 'site_group.freezed.dart';

@freezed
class SiteGroup with _$SiteGroup, CruvedObjectMixin {
  const SiteGroup._();
  
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
    CruvedResponse? cruved,
  }) = _SiteGroup;
}
