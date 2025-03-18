import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/core/helpers/form_config_parser.dart';
import 'package:gn_mobile_monitoring/core/helpers/format_datetime.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/base_visit.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/domain/model/observation.dart';
import 'package:gn_mobile_monitoring/presentation/model/module_info.dart';
import 'package:gn_mobile_monitoring/presentation/view/visit_form_page.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/observations_viewmodel.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/site_visits_viewmodel.dart';

class VisitDetailPage extends ConsumerStatefulWidget {
  final BaseVisit visit;
  final BaseSite site;
  final ModuleInfo? moduleInfo;

  const VisitDetailPage({
    super.key,
    required this.visit,
    required this.site,
    this.moduleInfo,
  });

  @override
  ConsumerState<VisitDetailPage> createState() => _VisitDetailPageState();
}

class _VisitDetailPageState extends ConsumerState<VisitDetailPage> {
  // Utiliser un FutureProvider unique à cette instance pour éviter la reconstruction à chaque build
  late final AutoDisposeFutureProvider<BaseVisit> _visitDetailsProvider;
  
  @override
  void initState() {
    super.initState();
    
    // Définir un provider pour cette instance spécifique
    _visitDetailsProvider = FutureProvider.autoDispose<BaseVisit>((ref) async {
      // L'appel est maintenant contrôlé et ne sera exécuté qu'une seule fois par le FutureProvider
      final viewModel = ref.read(siteVisitsViewModelProvider(widget.site.idBaseSite).notifier);
      return viewModel.getVisitWithFullDetails(widget.visit.idBaseVisit);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    // Récupérer la configuration des visites depuis le module
    final ObjectConfig? visitConfig =
        widget.moduleInfo?.module.complement?.configuration?.visit;

    // Récupérer la configuration des observations depuis le module
    final ObjectConfig? observationConfig =
        widget.moduleInfo?.module.complement?.configuration?.observation;

    // Utiliser le provider défini dans initState qui est maintenant stable
    final visitWithDetailsState = ref.watch(_visitDetailsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Détails de la visite'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              if (visitConfig != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VisitFormPage(
                      site: widget.site,
                      visitConfig: visitConfig,
                      customConfig:
                          widget.moduleInfo?.module.complement?.configuration?.custom,
                      moduleId: widget.moduleInfo?.module.id,
                      visit: widget.visit,
                    ),
                  ),
                ).then((_) {
                  // Rafraîchir les données après édition
                  ref
                      .read(
                          siteVisitsViewModelProvider(widget.site.idBaseSite).notifier)
                      .loadVisits();
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Configuration de visite non disponible'),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: visitWithDetailsState.when(
        data: (fullVisit) =>
            _buildContent(context, fullVisit, visitConfig, observationConfig),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text(
            'Erreur lors du chargement des détails: $error',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, BaseVisit fullVisit,
      ObjectConfig? visitConfig, ObjectConfig? observationConfig) {
    return Column(
      children: [
        // Informations de la visite (partie supérieure)
        Expanded(
          flex: 2, // Prend 1/3 de l'écran
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Carte d'informations générales
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Informations générales',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        _buildInfoRow(
                            'Site', widget.site.baseSiteName ?? 'Non spécifié'),
                        _buildInfoRow('Date de visite',
                            formatDateString(fullVisit.visitDateMin)),
                        if (fullVisit.visitDateMax != null &&
                            fullVisit.visitDateMax != fullVisit.visitDateMin)
                          _buildInfoRow('Fin de visite',
                              formatDateString(fullVisit.visitDateMax!)),
                        _buildInfoRow(
                            'Observateurs',
                            fullVisit.observers != null &&
                                    fullVisit.observers!.isNotEmpty
                                ? '${fullVisit.observers!.length} observateur(s)'
                                : 'Aucun observateur'),
                        _buildInfoRow(
                            'Date de création',
                            fullVisit.metaCreateDate != null
                                ? formatDateString(fullVisit.metaCreateDate!)
                                : 'Non spécifiée'),
                        if (fullVisit.metaUpdateDate != null &&
                            fullVisit.metaUpdateDate !=
                                fullVisit.metaCreateDate)
                          _buildInfoRow('Dernière modification',
                              formatDateString(fullVisit.metaUpdateDate!)),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Commentaires
                if (fullVisit.comments != null &&
                    fullVisit.comments!.isNotEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Commentaires',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 16),
                          Text(fullVisit.comments ?? 'Aucun commentaire'),
                        ],
                      ),
                    ),
                  ),

                const SizedBox(height: 16),

                // Données spécifiques au module
                if (fullVisit.data != null && fullVisit.data!.isNotEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Données spécifiques',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 16),
                          ..._buildDataFields(
                              fullVisit.data!, observationConfig),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),

        // Section des observations (partie inférieure)
        Expanded(
          flex: 3, // Prend 2/3 de l'écran
          child:
              _buildObservationsSection(context, fullVisit, observationConfig),
        ),
      ],
    );
  }

