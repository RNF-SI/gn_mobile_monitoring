import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/core/helpers/form_config_parser.dart';
import 'package:gn_mobile_monitoring/core/helpers/format_datetime.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/base_visit.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/domain/model/observation.dart';
import 'package:gn_mobile_monitoring/domain/model/observation_detail.dart';
import 'package:gn_mobile_monitoring/presentation/model/module_info.dart';
import 'package:gn_mobile_monitoring/presentation/view/observation_detail_detail_page.dart';
import 'package:gn_mobile_monitoring/presentation/view/observation_detail_form_page.dart';
import 'package:gn_mobile_monitoring/presentation/view/observation_form_page.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/observations_viewmodel.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/breadcrumb_navigation.dart';

class ObservationDetailPage extends ConsumerStatefulWidget {
  final Observation observation;
  final BaseVisit visit;
  final BaseSite site;
  final ModuleInfo? moduleInfo;
  final dynamic fromSiteGroup;

  const ObservationDetailPage({
    super.key,
    required this.observation,
    required this.visit,
    required this.site,
    this.moduleInfo,
    this.fromSiteGroup,
  });

  @override
  ConsumerState<ObservationDetailPage> createState() =>
      _ObservationDetailPageState();
}

class _ObservationDetailPageState extends ConsumerState<ObservationDetailPage> {
  // Future pour charger les détails d'observation
  Future<List<ObservationDetail>>? _observationDetailsFuture;

  @override
  void initState() {
    super.initState();
    _loadObservationDetails();
  }

  // Méthode pour charger ou recharger les détails d'observation
  void _loadObservationDetails() {
    final observationsViewModel =
        ref.read(observationsProvider(widget.visit.idBaseVisit).notifier);
    _observationDetailsFuture = observationsViewModel
        .getObservationDetailsByObservationId(widget.observation.idObservation);
  }

