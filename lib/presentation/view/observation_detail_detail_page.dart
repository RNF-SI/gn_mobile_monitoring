import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/domain/model/observation_detail.dart';
import 'package:gn_mobile_monitoring/presentation/view/observation_detail_detail_page_base.dart';

class ObservationDetailDetailPage extends ConsumerStatefulWidget {
  final ObservationDetail observationDetail;
  final ObjectConfig config;
  final CustomConfig? customConfig;
  final int index;

  const ObservationDetailDetailPage({
    super.key,
    required this.observationDetail,
    required this.config,
    this.customConfig,
    required this.index,
  });

  @override
  ConsumerState<ObservationDetailDetailPage> createState() => _ObservationDetailDetailPageState();
}

class _ObservationDetailDetailPageState extends ConsumerState<ObservationDetailDetailPage> {
  @override
  Widget build(BuildContext context) {
    return ObservationDetailDetailPageBase(
      ref: ref,
      observationDetail: widget.observationDetail,
      config: widget.config,
      customConfig: widget.customConfig,
      index: widget.index,
    );
  }
}