  Widget _buildObservationsSection(BuildContext context, BaseVisit fullVisit,
      ObjectConfig? observationConfig) {
    return Container(
      color: Colors.grey.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre et bouton d'ajout
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  observationConfig?.label ?? 'Observations',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    _showAddObservationDialog(fullVisit.idBaseVisit, observationConfig);
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Ajouter'),
                ),
              ],
            ),
          ),

          // Tableau des observations
          Expanded(
            child:
                _buildObservationsTable(context, fullVisit, observationConfig),
          ),
        ],
      ),
    );
  }

  Widget _buildObservationsTable(BuildContext context, BaseVisit fullVisit,
      ObjectConfig? observationConfig) {
    // Utiliser le nouveau viewModel pour les observations
    final observationsState = ref.watch(observationsProvider(fullVisit.idBaseVisit));
    
    return observationsState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(
        child: Text(
          'Erreur lors du chargement des observations: $error',
          style: const TextStyle(color: Colors.red),
        ),
      ),
      data: (observationsList) {
        // Convertir les objets Observation en Map pour le tableau
        final List<Map<String, dynamic>> observations = [];
        if (observationsList.isNotEmpty) {
          for (final observation in observationsList) {
            final Map<String, dynamic> obsMap = {
              'id_observation': observation.idObservation,
              'cd_nom': observation.cdNom,
              'comments': observation.comments,
            };
            
            // Ajouter les données spécifiques
            if (observation.data != null) {
              obsMap.addAll(observation.data!);
            }
            
            observations.add(obsMap);
          }
        }

        if (observations.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.nature, size: 48, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  'Aucune observation enregistrée pour cette visite',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Cliquez sur "Ajouter" pour créer une nouvelle observation',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          );
        }

        // Déterminer les colonnes à afficher
        List<String> displayColumns = ['actions'];

        if (observationConfig?.displayList != null &&
            observationConfig!.displayList!.isNotEmpty) {
          // Utiliser les colonnes définies dans la config
          displayColumns.addAll(observationConfig.displayList!);
        } else if (observationConfig?.displayProperties != null &&
            observationConfig!.displayProperties!.isNotEmpty) {
          // Utiliser les propriétés si disponibles
          displayColumns.addAll(observationConfig.displayProperties!);
        } else {
          // Colonnes par défaut
          displayColumns.addAll(['cd_nom', 'comments']);
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Card(
            elevation: 2,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: DataTable(
                  columns: _buildDataColumns(displayColumns, observationConfig),
                  rows: observations.map((observation) {
                    return _buildDataRow(
                      observation,
                      displayColumns,
                      observationConfig,
                      context,
                      fullVisit.idBaseVisit,
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  List<DataColumn> _buildDataColumns(
      List<String> columns, ObjectConfig? observationConfig) {
    return columns.map((column) {
      String label = column;

      // Obtenir le libellé à partir de la configuration
      if (column != 'actions' && observationConfig != null) {
        // Vérifier dans generic
        if (observationConfig.generic != null &&
            observationConfig.generic!.containsKey(column)) {
          label = observationConfig.generic![column]!.attributLabel ?? column;
        }
        // Vérifier dans specific
        else if (observationConfig.specific != null &&
            observationConfig.specific!.containsKey(column)) {
          final specificConfig =
              observationConfig.specific![column] as Map<String, dynamic>;
          if (specificConfig.containsKey('attribut_label')) {
            label = specificConfig['attribut_label'];
          }
        }
      }

      // Pour la colonne des actions
      if (column == 'actions') {
        label = 'Actions';
      }

      // Formater le libellé
      label = label
          .replaceAll('_', ' ')
          .split(' ')
          .map((word) =>
              word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '')
          .join(' ');

      return DataColumn(
        label: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      );
    }).toList();
  }

  DataRow _buildDataRow(
    Map<String, dynamic> observation, 
    List<String> columns,
    ObjectConfig? observationConfig, 
    BuildContext context,
    int visitId,
  ) {
    return DataRow(
      cells: columns.map((column) {
        // Cellule d'actions
        if (column == 'actions') {
          return DataCell(
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  onPressed: () {
                    _showEditObservationDialog(
                      observation['id_observation'] as int, 
                      visitId,
                      observation,
                      observationConfig
                    );
                  },
                  constraints: const BoxConstraints(
                    minWidth: 40,
                    minHeight: 40,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, size: 20),
                  onPressed: () {
                    // Afficher une boîte de dialogue de confirmation
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Confirmation'),
                        content: const Text('Voulez-vous vraiment supprimer cette observation?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Annuler'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              _deleteObservation(
                                observation['id_observation'] as int,
                                visitId,
                              );
                            },
                            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                  },
                  constraints: const BoxConstraints(
                    minWidth: 40,
                    minHeight: 40,
                  ),
                ),
              ],
            ),
          );
        }

        // Cellules de données
        final value = observation[column];
        String displayValue = value?.toString() ?? '';

        return DataCell(Text(displayValue));
      }).toList(),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
  
  List<Widget> _buildDataFields(
      Map<String, dynamic> data, ObjectConfig? config) {
    final List<Widget> widgets = [];
    final Map<String, String> fieldLabels = {};

    // Si une configuration est disponible, utiliser le form_config_parser
    // pour obtenir des libellés appropriés
    if (config != null) {
      final parsedConfig = FormConfigParser.generateUnifiedSchema(
          config, widget.moduleInfo?.module.complement?.configuration?.custom);

      // Extraire les libellés des champs
      for (final entry in parsedConfig.entries) {
        fieldLabels[entry.key] = entry.value['attribut_label'];
      }
    }

    // Trier les clés pour un affichage cohérent
    final sortedKeys = data.keys.toList()..sort();

    for (final key in sortedKeys) {
      if (data[key] != null) {
        // Formater le libellé du champ
        String displayLabel = fieldLabels[key] ?? key;
        if (displayLabel == key) {
          // Si pas de libellé trouvé, formater la clé pour qu'elle soit plus lisible
          displayLabel = key
              .replaceAll('_', ' ')
              .split(' ')
              .map((word) => word.isNotEmpty
                  ? word[0].toUpperCase() + word.substring(1)
                  : '')
              .join(' ');
        }

        String displayValue;
        if (data[key] is Map) {
          displayValue = 'Objet complexe';
        } else if (data[key] is List) {
          displayValue = 'Liste (${data[key].length} éléments)';
        } else {
          displayValue = data[key].toString();
        }

        widgets.add(_buildInfoRow(displayLabel, displayValue));
      }
    }

    if (widgets.isEmpty) {
      widgets.add(const Text('Aucune donnée spécifique disponible'));
    }

    return widgets;
  }
  
  // Méthodes pour gérer les observations
  
  // Afficher le dialogue d'ajout d'observation
  void _showAddObservationDialog(int visitId, ObjectConfig? observationConfig) {
    final formData = <String, dynamic>{};
    
    // Créer les contrôleurs pour les champs de base
    final commentController = TextEditingController();
    final taxonController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajouter une observation'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Champ pour le taxon (cd_nom)
              TextField(
                controller: taxonController,
                decoration: const InputDecoration(
                  labelText: 'Taxon (CD_NOM)',
                  hintText: 'Entrez le code du taxon',
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  if (value.isNotEmpty && int.tryParse(value) != null) {
                    formData['cd_nom'] = int.parse(value);
                  }
                },
              ),
              const SizedBox(height: 16),
              // Champ pour les commentaires
              TextField(
                controller: commentController,
                decoration: const InputDecoration(
                  labelText: 'Commentaires',
                  hintText: 'Entrez un commentaire',
                ),
                maxLines: 3,
                onChanged: (value) {
                  formData['comments'] = value;
                },
              ),
              
              // Ajouter d'autres champs selon la configuration
              if (observationConfig != null) ...[
                const SizedBox(height: 16),
                const Text('Champs supplémentaires', 
                  style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                // Ici vous pouvez générer des champs dynamiques selon observationConfig
                // Comme exemple simple, ajoutons un champ générique:
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Abondance',
                    hintText: 'Valeur numérique',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    if (value.isNotEmpty && int.tryParse(value) != null) {
                      formData['id_nomenclature_abondance'] = int.parse(value);
                    }
                  },
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _createObservation(formData, visitId);
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }
  
  // Afficher le dialogue d'édition d'observation
  void _showEditObservationDialog(
    int observationId, 
    int visitId,
    Map<String, dynamic> observationData,
    ObjectConfig? observationConfig
  ) {
    final formData = Map<String, dynamic>.from(observationData);
    
    // Créer les contrôleurs pour les champs de base avec les valeurs existantes
    final commentController = TextEditingController(
      text: observationData['comments']?.toString() ?? '',
    );
    final taxonController = TextEditingController(
      text: observationData['cd_nom']?.toString() ?? '',
    );
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modifier l\'observation'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Champ pour le taxon (cd_nom)
              TextField(
                controller: taxonController,
                decoration: const InputDecoration(
                  labelText: 'Taxon (CD_NOM)',
                  hintText: 'Entrez le code du taxon',
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  if (value.isNotEmpty && int.tryParse(value) != null) {
                    formData['cd_nom'] = int.parse(value);
                  } else {
                    formData['cd_nom'] = null;
                  }
                },
              ),
              const SizedBox(height: 16),
              // Champ pour les commentaires
              TextField(
                controller: commentController,
                decoration: const InputDecoration(
                  labelText: 'Commentaires',
                  hintText: 'Entrez un commentaire',
                ),
                maxLines: 3,
                onChanged: (value) {
                  formData['comments'] = value;
                },
              ),
              
              // Ajouter d'autres champs selon la configuration et les données existantes
              if (observationConfig != null) ...[
                const SizedBox(height: 16),
                const Text('Champs supplémentaires', 
                  style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                // Ici vous pouvez générer des champs dynamiques selon observationConfig
                // Pour cet exemple, nous ajoutons juste un champ d'abondance
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Abondance',
                    hintText: 'Valeur numérique',
                  ),
                  controller: TextEditingController(
                    text: observationData['id_nomenclature_abondance']?.toString() ?? '',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    if (value.isNotEmpty && int.tryParse(value) != null) {
                      formData['id_nomenclature_abondance'] = int.parse(value);
                    } else {
                      formData['id_nomenclature_abondance'] = null;
                    }
                  },
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _updateObservation(formData, observationId, visitId);
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }
  
  // Créer une nouvelle observation
  Future<void> _createObservation(Map<String, dynamic> formData, int visitId) async {
    try {
      final viewModel = ref.read(observationsProvider(visitId).notifier);
      await viewModel.createObservation(formData);
      
      // Afficher un message de succès
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Observation créée avec succès')),
        );
      }
    } catch (e) {
      // Afficher un message d'erreur
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: ${e.toString()}')),
        );
      }
    }
  }
  
  // Mettre à jour une observation existante
  Future<void> _updateObservation(
    Map<String, dynamic> formData, 
    int observationId, 
    int visitId
  ) async {
    try {
      final viewModel = ref.read(observationsProvider(visitId).notifier);
      final success = await viewModel.updateObservation(formData, observationId);
      
      if (success) {
        // Afficher un message de succès
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Observation mise à jour avec succès')),
          );
        }
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur lors de la mise à jour de l\'observation')),
        );
      }
    } catch (e) {
      // Afficher un message d'erreur
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: ${e.toString()}')),
        );
      }
    }
  }
  
  // Supprimer une observation
  Future<void> _deleteObservation(int observationId, int visitId) async {
    try {
      final viewModel = ref.read(observationsProvider(visitId).notifier);
      final success = await viewModel.deleteObservation(observationId);
      
      if (success) {
        // Afficher un message de succès
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Observation supprimée avec succès')),
          );
        }
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur lors de la suppression de l\'observation')),
        );
      }
    } catch (e) {
      // Afficher un message d'erreur
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: ${e.toString()}')),
        );
      }
    }
  }
}