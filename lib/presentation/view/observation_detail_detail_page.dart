import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/domain/model/observation_detail.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/property_display_widget.dart';

class ObservationDetailDetailPage extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails de l\'observation détail ${index}'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Propriétés
              PropertyDisplayWidget(
                data: observationDetail.data,
                config: config,
                customConfig: customConfig,
                title: 'Propriétés',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
