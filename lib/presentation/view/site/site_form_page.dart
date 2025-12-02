import 'package:flutter/material.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';
import 'package:gn_mobile_monitoring/presentation/model/module_info.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/site_form_wrapper.dart';

/// Formulaire de site - délègue à SiteFormWrapper
class SiteFormPage extends StatelessWidget {
  final BaseSite? site; // En mode édition, site existant
  final ObjectConfig siteConfig;
  final CustomConfig? customConfig;
  final int? moduleId;
  final ModuleInfo? moduleInfo;
  final SiteGroup? siteGroup;
  final int? selectedSiteTypeId; // Type de site sélectionné

  const SiteFormPage({
    super.key,
    this.site,
    required this.siteConfig,
    this.customConfig,
    this.moduleId,
    this.moduleInfo,
    this.siteGroup,
    this.selectedSiteTypeId,
  });

  @override
  Widget build(BuildContext context) {
    return SiteFormWrapper(
      siteConfig: siteConfig,
      customConfig: customConfig,
      site: site,
      moduleId: moduleId,
      moduleInfo: moduleInfo,
      siteGroup: siteGroup,
      selectedSiteTypeId: selectedSiteTypeId,
    );
  }
}

