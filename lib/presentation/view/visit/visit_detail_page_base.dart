import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/core/helpers/form_config_parser.dart';
import 'package:gn_mobile_monitoring/core/helpers/format_datetime.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/base_visit.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/domain/model/observation.dart';
import 'package:gn_mobile_monitoring/presentation/model/module_info.dart';
import 'package:gn_mobile_monitoring/presentation/view/base/detail_page.dart';
import 'package:gn_mobile_monitoring/presentation/view/observation/observation_detail_page.dart';
import 'package:gn_mobile_monitoring/presentation/view/observation/observation_form_page.dart';
import 'package:gn_mobile_monitoring/presentation/view/visit/visit_form_page.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/observations_viewmodel.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/site_visits_viewmodel.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/breadcrumb_navigation.dart';

/// Page de détail de visite basée sur la classe DetailPage
class VisitDetailPageBase extends DetailPage {
  final WidgetRef ref;
  final BaseVisit visit;
  final BaseSite site;
  final ModuleInfo? moduleInfo;
  final dynamic fromSiteGroup;
  final bool isNewVisit;

  const VisitDetailPageBase({
    super.key,
    required this.ref,
    required this.visit,
    required this.site,
    this.moduleInfo,
    this.fromSiteGroup,
    this.isNewVisit = false,
  });

  @override
  DetailPageState<VisitDetailPageBase> createState() =>
      _VisitDetailPageBaseState();
}

