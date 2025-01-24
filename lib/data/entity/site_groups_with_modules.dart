import 'package:gn_mobile_monitoring/data/entity/site_group_entity.dart';

class SiteGroupsWithModulesLabel {
  final SiteGroupEntity siteGroup;
  final List<String> moduleLabelList;

  SiteGroupsWithModulesLabel({
    required this.siteGroup,
    required this.moduleLabelList,
  });

  factory SiteGroupsWithModulesLabel.fromJson(Map<String, dynamic> json) {
    return SiteGroupsWithModulesLabel(
      siteGroup: SiteGroupEntity.fromJson(json),
      moduleLabelList: (json['modules'] as List<dynamic>).cast<String>(),
    );
  }
}
