import 'package:flutter/material.dart';
import 'package:gn_mobile_monitoring/core/helpers/form_config_parser.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/domain/model/observation.dart';
import 'package:gn_mobile_monitoring/presentation/view/observation_detail_form_page.dart';

/// Widget affichant les informations des observations détaillées
/// Ce widget est différent du widget d'observation normal et gère
/// spécifiquement le cas des observations_detail dans la configuration
class ObservationDetailWidget extends StatelessWidget {
  final ObjectConfig? observationDetail;
  final CustomConfig? customConfig;
  final int? observationId;

  const ObservationDetailWidget({
    Key? key,
    required this.observationDetail,
    required this.customConfig,
    this.observationId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Si pas de configuration pour observation_detail, afficher un placeholder
    if (observationDetail == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              'Aucune observation détaillée disponible',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
        ),
      );
    }

    // Parser la configuration avec le FormConfigParser
    final parsedConfig = FormConfigParser.generateUnifiedSchema(
      observationDetail!,
      customConfig,
    );

    // Récupérer les propriétés à afficher dans l'ordre
    final List<String> displayProperties =
        observationDetail!.displayProperties ??
            observationDetail!.displayList ??
            FormConfigParser.generateDefaultDisplayProperties(parsedConfig);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(4.0),
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey[300]!,
                    width: 1.0,
                  ),
                ),
              ),
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.list_alt,
                        color: Theme.of(context).primaryColor,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        observationDetail!.label ?? 'Observation détail',
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  // Bouton pour ajouter une nouvelle observation détaillée
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Ajouter'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 12.0),
                    ),
                    onPressed: () {
                      if (observationId != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ObservationDetailFormPage(
                              observationDetail: observationDetail,
                              observation: Observation(
                                  idObservation:
                                      observationId!), // Observation simplifiée avec juste l'id
                              customConfig: customConfig,
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Vous devez d\'abord créer une observation'),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            // Tableau des champs configurés
            _buildObservationDetailTable(displayProperties, parsedConfig),
          ],
        ),
      ),
    );
  }

  /// Construit le tableau des détails d'observation en fonction de la configuration
  Widget _buildObservationDetailTable(
    List<String> displayProperties,
    Map<String, dynamic> parsedConfig,
  ) {
    // Si nous n'avons pas de données à afficher
    if (observationId == null) {
      return Column(
        children: [
          // Entêtes de colonne
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey[400]!,
                  width: 1.0,
                ),
              ),
            ),
            child: Row(
              children: [
                // Colonne d'actions
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 80,
                    alignment: Alignment.center,
                    child: const Text(
                      'Actions',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                // Colonnes de données
                ...displayProperties.map((property) {
                  // Récupérer le libellé du champ depuis la configuration
                  final String label = parsedConfig.containsKey(property)
                      ? parsedConfig[property]['attribut_label'] ?? property
                      : property;

                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        label,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),

          // Message quand aucune donnée n'est disponible
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'Aucune donnée détaillée disponible pour cette observation',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
          ),
        ],
      );
    }

    // Construction de la liste des détails d'observation
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-têtes de colonnes
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey[400]!,
                  width: 1.0,
                ),
              ),
            ),
            child: Row(
              children: [
                // Colonne d'actions
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 80,
                    alignment: Alignment.center,
                    child: const Text(
                      'Actions',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                // Colonnes de données
                ...displayProperties.map((property) {
                  // Récupérer le libellé du champ depuis la configuration
                  final String label = parsedConfig.containsKey(property)
                      ? parsedConfig[property]['attribut_label'] ?? property
                      : property;

                  return SizedBox(
                    width: 150,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        label,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),

          // TODO: Ici, nous afficherions les données réelles des détails d'observation
          // Pour l'instant, nous affichons un exemple de ligne
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey[300]!,
                  width: 1.0,
                ),
              ),
            ),
            child: Row(
              children: [
                // Actions
                Container(
                  width: 80,
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.visibility, size: 20),
                        onPressed: () {
                          // Action pour voir les détails
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, size: 20),
                        onPressed: () {
                          // Action pour éditer
                        },
                      ),
                    ],
                  ),
                ),
                // Données
                ...displayProperties.map((property) {
                  return SizedBox(
                    width: 150,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Exemple pour $property'),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),

          // Si aucune donnée n'est disponible, afficher un message
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'Les détails seront disponibles ici après leur création.',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
