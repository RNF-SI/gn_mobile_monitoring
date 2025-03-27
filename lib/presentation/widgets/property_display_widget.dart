import 'package:flutter/material.dart';
import 'package:gn_mobile_monitoring/core/helpers/form_config_parser.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';

class PropertyDisplayWidget extends StatelessWidget {
  final Map<String, dynamic> data;
  final ObjectConfig? config;
  final CustomConfig? customConfig;
  final String title;
  final bool separateEmptyFields;

  const PropertyDisplayWidget({
    super.key,
    required this.data,
    this.config,
    this.customConfig,
    this.title = 'Données spécifiques',
    this.separateEmptyFields = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (data.isEmpty)
              const Text('Aucune donnée spécifique disponible')
            else
              ...buildPropertyRows(data, config, customConfig, separateEmptyFields),
          ],
        ),
      ),
    );
  }

  static List<Widget> buildPropertyRows(
    Map<String, dynamic> data,
    ObjectConfig? config,
    CustomConfig? customConfig,
    bool separateEmptyFields,
  ) {
    // Préparer la configuration si disponible
    final Map<String, dynamic> parsedConfig = config != null
        ? FormConfigParser.generateUnifiedSchema(config, customConfig)
        : {};

    // Extraire les libellés des champs
    final Map<String, String> fieldLabels = {};
    for (final entry in parsedConfig.entries) {
      fieldLabels[entry.key] = entry.value['attribut_label'];
    }

    if (!separateEmptyFields) {
      // Affichage simple (sans séparation des champs vides)
      final List<Widget> widgets = [];
      final sortedKeys = data.keys.toList()..sort();

      for (final key in sortedKeys) {
        if (data[key] != null) {
          // Formater le libellé du champ
          String displayLabel = fieldLabels[key] ?? key;
          if (displayLabel == key) {
            displayLabel = _formatLabel(key);
          }

          String displayValue = _formatValue(data[key]);
          
          widgets.add(_buildPropertyRow(displayLabel, displayValue));
        }
      }

      return widgets;
    } else {
      // Affichage avec séparation des champs vides et non vides
      return _buildSortedProperties(data, config, customConfig);
    }
  }

  static List<Widget> _buildSortedProperties(
    Map<String, dynamic> data,
    ObjectConfig? config,
    CustomConfig? customConfig,
  ) {
    // Séparer les propriétés remplies et vides
    final filledProperties = <MapEntry<String, dynamic>>[];
    final emptyProperties = <MapEntry<String, dynamic>>[];

    // Trier les propriétés selon qu'elles sont remplies ou non
    for (var entry in data.entries) {
      if (entry.value != null && entry.value.toString().isNotEmpty) {
        filledProperties.add(entry);
      } else {
        emptyProperties.add(entry);
      }
    }

    // Trier les propriétés par ordre alphabétique dans chaque groupe
    filledProperties.sort((a, b) => a.key.compareTo(b.key));
    emptyProperties.sort((a, b) => a.key.compareTo(b.key));

    // Construire les widgets pour les propriétés
    final widgets = <Widget>[];

    // Ajouter les propriétés remplies
    if (filledProperties.isNotEmpty) {
      widgets.add(
        const Padding(
          padding: EdgeInsets.only(bottom: 16.0),
          child: Text(
            'Champs remplis',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.green,
            ),
          ),
        ),
      );

      for (final entry in filledProperties) {
        final label = _getPropertyLabel(entry.key, config, customConfig);
        final value = _formatValue(entry.value);
        widgets.add(_buildPropertyRow(label, value));
      }
    }

    // Ajouter les propriétés vides
    if (emptyProperties.isNotEmpty) {
      widgets.add(const SizedBox(height: 16));
      widgets.add(
        const Padding(
          padding: EdgeInsets.only(bottom: 16.0),
          child: Text(
            'Champs non remplis',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ),
      );

      for (final entry in emptyProperties) {
        final label = _getPropertyLabel(entry.key, config, customConfig);
        widgets.add(_buildPropertyRow(
          label,
          'Non renseigné',
          isEmptyField: true,
        ));
      }
    }

    return widgets;
  }

  static String _getPropertyLabel(
    String key,
    ObjectConfig? config,
    CustomConfig? customConfig,
  ) {
    if (config != null) {
      // Vérifier dans la configuration parsée
      final parsedConfig = FormConfigParser.generateUnifiedSchema(config, customConfig);
      if (parsedConfig.containsKey(key) && 
          parsedConfig[key].containsKey('attribut_label')) {
        return parsedConfig[key]['attribut_label'];
      }
      
      // Vérifier dans generic
      if (config.generic != null && config.generic!.containsKey(key)) {
        return config.generic![key]!.attributLabel ?? key;
      }
      // Vérifier dans specific
      else if (config.specific != null && config.specific!.containsKey(key)) {
        final specificConfig = config.specific![key] as Map<String, dynamic>;
        if (specificConfig.containsKey('attribut_label')) {
          return specificConfig['attribut_label'];
        }
      }
    }
    return _formatLabel(key);
  }

  static String _formatLabel(String key) {
    return key
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) =>
            word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '')
        .join(' ');
  }

  static String _formatValue(dynamic value) {
    if (value == null) {
      return 'Non renseigné';
    } else if (value is Map) {
      return 'Objet complexe';
    } else if (value is List) {
      return 'Liste (${value.length} éléments)';
    } else {
      return value.toString();
    }
  }

  static Widget _buildPropertyRow(
    String label,
    String value, {
    bool isEmptyField = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 200,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: isEmptyField ? Colors.grey : null,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: isEmptyField ? Colors.grey : null,
                fontStyle: isEmptyField ? FontStyle.italic : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}