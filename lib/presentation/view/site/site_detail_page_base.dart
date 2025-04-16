import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/core/helpers/form_config_parser.dart';
import 'package:gn_mobile_monitoring/core/helpers/format_datetime.dart';
import 'package:gn_mobile_monitoring/core/helpers/value_formatter.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/domain/model/site_complement.dart';
import 'package:gn_mobile_monitoring/presentation/model/module_info.dart';
import 'package:gn_mobile_monitoring/presentation/view/base/detail_page.dart';
import 'package:gn_mobile_monitoring/presentation/view/visit/visit_detail_page.dart';
import 'package:gn_mobile_monitoring/presentation/view/visit/visit_form_page.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/site_visits_viewmodel.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/breadcrumb_navigation.dart';

class SiteDetailPageBase extends DetailPage {
  final WidgetRef ref;
  final BaseSite site;
  final ModuleInfo? moduleInfo;
  final dynamic fromSiteGroup;

  const SiteDetailPageBase({
    super.key,
    required this.ref,
    required this.site,
    this.moduleInfo,
    this.fromSiteGroup,
  });

  @override
  SiteDetailPageBaseState createState() => SiteDetailPageBaseState();
}

class SiteDetailPageBaseState extends DetailPageState<SiteDetailPageBase>
    with SingleTickerProviderStateMixin {
  // Variables pour la gestion des onglets et des visites
  TabController? _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<dynamic> _visitsFiltered = [];

  // Nous n'avons plus besoin de stocker le ViewModel dans une variable d'instance
  // ni d'avoir des fonctions d'encapsulation, car nous accéderons directement au provider

  @override
  ObjectConfig? get objectConfig =>
      widget.moduleInfo?.module.complement?.configuration?.site;

  @override
  CustomConfig? get customConfig =>
      widget.moduleInfo?.module.complement?.configuration?.custom;

  @override
  List<String>? get displayProperties =>
      objectConfig?.displayProperties ?? objectConfig?.displayList;

  // Site complement data pour le site courant
  SiteComplement? _siteComplement;

  @override
  Map<String, dynamic> get objectData {
    // Obtenir les données du site depuis le complément
    if (_siteComplement?.data != null) {
      try {
        // Tenter de parser le JSON si c'est au format chaîne
        if (_siteComplement!.data is String) {
          return Map<String, dynamic>.from(
              jsonDecode(_siteComplement!.data as String));
        }
        // Sinon, essayer de le convertir directement
        return Map<String, dynamic>.from(_siteComplement!.data as Map);
      } catch (e) {
        debugPrint('Erreur lors du décodage des données du site: $e');
      }
    }
    return {};
  }

  @override
  String get propertiesTitle => 'Propriétés du site';

  @override
  bool get separateEmptyFields => true;

  @override
  void initState() {
    super.initState();
    _initializeTabController();
  }

  // Cette méthode sera appelée une fois que les dépendances sont injectées
  void startLoadingData() {
    // Force le rechargement des visites en utilisant le provider directement
    try {
      if (widget.moduleInfo?.module.id != null) {
        // Paramètres pour le provider
        final params = (widget.site.idBaseSite, widget.moduleInfo!.module.id);

        // Accéder au SiteVisitsViewModel directement via le provider et appeler loadVisits()
        widget.ref
            .read(siteVisitsViewModelProvider(params).notifier)
            .loadVisits();

        // Invalider le provider pour forcer un rechargement complet
        widget.ref.invalidate(siteVisitsViewModelProvider(params));
      }
    } catch (e) {
      debugPrint('Erreur lors du chargement des visites: $e');
    }
  }

  void _initializeTabController() {
    // Initialiser le TabController avec une seule tab "Visites"
    _tabController = TabController(length: 1, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  List<BreadcrumbItem> getBreadcrumbItems() {
    final items = <BreadcrumbItem>[];

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
        // Récupérer le label configuré
        final String groupLabel = widget.moduleInfo?.module.complement
                ?.configuration?.sitesGroup?.label ??
            'Groupe';

        items.add(
          BreadcrumbItem(
            label: groupLabel,
            value: widget.fromSiteGroup.sitesGroupName ??
                widget.fromSiteGroup.sitesGroupCode ??
                'Groupe',
            onTap: () {
              // Retour vers le groupe (1 niveau)
              Navigator.of(context).pop();
            },
          ),
        );
      }

      // Site actuel (pas de navigation car page courante)
      // Récupérer le label configuré
      final String siteLabel =
          widget.moduleInfo?.module.complement?.configuration?.site?.label ??
              'Site';

      items.add(
        BreadcrumbItem(
          label: siteLabel,
          value: widget.site.baseSiteName ?? widget.site.baseSiteCode ?? 'Site',
        ),
      );
    }

    return items;
  }

  @override
  PreferredSizeWidget buildAppBar() {
    return AppBar(
      title: Text(getTitle()),
      // Actions pour éditer
      actions: [
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            // Logique pour éditer le site (à implémenter si nécessaire)
          },
        ),
      ],
    );
  }

  @override
  String getTitle() {
    return widget.site.baseSiteName ??
        widget.site.baseSiteCode ??
        'Détails du site';
  }

  @override
  Widget? buildChildrenContent() {
    if (_tabController == null) return null;

    return Column(
      children: [
        // TabBar utilisant la méthode factorisée
        buildTabBar(
          tabController: _tabController!,
          tabs: const [
            Tab(text: 'Visites'),
          ],
        ),

        // Visites en bas avec TabBarView - prend tout l'espace restant
        Expanded(
          child: TabBarView(
            controller: _tabController!,
            children: [
              _buildVisitsTab(),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget buildBaseContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Propriétés du site - non expandable et taille intrinsèque
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Informations générales',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                        'Code', widget.site.baseSiteCode ?? 'Non spécifié'),
                    _buildInfoRow(
                        'Nom', widget.site.baseSiteName ?? 'Non spécifié'),
                    _buildInfoRow('Description',
                        widget.site.baseSiteDescription ?? 'Non spécifiée'),
                    if (widget.site.firstUseDate != null)
                      _buildInfoRow(
                          'Date de création',
                          formatDateString(
                              widget.site.firstUseDate!.toString())),
                  ],
                ),
              ),
            ),
          ),

          // Propriétés spécifiques au module si présentes
          if (_siteComplement?.data != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: buildPropertiesWidget(),
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
            width: 120,
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

  Widget _buildVisitsTab() {
    // Configuration de la visite pour la création d'une nouvelle visite
    final visitConfig =
        widget.moduleInfo?.module.complement?.configuration?.visit;

    // Préparer les arguments pour la requête des visites
    final params = (widget.site.idBaseSite, widget.moduleInfo?.module.id ?? 0);

    // Récupérer toutes les visites de ce site via le provider
    final visitsAsyncValue =
        widget.ref.watch(siteVisitsViewModelProvider(params));

    // Bouton d'ajout de visite
    Widget? addVisitButton = visitConfig != null
        ? ElevatedButton.icon(
            onPressed: () {
              _showAddVisitForm(visitConfig);
            },
            icon: const Icon(Icons.add),
            label: const Text('Nouvelle visite'),
          )
        : null;

    return visitsAsyncValue.when(
      data: (visits) {
        // Filtrer les visites
        if (_visitsFiltered.isEmpty ||
            _visitsFiltered.length != visits.length) {
          _filterVisits(visitsAsyncValue);
        }

        // Utiliser la méthode factorisée pour déterminer les colonnes
        List<String> standardColumns = [
          'actions',
          'visit_date_min',
          'comments'
        ];

        // Ajouter les observateurs si disponibles
        if (_visitsFiltered.isNotEmpty &&
            _visitsFiltered.first.observers != null) {
          standardColumns.add('observers');
        }

        // Utiliser la méthode commune pour déterminer les colonnes
        Map<String, dynamic>? firstItemData =
            _visitsFiltered.isNotEmpty && _visitsFiltered.first.data != null
                ? _visitsFiltered.first.data
                : null;

        List<String> displayColumns = determineDataColumns(
          standardColumns: standardColumns,
          itemConfig: visitConfig,
          firstItemData: firstItemData,
          filterMetaColumns: true,
        );

        // Construire les colonnes du tableau
        List<DataColumn> columns =
            _buildVisitDataColumns(displayColumns, visitConfig);

        // Construire les lignes du tableau
        List<DataRow> rows = _visitsFiltered.map((visit) {
          return _buildVisitDataRow(
            visit,
            displayColumns,
            visitConfig,
          );
        }).toList();

        // Message vide personnalisé
        Widget emptyMessage = Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.calendar_today, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isNotEmpty
                  ? 'Aucune visite ne correspond à votre recherche'
                  : 'Aucune visite pour ce site',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        );

        // Utiliser la méthode factoriée pour construire le tableau
        return buildDataTable(
          columns: columns,
          rows: rows,
          showSearch: true,
          searchHint: 'Rechercher une visite',
          searchController: _searchController,
          onSearchChanged: (value) {
            setState(() {
              _searchQuery = value;
              _filterVisits(visitsAsyncValue);
            });
          },
          headerActions: addVisitButton,
          emptyMessage: emptyMessage,
          isLoading: false,
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(
        child: Text(
          'Erreur lors du chargement des visites: $error',
          style: const TextStyle(color: Colors.red),
        ),
      ),
    );
  }

  List<DataColumn> _buildVisitDataColumns(
      List<String> columns, ObjectConfig? visitConfig) {
    // Utiliser la méthode factorisée pour construire les colonnes du tableau
    return buildDataColumns(
      columns: columns,
      itemConfig: visitConfig,
      predefinedLabels: {
        'actions': 'Actions',
        'visit_date_min': 'Date de visite',
        'comments': 'Commentaires',
        'observers': 'Observateurs',
      },
    );
  }

  DataRow _buildVisitDataRow(
    dynamic visit,
    List<String> columns,
    ObjectConfig? visitConfig,
  ) {
    // Générer le schéma unifié pour la visite
    Map<String, dynamic> schema = {};
    if (visitConfig != null) {
      schema =
          FormConfigParser.generateUnifiedSchema(visitConfig, customConfig);
    }

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
                  tooltip: 'Voir les détails',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VisitDetailPage(
                          visit: visit,
                          site: widget.site,
                          moduleInfo: widget.moduleInfo,
                          fromSiteGroup: widget.fromSiteGroup,
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
                  tooltip: 'Modifier',
                  onPressed: () {
                    if (visitConfig != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VisitFormPage(
                            site: widget.site,
                            visitConfig: visitConfig,
                            customConfig: customConfig,
                            moduleId: widget.moduleInfo?.module.id,
                            visit: visit,
                            moduleInfo: widget.moduleInfo,
                            siteGroup: widget.fromSiteGroup,
                          ),
                        ),
                      ).then((_) {
                        // Rafraîchir les visites
                        final params = (
                          widget.site.idBaseSite,
                          widget.moduleInfo?.module.id ?? 0
                        );
                        widget.ref
                            .invalidate(siteVisitsViewModelProvider(params));
                      });
                    }
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

        // Colonnes standards
        if (column == 'visit_date_min') {
          return DataCell(Text(formatDateString(visit.visitDateMin)));
        } else if (column == 'comments') {
          final comments = visit.comments ?? '';
          return DataCell(
            Tooltip(
              message: comments.length > 40 ? comments : '',
              child: Text(
                comments,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          );
        } else if (column == 'observers') {
          // Afficher les observateurs (s'ils existent)
          if (visit.observers != null && visit.observers.isNotEmpty) {
            final observerCount = visit.observers.length;
            return DataCell(
              Text('$observerCount observateur${observerCount > 1 ? 's' : ''}'),
            );
          }
          return const DataCell(Text(''));
        }

        // Données spécifiques (depuis le champ data)
        if (visit.data != null) {
          dynamic rawValue;

          // Récupérer la valeur brute
          if (visit.data.containsKey(column)) {
            rawValue = visit.data[column];
          }

          if (rawValue != null) {
            // Utiliser la méthode factorisée pour formater la valeur
            String displayValue = formatDataCellValue(
              rawValue: rawValue,
              columnName: column,
              schema: schema,
            );

            // Utiliser la méthode factorisée pour construire la cellule
            return buildFormattedDataCell(
              value: displayValue,
              enableTooltip: true,
              tooltipThreshold: 30,
              maxLines: 1,
            );
          }
        }

        // Valeur vide si aucune donnée
        return buildFormattedDataCell(value: '');
      }).toList(),
    );
  }

  void _filterVisits(AsyncValue<List<dynamic>> visitsAsyncValue) {
    // Utiliser une variable temporaire pour éviter des mises à jour d'état excessives
    List<dynamic> newFilteredVisits = [];

    if (visitsAsyncValue is AsyncData) {
      final visits = visitsAsyncValue.value ?? [];

      if (_searchQuery.isEmpty) {
        newFilteredVisits = List.from(visits);
      } else {
        final query = _searchQuery.toLowerCase();
        newFilteredVisits = visits.where((visit) {
          // Recherche par date de visite
          final date = visit.visitDateMin?.toLowerCase() ?? '';
          // Recherche par commentaires
          final comments = visit.comments?.toLowerCase() ?? '';
          return date.contains(query) || comments.contains(query);
        }).toList();
      }
    }

    // Mettre à jour l'état uniquement si les résultats ont réellement changé
    // pour éviter des mises à jour d'état infinies
    if (!_areListsEqual(_visitsFiltered, newFilteredVisits)) {
      setState(() {
        _visitsFiltered = newFilteredVisits;
      });
    }
  }

  // Utilitaire pour comparer deux listes
  bool _areListsEqual(List<dynamic> list1, List<dynamic> list2) {
    if (list1.length != list2.length) return false;

    // Pour simplifier, on compare juste les identifiants
    // Pour une comparaison plus précise, on pourrait comparer plus de propriétés
    for (int i = 0; i < list1.length; i++) {
      if (list1[i].idBaseVisit != list2[i].idBaseVisit) {
        return false;
      }
    }

    return true;
  }

  void _showAddVisitForm(ObjectConfig visitConfig) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VisitFormPage(
          site: widget.site,
          visitConfig: visitConfig,
          customConfig: customConfig,
          moduleId: widget.moduleInfo?.module.id,
          moduleInfo: widget.moduleInfo,
          siteGroup: widget.fromSiteGroup,
        ),
      ),
    ).then((_) {
      // Rafraîchir les visites en utilisant le provider
      final params =
          (widget.site.idBaseSite, widget.moduleInfo?.module.id ?? 0);
      widget.ref.invalidate(siteVisitsViewModelProvider(params));
    });
  }
}
