import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/domain/model/observation_detail.dart';
import 'package:gn_mobile_monitoring/domain/model/sync_conflict.dart';
import 'package:gn_mobile_monitoring/presentation/view/base/detail_page.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/breadcrumb_navigation.dart';

class ObservationDetailDetailPageBase extends DetailPage {
  final WidgetRef ref;
  final ObservationDetail observationDetail;
  final ObjectConfig config;
  final CustomConfig? customConfig;
  final int index;
  final SyncConflict? currentConflict;

  const ObservationDetailDetailPageBase({
    super.key,
    required this.ref,
    required this.observationDetail,
    required this.config,
    this.customConfig,
    required this.index,
    this.currentConflict,
  });

  @override
  ObservationDetailDetailPageBaseState createState() =>
      ObservationDetailDetailPageBaseState();
}

class ObservationDetailDetailPageBaseState
    extends DetailPageState<ObservationDetailDetailPageBase> {
  @override
  ObjectConfig? get objectConfig => widget.config;

  @override
  CustomConfig? get customConfig => widget.customConfig;

  @override
  List<String>? get displayProperties =>
      objectConfig?.displayProperties ?? objectConfig?.displayList;

  @override
  Map<String, dynamic> get objectData => widget.observationDetail.data;

  @override
  String get propertiesTitle => 'Propriétés';

  @override
  bool get separateEmptyFields => false;

  @override
  List<BreadcrumbItem> getBreadcrumbItems() {
    // Ce type de détail n'a généralement pas besoin d'un fil d'Ariane complexe
    // car il s'agit d'un niveau imbriqué déjà profond dans la navigation
    return [];
  }

  @override
  PreferredSizeWidget buildAppBar() {
    return AppBar(
      title: Text(getTitle()),
    );
  }

  @override
  String getTitle() {
    return 'Détails de l\'observation détail ${widget.index}';
  }

  @override
  Widget buildBaseContent() {
    return super.buildBaseContent();
  }
}
