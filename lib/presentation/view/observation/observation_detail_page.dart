import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/base_visit.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/domain/model/observation.dart';
import 'package:gn_mobile_monitoring/presentation/model/module_info.dart';
import 'package:gn_mobile_monitoring/presentation/view/observation/observation_detail_page_base.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/taxon_service.dart';

class ObservationDetailPage extends ConsumerStatefulWidget {
  final Observation observation;
  final BaseVisit visit;
  final BaseSite site;
  final ModuleInfo? moduleInfo;
  final dynamic fromSiteGroup;
  final ObjectConfig? observationConfig;
  final CustomConfig? customConfig;
  final ObjectConfig? observationDetailConfig;
  final bool isNewObservation;

  const ObservationDetailPage({
    super.key,
    required this.observation,
    required this.visit,
    required this.site,
    this.moduleInfo,
    this.fromSiteGroup,
    this.observationConfig,
    this.customConfig,
    this.observationDetailConfig,
    this.isNewObservation = false,
  });

  @override
  ConsumerState<ObservationDetailPage> createState() =>
      _ObservationDetailPageState();
}

class _ObservationDetailPageState extends ConsumerState<ObservationDetailPage> {
  final GlobalKey<ObservationDetailPageBaseState> _baseKey =
      GlobalKey<ObservationDetailPageBaseState>();

  @override
  void initState() {
    super.initState();
    // Nous utilisons un callback après le build pour s'assurer que le widget est monté
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _injectDependencies();
    });
  }

  void _injectDependencies() {
    final baseState = _baseKey.currentState;
    if (baseState != null) {
      // Injection du service taxon provenant du provider
      baseState.taxonService = ref.read(taxonServiceProvider.notifier);

      // Maintenant que les dépendances sont injectées, démarrer le chargement des données
      baseState.startLoadingData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ObservationDetailPageBase(
      key: _baseKey,
      ref: ref,
      observation: widget.observation,
      visit: widget.visit,
      site: widget.site,
      moduleInfo: widget.moduleInfo,
      fromSiteGroup: widget.fromSiteGroup,
      observationConfig: widget.observationConfig,
      customConfig: widget.customConfig,
      observationDetailConfig: widget.observationDetailConfig,
      isNewObservation: widget.isNewObservation,
    );
  }
}
