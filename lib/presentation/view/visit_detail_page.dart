import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/core/helpers/format_datetime.dart';
import 'package:gn_mobile_monitoring/core/helpers/value_formatter.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/base_visit.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/domain/model/observation.dart';
import 'package:gn_mobile_monitoring/presentation/model/module_info.dart';
import 'package:gn_mobile_monitoring/presentation/view/observation_detail_page.dart';
import 'package:gn_mobile_monitoring/presentation/view/observation_form_page.dart';
import 'package:gn_mobile_monitoring/presentation/view/visit_form_page.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/observations_viewmodel.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/site_visits_viewmodel.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/breadcrumb_navigation.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/property_display_widget.dart';

class VisitDetailPage extends ConsumerStatefulWidget {
  final BaseVisit visit;
  final BaseSite site;
  final ModuleInfo? moduleInfo;
  final dynamic fromSiteGroup; // Information sur un éventuel groupe parent
  final bool isNewVisit;

  const VisitDetailPage({
    super.key,
    required this.visit,
    required this.site,
    this.moduleInfo,
    this.fromSiteGroup,
    this.isNewVisit = false,
  });

  @override
  ConsumerState<VisitDetailPage> createState() => _VisitDetailPageState();
}

class _VisitDetailPageState extends ConsumerState<VisitDetailPage> {
  // Utiliser un FutureProvider unique à cette instance pour éviter la reconstruction à chaque build
  late final AutoDisposeFutureProvider<BaseVisit> _visitDetailsProvider;
  bool _hasShownObservationDialog = false;

  @override
  void initState() {
    super.initState();
    _loadVisitDetails();

    // Proposer la création d'une observation après un court délai seulement si c'est une nouvelle visite
    if (widget.isNewVisit) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _proposeObservationCreation();
      });
    }
  }

  void _loadVisitDetails() {
    // Définir un provider pour cette instance spécifique
    _visitDetailsProvider = FutureProvider.autoDispose<BaseVisit>((ref) async {
      // L'appel est maintenant contrôlé et ne sera exécuté qu'une seule fois par le FutureProvider
      final viewModel = ref.read(siteVisitsViewModelProvider(
          (widget.site.idBaseSite, widget.visit.idModule)).notifier);
      return viewModel.getVisitWithFullDetails(widget.visit.idBaseVisit);
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
                      customConfig: widget
                          .moduleInfo?.module.complement?.configuration?.custom,
                      moduleId: widget.moduleInfo?.module.id,
                      visit: widget.visit,
                      moduleInfo: widget.moduleInfo, // Pour le fil d'Ariane
                      siteGroup: widget.fromSiteGroup, // Pour le fil d'Ariane
                    ),
                  ),
                ).then((_) {
                  // Rafraîchir les données après édition
                  ref
                      .read(siteVisitsViewModelProvider(
                              (widget.site.idBaseSite, widget.visit.idModule))
                          .notifier)
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

    return Column(
      children: [
        // Fil d'Ariane pour la navigation
        if (widget.moduleInfo != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
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
                    // Visite (actuelle)
                    BreadcrumbItem(
                      label: visitLabel,
                      value: formatDateString(fullVisit.visitDateMin),
                    ),
                  ],
                ),
              ),
            ),
          ),
        // Informations de la visite (partie supérieure)
        Expanded(
          flex: observationConfig != null
              ? 2
              : 1, // Ajuster le ratio en fonction de la présence de la config
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
                  PropertyDisplayWidget(
                    data: fullVisit.data!,
                    config: visitConfig,
                    customConfig: widget
                        .moduleInfo?.module.complement?.configuration?.custom,
                    separateEmptyFields: true,
                  ),
              ],
            ),
          ),
        ),

        // Section des observations (partie inférieure) - uniquement si la configuration existe
        if (observationConfig != null)
          Expanded(
            flex: 3, // Prend 2/3 de l'écran
            child: _buildObservationsSection(
                context, fullVisit, observationConfig),
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
                    _showAddObservationDialog(
                        fullVisit.idBaseVisit, observationConfig);
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
    final observationsState =
        ref.watch(observationsProvider(fullVisit.idBaseVisit));

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
      label = ValueFormatter.formatLabel(label);

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
                              .complement?.configuration?.observation,
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

        // Cellules de données
        final value = observation[column];
        String displayValue = ValueFormatter.format(value);

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

  // Méthodes pour gérer les observations

  // Afficher le formulaire d'ajout d'observation
  void _showAddObservationDialog(int visitId, ObjectConfig? observationConfig) {
    if (observationConfig == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Configuration des observations non disponible')),
      );
      return;
    }

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
      ref.refresh(observationsProvider(visitId));
    });
  }

  // Afficher le formulaire d'édition d'observation
  void _showEditObservationDialog(int observationId, int visitId,
      Map<String, dynamic> observationData, ObjectConfig? observationConfig) {
    if (observationConfig == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Configuration des observations non disponible')),
      );
      return;
    }

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
    ref
        .read(observationsProvider(visitId).notifier)
        .getObservationsByVisitId()
        .then((observations) {
      // Trouver l'observation correspondante
      final observation = observations.firstWhere(
        (o) => o.idObservation == observationId,
        orElse: () => throw Exception('Observation not found'),
      );

      // Naviguer vers la page d'édition
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ObservationFormPage(
            visitId: visitId,
            observationConfig: observationConfig,
            customConfig:
                widget.moduleInfo?.module.complement?.configuration?.custom,
            moduleId: widget.moduleInfo?.module.id,
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
        ref.refresh(observationsProvider(visitId));
      });
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Erreur lors du chargement de l\'observation: $error')),
      );
    });
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
          // Rafraîchir les observations
          ref.refresh(observationsProvider(visitId));
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
