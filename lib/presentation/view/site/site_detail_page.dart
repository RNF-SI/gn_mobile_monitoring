import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/sync_conflict.dart';
import 'package:gn_mobile_monitoring/presentation/model/module_info.dart';
import 'package:gn_mobile_monitoring/presentation/view/site/site_detail_page_base.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/site_visits_viewmodel.dart';

class SiteDetailPage extends ConsumerStatefulWidget {
  final BaseSite site;
  final ModuleInfo? moduleInfo;
  final dynamic fromSiteGroup;
  final SyncConflict? currentConflict;

  const SiteDetailPage({
    super.key,
    required this.site,
    this.moduleInfo,
    this.fromSiteGroup,
    this.currentConflict,
  });

  @override
  ConsumerState<SiteDetailPage> createState() => _SiteDetailPageState();
}

class _SiteDetailPageState extends ConsumerState<SiteDetailPage> {
  final GlobalKey<SiteDetailPageBaseState> _baseKey =
      GlobalKey<SiteDetailPageBaseState>();

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
        // Déclencher directement le chargement des données
        // La méthode startLoadingData accédera maintenant directement au provider
        baseState.startLoadingData();
      } catch (e) {
        debugPrint('Erreur lors du chargement des visites: $e');
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
      currentConflict: widget.currentConflict,
    );
  }
}
