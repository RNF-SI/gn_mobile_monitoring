import 'package:gn_mobile_monitoring/data/entity/site_group_entity.dart';

class SiteGroupsWithModulesLabel {
  final SiteGroupEntity siteGroup;
  final String moduleLabel;

  SiteGroupsWithModulesLabel({
    required this.siteGroup,
    required this.moduleLabel,
  });

  factory SiteGroupsWithModulesLabel.fromJson(Map<String, dynamic> json) {
    return SiteGroupsWithModulesLabel(
      siteGroup: SiteGroupEntity.fromJson(json['site_group']),
      moduleLabel: json['module_label'],
    );
  }
}
