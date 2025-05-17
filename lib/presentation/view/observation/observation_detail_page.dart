import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/base_visit.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/domain/model/observation.dart';
import 'package:gn_mobile_monitoring/presentation/model/module_info.dart';
import 'package:gn_mobile_monitoring/presentation/view/observation/observation_detail_page_base.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/observations_viewmodel.dart';
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
  late Observation _currentObservation;

  @override
  void initState() {
    super.initState();
    _currentObservation = widget.observation;
    // Nous utilisons un callback après le build pour s'assurer que le widget est monté
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _injectDependencies();
    });
  }

  @override
  void didUpdateWidget(ObservationDetailPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Si l'observation a changé, recharger les données
    if (oldWidget.observation.idObservation != widget.observation.idObservation ||
        oldWidget.observation.data != widget.observation.data) {
      _currentObservation = widget.observation;
      _loadLatestObservation();
    }
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

  Future<void> _loadLatestObservation() async {
    try {
      // Utiliser le provider des observations pour obtenir la dernière version
      final observationsViewModel = ref.read(
        observationsProvider(widget.visit.idBaseVisit).notifier,
      );
      
      final updatedObservation = await observationsViewModel
          .getObservationById(widget.observation.idObservation);
      
      if (updatedObservation != null && mounted) {
        setState(() {
          _currentObservation = updatedObservation;
        });
        
        // Mettre à jour la page de base avec la nouvelle observation
        final baseState = _baseKey.currentState;
        if (baseState != null) {
          baseState.updateObservation(updatedObservation);
        }
      }
    } catch (e) {
      debugPrint('Erreur lors du chargement de l\'observation: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ObservationDetailPageBase(
      key: _baseKey,
      ref: ref,
      observation: _currentObservation,
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
