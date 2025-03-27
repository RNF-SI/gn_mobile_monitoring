import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/core/helpers/form_config_parser.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/domain/model/observation_detail.dart';

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
    // Parser la configuration pour obtenir les labels des champs
    final parsedConfig = FormConfigParser.generateUnifiedSchema(
      config,
      customConfig,
    );

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
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Propriétés',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Liste des propriétés
                      ...observationDetail.data.entries.map((entry) {
                        final fieldConfig = parsedConfig[entry.key];
                        final label =
                            fieldConfig?['attribut_label'] ?? entry.key;
                        return _buildPropertyRow(label, entry.value.toString());
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPropertyRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 200,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
