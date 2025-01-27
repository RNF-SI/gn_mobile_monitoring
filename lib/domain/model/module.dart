import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/module_complement.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';

part 'module.freezed.dart';

@freezed
class Module with _$Module {
  const factory Module({
    required int id,
    String? moduleCode,
    String? moduleLabel,
    String? modulePicto,
    String? moduleDesc,
    String? moduleGroup,
    String? modulePath,
    String? moduleExternalUrl,
    String? moduleTarget,
    String? moduleComment,
    bool? activeFrontend,
    bool? activeBackend,
    String? moduleDocUrl,
    int? moduleOrder,
    String? ngModule,
    DateTime? metaCreateDate,
    DateTime? metaUpdateDate,
    bool? downloaded,
    ModuleComplement? complement,
    List<SiteGroup>? sitesGroup,
    List<BaseSite>? sites,
  }) = _Module;
}
