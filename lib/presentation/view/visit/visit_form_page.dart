import 'package:flutter/material.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/base_visit.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/presentation/model/module_info.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/visit_form_wrapper.dart';

/// Formulaire de visite - délègue maintenant à VisitFormWrapper
class VisitFormPage extends StatelessWidget {
  final BaseSite site;
  final ObjectConfig visitConfig;
  final CustomConfig? customConfig;
  final BaseVisit? visit; // En mode édition, visite existante
  final int? moduleId; // ID du module pour la visite
  final ModuleInfo?
      moduleInfo; // Information sur le module parent (pour le fil d'Ariane)
  final dynamic
      siteGroup; // Groupe de sites parent éventuel (pour le fil d'Ariane)

  const VisitFormPage({
    super.key,
    required this.site,
    required this.visitConfig,
    this.customConfig,
    this.visit,
    this.moduleId,
    this.moduleInfo,
    this.siteGroup,
  });

  @override
  Widget build(BuildContext context) {
    return VisitFormWrapper(
      site: site,
      visitConfig: visitConfig,
      customConfig: customConfig,
      visit: visit,
      moduleId: moduleId,
      moduleInfo: moduleInfo,
      siteGroup: siteGroup,
    );
  }
}