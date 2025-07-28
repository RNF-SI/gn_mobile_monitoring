import 'package:flutter/material.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/base_visit.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/domain/model/observation.dart';
import 'package:gn_mobile_monitoring/presentation/model/module_info.dart';
import 'package:gn_mobile_monitoring/domain/model/sync_conflict.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/observation_form_wrapper.dart';

/// Formulaire d'observation - délègue maintenant à ObservationFormWrapper
class ObservationFormPage extends StatelessWidget {
  final int visitId;
  final ObjectConfig observationConfig;
  final CustomConfig? customConfig;
  final Observation? observation; // En mode édition, observation existante
  final int? moduleId; // ID du module pour la visite/observation
  final ObjectConfig?
      observationDetailConfig; // Configuration des observations_detail

  // Informations complémentaires pour le fil d'Ariane et la redirection
  final String? moduleName;
  final String? siteLabel;
  final String? siteName;
  final String? visitLabel;
  final String? visitDate;
  final BaseVisit? visit;
  final BaseSite? site;
  final ModuleInfo? moduleInfo;
  final dynamic fromSiteGroup;
  final SyncConflict? currentConflict;

  const ObservationFormPage({
    super.key,
    required this.visitId,
    required this.observationConfig,
    this.customConfig,
    this.observation,
    this.moduleId,
    this.moduleName,
    this.siteLabel,
    this.siteName,
    this.visitLabel,
    this.visitDate,
    this.visit,
    this.site,
    this.moduleInfo,
    this.fromSiteGroup,
    this.observationDetailConfig,
    this.currentConflict,
  });

  @override
  Widget build(BuildContext context) {
    return ObservationFormWrapper(
      visitId: visitId,
      observationConfig: observationConfig,
      customConfig: customConfig,
      observation: observation,
      moduleId: moduleId,
      observationDetailConfig: observationDetailConfig,
      moduleName: moduleName,
      siteLabel: siteLabel,
      siteName: siteName,
      visitLabel: visitLabel,
      visitDate: visitDate,
      visit: visit,
      site: site,
      moduleInfo: moduleInfo,
      fromSiteGroup: fromSiteGroup,
      currentConflict: currentConflict,
    );
  }
}