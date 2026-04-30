import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gn_mobile_monitoring/core/helpers/form_config_parser.dart';
import 'package:gn_mobile_monitoring/core/helpers/value_formatter.dart';
import 'package:gn_mobile_monitoring/core/theme/app_colors.dart';
import 'package:gn_mobile_monitoring/data/data_module.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/sites_database.dart';
import 'package:gn_mobile_monitoring/data/service/map_geometry_service_impl.dart';
import 'package:gn_mobile_monitoring/domain/domain_module.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/module.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';
import 'package:gn_mobile_monitoring/domain/model/site_visit_stats.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_complete_module_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_orphan_sites_by_module_usecase.dart';
import 'package:gn_mobile_monitoring/presentation/model/module_info.dart';
import 'package:gn_mobile_monitoring/presentation/view/base/detail_page.dart';
import 'package:gn_mobile_monitoring/presentation/view/map/gen_map.dart';
import 'package:gn_mobile_monitoring/presentation/view/module/site_group_form_page.dart';
import 'package:gn_mobile_monitoring/presentation/view/module/uninstall_module_action.dart';
import 'package:gn_mobile_monitoring/presentation/view/site/site_detail_page.dart';
import 'package:gn_mobile_monitoring/presentation/view/site/site_form_page.dart';
import 'package:gn_mobile_monitoring/presentation/view/site_group_detail_page.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/breadcrumb_navigation.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/list_toolbar_widget.dart';
import 'package:latlong2/latlong.dart';

/// Widget personnalisé pour le breadcrumb avec description du module dans les détails
class _ModuleBreadcrumbWithDescription extends StatefulWidget {
  final List<BreadcrumbItem> items;
  final String? description;

  const _ModuleBreadcrumbWithDescription({
    required this.items,
    this.description,
  });

  @override
  State<_ModuleBreadcrumbWithDescription> createState() =>
      _ModuleBreadcrumbWithDescriptionState();
}

