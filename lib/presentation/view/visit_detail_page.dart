import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/base_visit.dart';
import 'package:gn_mobile_monitoring/presentation/model/module_info.dart';
import 'package:gn_mobile_monitoring/presentation/view/visit_detail_page_base.dart';

/// Page de détail pour une visite
/// Sert de façade pour VisitDetailPageBase, qui implémente la logique
class VisitDetailPage extends ConsumerStatefulWidget {
  final BaseVisit visit;
  final BaseSite site; 
  final ModuleInfo? moduleInfo;
  final dynamic fromSiteGroup; // Information sur un éventuel groupe parent
  final bool isNewVisit;

  const VisitDetailPage({
    super.key,
    required this.visit,
    required this.site,
    this.moduleInfo,
    this.fromSiteGroup,
    this.isNewVisit = false,
  });

  @override
  ConsumerState<VisitDetailPage> createState() => _VisitDetailPageState();
}

class _VisitDetailPageState extends ConsumerState<VisitDetailPage> {
  @override
  Widget build(BuildContext context) {
    return VisitDetailPageBase(
      ref: ref,
      visit: widget.visit,
      site: widget.site,
      moduleInfo: widget.moduleInfo,
      fromSiteGroup: widget.fromSiteGroup,
      isNewVisit: widget.isNewVisit,
    );
  }
}