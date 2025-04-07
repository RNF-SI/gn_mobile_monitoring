import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/presentation/model/module_info.dart';
import 'package:gn_mobile_monitoring/presentation/view/site_detail_page_base.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/site_visits_viewmodel.dart';

class SiteDetailPage extends ConsumerStatefulWidget {
  final BaseSite site;
  final ModuleInfo? moduleInfo;
  final dynamic fromSiteGroup;

  const SiteDetailPage({
    super.key,
    required this.site,
    this.moduleInfo,
    this.fromSiteGroup,
  });
  
  @override
  ConsumerState<SiteDetailPage> createState() => _SiteDetailPageState();
}

class _SiteDetailPageState extends ConsumerState<SiteDetailPage> {
  final GlobalKey<SiteDetailPageBaseState> _baseKey = GlobalKey<SiteDetailPageBaseState>();
  
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
      try {
        // Récupérer une instance du ViewModel
        // Note: nous ne pouvons pas utiliser .notifier directement sur un Provider.family
        final viewModel = ref.read(
          siteVisitsViewModelProvider((widget.site.idBaseSite, widget.moduleInfo?.module.id ?? 0))
        ).asData?.value;
        
        if (viewModel != null) {
          baseState.siteVisitsViewModel = viewModel as StateNotifier;
        }
        
        // Redéfinir les fonctions pour le watch et refresh
        baseState.observeVisits = (args) {
          if (args is (int, int)) {
            return ref.watch(siteVisitsViewModelProvider(args));
          }
          return const AsyncValue.loading();
        };
        
        baseState.refreshVisits = (args) {
          if (args is (int, int)) {
            final result = ref.refresh(siteVisitsViewModelProvider(args));
            return result;
          }
        };
        
        // Déclencher le chargement des données
        baseState.startLoadingData();
      } catch (e) {
        debugPrint('Erreur lors de l\'injection des dépendances: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SiteDetailPageBase(
      key: _baseKey,
      ref: ref,
      site: widget.site,
      moduleInfo: widget.moduleInfo,
      fromSiteGroup: widget.fromSiteGroup,
    );
  }
}