class _ModuleBreadcrumbWithDescriptionState
    extends State<_ModuleBreadcrumbWithDescription> {
  bool _showDetails = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Titre du fil d'Ariane
        Row(
          children: [
            Icon(
              Icons.navigation,
              size: 16,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 4),
            Text(
              'Navigation',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Fil d'Ariane générique (toujours visible)
        _buildGenericBreadcrumb(context),

        // Bouton pour afficher/masquer les détails
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            setState(() {
              _showDetails = !_showDetails;
            });
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _showDetails ? Icons.expand_less : Icons.expand_more,
                size: 16,
                color: Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(width: 4),
              Text(
                _showDetails ? 'Masquer les détails' : 'Afficher les détails',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        // Détails (affichés conditionnellement)
        if (_showDetails) ...[
          const SizedBox(height: 8),
          _buildDetailedBreadcrumb(context),
        ],
      ],
    );
  }

  Widget _buildGenericBreadcrumb(BuildContext context) {
    final breadcrumbItems = <Widget>[];

    for (int i = 0; i < widget.items.length; i++) {
      final item = widget.items[i];
      final isLast = i == widget.items.length - 1;

      breadcrumbItems.add(
        _buildGenericBreadcrumbItem(item, context, isLast),
      );

      if (!isLast) {
        breadcrumbItems.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: Icon(
              Icons.chevron_right,
              size: 14,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        );
      }
    }

    return Wrap(
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: breadcrumbItems,
    );
  }

  Widget _buildGenericBreadcrumbItem(
      BreadcrumbItem item, BuildContext context, bool isLast) {
    final style = TextStyle(
      fontSize: 14,
      fontWeight: isLast ? FontWeight.bold : FontWeight.w500,
      color: isLast
          ? Theme.of(context).colorScheme.primary
          : Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
    );

    if (item.onTap != null && !isLast) {
      return InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
          child: Text(item.label, style: style),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
        child: Text(item.label, style: style),
      );
    }
  }

  Widget _buildDetailedBreadcrumb(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Éléments du breadcrumb
          ...widget.items
              .map((item) => _buildDetailedBreadcrumbItem(item, context)),
          // Description du module
          if (widget.description != null && widget.description!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 80,
                    child: Text(
                      'Description:',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.7),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      widget.description!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailedBreadcrumbItem(
      BreadcrumbItem item, BuildContext context) {
    final isLast = widget.items.indexOf(item) == widget.items.length - 1;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '${item.label}:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ),
          Expanded(
            child: item.onTap != null && !isLast
                ? InkWell(
                    onTap: item.onTap,
                    child: Text(
                      item.value,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.primary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  )
                : Text(
                    item.value,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isLast ? FontWeight.bold : FontWeight.normal,
                      color: isLast
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class ModuleDetailPageBase extends DetailPage {
  final ModuleInfo moduleInfo;
  final WidgetRef? ref; // Optionnel pour accéder aux providers si nécessaire
  // Note: This class uses a different pattern than the others for accessing Riverpod providers
  // It relies on the GlobalKey<ModuleDetailPageBaseState> and injected use cases rather than WidgetRef
  // Mais on peut aussi passer ref pour accéder à la base de données

  const ModuleDetailPageBase({
    super.key,
    required this.moduleInfo,
    this.ref,
  });

  @override
  ModuleDetailPageBaseState createState() => ModuleDetailPageBaseState();
}

class ModuleDetailPageBaseState extends DetailPageState<ModuleDetailPageBase>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  List<String> _childrenTypes = [];
  final TextEditingController _searchController = TextEditingController();

  bool _isLoadingSites = false;
  List<dynamic> _displayedSites = [];
  List<dynamic> _filteredSites = [];
  List<dynamic> _allSites = [];

  /// IDs des sites du module ayant au moins une visite non synchronisée.
  /// Utilisé pour afficher un indicateur visuel sur la ligne du site (#XXX).
  Set<int> _unsyncedSiteIds = {};

  /// IDs des groupes de sites du module dont au moins un site a une visite
  /// non synchronisée. Permet d'afficher le badge orange sur la ligne du
  /// groupe avant même que l'utilisateur ne le déplie.
  Set<int> _unsyncedSiteGroupIds = {};

  /// Stats de visites (dernière visite, nombre total) par site pour ce
  /// module, calculées localement depuis t_base_visits. Source des colonnes
  /// "Dernier passage" et "Nb. passages" de l'onglet Sites.
  Map<int, SiteVisitStats> _visitStatsBySiteId = {};
  List<dynamic> _filteredSiteGroups = [];
  String _searchQuery = '';
  bool _showGroupSearch = false;
  String _groupSearchQuery = '';
  final TextEditingController _groupSearchController = TextEditingController();
  bool _configurationLoaded = false;
  bool _isInitialLoading = true;
  Future<List<SiteGroup>>? _groupsGeometryFuture;
  List<SiteGroup>? _cachedGroups;

  // Variables pour les groupes de sites avec ExpansionTile
  int? _expandedGroupPanelIndex;
  Position? _userPosition;
  bool _sortGroupsByDistance =
      true; // true = par distance, false = alphabétique

  // Module avec configuration complète (utilisé uniquement quand la configuration est chargée dynamiquement)
  Module? _updatedModule;

  // Sites orphelins (sans groupe) pour ce module, chargés depuis la DB (#157)
  List<BaseSite>? _orphanSites;
  bool _orphanSitesLoaded = false;

  // Injection du use case pour respecter la Clean Architecture
  late GetCompleteModuleUseCase getCompleteModuleUseCase;
  GetOrphanSitesByModuleUseCase? getOrphanSitesByModuleUseCase;

  @override
  ObjectConfig? get objectConfig {
    // Récupérer la configuration du module (qui est de type ModuleConfig)
    final moduleConfig = _updatedModule?.complement?.configuration?.module ??
        widget.moduleInfo.module.complement?.configuration?.module;

    // La configuration du module n'est pas compatible avec le type attendu
    // Nous devons créer un ObjectConfig plutôt que de retourner directement moduleConfig
    if (moduleConfig == null) return null;

    // Conversion de ModuleConfig en ObjectConfig en copiant les propriétés pertinentes
    return ObjectConfig(
        childrenTypes: moduleConfig.childrenTypes,
        descriptionFieldName: moduleConfig.descriptionFieldName,
        displayForm: moduleConfig.displayForm,
        displayList: moduleConfig.displayList,
        displayProperties: moduleConfig.displayProperties,
        exportPdf: moduleConfig.exportPdf,
        filters: moduleConfig.filters,
        generic: moduleConfig.generic,
        genre: moduleConfig.genre,
        idFieldName: moduleConfig.idFieldName,
        idTableLocation: moduleConfig.idTableLocation,
        label: moduleConfig.label,
        labelList: moduleConfig.moduleLabel,
        parentTypes: moduleConfig.parentTypes,
        propertiesKeys: moduleConfig.propertiesKeys,
        specific: moduleConfig.specific,
        typesSite: moduleConfig.typesSite,
        uuidFieldName: moduleConfig.uuidFieldName);
  }

  @override
  CustomConfig? get customConfig =>
      _updatedModule?.complement?.configuration?.custom ??
      widget.moduleInfo.module.complement?.configuration?.custom;

  @override
  List<String>? get displayProperties =>
      objectConfig?.displayProperties ?? objectConfig?.displayList;

  @override
  Map<String, dynamic> get objectData {
    // Données de base du module
    final module = _updatedModule ?? widget.moduleInfo.module;
    final Map<String, dynamic> data = {
      // Propriétés de base du module
      'id_module': module.id,
      'module_code': module.moduleCode,
      'module_label': module.moduleLabel,
      'module_desc': module.moduleDesc,
      'module_picto': module.modulePicto,
      'module_group': module.moduleGroup,
      'module_path': module.modulePath,
      'module_external_url': module.moduleExternalUrl,
      'module_target': module.moduleTarget,
      'module_comment': module.moduleComment,
      'active_frontend': module.activeFrontend,
      'active_backend': module.activeBackend,
      'module_doc_url': module.moduleDocUrl,
      'module_order': module.moduleOrder,
      'ng_module': module.ngModule,
      if (module.metaCreateDate != null)
        'meta_create_date': module.metaCreateDate!.toIso8601String(),
      if (module.metaUpdateDate != null)
        'meta_update_date': module.metaUpdateDate!.toIso8601String(),
      'downloaded': module.downloaded,
    };

    // Ajouter les données complémentaires si disponibles
    if (module.complement?.data != null) {
      // Le champ data est de type String?, nous devons donc le parser en JSON
      try {
        final Map<String, dynamic> parsedData = module.complement!.data != null
            ? Map<String, dynamic>.from(json.decode(module.complement!.data!))
            : {};
        data.addAll(parsedData);
      } catch (e) {
        // En cas d'erreur de parsing, on ignore silencieusement
        debugPrint('Erreur de parsing des données complémentaires: $e');
      }
    }

    return data;
  }

  @override
  List<String> get childrenTypes => _childrenTypes;

  @override
  String get propertiesTitle {
    final module = _updatedModule ?? widget.moduleInfo.module;
    final moduleLabel = module.moduleLabel ?? 'Module';
    return 'Module $moduleLabel';
  }

  @override
  Widget buildPropertiesWidget() {
    // On ne veut plus afficher la card des propriétés
    return const SizedBox.shrink();
  }

  @override
  Widget buildBaseContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildPropertiesWidget(),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    // Charger la position GPS
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserLocation();
    });

    // Toujours charger la configuration complète du module quand la propriété est injectée
  }

  /// Charge les sites orphelins (sans groupe parent) pour ce module (#157).
  /// Si le module a au moins un site orphelin, l'onglet "Sites" sera ajouté
  /// même si la config du serveur ne le mentionne pas.
  Future<void> _loadOrphanSites() async {
    final usecase = getOrphanSitesByModuleUseCase;
    if (usecase == null) return;
    try {
      final orphans = await usecase.execute(widget.moduleInfo.module.id);
      if (!mounted) return;
      setState(() {
        _orphanSites = orphans;
        _orphanSitesLoaded = true;
        if (_configurationLoaded) {
          _updateChildrenTypesFromConfig();
          _initializeTabController();
          _loadSitesIfAvailable();
        }
      });
    } catch (e) {
      debugPrint('Erreur lors du chargement des sites orphelins: $e');
      if (mounted) {
        setState(() {
          _orphanSites = [];
          _orphanSitesLoaded = true;
        });
      }
    }
  }

  // Méthode pour charger le module complet avec toutes ses données associées
  Future<void> loadCompleteModule() async {
    try {
      // Charger les sites orphelins en parallèle (#157)
      _loadOrphanSites();

      // Utiliser le use case injecté par le widget parent pour récupérer le module complet
      // Cela inclut : configuration, sites, groupes de sites et données complémentaires
      final completeModule =
          await getCompleteModuleUseCase.execute(widget.moduleInfo.module.id);

      // Vérifier si la configuration est bien présente
      final bool hasConfiguration =
          completeModule.complement?.configuration != null;

      // Mettre à jour le ModuleInfo
      if (mounted) {
        setState(() {
          // Stocker le module complet dans la variable de classe
          _updatedModule = completeModule;

          // Marquer la configuration comme chargée
          _configurationLoaded = hasConfiguration;
          _isInitialLoading = false;

          // Mettre à jour l'interface avec les nouvelles données
          _updateChildrenTypesFromConfig();
          _initializeTabController();
          _loadSitesIfAvailable();
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          // En cas d'erreur, utiliser la configuration existante si disponible
          final hasExistingConfig =
              widget.moduleInfo.module.complement?.configuration != null;
          _configurationLoaded = hasExistingConfig;
          _isInitialLoading = false;

          // Mettre à jour l'interface avec les données disponibles
          _updateChildrenTypesFromConfig();
          _initializeTabController();
          _loadSitesIfAvailable();
        });
      }
    }
  }

  void _updateChildrenTypesFromConfig() {
    // Utiliser le module mis à jour s'il est disponible
    final module = _updatedModule ?? widget.moduleInfo.module;

    // Vérifier si le module a une configuration chargée
    if (module.complement?.configuration?.module != null) {
      // Récupérer les types d'enfants directement depuis la configuration
      _childrenTypes =
          module.complement!.configuration!.module!.childrenTypes ?? [];
    } else {
      // Si le module n'a pas de configuration, construire les types à partir des données
      _childrenTypes = [];

      // Si le module a des sites, ajouter 'site' au childrenTypes par défaut
      if (module.sites != null && module.sites!.isNotEmpty) {
        _childrenTypes = ['site'];
      }

      // Si le module a des groupes de sites, ajouter 'sites_group' au childrenTypes par défaut
      if (_updatedModule?.sitesGroup != null &&
          _updatedModule!.sitesGroup!.isNotEmpty) {
        _childrenTypes = [..._childrenTypes, 'sites_group'];
      } else if (widget.moduleInfo.module.sitesGroup != null &&
          widget.moduleInfo.module.sitesGroup!.isNotEmpty) {
        _childrenTypes = [..._childrenTypes, 'sites_group'];
      }
    }

    // Assurer que nous avons au moins un onglet (même si aucun enfant n'est trouvé)
    if (_childrenTypes.isEmpty) {
      // Check using _updatedModule first if available
      if (_updatedModule != null &&
          _updatedModule!.sites != null &&
          _updatedModule!.sites!.isNotEmpty) {
        _childrenTypes = ['site'];
      }
      // Fallback to widget.moduleInfo.module
      else if (widget.moduleInfo.module.sites != null &&
          widget.moduleInfo.module.sites!.isNotEmpty) {
        _childrenTypes = ['site'];
      }
    }

    // Issue #157 : si le module a des sites sans groupe parent mais que la
    // config ne déclare pas l'onglet 'site', l'ajouter d'office pour que ces
    // sites orphelins soient accessibles.
    if (_orphanSitesLoaded &&
        (_orphanSites?.isNotEmpty ?? false) &&
        !_childrenTypes.contains('site')) {
      _childrenTypes = [..._childrenTypes, 'site'];
    }
  }

  void _initializeTabController() {
    // Recréer le TabController si nécessaire
    if (_tabController == null ||
        _tabController!.length != _childrenTypes.length) {
      if (_tabController != null) {
        _tabController!.removeListener(_handleTabChange);
        _tabController!.dispose();
      }

      _tabController = TabController(
          length: _childrenTypes.isNotEmpty ? _childrenTypes.length : 1,
          vsync: this);
      _tabController!.addListener(_handleTabChange);
    }
  }

  void _loadSitesIfAvailable() {
    final module = _updatedModule ?? widget.moduleInfo.module;
    if (_childrenTypes.contains('site') ||
        (module.sites != null && module.sites!.isNotEmpty)) {
      _loadInitialSites();
      _loadVisitDerivedData();
    }
  }

  /// Charge en parallèle les stats de visites par site et la liste des sites
  /// ayant des visites non téléversées. Silencieux en cas d'erreur : la
  /// dégradation se limite à des colonnes vides et à l'absence du badge.
  Future<void> _loadVisitDerivedData() async {
    final ref = widget.ref;
    if (ref == null) return;
    final moduleId = (_updatedModule ?? widget.moduleInfo.module).id;
    try {
      final db = ref.read(visitDatabaseProvider);
      final results = await Future.wait([
        db.getSiteIdsWithUnsyncedVisitsForModule(moduleId),
        db.getVisitStatsForModule(moduleId),
        db.getSiteGroupIdsWithUnsyncedVisitsForModule(moduleId),
      ]);
      if (!mounted) return;
      setState(() {
        _unsyncedSiteIds = results[0] as Set<int>;
        _visitStatsBySiteId = results[1] as Map<int, SiteVisitStats>;
        _unsyncedSiteGroupIds = results[2] as Set<int>;
      });
    } catch (e) {
      debugPrint('Erreur chargement stats de visites: $e');
    }
  }

  @override
  void dispose() {
    if (_tabController != null) {
      _tabController!.removeListener(_handleTabChange);
      _tabController!.dispose();
    }
    _searchController.dispose();
    _groupSearchController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (_tabController != null) {
      // Réinitialiser le champ de recherche lors du changement d'onglet
      _searchController.clear();
      _searchQuery = '';

      // Charger les sites si on est sur l'onglet sites
      if (_tabController!.index == _childrenTypes.indexOf('site')) {
        _loadInitialSites();
      }
      // Mettre à jour les groupes de sites si on est sur l'onglet groupes
      else if (_tabController!.index == _childrenTypes.indexOf('sites_group')) {
        _filterSiteGroups();
      }
    }
  }

  void _loadInitialSites() {
    setState(() {
      _isLoadingSites = true;

      // L'onglet Sites liste TOUS les sites du module (cohérent avec le
      // comportement GeoNature web où l'onglet Sites affiche les 156 points
      // du module plaquesreptiles, et pas seulement les sites hors groupe).
      // Les orphelins servent uniquement à forcer l'AJOUT de l'onglet quand
      // la config serveur ne le déclare pas — voir _updateChildrenTypesFromConfig.
      final module = _updatedModule ?? widget.moduleInfo.module;
      _allSites = module.sites ?? [];
      _filterSites();

      _isLoadingSites = false;
    });
  }

  void _filterSites() {
    if (_searchQuery.isEmpty) {
      _filteredSites = _allSites;
    } else {
      _filteredSites = _allSites.where((site) {
        final name = site.baseSiteName?.toLowerCase() ?? '';
        final code = site.baseSiteCode?.toLowerCase() ?? '';
        final query = _searchQuery.toLowerCase();
        return name.contains(query) || code.contains(query);
      }).toList();
    }

    _displayedSites = _filteredSites;
  }

  void _filterSiteGroups() {
    final module = _updatedModule ?? widget.moduleInfo.module;
    final allSiteGroups = module.sitesGroup ?? [];

    if (_searchQuery.isEmpty) {
      _filteredSiteGroups = allSiteGroups;
    } else {
      _filteredSiteGroups = allSiteGroups.where((group) {
        final name = group.sitesGroupName?.toLowerCase() ?? '';
        final code = group.sitesGroupCode?.toLowerCase() ?? '';
        final query = _searchQuery.toLowerCase();
        return name.contains(query) || code.contains(query);
      }).toList();
    }
  }

  void _handleSearch(String value) {
    setState(() {
      _searchQuery = value;

      _filterSites();
      _filterSiteGroups();
    });
  }

  @override
  List<BreadcrumbItem> getBreadcrumbItems() {
    return [
      BreadcrumbItem(
        label: 'Module',
        value: widget.moduleInfo.module.moduleLabel ?? 'Module',
      ),
    ];
  }

  @override
  Widget buildBreadcrumb() {
    final items = getBreadcrumbItems();
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    final module = _updatedModule ?? widget.moduleInfo.module;
    final moduleDesc = module.moduleDesc;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          child: _ModuleBreadcrumbWithDescription(
            items: items,
            description: moduleDesc,
          ),
        ),
      ),
    );
  }

  @override
  PreferredSizeWidget buildAppBar() {
    // Vérifier si la configuration est en cours de chargement
    final bool isConfiguringModule = _isInitialLoading ||
        (!_configurationLoaded &&
            (widget.moduleInfo.module.complement != null ||
                _updatedModule?.complement != null));

    return AppBar(
      title: Text(getTitle()),
      // Afficher un indicateur de chargement dans l'AppBar si configuration en cours
      actions: [
        if (isConfiguringModule)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          )
        else
          UninstallModuleAction(
            moduleId: widget.moduleInfo.module.id,
            moduleLabel: widget.moduleInfo.module.moduleLabel ??
                widget.moduleInfo.module.moduleCode ??
                'le module',
          ),
      ],
    );
  }

  @override
  String getTitle() {
    return 'Module: ${widget.moduleInfo.module.moduleLabel ?? 'Détails du module'}';
  }

  @override
  Widget build(BuildContext context) {
    final childContent = buildChildrenContent();

    // Si on a des groupes de sites, les afficher directement sous la navigation
    final hasSiteGroups = _childrenTypes.contains('sites_group');
    final hasSite = _childrenTypes.contains('site');
    // Issue #157 : mode mixte = le module affiche à la fois des groupes et
    // des sites orphelins. On montre alors un TabBar à 2 onglets
    // (Groupes / Sites) au lieu d'afficher seulement les groupes.
    final isMixedMode =
        hasSiteGroups && hasSite && _tabController != null &&
            _tabController!.length == 2;

    // Toutes les infos « propriétés » du module sont déjà accessibles via la
    // breadcrumb dépliable (« Afficher les détails ») ; on ne réserve donc
    // pas un Expanded au-dessus du tableau, qui restait vide en pratique et
    // mangeait ~40% de la hauteur (retour Camille v1.1.0).
    return Scaffold(
      appBar: buildAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildBreadcrumb(),
          if (isMixedMode)
            Expanded(
              child: Column(
                children: [
                  buildTabBar(
                    tabController: _tabController!,
                    tabs: _childrenTypes
                        .map((t) => _buildTabLabel(t))
                        .toList(),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController!,
                      children: _childrenTypes.map((t) {
                        if (t == 'sites_group') return _buildGroupsTab();
                        if (t == 'site') return _buildSitesTab();
                        return const SizedBox.shrink();
                      }).toList(),
                    ),
                  ),
                ],
              ),
            )
          else if (hasSiteGroups)
            Expanded(child: _buildGroupsTab())
          else if (childContent != null)
            Expanded(child: childContent)
          else
            Expanded(child: buildBaseContent()),
        ],
      ),
      floatingActionButton: hasSiteGroups ? _buildGroupsMapButton() : null,
    );
  }

  @override
  Widget? buildChildrenContent() {
    if (_childrenTypes.isEmpty || _tabController == null) {
      return null;
    }

    // Si on a des groupes de sites, on ne passe pas par buildChildrenContent
    // car ils sont affichés directement dans build()
    if (_childrenTypes.contains('sites_group')) {
      return null;
    }

    return Column(
      children: [
        // Message d'information si le module est en cours de configuration
        if (_isInitialLoading ||
            (!_configurationLoaded &&
                widget.moduleInfo.module.complement != null))
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              color: AppColors.primary.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: const [
                    Icon(Icons.info_outline, color: AppColors.dark),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Chargement de la configuration du module...',
                        style: TextStyle(color: AppColors.dark),
                      ),
                    ),
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(AppColors.dark),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

        // Utiliser notre méthode factorisée buildTabBar
        buildTabBar(
          tabController: _tabController!,
          tabs: [
            if (_childrenTypes.contains('site')) _buildTabLabel('site'),
          ],
        ),

        // Tab Views
        Expanded(
          child: TabBarView(
            controller: _tabController!,
            children: [
              if (_childrenTypes.contains('site')) _buildSitesTab(),
            ],
          ),
        ),
      ],
    );
  }

  Tab _buildTabLabel(String childType) {
    final module = _updatedModule ?? widget.moduleInfo.module;
    int count = 0;
    String label = '';

    if (childType == 'site') {
      // L'onglet Sites affiche TOUS les sites du module, comme sur le web.
      count = module.sites?.length ?? 0;
      label = module.complement?.configuration?.site?.labelList ??
          module.complement?.configuration?.site?.label ??
          'Sites';
    } else if (childType == 'sites_group') {
      count = module.sitesGroup?.length ?? 0;
      label = module.complement?.configuration?.sitesGroup?.labelList ??
          module.complement?.configuration?.sitesGroup?.label ??
          'Groupes de sites';
    }

    return Tab(text: '$label ($count)');
  }

  Widget _buildGroupsTab() {
    // Utiliser le module mis à jour s'il est disponible
    final module = _updatedModule ?? widget.moduleInfo.module;

    // Récupérer la configuration pour les groupes
    final ObjectConfig? sitesGroupConfig =
        module.complement?.configuration?.sitesGroup;
    final CustomConfig? customConfig = module.complement?.configuration?.custom;

    // Appliquer le filtre aux groupes de sites si ce n'est pas déjà fait
    if (_filteredSiteGroups.isEmpty) {
      _filterSiteGroups();
    }

    // Générer le schéma unifié pour le formatage
    Map<String, dynamic> parsedGroupConfig = {};
    if (sitesGroupConfig != null) {
      parsedGroupConfig = FormConfigParser.generateUnifiedSchema(
          sitesGroupConfig, customConfig);
    }

    // Convertir en List<SiteGroup> (sans géométrie depuis le module)
    final List<SiteGroup> groupsFromModule =
        _filteredSiteGroups.whereType<SiteGroup>().toList();

    // Utiliser les données en cache si disponibles, sinon créer/mémoriser le Future
    if (_cachedGroups != null) {
      // Utiliser les données en cache directement pour éviter le rechargement
      return _buildGroupsContent(_cachedGroups!, sitesGroupConfig, customConfig,
          parsedGroupConfig, groupsFromModule);
    }

    // Mémoriser le Future pour éviter de le recréer à chaque rebuild
    if (_groupsGeometryFuture == null) {
      _groupsGeometryFuture = _loadGroupsWithGeometry(groupsFromModule);
      _groupsGeometryFuture!.then((groups) {
        if (mounted) {
          setState(() {
            _cachedGroups = groups;
          });
        }
      });
    }

    // Charger les groupes depuis la base de données pour avoir la géométrie
    return FutureBuilder<List<SiteGroup>>(
      future: _groupsGeometryFuture,
      builder: (context, snapshot) {
        // Utiliser les groupes de la base de données si disponibles, sinon ceux du module
        final List<SiteGroup> groups =
            snapshot.hasData && snapshot.data!.isNotEmpty
                ? snapshot.data!
                : groupsFromModule;

        // Mettre en cache les données une fois chargées
        if (snapshot.hasData && _cachedGroups == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _cachedGroups = snapshot.data;
              });
            }
          });
        }

        return _buildGroupsContent(groups, sitesGroupConfig, customConfig,
            parsedGroupConfig, groupsFromModule);
      },
    );
  }

  /// Construit le contenu des groupes (sans FutureBuilder)
  Widget _buildGroupsContent(
    List<SiteGroup> groups,
    ObjectConfig? sitesGroupConfig,
    CustomConfig? customConfig,
    Map<String, dynamic> parsedGroupConfig,
    List<SiteGroup> groupsFromModule,
  ) {
    final module = _updatedModule ?? widget.moduleInfo.module;

    return Column(
      children: [
        // Barre d'outils avec label, recherche, ajout et tri
        Builder(
          builder: (context) {
            final isEditable = _isSiteGroupEditableOnField(sitesGroupConfig);
            Widget? addButton;
            if (isEditable) {
              addButton = IconButton(
                key: const Key('create-site-group-button'),
                onPressed: () {
                  if (sitesGroupConfig != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SiteGroupFormPage(
                          siteGroupConfig: sitesGroupConfig,
                          customConfig: customConfig,
                          moduleId: module.id,
                          moduleInfo: widget.moduleInfo,
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Configuration de groupe de sites non disponible'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.add_circle),
                tooltip:
                    'Ajouter un ${sitesGroupConfig?.label ?? 'groupe de sites'}',
              );
            }
            return ListToolbarWidget(
              label: sitesGroupConfig?.labelList ??
                  sitesGroupConfig?.label ??
                  'Groupes de sites',
              showSearch: _showGroupSearch,
              searchQuery: _groupSearchQuery,
              searchController: _groupSearchController,
              onSearchChanged: (value) {
                setState(() {
                  _groupSearchQuery = value;
                });
              },
              onToggleSearch: () {
                setState(() {
                  _showGroupSearch = !_showGroupSearch;
                  if (!_showGroupSearch) {
                    _groupSearchQuery = '';
                    _groupSearchController.clear();
                  }
                });
              },
              onCloseSearch: () {
                setState(() {
                  _showGroupSearch = false;
                  _groupSearchQuery = '';
                  _groupSearchController.clear();
                });
              },
              userPosition: _userPosition,
              sortByDistance: _sortGroupsByDistance,
              onToggleSort: () {
                setState(() {
                  _sortGroupsByDistance = !_sortGroupsByDistance;
                });
              },
              searchHintText: 'Rechercher par nom de groupe...',
              addButton: addButton,
            );
          },
        ),
        // Liste des groupes avec ExpansionTile
        Expanded(
          child: _buildGroupsExpansionPanelList(
            _groupSearchQuery.isEmpty
                ? groups
                : groups.where((group) {
                    final groupName = group.sitesGroupName?.toLowerCase() ?? '';
                    final groupCode = group.sitesGroupCode?.toLowerCase() ?? '';
                    return groupName.contains(_groupSearchQuery) ||
                        groupCode.contains(_groupSearchQuery);
                  }).toList(),
            sitesGroupConfig,
            customConfig,
            parsedGroupConfig,
          ),
        ),
      ],
    );
  }

  /// Charge les groupes de sites depuis la base de données avec leur géométrie
  /// Enrichit les groupes du module avec les géométries de la base de données
  /// Utilise la même logique que site_group_detail_page.dart pour charger depuis la base de données
  Future<List<SiteGroup>> _loadGroupsWithGeometry(
      List<SiteGroup> groupsFromModule) async {
    debugPrint('=== DÉBUT CHARGEMENT GROUPES AVEC GÉOMÉTRIE ===');
    debugPrint(
        'Nombre de groupes depuis le module: ${groupsFromModule.length}');

    if (widget.ref == null) {
      debugPrint(
          '⚠️ Pas de ref disponible, retour des groupes du module sans géométrie');
      return groupsFromModule;
    }

    try {
      // Charger tous les groupes depuis la base de données (comme dans site_group_detail_page)
      debugPrint('Chargement des groupes depuis la base de données...');
      final sitesDatabase = widget.ref!.read(siteDatabaseProvider);
      final allDbGroups = await sitesDatabase.getAllSiteGroups();
      debugPrint(
          '✓ ${allDbGroups.length} groupes chargés depuis la base de données');

      // Log pour vérifier les géométries dans les groupes de la base de données
      debugPrint('=== VÉRIFICATION GÉOMÉTRIES DANS LA BASE DE DONNÉES ===');
      for (var dbGroup in allDbGroups) {
        debugPrint(
            'Groupe DB ${dbGroup.idSitesGroup} (${dbGroup.sitesGroupName ?? dbGroup.sitesGroupCode ?? "sans nom"}):');
        if (dbGroup.geom != null && dbGroup.geom!.isNotEmpty) {
          debugPrint(
              '  ✓ geom non null et non vide (longueur: ${dbGroup.geom!.length})');
          try {
            final geomData = jsonDecode(dbGroup.geom!);
            debugPrint('  Type: ${geomData['type'] ?? "non défini"}');
          } catch (e) {
            debugPrint('  ⚠️ Erreur parsing: $e');
          }
        } else {
          debugPrint('  ✗ geom est null ou vide');
        }
      }
      debugPrint('=== FIN VÉRIFICATION GÉOMÉTRIES ===');

      // Créer un map pour un accès rapide par ID
      final Map<int, SiteGroup> dbGroupsMap = {
        for (var group in allDbGroups) group.idSitesGroup: group
      };

      // Enrichir les groupes filtrés avec leur géométrie depuis la base de données
      // ou calculer la géométrie à partir des sites enfants
      final enrichedGroups = await Future.wait(
        groupsFromModule.map((group) async {
          final dbGroup = dbGroupsMap[group.idSitesGroup];
          if (dbGroup != null) {
            debugPrint(
                'Groupe ${group.idSitesGroup} (${group.sitesGroupName ?? group.sitesGroupCode ?? "sans nom"}):');
            if (dbGroup.geom != null && dbGroup.geom!.isNotEmpty) {
              debugPrint('  ✓ Géométrie présente dans la base de données');
              try {
                final geomData = jsonDecode(dbGroup.geom!);
                debugPrint('  Type: ${geomData['type'] ?? "non défini"}');
                if (geomData['coordinates'] != null) {
                  final coordsStr = geomData['coordinates'].toString();
                  debugPrint(
                      '  Coordonnées: ${coordsStr.length > 100 ? "${coordsStr.substring(0, 100)}..." : coordsStr}');
                }
              } catch (e) {
                debugPrint('  ⚠️ Erreur parsing géométrie: $e');
              }
              // Utiliser le groupe de la base de données qui a la géométrie
              return dbGroup;
            } else {
              debugPrint(
                  '  ✗ Aucune géométrie dans la base de données, calcul depuis les sites enfants...');
              // Calculer la géométrie à partir des sites enfants
              final calculatedGeom = await _calculateGroupGeometryFromSites(
                  group.idSitesGroup,
                  widget.moduleInfo.module.id,
                  sitesDatabase);
              if (calculatedGeom != null) {
                debugPrint('  ✓ Géométrie calculée depuis les sites enfants');
                // Retourner le groupe avec la géométrie calculée
                return group.copyWith(geom: calculatedGeom);
              } else {
                debugPrint(
                    '  ✗ Impossible de calculer la géométrie (pas de sites avec géométrie)');
              }
            }
          } else {
            debugPrint(
                'Groupe ${group.idSitesGroup} (${group.sitesGroupName ?? group.sitesGroupCode ?? "sans nom"}):');
            debugPrint(
                '  ✗ Groupe non trouvé dans la base de données, calcul depuis les sites enfants...');
            // Calculer la géométrie à partir des sites enfants
            final calculatedGeom = await _calculateGroupGeometryFromSites(
                group.idSitesGroup,
                widget.moduleInfo.module.id,
                sitesDatabase);
            if (calculatedGeom != null) {
              debugPrint('  ✓ Géométrie calculée depuis les sites enfants');
              // Retourner le groupe avec la géométrie calculée
              return group.copyWith(geom: calculatedGeom);
            } else {
              debugPrint(
                  '  ✗ Impossible de calculer la géométrie (pas de sites avec géométrie)');
            }
          }
          // Si pas de géométrie, retourner le groupe du module
          return group;
        }),
      );

      debugPrint('=== FIN CHARGEMENT GROUPES AVEC GÉOMÉTRIE ===');
      return enrichedGroups;
    } catch (e, stackTrace) {
      debugPrint('❌ Erreur lors du chargement des groupes avec géométrie: $e');
      debugPrint('Stack trace: $stackTrace');
      // En cas d'erreur, retourner les groupes du module
      return groupsFromModule;
    }
  }

  /// Calcule la géométrie d'un groupe à partir de ses sites enfants
  /// Retourne un Polygon GeoJSON représentant l'enveloppe convexe (convex hull) des sites
  Future<String?> _calculateGroupGeometryFromSites(int siteGroupId,
      int moduleId, SitesDatabase sitesDatabase) async {
    try {
      // Récupérer les sites du groupe liés au module courant
      final sites = await sitesDatabase.getSitesBySiteGroupAndModule(
          siteGroupId, moduleId);
      debugPrint('  Nombre de sites dans le groupe: ${sites.length}');

      // Extraire les coordonnées de tous les sites qui ont une géométrie
      final List<List<double>> coordinates = [];
      for (var site in sites) {
        if (site.geom != null && site.geom!.isNotEmpty) {
          try {
            final geomData = jsonDecode(site.geom!);
            if (geomData is Map<String, dynamic>) {
              final type = geomData['type'];
              final coords = geomData['coordinates'];

              if (type == 'Point' && coords is List && coords.length >= 2) {
                // Format GeoJSON: [longitude, latitude]
                coordinates.add([
                  coords[0].toDouble(),
                  coords[1].toDouble(),
                ]);
              } else if (type == 'Polygon' && coords is List) {
                // Pour un polygon, extraire tous les points du premier ring
                if (coords.isNotEmpty && coords[0] is List) {
                  final firstRing = coords[0] as List;
                  for (var point in firstRing) {
                    if (point is List && point.length >= 2) {
                      coordinates.add([
                        point[0].toDouble(),
                        point[1].toDouble(),
                      ]);
                    }
                  }
                }
              }
            }
          } catch (e) {
            debugPrint(
                '  ⚠️ Erreur parsing géométrie du site ${site.idBaseSite}: $e');
          }
        }
      }

      if (coordinates.isEmpty) {
        debugPrint('  ✗ Aucun site avec géométrie valide trouvé');
        return null;
      }

      // Si on a un seul point, retourner un Point GeoJSON
      if (coordinates.length == 1) {
        final lon = coordinates[0][0];
        final lat = coordinates[0][1];
        final pointGeom = {
          'type': 'Point',
          'coordinates': [lon, lat],
        };
        debugPrint('  Point unique: lon=$lon, lat=$lat');
        return jsonEncode(pointGeom);
      }

      // Calculer l'enveloppe convexe (convex hull) des points
      final hull = _calculateConvexHull(coordinates);

      if (hull.isEmpty) {
        debugPrint('  ✗ Impossible de calculer l\'enveloppe convexe');
        return null;
      }

      // Fermer le polygone en ajoutant le premier point à la fin
      if (hull.first[0] != hull.last[0] || hull.first[1] != hull.last[1]) {
        hull.add([hull.first[0], hull.first[1]]);
      }

      debugPrint('  Enveloppe convexe calculée avec ${hull.length} points');

      // Créer un Polygon GeoJSON
      final polygonGeom = {
        'type': 'Polygon',
        'coordinates': [hull],
      };

      return jsonEncode(polygonGeom);
    } catch (e) {
      debugPrint('  ❌ Erreur lors du calcul de la géométrie: $e');
      return null;
    }
  }

  /// Calcule l'enveloppe convexe (convex hull) d'un ensemble de points
  /// Utilise l'algorithme de Graham scan
  List<List<double>> _calculateConvexHull(List<List<double>> points) {
    if (points.length < 3) {
      // Si moins de 3 points, retourner tous les points
      return List.from(points);
    }

    // Trier les points par x, puis par y
    final sortedPoints = List<List<double>>.from(points);
    sortedPoints.sort((a, b) {
      if (a[0] != b[0]) {
        return a[0].compareTo(b[0]);
      }
      return a[1].compareTo(b[1]);
    });

    // Fonction pour calculer l'orientation (cross product)
    int orientation(List<double> p, List<double> q, List<double> r) {
      final val = (q[1] - p[1]) * (r[0] - q[0]) - (q[0] - p[0]) * (r[1] - q[1]);
      if (val == 0) return 0; // Collinear
      return (val > 0) ? 1 : 2; // Clockwise or Counterclockwise
    }

    // Construire la partie inférieure de l'enveloppe convexe
    final lower = <List<double>>[];
    for (var point in sortedPoints) {
      while (lower.length >= 2 &&
          orientation(
                  lower[lower.length - 2], lower[lower.length - 1], point) !=
              2) {
        lower.removeLast();
      }
      lower.add(point);
    }

    // Construire la partie supérieure de l'enveloppe convexe
    final upper = <List<double>>[];
    for (var i = sortedPoints.length - 1; i >= 0; i--) {
      final point = sortedPoints[i];
      while (upper.length >= 2 &&
          orientation(
                  upper[upper.length - 2], upper[upper.length - 1], point) !=
              2) {
        upper.removeLast();
      }
      upper.add(point);
    }

    // Combiner les deux parties (enlever le dernier point de chaque pour éviter la duplication)
    lower.removeLast();
    upper.removeLast();
    lower.addAll(upper);

    return lower;
  }

  Widget _buildGroupsExpansionPanelList(
    List<SiteGroup> groups,
    ObjectConfig? sitesGroupConfig,
    CustomConfig? customConfig,
    Map<String, dynamic> parsedGroupConfig,
  ) {
    if (groups.isEmpty) {
      return const Center(
        child: Text('Aucun groupe de sites associé à ce module'),
      );
    }

    // Trier les groupes selon le mode sélectionné
    List<SiteGroup> sortedGroups = List.from(groups);

    if (_sortGroupsByDistance && _userPosition != null) {
      // Tri par distance
      sortedGroups.sort((a, b) {
        final distanceA = _calculateGroupDistance(a);
        final distanceB = _calculateGroupDistance(b);

        // Si les deux distances sont disponibles, trier par distance
        if (distanceA != null && distanceB != null) {
          return distanceA.compareTo(distanceB);
        }
        // Si seule la distance A est disponible, A vient en premier
        if (distanceA != null && distanceB == null) {
          return -1;
        }
        // Si seule la distance B est disponible, B vient en premier
        if (distanceA == null && distanceB != null) {
          return 1;
        }
        // Si aucune distance n'est disponible, conserver l'ordre original
        return 0;
      });
    } else {
      // Tri alphabétique par le premier champ de display_list
      final List<String>? displayProperties =
          sitesGroupConfig?.displayList ?? sitesGroupConfig?.displayProperties;

      if (displayProperties != null && displayProperties.isNotEmpty) {
        final firstProperty = displayProperties.first;

        sortedGroups.sort((a, b) {
          // Récupérer les valeurs pour le tri
          String valueA = _getGroupPropertyValue(a, firstProperty,
              sitesGroupConfig, customConfig, parsedGroupConfig);
          String valueB = _getGroupPropertyValue(b, firstProperty,
              sitesGroupConfig, customConfig, parsedGroupConfig);

          return valueA.compareTo(valueB);
        });
      }
    }

    return ListView.builder(
      itemCount: sortedGroups.length,
      itemBuilder: (context, index) {
        final group = sortedGroups[index];
        // Trouver l'index original pour gérer l'expansion
        final originalIndex = groups.indexOf(group);
        final isExpanded = _expandedGroupPanelIndex == originalIndex;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: ExpansionTile(
            key: ValueKey(
                'group_expansion_${originalIndex}_$_expandedGroupPanelIndex'),
            shape: const RoundedRectangleBorder(
              side: BorderSide.none,
            ),
            collapsedShape: const RoundedRectangleBorder(
              side: BorderSide.none,
            ),
            tilePadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            childrenPadding: EdgeInsets.zero,
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.visibility, size: 20),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SiteGroupDetailPage(
                          siteGroup: group,
                          moduleInfo: _updatedModule != null
                              ? widget.moduleInfo
                                  .copyWith(module: _updatedModule!)
                              : widget.moduleInfo,
                        ),
                      ),
                    );
                    // Au retour : une visite a pu être créée/synchronisée
                    // dans un site du groupe — on rafraîchit le badge orange
                    // au niveau groupe également.
                    if (mounted) _loadVisitDerivedData();
                  },
                  tooltip: 'Voir les détails',
                ),
                if (_unsyncedSiteGroupIds.contains(group.idSitesGroup))
                  Tooltip(
                    message: 'Saisies locales non téléversées',
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            title: Row(
              children: [
                Expanded(
                  child: _buildGroupTitle(
                    group,
                    sitesGroupConfig,
                    parsedGroupConfig,
                  ),
                ),
                // Afficher la distance à droite
                if (_userPosition != null && group.geom != null)
                  _buildGroupDistanceBadge(group),
              ],
            ),
            initiallyExpanded: isExpanded,
            onExpansionChanged: (bool expanded) {
              setState(() {
                if (expanded) {
                  _expandedGroupPanelIndex = originalIndex;
                } else if (_expandedGroupPanelIndex == originalIndex) {
                  _expandedGroupPanelIndex = null;
                }
              });
            },
            children: [
              _buildGroupProperties(
                  group, sitesGroupConfig, customConfig, parsedGroupConfig),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGroupTitle(
    SiteGroup group,
    ObjectConfig? sitesGroupConfig,
    Map<String, dynamic> parsedGroupConfig,
  ) {
    // Construire les données du groupe
    final Map<String, dynamic> groupData = {};

    // Ajouter les champs de base
    if (group.sitesGroupCode != null) {
      groupData['sites_group_code'] = group.sitesGroupCode;
    }
    if (group.sitesGroupName != null) {
      groupData['sites_group_name'] = group.sitesGroupName;
    }
    if (group.sitesGroupDescription != null) {
      groupData['sites_group_description'] = group.sitesGroupDescription;
    }

    // Ajouter les données du champ data si disponible
    if (group.data != null && group.data!.isNotEmpty) {
      try {
        Map<String, dynamic> dataMap = {};
        if (group.data is String) {
          dataMap = Map<String, dynamic>.from(jsonDecode(group.data as String));
        } else {
          dataMap = Map<String, dynamic>.from(group.data as Map);
        }
        groupData.addAll(dataMap);
      } catch (e) {
        debugPrint('Erreur lors du décodage des données du groupe: $e');
      }
    }

    // Récupérer le nom du groupe (sites_group_name) depuis display_list ou utiliser le nom par défaut
    final List<String>? displayProperties =
        sitesGroupConfig?.displayList ?? sitesGroupConfig?.displayProperties;

    String displayText = group.sitesGroupName ?? 'Groupe sans nom';

    // Chercher sites_group_name dans display_list, peu importe sa position
    if (displayProperties != null && displayProperties.isNotEmpty) {
      if (displayProperties.contains('sites_group_name') &&
          groupData.containsKey('sites_group_name')) {
        final rawValue = groupData['sites_group_name'];
        displayText = ValueFormatter.format(rawValue);
      } else if (displayProperties.isNotEmpty) {
        // Si sites_group_name n'est pas dans display_list, utiliser le premier élément
        final firstProperty = displayProperties.first;
        if (groupData.containsKey(firstProperty)) {
          final rawValue = groupData[firstProperty];
          displayText = ValueFormatter.format(rawValue);
        }
      }
    }

    return Text(
      displayText,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildGroupProperties(
    SiteGroup group,
    ObjectConfig? sitesGroupConfig,
    CustomConfig? customConfig,
    Map<String, dynamic> parsedGroupConfig,
  ) {
    // Construire les données du groupe
    final Map<String, dynamic> groupData = {};

    // Ajouter les champs de base
    if (group.sitesGroupCode != null) {
      groupData['sites_group_code'] = group.sitesGroupCode;
    }
    if (group.sitesGroupName != null) {
      groupData['sites_group_name'] = group.sitesGroupName;
    }
    if (group.sitesGroupDescription != null) {
      groupData['sites_group_description'] = group.sitesGroupDescription;
    }

    // Ajouter les données du champ data si disponible
    if (group.data != null && group.data!.isNotEmpty) {
      try {
        Map<String, dynamic> dataMap = {};
        if (group.data is String) {
          dataMap = Map<String, dynamic>.from(jsonDecode(group.data as String));
        } else {
          dataMap = Map<String, dynamic>.from(group.data as Map);
        }
        groupData.addAll(dataMap);
      } catch (e) {
        debugPrint('Erreur lors du décodage des données du groupe: $e');
      }
    }

    // Déterminer les colonnes à afficher (uniquement display_list)
    List<String>? displayProperties =
        sitesGroupConfig?.displayList ?? sitesGroupConfig?.displayProperties;

    // Si pas de displayProperties, ne rien afficher
    if (displayProperties == null || displayProperties.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'Aucune information à afficher',
          style: TextStyle(
            fontSize: 14,
            fontStyle: FontStyle.italic,
            color: Colors.grey,
          ),
        ),
      );
    }

    // Vérifier si on a besoin de calculer nb_sites de manière asynchrone
    // On calcule toujours nb_sites s'il est dans display_list, même s'il est déjà dans groupData
    // pour s'assurer qu'il est à jour
    final needsNbSites = displayProperties.contains('nb_sites');

    debugPrint(
        '🔍 _buildGroupProperties - needsNbSites: $needsNbSites, displayProperties: $displayProperties, groupData keys: ${groupData.keys.toList()}');

    // Si nb_sites est dans display_list, utiliser un FutureBuilder pour le calculer
    if (needsNbSites && widget.ref != null) {
      return FutureBuilder<int>(
        future: _calculateNbSites(group.idSitesGroup),
        builder: (context, snapshot) {
          // Ajouter nb_sites aux données si calculé
          final enrichedGroupData = Map<String, dynamic>.from(groupData);

          if (snapshot.connectionState == ConnectionState.waiting) {
            // Pendant le chargement, on peut afficher les autres propriétés
            // mais on ajoute quand même nb_sites avec une valeur par défaut pour éviter le filtre
            enrichedGroupData['nb_sites'] =
                0; // Utiliser 0 au lieu de null pour que le filtre le trouve
            debugPrint('⏳ Calcul de nb_sites en cours...');
          } else if (snapshot.hasData) {
            enrichedGroupData['nb_sites'] = snapshot.data;
            debugPrint('✅ nb_sites calculé: ${snapshot.data}');
          } else if (snapshot.hasError) {
            // En cas d'erreur, on met 0 pour éviter que le filtre ne trouve rien
            enrichedGroupData['nb_sites'] = 0;
            debugPrint(
                '❌ Erreur lors du calcul de nb_sites: ${snapshot.error}');
          }

          // Ajouter les autres propriétés calculées si nécessaire
          final List<String>? displayPropsForEnrichment =
              sitesGroupConfig?.displayList ??
                  sitesGroupConfig?.displayProperties;
          if (displayPropsForEnrichment != null) {
            for (final property in displayPropsForEnrichment) {
              if (property != 'nb_sites' &&
                  !enrichedGroupData.containsKey(property)) {
                final value = _getSiteGroupValue(group, property);
                if (value != null) {
                  enrichedGroupData[property] = value;
                }
              }
            }
          }

          debugPrint(
              '📊 enrichedGroupData keys: ${enrichedGroupData.keys.toList()}, nb_sites: ${enrichedGroupData['nb_sites']}');

          return _buildGroupPropertiesContent(
              enrichedGroupData, displayProperties, parsedGroupConfig);
        },
      );
    }

    // Sinon, enrichir les données de manière synchrone
    // Mais si nb_sites est nécessaire et qu'on n'a pas de ref, on essaie quand même de le calculer
    final List<String>? displayPropsForEnrichment =
        sitesGroupConfig?.displayList ?? sitesGroupConfig?.displayProperties;
    if (displayPropsForEnrichment != null) {
      for (final property in displayPropsForEnrichment) {
        if (!groupData.containsKey(property)) {
          if (property == 'nb_sites' && widget.ref != null) {
            // Si nb_sites est nécessaire mais qu'on n'est pas passé par le FutureBuilder,
            // on doit quand même le calculer de manière asynchrone
            return FutureBuilder<int>(
              future: _calculateNbSites(group.idSitesGroup),
              builder: (context, snapshot) {
                final enrichedGroupData = Map<String, dynamic>.from(groupData);
                if (snapshot.hasData) {
                  enrichedGroupData['nb_sites'] = snapshot.data;
                } else {
                  enrichedGroupData['nb_sites'] = 0;
                }
                // Ajouter les autres propriétés
                for (final prop in displayPropsForEnrichment) {
                  if (prop != 'nb_sites' &&
                      !enrichedGroupData.containsKey(prop)) {
                    final value = _getSiteGroupValue(group, prop);
                    if (value != null) {
                      enrichedGroupData[prop] = value;
                    }
                  }
                }
                return _buildGroupPropertiesContent(
                    enrichedGroupData, displayProperties, parsedGroupConfig);
              },
            );
          } else {
            final value = _getSiteGroupValue(group, property);
            if (value != null) {
              groupData[property] = value;
            }
          }
        }
      }
    }

    return _buildGroupPropertiesContent(
        groupData, displayProperties, parsedGroupConfig);
  }

  Widget _buildPropertyRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label,
                style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  /// Construit le contenu des propriétés du groupe
  Widget _buildGroupPropertiesContent(
    Map<String, dynamic> groupData,
    List<String> displayProperties,
    Map<String, dynamic> parsedGroupConfig,
  ) {
    // Si pas de données, afficher un message
    if (groupData.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'Aucune information disponible',
          style: TextStyle(
            fontSize: 14,
            fontStyle: FontStyle.italic,
            color: Colors.grey,
          ),
        ),
      );
    }

    // Exclure sites_group_name (déjà affiché dans le title), peu importe sa position
    final propertiesToShow = displayProperties.where((key) {
      return key != 'sites_group_name';
    }).toList();

    // Filtrer les propriétés meta et ne garder que celles présentes dans les données
    final filteredProperties = propertiesToShow.where((key) {
      final hasKey = groupData.containsKey(key);
      final isMeta = key.startsWith('meta_');
      final value = groupData[key];
      debugPrint(
          '🔍 Filtrage propriété $key: hasKey=$hasKey, isMeta=$isMeta, value=$value');
      return !isMeta && hasKey;
    }).toList();

    debugPrint('📋 propertiesToShow: $propertiesToShow');
    debugPrint('✅ filteredProperties: $filteredProperties');

    // Si aucune propriété ne correspond après filtrage
    if (filteredProperties.isEmpty) {
      debugPrint(
          '⚠️ Aucune propriété après filtrage - groupData: ${groupData.keys.toList()}');
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'Aucune information à afficher',
          style: TextStyle(
            fontSize: 14,
            fontStyle: FontStyle.italic,
            color: Colors.grey,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: filteredProperties.map((propertyKey) {
          final rawValue = groupData[propertyKey];

          // Obtenir le label depuis la configuration
          String label = propertyKey;
          if (parsedGroupConfig.containsKey(propertyKey)) {
            label =
                parsedGroupConfig[propertyKey]['attribut_label'] ?? propertyKey;
          }

          // Formater la valeur
          String displayValue = ValueFormatter.format(rawValue);

          return _buildPropertyRow(label, displayValue);
        }).toList(),
      ),
    );
  }

  /// Calcule le nombre de sites d'un groupe rattachés au module courant
  Future<int> _calculateNbSites(int siteGroupId) async {
    if (widget.ref == null) {
      return 0;
    }
    try {
      final sitesDatabase = widget.ref!.read(siteDatabaseProvider);
      final sites = await sitesDatabase.getSitesBySiteGroupAndModule(
          siteGroupId, widget.moduleInfo.module.id);
      return sites.length;
    } catch (e) {
      debugPrint(
          'Erreur lors du calcul de nb_sites pour le groupe $siteGroupId: $e');
      return 0;
    }
  }

  /// Construit le bouton flottant pour afficher la carte des groupes de sites
  Widget _buildGroupsMapButton() {
    final module = _updatedModule ?? widget.moduleInfo.module;
    final ObjectConfig? sitesGroupConfig =
        module.complement?.configuration?.sitesGroup;
    final CustomConfig? customConfig = module.complement?.configuration?.custom;

    // Utiliser les groupes en cache s'ils sont disponibles, sinon ceux du module
    final List<SiteGroup> groupsToDisplay =
        _cachedGroups ?? _filteredSiteGroups.whereType<SiteGroup>().toList();

    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => Scaffold(
              appBar: AppBar(
                title: Text(
                  'Carte des ${sitesGroupConfig?.label ?? 'groupes de sites'}',
                ),
              ),
              body: GeometriesMapWidget(
                geojsonData: _convertSiteGroupsToGeoJSON(groupsToDisplay),
                displayList: sitesGroupConfig?.displayList ??
                    sitesGroupConfig?.displayProperties,
                siteConfig: null, // Pas de siteConfig pour les groupes
                customConfig: customConfig,
                moduleInfo: widget.moduleInfo,
                siteGroup: null, // Pas de siteGroup spécifique
              ),
            ),
          ),
        );
      },
      tooltip: 'Afficher la carte des groupes de sites',
      child: const Icon(Icons.map, color: Colors.white),
    );
  }

  /// Convertit une liste de SiteGroup en format GeoJSON pour GeometriesMapWidget
  String? _convertSiteGroupsToGeoJSON(List<SiteGroup> groups) {
    if (groups.isEmpty) return null;

    final List<Map<String, dynamic>> geoJsonFeatures = [];

    for (final group in groups) {
      if (group.geom == null || group.geom!.isEmpty) continue;

      try {
        // Parser la géométrie JSON string
        final Map<String, dynamic> geometry = jsonDecode(group.geom!);

        // Créer une feature avec les informations du groupe
        final feature = <String, dynamic>{
          'id': group.idSitesGroup,
          'name': group.sitesGroupName ?? 'Groupe ${group.idSitesGroup}',
          'description': group.sitesGroupDescription ?? '',
          'geom': geometry,
        };

        // Ajouter les champs de base pour le display_list
        if (group.sitesGroupCode != null) {
          feature['sites_group_code'] = group.sitesGroupCode;
        }
        if (group.sitesGroupName != null) {
          feature['sites_group_name'] = group.sitesGroupName;
        }
        if (group.sitesGroupDescription != null) {
          feature['sites_group_description'] = group.sitesGroupDescription;
        }
        if (group.altitudeMin != null) {
          feature['altitude_min'] = group.altitudeMin;
        }
        if (group.altitudeMax != null) {
          feature['altitude_max'] = group.altitudeMax;
        }
        if (group.comments != null) {
          feature['comments'] = group.comments;
        }

        // Ajouter les données du champ data si disponible
        if (group.data != null && group.data!.isNotEmpty) {
          try {
            Map<String, dynamic> dataMap = {};
            if (group.data is String) {
              dataMap =
                  Map<String, dynamic>.from(jsonDecode(group.data as String));
            } else {
              dataMap = Map<String, dynamic>.from(group.data as Map);
            }
            feature.addAll(dataMap);
          } catch (e) {
            debugPrint(
                'Erreur lors du décodage des données du groupe ${group.idSitesGroup}: $e');
          }
        }

        geoJsonFeatures.add(feature);
      } catch (e) {
        debugPrint(
            'Erreur parsing geometry pour groupe ${group.idSitesGroup}: $e');
        // Skip this group if geometry parsing fails
      }
    }

    if (geoJsonFeatures.isEmpty) return null;

    return jsonEncode(geoJsonFeatures);
  }

  /// Récupère la valeur d'une propriété d'un groupe pour le tri
  String _getGroupPropertyValue(
    SiteGroup group,
    String propertyKey,
    ObjectConfig? sitesGroupConfig,
    CustomConfig? customConfig,
    Map<String, dynamic> parsedGroupConfig,
  ) {
    // Construire les données du groupe (uniquement les champs de base pour le tri synchrone)
    final Map<String, dynamic> groupData = {};

    // Ajouter les champs de base
    if (group.sitesGroupCode != null) {
      groupData['sites_group_code'] = group.sitesGroupCode;
    }
    if (group.sitesGroupName != null) {
      groupData['sites_group_name'] = group.sitesGroupName;
    }
    if (group.sitesGroupDescription != null) {
      groupData['sites_group_description'] = group.sitesGroupDescription;
    }

    // Récupérer la valeur
    if (groupData.containsKey(propertyKey)) {
      final rawValue = groupData[propertyKey];
      return ValueFormatter.format(rawValue);
    }

    // Valeur par défaut si la propriété n'existe pas dans les données de base
    return '';
  }

  /// Vérifie si les groupes de sites sont éditables sur le terrain
  /// Retourne true si is_editable_on_field est true ou absent (par défaut)
  /// Retourne false si is_editable_on_field est explicitement false
  bool _isSiteGroupEditableOnField(ObjectConfig? sitesGroupConfig) {
    debugPrint(
        '🔍 _isSiteGroupEditableOnField - sitesGroupConfig: ${sitesGroupConfig != null ? "non null" : "null"}');

    if (sitesGroupConfig == null) {
      debugPrint('❌ sitesGroupConfig est null, retourne false');
      return false;
    }

    // Vérifier d'abord la propriété directe isEditableOnField
    if (sitesGroupConfig.isEditableOnField != null) {
      debugPrint(
          '✅ Trouvé isEditableOnField (propriété directe): ${sitesGroupConfig.isEditableOnField}');
      return sitesGroupConfig.isEditableOnField!;
    }

    // Vérifier dans le champ specific (fallback)
    final specific = sitesGroupConfig.specific;
    debugPrint(
        '🔍 specific: ${specific != null ? "non null (${specific.keys.length} clés)" : "null"}');

    if (specific != null) {
      debugPrint('🔍 Clés dans specific: ${specific.keys.toList()}');

      if (specific.containsKey('is_editable_on_field')) {
        final value = specific['is_editable_on_field'];
        debugPrint(
            '✅ Trouvé is_editable_on_field dans specific: $value (type: ${value.runtimeType})');

        // Convertir en booléen de manière sécurisée
        bool result;
        if (value is bool) {
          result = value;
        } else if (value is String) {
          result = value.toLowerCase() == 'true';
        } else if (value is num) {
          result = value != 0;
        } else {
          result = false;
        }
        debugPrint('📊 Résultat: $result');
        return result;
      } else {
        debugPrint('⚠️ is_editable_on_field non trouvé dans specific');
      }
    }

    debugPrint('⚠️ is_editable_on_field non trouvé, retourne true par défaut');
    // Par défaut, si le paramètre n'est pas présent, on considère que c'est éditable
    return true;
  }

  /// Vérifie si les sites sont éditables sur le terrain
  bool _isSiteEditableOnField(ObjectConfig? siteConfig) {
    if (siteConfig == null) return false;

    if (siteConfig.isEditableOnField != null) {
      return siteConfig.isEditableOnField!;
    }

    final specific = siteConfig.specific;
    if (specific != null && specific.containsKey('is_editable_on_field')) {
      final value = specific['is_editable_on_field'];
      if (value is bool) return value;
      if (value is String) return value.toLowerCase() == 'true';
      if (value is num) return value != 0;
      return false;
    }

    // Par défaut, éditable
    return true;
  }

  /// Charge la position GPS de l'utilisateur
  Future<void> _loadUserLocation() async {
    try {
      debugPrint('Début du chargement de la position GPS');
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint('⚠️ Service de localisation désactivé');
        return;
      }
      debugPrint('✓ Service de localisation activé');

      LocationPermission permission = await Geolocator.checkPermission();
      debugPrint('Permission actuelle: $permission');

      if (permission == LocationPermission.denied) {
        debugPrint('Demande de permission...');
        permission = await Geolocator.requestPermission();
        debugPrint('Permission après demande: $permission');
        if (permission == LocationPermission.denied) {
          debugPrint('⚠️ Permission de localisation refusée');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        debugPrint('⚠️ Permission de localisation refusée définitivement');
        return;
      }

      debugPrint('Récupération de la position...');
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
        ),
      );
      debugPrint(
          '✓ Position récupérée: lat=${position.latitude}, lon=${position.longitude}');

      if (mounted) {
        setState(() {
          _userPosition = position;
        });
        debugPrint('✓ Position enregistrée dans l\'état');
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Erreur lors de la récupération de la position: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  /// Calcule la distance minimale entre la position de l'utilisateur et un
  /// groupe de sites, tous types GeoJSON confondus (Point, LineString,
  /// Polygon, MultiPolygon). Retourne 0 quand l'utilisateur est à
  /// l'intérieur d'un polygone.
  double? _calculateGroupDistance(SiteGroup group) {
    if (_userPosition == null || group.geom == null) {
      return null;
    }

    try {
      final service = widget.ref?.read(mapGeometryServiceProvider) ??
          const MapGeometryServiceImpl();
      return service.distanceToGeoJson(
        group.geom!,
        LatLng(_userPosition!.latitude, _userPosition!.longitude),
      );
    } catch (e) {
      debugPrint(
          'Erreur lors du calcul de la distance pour le groupe ${group.idSitesGroup}: $e');
      return null;
    }
  }

  /// Formate la distance pour l'affichage
  String _formatDistance(double distanceInMeters) {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.toStringAsFixed(0)} m';
    } else {
      return '${(distanceInMeters / 1000).toStringAsFixed(2)} km';
    }
  }

  /// Construit le badge de distance pour le header
  Widget _buildGroupDistanceBadge(SiteGroup group) {
    if (group.geom == null) {
      return const SizedBox.shrink();
    }
    if (_userPosition == null) {
      return _buildPendingDistanceBadge();
    }

    final distance = _calculateGroupDistance(group);
    if (distance == null) {
      return const SizedBox.shrink();
    }

    // Couleur verte si la distance est 0m (utilisateur à l'intérieur), bleue sinon
    final isInside = distance == 0.0;
    final badgeColor = isInside ? Colors.green : Colors.blue;

    return Container(
      margin: const EdgeInsets.only(left: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: badgeColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.location_on,
            color: badgeColor,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            _formatDistance(distance),
            style: TextStyle(
              fontSize: 12,
              color: badgeColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// Badge affiché pendant l'attente du GPS : CircularProgressIndicator
  /// + texte "Calcul…" pour signaler que la distance est en cours et non
  /// définitivement absente.
  Widget _buildPendingDistanceBadge() {
    return Container(
      margin: const EdgeInsets.only(left: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(
              strokeWidth: 1.5,
              color: Colors.grey,
            ),
          ),
          SizedBox(width: 6),
          Text(
            'Calcul…',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  /// Récupère dynamiquement la valeur d'une colonne depuis un SiteGroup
  /// Cette fonction mappe automatiquement les noms de colonnes aux propriétés du modèle
  dynamic _getSiteGroupValue(dynamic group, String column) {
    // Mapping des noms de colonnes vers les propriétés du modèle SiteGroup
    final Map<String, dynamic Function(dynamic)> propertyMap = {
      'sites_group_name': (g) => g.sitesGroupName,
      'sites_group_code': (g) => g.sitesGroupCode,
      'sites_group_description': (g) => g.sitesGroupDescription,
      'altitude_min': (g) => g.altitudeMin,
      'altitude_max': (g) => g.altitudeMax,
      'comments': (g) => g.comments,
      'uuid_sites_group': (g) => g.uuidSitesGroup,
      'id_sites_group': (g) => g.idSitesGroup,
      'id_digitiser': (g) => g.idDigitiser,
      'meta_create_date': (g) => g.metaCreateDate?.toIso8601String(),
      'meta_update_date': (g) => g.metaUpdateDate?.toIso8601String(),
    };

    // Essayer d'abord le mapping direct des propriétés
    if (propertyMap.containsKey(column)) {
      try {
        return propertyMap[column]!(group);
      } catch (e) {
        // Si l'accès échoue, continuer avec les autres méthodes
      }
    }

    // Pour nb_sites et nb_visits, ou autres colonnes calculées,
    // essayer de les récupérer depuis le champ data (JSON)
    if (group.data != null && group.data!.isNotEmpty) {
      try {
        final dataMap = jsonDecode(group.data!) as Map<String, dynamic>;
        if (dataMap.containsKey(column)) {
          return dataMap[column];
        }
      } catch (e) {
        // Si le parsing échoue, continuer
      }
    }

    // Si aucune valeur n'est trouvée, retourner null
    return null;
  }

  Widget _buildSitesTab() {
    // Utiliser le module mis à jour s'il est disponible
    final module = _updatedModule ?? widget.moduleInfo.module;

    // Obtenir la configuration des sites
    final siteConfig = module.complement?.configuration?.site;

    if (_isLoadingSites && _displayedSites.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    // Déterminer les colonnes à afficher pour les sites
    List<String> standardColumns = [
      'actions',
      'base_site_name',
      'base_site_code',
      'base_site_description'
    ];

    // BaseSite n'a pas de propriété 'data' directement, nous devons donc éviter d'y accéder
    Map<String, dynamic>? firstItemData;

    List<String> displayColumns = determineDataColumns(
      standardColumns: standardColumns,
      itemConfig: siteConfig,
      firstItemData: firstItemData,
      filterMetaColumns: true,
    );

    // Créer les colonnes du DataTable
    List<DataColumn> columns = buildDataColumns(
      columns: displayColumns,
      itemConfig: siteConfig,
      predefinedLabels: {
        'actions': 'Action',
        'base_site_name': 'Nom',
        'base_site_code': 'Code',
        'base_site_description': 'Description',
        'altitude_min': 'Altitude min',
        'altitude_max': 'Altitude max',
        'last_visit': 'Dernier passage',
        'nb_visits': 'Nb. passages',
      },
    );

    // Générer le schéma pour le formatage des cellules
    Map<String, dynamic> schema = {};
    if (siteConfig != null) {
      schema = FormConfigParser.generateUnifiedSchema(siteConfig, customConfig);
    }

    // Construire les lignes du tableau
    List<DataRow> rows = _displayedSites.map((site) {
      return DataRow(
        cells: displayColumns.map((column) {
          // Colonne d'actions
          if (column == 'actions') {
            final hasUnsyncedVisits = _unsyncedSiteIds.contains(site.idBaseSite);
            return DataCell(
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.visibility, size: 20),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SiteDetailPage(
                            site: site,
                            moduleInfo: _updatedModule != null
                                ? widget.moduleInfo
                                    .copyWith(module: _updatedModule!)
                                : widget.moduleInfo,
                          ),
                        ),
                      );
                      // L'utilisateur a pu créer/synchroniser une visite sur
                      // ce site ; on rafraîchit le badge et les stats au
                      // retour pour que "Dernier passage" / "Nb. passages"
                      // reflètent la saisie immédiatement.
                      if (mounted) _loadVisitDerivedData();
                    },
                    constraints: const BoxConstraints(
                      minWidth: 36,
                      minHeight: 36,
                    ),
                  ),
                  if (hasUnsyncedVisits)
                    Tooltip(
                      message: 'Saisies locales non téléversées',
                      child: Container(
                        width: 10,
                        height: 10,
                        margin: const EdgeInsets.only(left: 2),
                        decoration: const BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            );
          }

          // Propriétés standard du site
          dynamic value;
          switch (column) {
            case 'base_site_name':
              value = site.baseSiteName;
              break;
            case 'base_site_code':
              value = site.baseSiteCode;
              break;
            case 'base_site_description':
              value = site.baseSiteDescription;
              break;
            case 'altitude_min':
              value = site.altitudeMin;
              break;
            case 'altitude_max':
              value = site.altitudeMax;
              break;
            case 'last_visit':
              // Calculé localement depuis t_base_visits : prend en compte
              // les saisies offline pas encore téléversées, contrairement
              // au last_visit serveur. Formaté "dd/MM/yyyy" ici car la
              // config `site` ne déclare généralement pas la colonne dans
              // `generic`, donc formatDataCellValue n'a pas le type_widget
              // `date` pour la formater elle-même.
              final lastVisit =
                  _visitStatsBySiteId[site.idBaseSite]?.lastVisit;
              value = lastVisit != null
                  ? '${lastVisit.day.toString().padLeft(2, '0')}/'
                      '${lastVisit.month.toString().padLeft(2, '0')}/'
                      '${lastVisit.year}'
                  : null;
              break;
            case 'nb_visits':
              value = _visitStatsBySiteId[site.idBaseSite]?.nbVisits ?? 0;
              break;
            default:
              // Colonne inconnue ou non encore exploitée (ex. "visitors",
              // "comments" côté server complement → issue dédiée).
              value = null;
          }

          // Formater la valeur et créer la cellule
          String displayValue = formatDataCellValue(
            rawValue: value,
            columnName: column,
            schema: schema,
          );

          return buildFormattedDataCell(
            value: displayValue,
            enableTooltip: true,
          );
        }).toList(),
      );
    }).toList();

    // Message vide personnalisé
    Widget emptyMessage = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        'Aucun site associé à ce module',
        style: TextStyle(
          fontSize: 16,
          color: AppColors.hint,
        ),
      ),
    );

    // Bouton d'ajout de site si éditable
    Widget? addButton;
    final isEditable = _isSiteEditableOnField(siteConfig);
    if (isEditable && siteConfig != null) {
      final customConfig = module.complement?.configuration?.custom;
      final currentModuleInfo = _updatedModule != null
          ? widget.moduleInfo.copyWith(module: _updatedModule!)
          : widget.moduleInfo;
      addButton = IconButton(
        key: const Key('create-site-button'),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SiteFormPage(
                siteConfig: siteConfig,
                customConfig: customConfig,
                moduleId: module.id,
                moduleInfo: currentModuleInfo,
              ),
            ),
          );
          // Recharger les sites après retour du formulaire
          if (mounted) {
            loadCompleteModule();
          }
        },
        icon: const Icon(Icons.add_circle),
        tooltip: 'Ajouter un ${siteConfig.label ?? 'site'}',
      );
    }

    // Utiliser notre méthode factorisée buildDataTable
    return buildDataTable(
      columns: columns,
      rows: rows,
      showSearch: true,
      searchHint: "Rechercher un site",
      searchController: _searchController,
      onSearchChanged: _handleSearch,
      headerActions: addButton,
      emptyMessage: emptyMessage,
      isLoading: _isLoadingSites,
    );
  }
}
