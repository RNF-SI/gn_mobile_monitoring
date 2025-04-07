import 'package:flutter/material.dart';
import 'package:gn_mobile_monitoring/core/helpers/form_config_parser.dart';
import 'package:gn_mobile_monitoring/domain/model/module.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_module_with_config_usecase.dart';
import 'package:gn_mobile_monitoring/presentation/model/module_info.dart';
import 'package:gn_mobile_monitoring/presentation/view/base/detail_page.dart';
import 'package:gn_mobile_monitoring/presentation/view/site/site_detail_page.dart';
import 'package:gn_mobile_monitoring/presentation/view/site_group_detail_page.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/breadcrumb_navigation.dart';

class ModuleDetailPageBase extends DetailPage {
  final ModuleInfo moduleInfo;
  // Note: This class uses a different pattern than the others for accessing Riverpod providers
  // It relies on the GlobalKey<ModuleDetailPageBaseState> and injected use cases rather than WidgetRef

  const ModuleDetailPageBase({
    super.key,
    required this.moduleInfo,
  });

  @override
  ModuleDetailPageBaseState createState() => ModuleDetailPageBaseState();
}

class ModuleDetailPageBaseState extends DetailPageState<ModuleDetailPageBase>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  List<String> _childrenTypes = [];
  final ScrollController _sitesScrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  static const int _sitesPerPage = 20;
  int _currentSitesPage = 1;
  bool _isLoadingSites = false;
  List<dynamic> _displayedSites = [];
  List<dynamic> _filteredSites = [];
  List<dynamic> _allSites = [];
  List<dynamic> _filteredSiteGroups = [];
  String _searchQuery = '';
  bool _configurationLoaded = false;
  bool _isInitialLoading = true;

  // Module avec configuration complète (utilisé uniquement quand la configuration est chargée dynamiquement)
  Module? _updatedModule;

  // Injection du use case pour respecter la Clean Architecture
  late GetModuleWithConfigUseCase getModuleWithConfigUseCase;

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
      'moduleLabel': module.moduleLabel,
      'moduleDesc': module.moduleDesc,
      // Ajout d'autres propriétés de base si disponibles
    };

    // Ajouter les données complémentaires si disponibles
    if (module.complement?.data != null) {
      data.addAll(module.complement!.data as Map<String, dynamic>);
    }

    return data;
  }

  @override
  List<String> get childrenTypes => _childrenTypes;

  @override
  String get propertiesTitle => 'Propriétés';

  @override
  void initState() {
    super.initState();

    // Ajouter un écouteur pour le défilement
    _sitesScrollController.addListener(_handleScroll);

    // Toujours charger la configuration complète du module quand la propriété est injectée
  }

  // Méthode pour charger le module avec sa configuration complète
  Future<void> loadModuleWithConfig() async {
    try {
      // Utiliser le use case injecté par le widget parent
      final moduleWithConfig =
          await getModuleWithConfigUseCase.execute(widget.moduleInfo.module.id);

      // Vérifier si la configuration est bien présente
      final bool hasConfiguration =
          moduleWithConfig.complement?.configuration != null;

      // Mettre à jour le ModuleInfo
      if (mounted) {
        setState(() {
          // Stocker le module mis à jour avec sa configuration dans la variable de classe
          _updatedModule = moduleWithConfig;

          // Marquer la configuration comme chargée
          _configurationLoaded = hasConfiguration;
          _isInitialLoading = false;

          // Mettre à jour l'interface
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
    }
  }

  @override
  void dispose() {
    _sitesScrollController.removeListener(_handleScroll);
    if (_tabController != null) {
      _tabController!.removeListener(_handleTabChange);
      _tabController!.dispose();
    }
    _sitesScrollController.dispose();
    _searchController.dispose();
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
      _currentSitesPage = 1;

      // Les sites dans le module sont déjà filtrés
      // pour ce module spécifique via la relation cor_site_module
      final module = _updatedModule ?? widget.moduleInfo.module;
      final sitesForModule = module.sites ?? [];
      _allSites = sitesForModule;
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

    _displayedSites = _filteredSites.take(_sitesPerPage).toList();
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

  void _loadMoreSites() {
    if (_isLoadingSites) return;

    setState(() {
      _isLoadingSites = true;
    });

    final startIndex = _currentSitesPage * _sitesPerPage;
    final endIndex = startIndex + _sitesPerPage;

    if (startIndex < _filteredSites.length) {
      setState(() {
        _displayedSites.addAll(
          _filteredSites.getRange(
            startIndex,
            endIndex > _filteredSites.length ? _filteredSites.length : endIndex,
          ),
        );
        _currentSitesPage++;
        _isLoadingSites = false;
      });
    } else {
      setState(() {
        _isLoadingSites = false;
      });
    }
  }

  void _handleSearch(String value) {
    setState(() {
      _searchQuery = value;
      _currentSitesPage = 1;

      _filterSites();
      _filterSiteGroups();
    });
  }

  void _handleScroll() {
    if (_sitesScrollController.position.pixels >=
        _sitesScrollController.position.maxScrollExtent - 200) {
      _loadMoreSites();
    }
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
          ),
      ],
    );
  }

  @override
  String getTitle() {
    return 'Module: ${widget.moduleInfo.module.moduleLabel ?? 'Détails du module'}';
  }

  @override
  Widget buildBaseContent() {
    return super.buildBaseContent(); // Utilise la mise en page par défaut
  }

  @override
  Widget? buildChildrenContent() {
    if (_childrenTypes.isEmpty || _tabController == null) {
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
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue[700]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Chargement de la configuration du module...',
                        style: TextStyle(color: Colors.blue[700]),
                      ),
                    ),
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.blue[700]!),
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
            if (_childrenTypes.contains('sites_group'))
              _buildTabLabel('sites_group'),
            if (_childrenTypes.contains('site')) _buildTabLabel('site'),
          ],
        ),

        // Tab Views
        Expanded(
          child: TabBarView(
            controller: _tabController!,
            children: [
              if (_childrenTypes.contains('sites_group')) _buildGroupsTab(),
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

    Map<String, dynamic> parsedGroupConfig = {};

    if (sitesGroupConfig != null) {
      final customConfig = module.complement?.configuration?.custom;
      parsedGroupConfig = FormConfigParser.generateUnifiedSchema(
          sitesGroupConfig, customConfig);
    }

    // Libellés personnalisés en fonction de la configuration
    final String groupNameLabel = (parsedGroupConfig.isNotEmpty &&
            parsedGroupConfig.containsKey('sites_group_name'))
        ? parsedGroupConfig['sites_group_name']['attribut_label'] ??
            'Nom du groupe'
        : sitesGroupConfig?.label ?? 'Nom du groupe';

    // Appliquer le filtre aux groupes de sites si ce n'est pas déjà fait
    if (_filteredSiteGroups.isEmpty) {
      _filterSiteGroups();
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          // Champ de recherche
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Rechercher un groupe',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _handleSearch('');
                        },
                      )
                    : null,
                border: const OutlineInputBorder(),
              ),
              onChanged: _handleSearch,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: _filteredSiteGroups.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          'Aucun groupe de sites associé à ce module',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    )
                  : Table(
                      columnWidths: const {
                        0: FixedColumnWidth(
                            80), // Reduced width for single icon
                        1: FlexColumnWidth(2), // Name column
                      },
                      children: [
                        TableRow(
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16.0),
                              child: Text('Action',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(groupNameLabel,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        ..._filteredSiteGroups.map((group) => TableRow(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  height: 48,
                                  alignment: Alignment.center,
                                  child: IconButton(
                                    icon:
                                        const Icon(Icons.visibility, size: 20),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              SiteGroupDetailPage(
                                            siteGroup: group,
                                            moduleInfo: _updatedModule != null
                                                ? widget.moduleInfo.copyWith(
                                                    module: _updatedModule!)
                                                : widget.moduleInfo,
                                          ),
                                        ),
                                      );
                                    },
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(
                                      minWidth: 36,
                                      minHeight: 36,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 48,
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(group.sitesGroupName ?? ''),
                                ),
                              ],
                            )),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
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
    Map<String, dynamic>? firstItemData = null;

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
            return DataCell(
              IconButton(
                icon: const Icon(Icons.visibility, size: 20),
                onPressed: () {
                  Navigator.push(
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
                },
                constraints: const BoxConstraints(
                  minWidth: 36,
                  minHeight: 36,
                ),
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
            default:
              // BaseSite n'a pas de propriété 'data', on laisse la valeur à null
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
          color: Colors.grey[600],
        ),
      ),
    );

    // Utiliser notre méthode factorisée buildDataTable
    return buildDataTable(
      columns: columns,
      rows: rows,
      showSearch: true,
      searchHint: "Rechercher un site",
      searchController: _searchController,
      onSearchChanged: _handleSearch,
      emptyMessage: emptyMessage,
      isLoading: _isLoadingSites,
    );
  }
}
