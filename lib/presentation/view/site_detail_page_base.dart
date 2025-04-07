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
import 'package:gn_mobile_monitoring/presentation/view/detail_page.dart';
import 'package:gn_mobile_monitoring/presentation/view/visit_detail_page.dart';
import 'package:gn_mobile_monitoring/presentation/view/visit_form_page.dart';
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
        // TabBar avec une seule option "Visites"
        Material(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          child: TabBar(
            controller: _tabController!,
            tabs: const [
              Tab(text: 'Visites'),
            ],
            labelColor: Theme.of(context).primaryColor,
            indicatorColor: Theme.of(context).primaryColor,
          ),
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

    return Container(
      color: Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Bouton d'ajout de visite + Champ de recherche
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  if (visitConfig != null)
                    ElevatedButton.icon(
                      onPressed: () {
                        _showAddVisitForm(visitConfig);
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Nouvelle visite'),
                    ),
                  const Spacer(),
                  SizedBox(
                    width: 200,
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Rechercher',
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    _searchQuery = '';
                                    _filterVisits(visitsAsyncValue);
                                  });
                                },
                              )
                            : const Icon(Icons.search),
                        border: const OutlineInputBorder(),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                          _filterVisits(visitsAsyncValue);
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Liste des visites
            Expanded(
              child: visitsAsyncValue.when(
                data: (visits) {
                  // Filtrer les visites
                  if (_visitsFiltered.isEmpty ||
                      _visitsFiltered.length != visits.length) {
                    _filterVisits(visitsAsyncValue);
                  }

                  if (_visitsFiltered.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.calendar_today,
                              size: 48, color: Colors.grey),
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
                      ),
                    );
                  }

                  // Déterminer les colonnes à afficher en suivant la même logique
                  // que dans PropertyDisplayWidget

                  List<String> displayColumns = ['actions'];

                  // Ajouter les colonnes génériques toujours présentes
                  displayColumns.addAll(['visit_date_min', 'comments']);

                  // Ajouter les observateurs si disponibles
                  if (_visitsFiltered.isNotEmpty &&
                      _visitsFiltered.first.observers != null) {
                    displayColumns.add('observers');
                  }

                  // Collecter toutes les clés possibles, comme dans PropertyDisplayWidget._buildSortedProperties
                  Set<String> allPossibleKeys = <String>{};

                  // Utiliser en priorité les propriétés d'affichage définies dans la configuration
                  if (visitConfig?.displayList != null &&
                      visitConfig!.displayList!.isNotEmpty) {
                    // Utiliser displayList pour un affichage personnalisé
                    allPossibleKeys.addAll(visitConfig!.displayList!);
                  } else if (visitConfig?.displayProperties != null &&
                      visitConfig!.displayProperties!.isNotEmpty) {
                    // Utiliser displayProperties comme alternative
                    allPossibleKeys.addAll(visitConfig!.displayProperties!);
                  } 
                  
                  // Ajouter les propriétés de generic et specific si disponibles
                  if (visitConfig != null) {
                    if (visitConfig.generic != null) {
                      allPossibleKeys.addAll(visitConfig.generic!.keys);
                    }
                    if (visitConfig.specific != null) {
                      allPossibleKeys.addAll(visitConfig.specific!.keys);
                    }
                    if (visitConfig.propertiesKeys != null) {
                      allPossibleKeys.addAll(visitConfig.propertiesKeys!);
                    }
                  }

                  // Ajouter les clés trouvées dans les données
                  if (_visitsFiltered.isNotEmpty && _visitsFiltered.first.data != null) {
                    allPossibleKeys.addAll(_visitsFiltered.first.data!.keys);
                  }

                  // Filtrer les clés pour ne garder que les pertinentes
                  // Éviter les métadonnées et géométries
                  List<String> filteredKeys = allPossibleKeys
                      .where((key) => 
                          !key.contains('geom') &&
                          !key.contains('uuid') &&
                          !key.contains('meta') &&
                          !displayColumns.contains(key))
                      .toList();

                  // Prioriser les clés plutôt que les limiter
                  // (suppression de la limitation à 5 clés pour afficher toutes les propriétés)
                  List<String> priorityKeys = [];
                  if (visitConfig?.displayList != null) {
                    priorityKeys.addAll(visitConfig!.displayList!);
                  } else if (visitConfig?.displayProperties != null) {
                    priorityKeys.addAll(visitConfig!.displayProperties!);
                  }
                  
                  // Trier les clés pour mettre en priorité celles définies dans la configuration
                  filteredKeys.sort((a, b) {
                    // Si a est dans priorityKeys mais pas b, a vient en premier
                    if (priorityKeys.contains(a) && !priorityKeys.contains(b)) {
                      return -1;
                    }
                    // Si b est dans priorityKeys mais pas a, b vient en premier
                    if (!priorityKeys.contains(a) && priorityKeys.contains(b)) {
                      return 1;
                    }
                    // Sinon, ordre alphabétique
                    return a.compareTo(b);
                  });

                  // Ajouter les clés filtrées aux colonnes
                  displayColumns.addAll(filteredKeys);

                  return Card(
                    elevation: 2,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        child: DataTable(
                          columns: _buildVisitDataColumns(
                              displayColumns, visitConfig),
                          rows: _visitsFiltered.map((visit) {
                            return _buildVisitDataRow(
                              visit,
                              displayColumns,
                              visitConfig,
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) => Center(
                  child: Text(
                    'Erreur lors du chargement des visites: $error',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<DataColumn> _buildVisitDataColumns(
      List<String> columns, ObjectConfig? visitConfig) {
    // Générer le schéma unifié à partir de la configuration de visite
    Map<String, dynamic> schema = {};
    if (visitConfig != null) {
      schema = FormConfigParser.generateUnifiedSchema(visitConfig, customConfig);
    }

    return columns.map((column) {
      String label = column;

      // Colonnes prédéfinies standards
      if (column == 'actions') {
        label = 'Actions';
      } else if (column == 'visit_date_min') {
        label = 'Date de visite';
      } else if (column == 'comments') {
        label = 'Commentaires';
      } else if (column == 'observers') {
        label = 'Observateurs';
      } else {
        // Utiliser la même logique que dans PropertyDisplayWidget._getPropertyLabel
        if (visitConfig != null) {
          // Vérifier dans la configuration parsée
          if (schema.containsKey(column) && 
              schema[column].containsKey('attribut_label')) {
            label = schema[column]['attribut_label'];
          }
          // Si pas trouvé, vérifier dans generic
          else if (visitConfig.generic != null &&
              visitConfig.generic!.containsKey(column)) {
            label = visitConfig.generic![column]!.attributLabel ?? column;
          }
          // Si pas trouvé, vérifier dans specific
          else if (visitConfig.specific != null &&
              visitConfig.specific!.containsKey(column)) {
            final specificConfig =
                visitConfig.specific![column] as Map<String, dynamic>?;
            if (specificConfig != null &&
                specificConfig.containsKey('attribut_label')) {
              label = specificConfig['attribut_label'];
            }
          }
        }
      }

      // Formater le libellé pour une meilleure présentation
      label = ValueFormatter.formatLabel(label);

      return DataColumn(
        label: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      );
    }).toList();
  }

  DataRow _buildVisitDataRow(
    dynamic visit,
    List<String> columns,
    ObjectConfig? visitConfig,
  ) {
    // Générer le schéma unifié pour la visite
    Map<String, dynamic> schema = {};
    if (visitConfig != null) {
      schema = FormConfigParser.generateUnifiedSchema(visitConfig, customConfig);
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
        String displayValue = '';
        if (visit.data != null) {
          dynamic rawValue;

          // Récupérer la valeur brute
          if (visit.data.containsKey(column)) {
            rawValue = visit.data[column];
          }

          // Formater la valeur selon son type et la configuration
          if (rawValue != null) {
            // Utiliser le type défini dans le schéma pour formater correctement la valeur
            if (schema.containsKey(column)) {
              final fieldConfig = schema[column];
              final typeWidget = fieldConfig['type_widget'];

              // Formater en fonction du type de widget
              switch (typeWidget) {
                case 'nomenclature':
                  // Idéalement récupérer le label de la nomenclature
                  // Pour l'instant, on utilise juste la valeur brute
                  displayValue = rawValue.toString();
                  break;
                case 'checkbox':
                  displayValue = rawValue == true ? 'Oui' : 'Non';
                  break;
                case 'date':
                case 'datetime':
                  if (rawValue is String) {
                    displayValue = formatDateString(rawValue);
                  } else {
                    displayValue = ValueFormatter.format(rawValue);
                  }
                  break;
                case 'number':
                  if (rawValue is num) {
                    // Appliquer un format spécifique pour les nombres si nécessaire
                    displayValue = ValueFormatter.format(rawValue);
                  } else {
                    displayValue = ValueFormatter.format(rawValue);
                  }
                  break;
                case 'text':
                case 'textarea':
                  if (rawValue is String) {
                    displayValue = rawValue;
                  } else {
                    displayValue = ValueFormatter.format(rawValue);
                  }
                  break;
                default:
                  displayValue = ValueFormatter.format(rawValue);
              }
            } else {
              // Format par défaut si aucune configuration spécifique
              displayValue = ValueFormatter.format(rawValue);
            }
          }
        }

        // Pour afficher proprement les valeurs potentiellement longues
        return DataCell(
          Tooltip(
            message: displayValue.length > 30 ? displayValue : '',
            child: Text(
              displayValue,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        );
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
