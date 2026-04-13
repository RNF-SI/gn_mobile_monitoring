import 'package:flutter/material.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/base_visit.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/domain/model/observation.dart';
import 'package:gn_mobile_monitoring/domain/model/observation_detail.dart';
import 'package:gn_mobile_monitoring/presentation/model/module_info.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/observation_detail_form_wrapper.dart';

/// Formulaire de détail d'observation - délègue maintenant à ObservationDetailFormWrapper
class ObservationDetailFormPage extends StatelessWidget {
  final ObjectConfig? observationDetail;
  final Observation observation;
  final CustomConfig? customConfig;
  final ObservationDetail? existingDetail;
  
  // Informations optionnelles pour la navigation complète
  final BaseVisit? visit;
  final BaseSite? site;
  final ModuleInfo? moduleInfo;
  final dynamic fromSiteGroup;

  const ObservationDetailFormPage({
    super.key,
    this.observationDetail,
    required this.observation,
    this.customConfig,
    this.existingDetail,
    this.visit,
    this.site,
    this.moduleInfo,
    this.fromSiteGroup,
  });

  @override
  Widget build(BuildContext context) {
    // Vérifier qu'on a la configuration nécessaire
    if (observationDetail == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Erreur de configuration'),
        ),
        body: const Center(
          child: Text('Configuration du détail d\'observation manquante'),
        ),
      );
    }

    return ObservationDetailFormWrapper(
      observationDetail: observationDetail!,
      observation: observation,
      customConfig: customConfig,
      existingDetail: existingDetail,
      visit: visit,
      site: site,
      moduleInfo: moduleInfo,
      fromSiteGroup: fromSiteGroup,
    );
  }
}