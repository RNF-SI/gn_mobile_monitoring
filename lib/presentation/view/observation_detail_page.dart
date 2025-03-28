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
import 'package:gn_mobile_monitoring/presentation/viewmodel/observation_detail_viewmodel.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/breadcrumb_navigation.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/property_display_widget.dart';

class ObservationDetailPage extends ConsumerStatefulWidget {
  final Observation observation;
  final BaseVisit visit;
  final BaseSite site;
  final ModuleInfo? moduleInfo;
  final dynamic fromSiteGroup;
  final ObjectConfig? observationConfig;
  final CustomConfig? customConfig;
  final ObjectConfig? observationDetailConfig;
  final bool isNewObservation;

  const ObservationDetailPage({
    super.key,
    required this.observation,
    required this.visit,
    required this.site,
    this.moduleInfo,
    this.fromSiteGroup,
    this.observationConfig,
    this.customConfig,
    this.observationDetailConfig,
    this.isNewObservation = false,
  });

  @override
  ConsumerState<ObservationDetailPage> createState() =>
      _ObservationDetailPageState();
}

class _ObservationDetailPageState extends ConsumerState<ObservationDetailPage> {
  // Future pour charger les détails d'observation
  Future<List<ObservationDetail>>? _observationDetailsFuture;
  bool _hasShownDetailDialog = false;