class _VisitDetailPageBaseState extends DetailPageState<VisitDetailPageBase>
    with SingleTickerProviderStateMixin {
  bool _hasShownObservationDialog = false;
  BaseVisit? _fullVisit;
  TabController? _tabController;

  @override
  void initState() {
    super.initState();

    // Initialiser le TabController avec un seul onglet "Observations"
    _tabController = TabController(length: 1, vsync: this);

    // Charger les détails de la visite dès l'initialisation
    _loadVisitDetails();

    // Proposer la création d'une observation après un court délai si c'est une nouvelle visite
    if (widget.isNewVisit) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _proposeObservationCreation();
      });
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  // Charger les détails de la visite
  void _loadVisitDetails() {
    final viewModel = widget.ref.read(siteVisitsViewModelProvider(
        (widget.site.idBaseSite, widget.visit.idModule)).notifier);

    viewModel.getVisitWithFullDetails(widget.visit.idBaseVisit).then((visit) {
      if (mounted) {
        setState(() {
          _fullVisit = visit;
        });
      }
    }).catchError((e) {
      // Gérer l'erreur de chargement
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur de chargement: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }

  void _proposeObservationCreation() {
    if (!_hasShownObservationDialog && mounted) {
      _hasShownObservationDialog = true;

      // Récupérer la configuration des observations
      final ObjectConfig? observationConfig =
          widget.moduleInfo?.module.complement?.configuration?.observation;

      if (observationConfig != null) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Créer une observation'),
            content: const Text(
                'Voulez-vous créer une observation pour cette visite maintenant ?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Plus tard'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _showAddObservationDialog(
                      widget.visit.idBaseVisit, observationConfig);
                },
                child: const Text('Créer'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  ObjectConfig? get objectConfig =>
      widget.moduleInfo?.module.complement?.configuration?.visit;

  @override
  CustomConfig? get customConfig =>
      widget.moduleInfo?.module.complement?.configuration?.custom;

  @override
  List<String>? get displayProperties =>
      objectConfig?.displayProperties ?? objectConfig?.displayList;

  @override
  Map<String, dynamic> get objectData {
    if (_fullVisit?.data != null) {
      return _fullVisit!.data!;
    }
    return {};
  }

  @override
  String get propertiesTitle => 'Données spécifiques de la visite';

  @override
  bool get separateEmptyFields => true;

  @override
  List<BreadcrumbItem> getBreadcrumbItems() {
    final items = <BreadcrumbItem>[];

    // Récupérer les labels configurés
    final String siteLabel =
        widget.moduleInfo?.module.complement?.configuration?.site?.label ??
            'Site';
    final String visitLabel =
        widget.moduleInfo?.module.complement?.configuration?.visit?.label ??
            'Visite';
    final String groupLabel = widget
            .moduleInfo?.module.complement?.configuration?.sitesGroup?.label ??
        'Groupe';

    if (widget.moduleInfo != null) {
      // Module
      items.add(
        BreadcrumbItem(
          label: 'Module',
          value: widget.moduleInfo!.module.moduleLabel ?? 'Module',
          onTap: () {
            // Naviguer vers le module (retour de plusieurs niveaux)
            Navigator.of(context).popUntil((route) =>
                route.isFirst || route.settings.name == '/module_detail');
          },
        ),
      );

      // Groupe de site (si disponible)
      if (widget.fromSiteGroup != null) {
        items.add(
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
        );
      }

      // Site
      items.add(
        BreadcrumbItem(
          label: siteLabel,
          value: widget.site.baseSiteName ?? widget.site.baseSiteCode ?? 'Site',
          onTap: () {
            // Naviguer vers le site (retour de 1 niveau)
            Navigator.of(context).pop();
          },
        ),
      );

      // Visite (actuelle)
      items.add(
        BreadcrumbItem(
          label: visitLabel,
          value: formatDateString(widget.visit.visitDateMin),
        ),
      );
    }

    return items;
  }

  @override
  PreferredSizeWidget buildAppBar() {
    return AppBar(
      title: Text(getTitle()),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            if (objectConfig != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VisitFormPage(
                    site: widget.site,
                    visitConfig: objectConfig!,
                    customConfig: customConfig,
                    moduleId: widget.moduleInfo?.module.id,
                    visit: widget.visit,
                    moduleInfo: widget.moduleInfo, // Pour le fil d'Ariane
                    siteGroup: widget.fromSiteGroup, // Pour le fil d'Ariane
                  ),
                ),
              ).then((_) {
                // Rafraîchir les données après édition
                widget.ref
                    .read(siteVisitsViewModelProvider(
                            (widget.site.idBaseSite, widget.visit.idModule))
                        .notifier)
                    .loadVisits();

                // Recharger les détails
                _loadVisitDetails();
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
    );
  }

  @override
  String getTitle() {
    return 'Détails de la visite';
  }

  @override
  Widget buildBaseContent() {
    if (_fullVisit == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
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
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  _buildInfoRow(
                      'Site', widget.site.baseSiteName ?? 'Non spécifié'),
                  _buildInfoRow('Date de visite',
                      formatDateString(_fullVisit!.visitDateMin)),
                  if (_fullVisit!.visitDateMax != null &&
                      _fullVisit!.visitDateMax != _fullVisit!.visitDateMin)
                    _buildInfoRow('Fin de visite',
                        formatDateString(_fullVisit!.visitDateMax!)),
                  _buildInfoRow(
                      'Observateurs',
                      _fullVisit!.observers != null &&
                              _fullVisit!.observers!.isNotEmpty
                          ? '${_fullVisit!.observers!.length} observateur(s)'
                          : 'Aucun observateur'),
                  _buildInfoRow(
                      'Date de création',
                      _fullVisit!.metaCreateDate != null
                          ? formatDateString(_fullVisit!.metaCreateDate!)
                          : 'Non spécifiée'),
                  if (_fullVisit!.metaUpdateDate != null &&
                      _fullVisit!.metaUpdateDate != _fullVisit!.metaCreateDate)
                    _buildInfoRow('Dernière modification',
                        formatDateString(_fullVisit!.metaUpdateDate!)),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Commentaires
          if (_fullVisit!.comments != null && _fullVisit!.comments!.isNotEmpty)
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
                    Text(_fullVisit!.comments ?? 'Aucun commentaire'),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 16),

          // Données spécifiques au module si présentes
          if (_fullVisit!.data != null && _fullVisit!.data!.isNotEmpty)
            buildPropertiesWidget(),
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

  @override
  Widget? buildChildrenContent() {
    // Récupérer la configuration des observations
    final ObjectConfig? observationConfig =
        widget.moduleInfo?.module.complement?.configuration?.observation;

    if (observationConfig == null || _fullVisit == null) {
      return null;
    }

    return _buildObservationsSection(context, _fullVisit!, observationConfig);
  }

  Widget _buildObservationsSection(BuildContext context, BaseVisit fullVisit,
      ObjectConfig observationConfig) {
    if (_tabController == null) return const SizedBox.shrink();

    return Column(
      children: [
        // TabBar avec une seule option "Observations"
        buildTabBar(
          tabController: _tabController!,
          tabs: const [
            Tab(text: 'Observations'),
          ],
        ),

        // TabBarView avec le tableau des observations
        Expanded(
          child: TabBarView(
            controller: _tabController!,
            children: [
              _buildObservationsTable(context, fullVisit, observationConfig),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildObservationsTable(BuildContext context, BaseVisit fullVisit,
      ObjectConfig observationConfig) {
    // Utiliser le viewModel pour les observations
    final observationsState =
        widget.ref.watch(observationsProvider(fullVisit.idBaseVisit));

    // Bouton d'ajout d'observation
    Widget addObservationButton = ElevatedButton.icon(
      onPressed: () {
        _showAddObservationDialog(fullVisit.idBaseVisit, observationConfig);
      },
      icon: const Icon(Icons.add),
      label: const Text('Ajouter'),
    );

    // Message vide personnalisé pour les observations
    Widget emptyObservationsMessage = Column(
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
    );

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

        // Utiliser la méthode factorisée pour déterminer les colonnes à afficher
        List<String> standardColumns = ['actions'];

        // Récupérer le premier élément pour auto-détecter les propriétés
        Map<String, dynamic>? firstItemData =
            observations.isNotEmpty ? observations.first : null;

        List<String> displayColumns = determineDataColumns(
          standardColumns: standardColumns,
          itemConfig: observationConfig,
          firstItemData: firstItemData,
          filterMetaColumns: true,
        );

        // Construire les colonnes du tableau
        List<DataColumn> columns =
            _buildDataColumns(displayColumns, observationConfig);

        // Construire les lignes du tableau
        List<DataRow> rows = observations.map((observation) {
          return _buildDataRow(
            observation,
            displayColumns,
            observationConfig,
            context,
            fullVisit.idBaseVisit,
          );
        }).toList();

        // Utiliser la méthode factorisée buildDataTable
        return buildDataTable(
          columns: columns,
          rows: rows,
          showSearch: false, // Pas de recherche pour les observations
          headerActions: addObservationButton,
          emptyMessage: emptyObservationsMessage,
          isLoading: false,
        );
      },
    );
  }

  List<DataColumn> _buildDataColumns(
      List<String> columns, ObjectConfig observationConfig) {
    // Utiliser la méthode factorisée pour construire les colonnes du tableau
    return buildDataColumns(
      columns: columns,
      itemConfig: observationConfig,
      predefinedLabels: {
        'actions': 'Actions',
        'cd_nom': 'Taxon',
        'comments': 'Commentaires',
      },
    );
  }

  DataRow _buildDataRow(
    Map<String, dynamic> observation,
    List<String> columns,
    ObjectConfig observationConfig,
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
                  icon: const Icon(Icons.visibility, size: 20),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ObservationDetailPage(
                          observation: Observation(
                            idObservation: observation['id_observation'] as int,
                            idBaseVisit: visitId,
                            cdNom: observation['cd_nom'] as int?,
                            comments: observation['comments'] as String?,
                            data: observation,
                            metaCreateDate:
                                observation['meta_create_date'] as String?,
                            metaUpdateDate:
                                observation['meta_update_date'] as String?,
                          ),
                          visit: widget.visit,
                          site: widget.site,
                          moduleInfo: widget.moduleInfo,
                          fromSiteGroup: widget.fromSiteGroup,
                          observationConfig: observationConfig,
                          customConfig: widget.moduleInfo?.module.complement
                              ?.configuration?.custom,
                          observationDetailConfig: widget.moduleInfo?.module
                              .complement?.configuration?.observationDetail,
                          isNewObservation: false,
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
                    _showEditObservationDialog(
                        observation['id_observation'] as int,
                        visitId,
                        observation,
                        observationConfig);
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
                              _deleteObservation(
                                observation['id_observation'] as int,
                                visitId,
                              );
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

        // Cellules de données avec la logique factorisée
        final rawValue = observation[column];

        // Générer le schéma si ce n'est pas déjà fait
        Map<String, dynamic> schema = {};
        if (observationConfig != null) {
          schema = FormConfigParser.generateUnifiedSchema(
              observationConfig, customConfig);
        }

        // Formater la valeur
        String displayValue = formatDataCellValue(
          rawValue: rawValue,
          columnName: column,
          schema: schema,
        );

        // Construire la cellule
        return buildFormattedDataCell(
          value: displayValue,
          enableTooltip: true,
        );
      }).toList(),
    );
  }

  // Afficher le formulaire d'ajout d'observation
  void _showAddObservationDialog(int visitId, ObjectConfig observationConfig) {
    // Préparer les informations pour le fil d'Ariane
    final String? moduleName = widget.moduleInfo?.module.moduleLabel;
    final String? siteLabel =
        widget.moduleInfo?.module.complement?.configuration?.site?.label ??
            'Site';
    final String? siteName =
        widget.site.baseSiteName ?? widget.site.baseSiteCode;
    final String? visitLabel =
        widget.moduleInfo?.module.complement?.configuration?.visit?.label ??
            'Visite';
    final String? visitDate = formatDateString(widget.visit.visitDateMin);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ObservationFormPage(
          visitId: visitId,
          observationConfig: observationConfig,
          customConfig:
              widget.moduleInfo?.module.complement?.configuration?.custom,
          moduleId: widget.moduleInfo?.module.id,
          // Ajouter la configuration des détails d'observation
          observationDetailConfig: 
              widget.moduleInfo?.module.complement?.configuration?.observationDetail,
          // Passer les informations pour le fil d'Ariane
          moduleName: moduleName,
          siteLabel: siteLabel,
          siteName: siteName,
          visitLabel: visitLabel,
          visitDate: visitDate,
          // Passer les informations pour la redirection
          visit: widget.visit,
          site: widget.site,
          moduleInfo: widget.moduleInfo,
          fromSiteGroup: widget.fromSiteGroup,
        ),
      ),
    ).then((_) {
      // Rafraîchir les observations quand on revient du formulaire
      widget.ref.refresh(observationsProvider(visitId));
    });
  }

  // Afficher le formulaire d'édition d'observation
  void _showEditObservationDialog(int observationId, int visitId,
      Map<String, dynamic> observationData, ObjectConfig observationConfig) {
    // Préparer les informations pour le fil d'Ariane
    final String? moduleName = widget.moduleInfo?.module.moduleLabel;
    final String? siteLabel =
        widget.moduleInfo?.module.complement?.configuration?.site?.label ??
            'Site';
    final String? siteName =
        widget.site.baseSiteName ?? widget.site.baseSiteCode;
    final String? visitLabel =
        widget.moduleInfo?.module.complement?.configuration?.visit?.label ??
            'Visite';
    final String? visitDate = formatDateString(widget.visit.visitDateMin);

    // Récupérer l'observation complète
    widget.ref
        .read(observationsProvider(visitId).notifier)
        .getObservationsByVisitId()
        .then((observations) {
      // Trouver l'observation correspondante
      final observation = observations.firstWhere(
        (o) => o.idObservation == observationId,
        orElse: () => throw Exception('Observation not found'),
      );

      // Naviguer vers la page d'édition
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ObservationFormPage(
              visitId: visitId,
              observationConfig: observationConfig,
              customConfig:
                  widget.moduleInfo?.module.complement?.configuration?.custom,
              moduleId: widget.moduleInfo?.module.id,
              // Ajouter la configuration des détails d'observation
              observationDetailConfig: 
                  widget.moduleInfo?.module.complement?.configuration?.observationDetail,
              observation: observation,
              // Passer les informations pour le fil d'Ariane
              moduleName: moduleName,
              siteLabel: siteLabel,
              siteName: siteName,
              visitLabel: visitLabel,
              visitDate: visitDate,
            ),
          ),
        ).then((_) {
          // Rafraîchir les observations quand on revient du formulaire
          widget.ref.refresh(observationsProvider(visitId));
        });
      }
    }).catchError((error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Erreur lors du chargement de l\'observation: $error')),
        );
      }
    });
  }

  // Supprimer une observation
  Future<void> _deleteObservation(int observationId, int visitId) async {
    try {
      final viewModel = widget.ref.read(observationsProvider(visitId).notifier);
      final success = await viewModel.deleteObservation(observationId);

      if (success) {
        // Afficher un message de succès
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Observation supprimée avec succès')),
          );
          // Rafraîchir les observations
          widget.ref.refresh(observationsProvider(visitId));
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
}