  // Méthode pour rafraîchir les détails d'observation
  void _refreshObservationDetails() {
    setState(() {
      _loadObservationDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Récupérer la configuration des observations depuis le module
    final ObjectConfig? observationConfig =
        widget.moduleInfo?.module.complement?.configuration?.observation;

    return Scaffold(
      appBar: AppBar(
        title: Text('Détails de l\'observation'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              if (observationConfig != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ObservationFormPage(
                      visitId: widget.visit.idBaseVisit,
                      observationConfig: observationConfig,
                      customConfig: widget
                          .moduleInfo?.module.complement?.configuration?.custom,
                      moduleId: widget.moduleInfo?.module.id,
                      observation: widget.observation,
                      moduleName: widget.moduleInfo?.module.moduleLabel,
                      siteLabel: widget.moduleInfo?.module.complement
                              ?.configuration?.site?.label ??
                          'Site',
                      siteName:
                          widget.site.baseSiteName ?? widget.site.baseSiteCode,
                      visitLabel: widget.moduleInfo?.module.complement
                              ?.configuration?.visit?.label ??
                          'Visite',
                      visitDate: formatDateString(widget.visit.visitDateMin),
                    ),
                  ),
                ).then((_) {
                  // Rafraîchir les observations après édition
                  ref.refresh(observationsProvider(widget.visit.idBaseVisit));
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                        Text('Configuration des observations non disponible'),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: _buildContent(context, observationConfig),
    );
  }

  Widget _buildContent(BuildContext context, ObjectConfig? observationConfig) {
    // Récupérer les labels configurés
    final String siteLabel =
        widget.moduleInfo?.module.complement?.configuration?.site?.label ??
            'Site';
    final String visitLabel =
        widget.moduleInfo?.module.complement?.configuration?.visit?.label ??
            'Visite';
    final String observationLabel = widget
            .moduleInfo?.module.complement?.configuration?.observation?.label ??
        'Observation';
    final String groupLabel = widget
            .moduleInfo?.module.complement?.configuration?.sitesGroup?.label ??
        'Groupe';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fil d'Ariane pour la navigation
          if (widget.moduleInfo != null)
            Card(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                child: BreadcrumbNavigation(
                  items: [
                    // Module
                    BreadcrumbItem(
                      label: 'Module',
                      value: widget.moduleInfo!.module.moduleLabel ?? 'Module',
                      onTap: () {
                        Navigator.of(context).popUntil((route) =>
                            route.isFirst ||
                            route.settings.name == '/module_detail');
                      },
                    ),

                    // Groupe de site (si disponible)
                    if (widget.fromSiteGroup != null)
                      BreadcrumbItem(
                        label: groupLabel,
                        value: widget.fromSiteGroup.sitesGroupName ??
                            widget.fromSiteGroup.sitesGroupCode ??
                            'Groupe',
                        onTap: () {
                          int count = 0;
                          Navigator.of(context).popUntil((route) {
                            return count++ >= 3;
                          });
                        },
                      ),

                    // Site
                    BreadcrumbItem(
                      label: siteLabel,
                      value: widget.site.baseSiteName ??
                          widget.site.baseSiteCode ??
                          'Site',
                      onTap: () {
                        int count = 0;
                        Navigator.of(context).popUntil((route) => count++ >= 2);
                      },
                    ),

                    // Visite
                    BreadcrumbItem(
                      label: visitLabel,
                      value: formatDateString(widget.visit.visitDateMin),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),

                    // Observation (actuelle)
                    BreadcrumbItem(
                      label: observationLabel,
                      value: 'Observation #${widget.observation.idObservation}',
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 16),

          // Informations générales
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Informations générales',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  _buildInfoRow(
                      'ID', widget.observation.idObservation.toString()),
                  _buildInfoRow(
                      'Date de création',
                      widget.observation.metaCreateDate != null
                          ? formatDateString(widget.observation.metaCreateDate!)
                          : 'Non spécifiée'),
                  if (widget.observation.metaUpdateDate != null &&
                      widget.observation.metaUpdateDate !=
                          widget.observation.metaCreateDate)
                    _buildInfoRow('Dernière modification',
                        formatDateString(widget.observation.metaUpdateDate!)),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Commentaires
          if (widget.observation.comments != null &&
              widget.observation.comments!.isNotEmpty)
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
                    Text(widget.observation.comments ?? 'Aucun commentaire'),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 16),

          // Données spécifiques
          if (widget.observation.data != null &&
              widget.observation.data!.isNotEmpty)
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
                    // Trier et afficher les propriétés
                    ..._buildSortedProperties(
                      widget.observation.data!,
                      observationConfig,
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 16),

          // Détails d'observation (observation_detail)
          if (widget.moduleInfo?.module.complement?.configuration
                  ?.observationDetail !=
              null)
            Card(
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
                                widget
                                        .moduleInfo!
                                        .module
                                        .complement!
                                        .configuration!
                                        .observationDetail!
                                        .label ??
                                    'Observation détail',
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ObservationDetailFormPage(
                                    observationDetail: widget
                                        .moduleInfo!
                                        .module
                                        .complement!
                                        .configuration!
                                        .observationDetail,
                                    observation: widget.observation,
                                    customConfig: widget.moduleInfo!.module
                                        .complement!.configuration!.custom,
                                  ),
                                ),
                              ).then((result) {
                                // Si un résultat est retourné (détail sauvegardé avec succès)
                                if (result != null) {
                                  // Forcer un rechargement complet des détails
                                  setState(() {
                                    // Annuler toute future en cours
                                    _observationDetailsFuture = null;
                                    // Recharger les détails
                                    _loadObservationDetails();
                                  });

                                  // Afficher une confirmation
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Détail d\'observation ajouté avec succès'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    _buildObservationDetailDataTable(
                      widget.moduleInfo!.module.complement!.configuration!
                          .observationDetail!,
                      widget
                          .moduleInfo!.module.complement!.configuration!.custom,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildObservationDetailDataTable(
    ObjectConfig observationDetail,
    CustomConfig? customConfig,
  ) {
    // Parser la configuration avec le FormConfigParser
    final parsedConfig = FormConfigParser.generateUnifiedSchema(
      observationDetail,
      customConfig,
    );

    // Récupérer les propriétés à afficher dans l'ordre
    final List<String> displayProperties =
        observationDetail.displayProperties ??
            observationDetail.displayList ??
            FormConfigParser.generateDefaultDisplayProperties(parsedConfig);

    // Toujours recharger les détails pour s'assurer d'avoir les données les plus récentes
    // Cela garantit que le FutureBuilder sera reconstruit avec une nouvelle future
    _loadObservationDetails();

    return FutureBuilder<List<ObservationDetail>>(
      // Utiliser un UniqueKey pour forcer la reconstruction du FutureBuilder à chaque setState
      key: UniqueKey(),
      future: _observationDetailsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Erreur lors du chargement des détails: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        final observationDetails = snapshot.data ?? [];

        if (observationDetails.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Icon(Icons.info_outline, size: 48, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Aucun détail d\'observation disponible',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Cliquez sur "Ajouter" pour créer un nouveau détail',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Convertir les objets ObservationDetail pour l'affichage
        final List<Map<String, dynamic>> detailsData = observationDetails
            .map((ObservationDetail detail) => {
                  'id': detail.idObservationDetail,
                  'uuid': detail.uuidObservationDetail,
                  ...detail.data,
                })
            .toList();

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Card(
            elevation: 1,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: DataTable(
                  columns: [
                    const DataColumn(
                      label: Text(
                        'Actions',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    ...displayProperties.map((property) {
                      // Récupérer le libellé du champ depuis la configuration
                      final String label = parsedConfig.containsKey(property)
                          ? parsedConfig[property]['attribut_label'] ?? property
                          : property;

                      return DataColumn(
                        label: Text(
                          label,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      );
                    }).toList(),
                  ],
                  rows: detailsData.map((detail) {
                    return DataRow(
                      cells: [
                        // Cellule d'actions
                        DataCell(
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.visibility, size: 20),
                                onPressed: () {
                                  // Trouver le détail complet dans la liste
                                  final detailId = detail['id'] as int;
                                  final fullDetail =
                                      observationDetails.firstWhere(
                                    (d) => d.idObservationDetail == detailId,
                                  );

                                  // Trouver l'index du détail
                                  final index =
                                      observationDetails.indexOf(fullDetail) +
                                          1;

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ObservationDetailDetailPage(
                                        observationDetail: fullDetail,
                                        config: observationDetail,
                                        customConfig: customConfig,
                                        index: index,
                                      ),
                                    ),
                                  );
                                },
                                constraints: const BoxConstraints(
                                  minWidth: 40,
                                  minHeight: 40,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit, size: 20),
                                onPressed: () {
                                  final detailId = detail['id'] as int;
                                  _editObservationDetail(detailId,
                                      observationDetail, customConfig);
                                },
                                constraints: const BoxConstraints(
                                  minWidth: 40,
                                  minHeight: 40,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, size: 20),
                                onPressed: () {
                                  final detailId = detail['id'] as int;
                                  _showDeleteConfirmationDialog(detailId);
                                },
                                constraints: const BoxConstraints(
                                  minWidth: 40,
                                  minHeight: 40,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Cellules de données
                        ...displayProperties.map((property) {
                          final value = detail[property];
                          String displayValue = value?.toString() ?? '';
                          return DataCell(Text(displayValue));
                        }).toList(),
                      ],
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

  void _editObservationDetail(int detailId, ObjectConfig observationDetail,
      CustomConfig? customConfig) async {
    try {
      final observationsViewModel =
          ref.read(observationsProvider(widget.visit.idBaseVisit).notifier);
      final detail =
          await observationsViewModel.getObservationDetailById(detailId);

      if (detail != null) {
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ObservationDetailFormPage(
                observationDetail: observationDetail,
                observation: widget.observation,
                customConfig: customConfig,
                detail: detail, // Passer le détail existant pour l'édition
              ),
            ),
          ).then((result) {
            // Si un résultat est retourné (détail modifié avec succès)
            if (result != null) {
              // Forcer un rechargement complet des détails
              setState(() {
                // Annuler toute future en cours
                _observationDetailsFuture = null;
                // Recharger les détails
                _loadObservationDetails();
              });

              // Afficher une confirmation
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Détail d\'observation modifié avec succès'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          });
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Détail d\'observation non trouvé')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: ${e.toString()}')),
        );
      }
    }
  }

  void _showDeleteConfirmationDialog(int detailId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmation'),
        content: const Text(
            'Voulez-vous vraiment supprimer ce détail d\'observation?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteObservationDetail(detailId);
            },
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteObservationDetail(int detailId) async {
    try {
      final observationsViewModel =
          ref.read(observationsProvider(widget.visit.idBaseVisit).notifier);
      final success =
          await observationsViewModel.deleteObservationDetail(detailId);

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Détail d\'observation supprimé avec succès'),
                backgroundColor: Colors.green),
          );
          // Forcer un rechargement complet des détails
          setState(() {
            // Annuler toute future en cours
            _observationDetailsFuture = null;
            // Recharger les détails
            _loadObservationDetails();
          });
        }
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Erreur lors de la suppression du détail')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: ${e.toString()}')),
        );
      }
    }
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
    int observationId,
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
                    if (observationConfig != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ObservationFormPage(
                            visitId: widget.visit.idBaseVisit,
                            observationConfig: observationConfig,
                            customConfig: widget.moduleInfo?.module.complement
                                ?.configuration?.custom,
                            moduleId: widget.moduleInfo?.module.id,
                            observation: widget.observation,
                            moduleName: widget.moduleInfo?.module.moduleLabel,
                            siteLabel: widget.moduleInfo?.module.complement
                                    ?.configuration?.site?.label ??
                                'Site',
                            siteName: widget.site.baseSiteName ??
                                widget.site.baseSiteCode,
                            visitLabel: widget.moduleInfo?.module.complement
                                    ?.configuration?.visit?.label ??
                                'Visite',
                            visitDate:
                                formatDateString(widget.visit.visitDateMin),
                          ),
                        ),
                      ).then((_) {
                        // Rafraîchir les observations après édition
                        ref.refresh(
                            observationsProvider(widget.visit.idBaseVisit));
                      });
                    }
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
                        content: const Text(
                            'Voulez-vous vraiment supprimer cette observation?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Annuler'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              _deleteObservation(observationId);
                            },
                            child: const Text('Supprimer',
                                style: TextStyle(color: Colors.red)),
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

  // Supprimer une observation
  Future<void> _deleteObservation(int observationId) async {
    try {
      final viewModel =
          ref.read(observationsProvider(widget.visit.idBaseVisit).notifier);
      final success = await viewModel.deleteObservation(observationId);

      if (success) {
        // Afficher un message de succès
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Observation supprimée avec succès')),
          );
          // Rafraîchir les observations
          ref.refresh(observationsProvider(widget.visit.idBaseVisit));
          // Retourner à la page précédente
          Navigator.of(context).pop();
        }
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Erreur lors de la suppression de l\'observation')),
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

  List<Widget> _buildSortedProperties(
    Map<String, dynamic> data,
    ObjectConfig? observationConfig,
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

    // Fonction pour obtenir le label d'une propriété
    String getPropertyLabel(String key) {
      if (observationConfig != null) {
        // Vérifier dans generic
        if (observationConfig.generic != null &&
            observationConfig.generic!.containsKey(key)) {
          return observationConfig.generic![key]!.attributLabel ?? key;
        }
        // Vérifier dans specific
        else if (observationConfig.specific != null &&
            observationConfig.specific!.containsKey(key)) {
          final specificConfig =
              observationConfig.specific![key] as Map<String, dynamic>;
          if (specificConfig.containsKey('attribut_label')) {
            return specificConfig['attribut_label'];
          }
        }
      }
      // Formater le libellé par défaut
      return key
          .replaceAll('_', ' ')
          .split(' ')
          .map((word) =>
              word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '')
          .join(' ');
    }

    // Construire les widgets pour les propriétés remplies
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

      widgets.addAll(filledProperties.map((entry) => _buildPropertyRow(
            getPropertyLabel(entry.key),
            entry.value.toString(),
          )));
    }

    // Ajouter les propriétés vides
    if (emptyProperties.isNotEmpty) {
      widgets.add(
        const SizedBox(height: 16),
      );
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

      widgets.addAll(emptyProperties.map((entry) => _buildPropertyRow(
            getPropertyLabel(entry.key),
            'Non renseigné',
            isEmptyField: true,
          )));
    }

    return widgets;
  }

  Widget _buildPropertyRow(String label, String value,
      {bool isEmptyField = false}) {
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