  @override
  void initState() {
    super.initState();
    _loadObservationDetails();

    // Proposer la création d'un détail après un court délai seulement si c'est une nouvelle observation
    if (widget.isNewObservation) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _proposeObservationDetailCreation();
      });
    }
  }

  // Méthode pour charger ou recharger les détails d'observation
  void _loadObservationDetails() {
    final observationDetailsViewModel = ref.read(
        observationDetailsProvider(widget.observation.idObservation).notifier);
    _observationDetailsFuture = observationDetailsViewModel
        .getObservationDetailsByObservationId(widget.observation.idObservation);
  }

  // Méthode pour rafraîchir les détails d'observation
  void _refreshObservationDetails() {
    setState(() {
      _loadObservationDetails();
    });
  }

  void _proposeObservationDetailCreation() {
    if (!_hasShownDetailDialog && mounted) {
      _hasShownDetailDialog = true;

      // Récupérer la configuration des détails d'observation
      final ObjectConfig? observationDetailConfig = widget
          .moduleInfo?.module.complement?.configuration?.observationDetail;

      if (observationDetailConfig != null) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Nouvelle observation'),
            content: const Text(
                'Souhaitez-vous saisir des détails pour cette observation ?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Non'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _showAddObservationDetailDialog(
                      widget.observation.idObservation,
                      observationDetailConfig);
                },
                child: const Text('Oui'),
              ),
            ],
          ),
        );
      }
    }
  }

  void _showAddObservationDetailDialog(
      int observationId, ObjectConfig observationDetailConfig) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ObservationDetailFormPage(
          observationDetail: observationDetailConfig,
          observation: widget.observation,
          customConfig: widget.customConfig,
          visit: widget.visit,
          site: widget.site,
          moduleInfo: widget.moduleInfo,
          fromSiteGroup: widget.fromSiteGroup,
        ),
      ),
    ).then((_) {
      // Rafraîchir les détails après ajout
      ref.refresh(observationDetailsProvider(observationId));
    });
  }

  void _showEditObservationDetailDialog(int observationId, int detailId,
      Map<String, dynamic> detailData, ObjectConfig observationDetailConfig) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ObservationDetailFormPage(
          observationDetail: observationDetailConfig,
          observation: widget.observation,
          customConfig: widget.customConfig,
          visit: widget.visit,
          site: widget.site,
          moduleInfo: widget.moduleInfo,
          fromSiteGroup: widget.fromSiteGroup,
          existingDetail: ObservationDetail(
            idObservationDetail: detailId,
            idObservation: observationId,
            data: detailData,
          ),
        ),
      ),
    ).then((_) {
      // Rafraîchir les détails après édition
      ref.refresh(observationDetailsProvider(observationId));
    });
  }

  Future<void> _deleteObservationDetail(int observationId, int detailId) async {
    try {
      final success = await ref
          .read(observationDetailsProvider(observationId).notifier)
          .deleteObservationDetail(detailId);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Détail d\'observation supprimé avec succès'),
            backgroundColor: Colors.green,
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Erreur lors de la suppression du détail d\'observation'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Utiliser le provider pour les détails d'observation
    final observationDetailsState =
        ref.watch(observationDetailsProvider(widget.observation.idObservation));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails de l\'observation'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              if (widget.observationConfig != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ObservationFormPage(
                      visitId: widget.visit.idBaseVisit,
                      observationConfig: widget.observationConfig!,
                      customConfig: widget.customConfig,
                      observation: widget.observation,
                      moduleId: widget.moduleInfo?.module.id,
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
                      visit: widget.visit,
                      site: widget.site,
                      moduleInfo: widget.moduleInfo,
                      fromSiteGroup: widget.fromSiteGroup,
                    ),
                  ),
                ).then((_) {
                  // Rafraîchir les détails après édition
                  ref.refresh(observationDetailsProvider(
                      widget.observation.idObservation));
                });
              }
            },
          ),
        ],
      ),
      body: observationDetailsState.when(
        data: (details) => _buildContent(context, details),
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

  Widget _buildContent(BuildContext context, List<ObservationDetail> details) {
    // Récupérer la configuration des observations depuis le module
    final ObjectConfig? observationConfig =
        widget.moduleInfo?.module.complement?.configuration?.observation;

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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 12.0),
                  child: BreadcrumbNavigation(
                    items: [
                      // Module
                      BreadcrumbItem(
                        label: 'Module',
                        value:
                            widget.moduleInfo!.module.moduleLabel ?? 'Module',
                        onTap: () {
                          // Naviguer vers le module (retour de plusieurs niveaux)
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
                            // Retour vers le groupe (2 niveaux - passer par le site)
                            int count = 0;
                            Navigator.of(context).popUntil((route) {
                              return count++ >= 2;
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
                          // Naviguer vers le site (retour de 1 niveau)
                          Navigator.of(context).pop();
                        },
                      ),
                      // Visite
                      BreadcrumbItem(
                        label: visitLabel,
                        value: formatDateString(widget.visit.visitDateMin),
                        onTap: () {
                          // Retour à la visite (1 niveau)
                          Navigator.of(context).pop();
                        },
                      ),
                      // Observation (actuelle)
                      BreadcrumbItem(
                        label: observationLabel,
                        value:
                            'Observation #${widget.observation.idObservation}',
                      ),
                    ],
                  ),
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
            PropertyDisplayWidget(
              data: widget.observation.data!,
              config: observationConfig,
              customConfig:
                  widget.moduleInfo?.module.complement?.configuration?.custom,
              separateEmptyFields: true,
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
                                    visit: widget.visit,
                                    site: widget.site,
                                    moduleInfo: widget.moduleInfo,
                                    fromSiteGroup: widget.fromSiteGroup,
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
      final observationDetailsViewModel = ref.read(
          observationDetailsProvider(widget.observation.idObservation)
              .notifier);
      final detail =
          await observationDetailsViewModel.getObservationDetailById(detailId);

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
                visit: widget.visit,
                site: widget.site,
                moduleInfo: widget.moduleInfo,
                fromSiteGroup: widget.fromSiteGroup,
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
              _deleteObservationDetail(
                  widget.observation.idObservation, detailId);
            },
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
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
                            observationConfig: widget.observationConfig!,
                            customConfig: widget.customConfig,
                            observation: widget.observation,
                            moduleId: widget.moduleInfo?.module.id,
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
                            visit: widget.visit,
                            site: widget.site,
                            moduleInfo: widget.moduleInfo,
                            fromSiteGroup: widget.fromSiteGroup,
                          ),
                        ),
                      ).then((_) {
                        // Rafraîchir les détails après édition
                        ref.refresh(observationDetailsProvider(
                            widget.observation.idObservation));
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
                              _deleteObservationDetail(
                                  widget.observation.idObservation,
                                  observationId);
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
}
