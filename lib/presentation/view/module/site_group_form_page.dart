import 'package:flutter/material.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';
import 'package:gn_mobile_monitoring/presentation/model/module_info.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/site_group_form_wrapper.dart';

/// Formulaire de site - délègue à SiteGroupFormWrapper
class SiteGroupFormPage extends StatelessWidget {
  final SiteGroup? siteGroup; // En mode édition, site existant
  final ObjectConfig  siteGroupConfig;
  final ObjectConfig?  siteConfig;
  final CustomConfig? customConfig;
  final int? moduleId;
  final ModuleInfo? moduleInfo;

  const SiteGroupFormPage({
    super.key,
    this.siteGroup,
    required this.siteGroupConfig,
    this.siteConfig,
    this.customConfig,
    this.moduleId,
    this.moduleInfo,
  });

  @override
  Widget build(BuildContext context) {
    return SiteGroupFormWrapper(
      siteGroupConfig: siteGroupConfig,
      siteConfig: siteConfig,
      customConfig: customConfig,
      moduleId: moduleId,
      moduleInfo: moduleInfo,
      siteGroup: siteGroup,
    );
  }
}

