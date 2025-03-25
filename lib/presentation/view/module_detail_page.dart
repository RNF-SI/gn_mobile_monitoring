import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gn_mobile_monitoring/core/helpers/form_config_parser.dart';
import 'package:gn_mobile_monitoring/domain/domain_module.dart';
import 'package:gn_mobile_monitoring/domain/model/module.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/presentation/model/module_info.dart';
import 'package:gn_mobile_monitoring/presentation/view/site_detail_page.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ModuleDetailPage extends ConsumerStatefulWidget {
  final ModuleInfo moduleInfo;

  const ModuleDetailPage({super.key, required this.moduleInfo});

  @override
  ConsumerState<ModuleDetailPage> createState() => _ModuleDetailPageState();
}

class _ModuleDetailPageState extends ConsumerState<ModuleDetailPage>
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

  // Configuration du module parsée
  Map<String, dynamic> _moduleConfig = {};

  @override
  void initState() {
    super.initState();

    // Ajouter un écouteur pour le défilement
    _sitesScrollController.addListener(_handleScroll);

    // Vérifier immédiatement si la configuration est disponible
    if (widget.moduleInfo.module.complement?.configuration != null) {
      _configurationLoaded = true;

      // Stocker une référence au module actuel
      _updatedModule = widget.moduleInfo.module;

      // Configuration initiale (déjà disponible)
      _updateChildrenTypesFromConfig();
      _initializeModuleConfig();
      _loadSitesIfAvailable();

      // Marquer le chargement comme terminé
      Future.delayed(Duration.zero, () {
        if (mounted) {
          setState(() {
            _isInitialLoading = false;
          });
        }
      });
    } else {
      // Utiliser le UseCase pour récupérer la configuration complète
      _loadModuleWithConfig();
    }
  }

  // Méthode pour charger le module avec sa configuration complète
  Future<void> _loadModuleWithConfig() async {
    try {
      // Récupérer le UseCase depuis le provider
      final getModuleWithConfigUseCase =
          ref.read(getModuleWithConfigUseCaseProvider);

      // Charger le module avec sa configuration
      final moduleWithConfig =
          await getModuleWithConfigUseCase.execute(widget.moduleInfo.module.id);

      // Mettre à jour le ModuleInfo
      if (mounted) {
        setState(() {
          // Stocker le module mis à jour avec sa configuration dans la variable de classe
          _updatedModule = moduleWithConfig;

          // Marquer la configuration comme chargée
          _configurationLoaded = true;
          _isInitialLoading = false;

          // Mettre à jour l'interface
          _updateChildrenTypesFromConfig();
          _initializeModuleConfig();
          _loadSitesIfAvailable();
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          // En cas d'erreur, marquer quand même comme chargé pour éviter un blocage de l'interface
          _configurationLoaded = true;
          _isInitialLoading = false;

          // Utiliser la configuration actuelle, même si elle est incomplète
          _updateChildrenTypesFromConfig();
          _initializeModuleConfig();
          _loadSitesIfAvailable();
        });
      }
    }
  }

  void _updateChildrenTypesFromConfig() {
    // Vérifier si le module a une configuration ou non
    // Utiliser le module mis à jour s'il est disponible
    final module = _updatedModule ?? widget.moduleInfo.module;

    if (module.complement?.configuration?.module != null) {
      _childrenTypes =
          module.complement!.configuration!.module!.childrenTypes ?? [];
    } else {
      // Si le module n'a pas de configuration, utiliser des valeurs par défaut
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

  void _initializeModuleConfig() {
    // Récupérer la configuration du module
    final module = _updatedModule ?? widget.moduleInfo.module;
    final moduleConfig = module.complement?.configuration?.module;
    final customConfig = module.complement?.configuration?.custom;

    // Créer un ObjectConfig à partir du ModuleConfig pour pouvoir utiliser le FormConfigParser
    if (moduleConfig != null) {
      final ObjectConfig objectConfig = ObjectConfig(
        label: moduleConfig.label,
        labelList: moduleConfig.moduleLabel,
        generic: moduleConfig.generic,
        specific: moduleConfig.specific,
        displayProperties: moduleConfig.displayProperties,
        displayList: moduleConfig.displayList,
        displayForm: moduleConfig.displayForm,
      );

      // Utiliser le FormConfigParser pour générer un schéma unifié
      _moduleConfig =
          FormConfigParser.generateUnifiedSchema(objectConfig, customConfig);
    } else {
      // Configuration par défaut si moduleConfig est null
      _moduleConfig = {
        'moduleLabel': {'attribut_label': 'Nom du module', 'required': true},
        'moduleDesc': {'attribut_label': 'Description', 'required': false}
      };

      // Ajouter des propriétés de base pour les sites si présents
      final module = _updatedModule ?? widget.moduleInfo.module;
      if (module.sites != null && module.sites!.isNotEmpty) {
        _moduleConfig['base_site_name'] = {
          'attribut_label': 'Nom du site',
          'required': true
        };
        _moduleConfig['base_site_code'] = {
          'attribut_label': 'Code',
          'required': false
        };
      }

      // Ajouter des propriétés de base pour les groupes de sites si présents
      if (module.sitesGroup != null && module.sitesGroup!.isNotEmpty) {
        _moduleConfig['sites_group_name'] = {
          'attribut_label': 'Nom du groupe',
          'required': true
        };
        _moduleConfig['sites_group_code'] = {
          'attribut_label': 'Code du groupe',
          'required': false
        };
      }
    }
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
  Widget build(BuildContext context) {
    // Utiliser le module mis à jour s'il est disponible, sinon utiliser celui du widget
    final module = _updatedModule ?? widget.moduleInfo.module;

    final siteConfig = module.complement?.configuration?.site;
    final sitesGroupConfig = module.complement?.configuration?.sitesGroup;

    // Nombre d'éléments pour les groupes et les sites
    final int siteGroupCount = module.sitesGroup?.length ?? 0;
    final int siteCount = module.sites?.length ?? 0;

    // Vérifier si la configuration est en cours de chargement
    final bool isConfiguringModule = _isInitialLoading ||
        (!_configurationLoaded && module.complement != null);

    return Scaffold(
      appBar: AppBar(
        title: Text('Module: ${module.moduleLabel ?? 'Module Details'}'),
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
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Properties Card
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Propriétés',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    _buildModulePropertiesList(),
                  ],
                ),
              ),
            ),
          ),
          // Message d'information si le module est en cours de configuration
          if (isConfiguringModule)
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
          if (_childrenTypes.isNotEmpty && _tabController != null) ...[
            // Tab Bar
            TabBar(
              controller: _tabController!,
              tabs: [
                if (_childrenTypes.contains('sites_group'))
                  Tab(
                      text:
                          '${sitesGroupConfig?.labelList ?? sitesGroupConfig?.label ?? 'Groupes de sites'} ($siteGroupCount)'),
                if (_childrenTypes.contains('site'))
                  Tab(
                      text:
                          '${siteConfig?.labelList ?? siteConfig?.label ?? 'Sites'} ($siteCount)'),
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
          // Si aucun onglet n'est disponible mais qu'on a des sites, afficher la liste des sites directement
          if (_childrenTypes.isEmpty && siteCount > 0)
            Expanded(
              child: _buildSitesTab(),
            ),
        ],
      ),
    );
  }

  Widget _buildModulePropertiesList() {
    // Utiliser le module mis à jour s'il est disponible, sinon utiliser celui du widget
    final module = _updatedModule ?? widget.moduleInfo.module;

    // Propriétés basiques à toujours afficher
    final basicProperties = [
      {'key': 'moduleLabel', 'label': 'Nom', 'value': module.moduleLabel ?? ''},
      {
        'key': 'moduleDesc',
        'label': 'Description',
        'value': module.moduleDesc ?? ''
      },
      {
        'key': 'dataset',
        'label': 'Jeu de données',
        'value': 'Contact aléatoire tous règnes confondus'
      },
    ];

    // Liste des propriétés à afficher
    final List<Map<String, String>> properties = [];

    // Ajouter les propriétés basiques
    properties.addAll(basicProperties.map((p) => {
          'label': p['label']!,
          'value': p['value']!,
        }));

    // Ajouter les propriétés depuis la configuration parsée
    if (_moduleConfig.isNotEmpty) {
      // Récupérer la liste de propriétés d'affichage
      final module = _updatedModule ?? widget.moduleInfo.module;
      final moduleConfig = module.complement?.configuration?.module;
      final List<String> displayProperties = moduleConfig?.displayProperties ??
          moduleConfig?.displayList ??
          FormConfigParser.generateDefaultDisplayProperties(_moduleConfig);

      // Récupérer les valeurs des propriétés depuis le module
      for (final propName in displayProperties) {
        // Ne pas redondant avec les propriétés basiques déjà affichées
        if (basicProperties.any((p) => p['key'] == propName)) continue;

        if (_moduleConfig.containsKey(propName)) {
          final fieldConfig = _moduleConfig[propName];
          final label = fieldConfig['attribut_label'] ?? propName;
          final value = module.complement?.data != null
              ? Map<String, dynamic>.from(module.complement!.data
                          as Map<String, dynamic>)[propName]
                      ?.toString() ??
                  ''
              : '';

          if (value.isNotEmpty) {
            properties.add({
              'label': label,
              'value': value,
            });
          }
        }
      }
    }

    // Construire les widgets
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: properties
          .map((prop) => _buildPropertyRow(prop['label']!, prop['value']!))
          .toList(),
    );
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
    final String groupNameLabel =
        parsedGroupConfig.containsKey('sites_group_name')
            ? parsedGroupConfig['sites_group_name']['attribut_label'] ??
                'Nom du groupe'
            : 'Nom du groupe';

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
                                    onPressed: () {},
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

    // Obtenir la configuration des sites et l'analyser avec FormConfigParser
    final siteConfig = module.complement?.configuration?.site;
    final customConfig = module.complement?.configuration?.custom;
    Map<String, dynamic> parsedSiteConfig = {};

    if (siteConfig != null) {
      parsedSiteConfig =
          FormConfigParser.generateUnifiedSchema(siteConfig, customConfig);
    }

    // Récupérer les libellés personnalisés en fonction de la configuration
    final String baseSiteNameLabel =
        parsedSiteConfig.containsKey('base_site_name')
            ? parsedSiteConfig['base_site_name']['attribut_label'] ?? 'Nom'
            : 'Nom';

    final String baseSiteCodeLabel =
        parsedSiteConfig.containsKey('base_site_code')
            ? parsedSiteConfig['base_site_code']['attribut_label'] ?? 'Code'
            : 'Code';

    final String altitudeLabel = parsedSiteConfig.containsKey('altitude')
        ? parsedSiteConfig['altitude']['attribut_label'] ?? 'Altitude'
        : 'Altitude';

    if (_isLoadingSites && _displayedSites.isEmpty) {
      return const Center(child: CircularProgressIndicator());
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
                labelText: 'Rechercher un site',
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
              controller: _sitesScrollController,
              child: _displayedSites.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          'Aucun site associé à ce module',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    )
                  : Table(
                      columnWidths: const {
                        0: FixedColumnWidth(80), // Action column
                        1: FlexColumnWidth(2), // Name column
                        2: FixedColumnWidth(100), // Code column
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
                              child: Text(baseSiteNameLabel,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(baseSiteCodeLabel,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        ..._displayedSites.map((site) => TableRow(
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
                                          builder: (context) => SiteDetailPage(
                                            site: site,
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
                                  child: Text(site.baseSiteName ?? ''),
                                ),
                                Container(
                                  height: 48,
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(site.baseSiteCode ?? ''),
                                ),
                              ],
                            )),
                      ],
                    ),
            ),
          ),
          if (_isLoadingSites)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}

class ModuleSiteGroupsPage extends StatelessWidget {
  final ModuleInfo moduleInfo;

  const ModuleSiteGroupsPage({super.key, required this.moduleInfo});

  @override
  Widget build(BuildContext context) {
    final module = moduleInfo.module;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Site Groups'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: module.sitesGroup?.length ?? 0,
        itemBuilder: (context, index) {
          final siteGroup = module.sitesGroup![index];
          return Card(
            margin: const EdgeInsets.only(bottom: 8.0),
            child: ListTile(
              title: Text(
                siteGroup.sitesGroupName ?? 'Unnamed Group',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Code: ${siteGroup.sitesGroupCode ?? 'N/A'}'),
                  if (siteGroup.sitesGroupDescription != null)
                    Text('Description: ${siteGroup.sitesGroupDescription}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
