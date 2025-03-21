import 'package:flutter/material.dart';
import 'package:gn_mobile_monitoring/core/helpers/form_config_parser.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/presentation/model/module_info.dart';
import 'package:gn_mobile_monitoring/presentation/view/site_detail_page.dart';

class ModuleDetailPage extends StatefulWidget {
  final ModuleInfo moduleInfo;

  const ModuleDetailPage({super.key, required this.moduleInfo});

  @override
  State<ModuleDetailPage> createState() => _ModuleDetailPageState();
}

class _ModuleDetailPageState extends State<ModuleDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<String> _childrenTypes;
  final ScrollController _sitesScrollController = ScrollController();

  static const int _sitesPerPage = 20;
  int _currentSitesPage = 1;
  bool _isLoadingSites = false;
  List<dynamic> _displayedSites = [];

  // Configuration du module parsée
  late Map<String, dynamic> _moduleConfig;

  @override
  void initState() {
    super.initState();
    _childrenTypes = widget.moduleInfo.module.complement!.configuration?.module
            ?.childrenTypes ??
        [];
    _tabController = TabController(length: _childrenTypes.length, vsync: this);
    _tabController.addListener(_handleTabChange);
    _sitesScrollController.addListener(_handleScroll);

    // Initialiser la configuration du module parsée
    _initializeModuleConfig();

    if (_childrenTypes.contains('site')) {
      _loadInitialSites();
    }
  }

  void _initializeModuleConfig() {
    // Récupérer la configuration du module
    final moduleConfig =
        widget.moduleInfo.module.complement?.configuration?.module;
    final customConfig =
        widget.moduleInfo.module.complement?.configuration?.custom;

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
      _moduleConfig = {};
    }
  }

  void _handleTabChange() {
    if (_tabController.index == _childrenTypes.indexOf('site')) {
      _loadInitialSites();
    }
  }

  void _loadInitialSites() {
    setState(() {
      _isLoadingSites = true;
      _currentSitesPage = 1;
      _displayedSites =
          widget.moduleInfo.module.sites?.take(_sitesPerPage).toList() ?? [];
      _isLoadingSites = false;
    });
  }

  void _loadMoreSites() {
    if (_isLoadingSites) return;

    setState(() {
      _isLoadingSites = true;
    });

    final startIndex = _currentSitesPage * _sitesPerPage;
    final endIndex = startIndex + _sitesPerPage;
    final allSites = widget.moduleInfo.module.sites ?? [];

    if (startIndex < allSites.length) {
      setState(() {
        _displayedSites.addAll(
          allSites.getRange(
            startIndex,
            endIndex > allSites.length ? allSites.length : endIndex,
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

  void _handleScroll() {
    if (_sitesScrollController.position.pixels >=
        _sitesScrollController.position.maxScrollExtent - 200) {
      _loadMoreSites();
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _sitesScrollController.removeListener(_handleScroll);
    _sitesScrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final siteConfig = widget.moduleInfo.module.complement?.configuration?.site;
    final sitesGroupConfig =
        widget.moduleInfo.module.complement?.configuration?.sitesGroup;

    // Récupérer les labels pour les onglets
    final sitesGroupLabel = sitesGroupConfig?.label ?? 'Secteurs';
    final siteLabel = siteConfig?.labelList ?? siteConfig?.label ?? 'Dalles';

    // Compter le nombre de sites et de groupes de sites
    final sitesCount = widget.moduleInfo.module.sites?.length ?? 0;
    final sitesGroupCount = widget.moduleInfo.module.sitesGroup?.length ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.moduleInfo.module.moduleLabel ?? ''),
      ),
      body: Column(
        children: [
          // Afficher les propriétés du module
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildModulePropertiesList(),
          ),
          // Afficher les onglets avec le comptage
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(
                text: '$sitesGroupLabel ($sitesGroupCount)',
              ),
              Tab(
                text: '$siteLabel ($sitesCount)',
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildSitesGroupList(),
                _buildSitesList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModulePropertiesList() {
    // Propriétés basiques à toujours afficher
    final basicProperties = [
      {
        'key': 'moduleLabel',
        'label': 'Nom',
        'value': widget.moduleInfo.module.moduleLabel ?? ''
      },
      {
        'key': 'moduleDesc',
        'label': 'Description',
        'value': widget.moduleInfo.module.moduleDesc ?? ''
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
      final moduleConfig =
          widget.moduleInfo.module.complement?.configuration?.module;
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
          final value = widget.moduleInfo.module.complement?.data != null
              ? Map<String, dynamic>.from(widget.moduleInfo.module.complement!
                          .data as Map<String, dynamic>)[propName]
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
    // Récupérer la configuration pour les groupes
    final ObjectConfig? sitesGroupConfig =
        widget.moduleInfo.module.complement?.configuration?.site;
    Map<String, dynamic> parsedGroupConfig = {};

    if (sitesGroupConfig != null) {
      final customConfig =
          widget.moduleInfo.module.complement?.configuration?.custom;
      parsedGroupConfig = FormConfigParser.generateUnifiedSchema(
          sitesGroupConfig, customConfig);
    }

    // Libellés personnalisés en fonction de la configuration
    final String groupNameLabel =
        parsedGroupConfig.containsKey('sites_group_name')
            ? parsedGroupConfig['sites_group_name']['attribut_label'] ??
                'Nom du groupe'
            : 'Nom du groupe';

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Table(
          columnWidths: const {
            0: FixedColumnWidth(80), // Reduced width for single icon
            1: FlexColumnWidth(2), // Name column
            2: FixedColumnWidth(80), // Sites count
            3: FixedColumnWidth(80), // Visits count
          },
          children: [
            TableRow(
              children: [
                const Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Text('Action',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(groupNameLabel,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('Sites',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('Visites',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            if (widget.moduleInfo.module.sitesGroup != null)
              ...widget.moduleInfo.module.sitesGroup!.map((group) => TableRow(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        height: 48,
                        alignment: Alignment.center,
                        child: IconButton(
                          icon: const Icon(Icons.visibility, size: 20),
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
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(group.sitesGroupName ?? ''),
                      ),
                      Container(
                        height: 48,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: const Text('0'), // TODO: Implement actual count
                      ),
                      Container(
                        height: 48,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: const Text('0'), // TODO: Implement actual count
                      ),
                    ],
                  )),
          ],
        ),
      ),
    );
  }

  Widget _buildSitesTab() {
    // Obtenir la configuration des sites et l'analyser avec FormConfigParser
    final siteConfig = widget.moduleInfo.module.complement?.configuration?.site;
    final customConfig =
        widget.moduleInfo.module.complement?.configuration?.custom;
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
          Expanded(
            child: SingleChildScrollView(
              controller: _sitesScrollController,
              child: Table(
                columnWidths: const {
                  0: FixedColumnWidth(80), // Action column
                  1: FlexColumnWidth(2), // Name column
                  2: FixedColumnWidth(100), // Code column
                  3: FixedColumnWidth(80), // Altitude column
                },
                children: [
                  TableRow(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: Text('Action',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(baseSiteNameLabel,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(baseSiteCodeLabel,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(altitudeLabel,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  ..._displayedSites.map((site) => TableRow(
                        children: [
                          Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            height: 48,
                            alignment: Alignment.center,
                            child: IconButton(
                              icon: const Icon(Icons.visibility, size: 20),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SiteDetailPage(
                                      site: site,
                                      moduleInfo: widget.moduleInfo,
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(site.baseSiteName ?? ''),
                          ),
                          Container(
                            height: 48,
                            alignment: Alignment.centerLeft,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(site.baseSiteCode ?? ''),
                          ),
                          Container(
                            height: 48,
                            alignment: Alignment.centerLeft,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              site.altitudeMin != null &&
                                      site.altitudeMax != null
                                  ? '${site.altitudeMin}-${site.altitudeMax}m'
                                  : site.altitudeMin?.toString() ??
                                      site.altitudeMax?.toString() ??
                                      '',
                            ),
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

  Widget _buildSitesGroupList() {
    final sitesGroupConfig =
        widget.moduleInfo.module.complement?.configuration?.sitesGroup;
    final sitesGroups = widget.moduleInfo.module.sitesGroup ?? [];

    return ListView.builder(
      itemCount: sitesGroups.length,
      itemBuilder: (context, index) {
        final siteGroup = sitesGroups[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: ListTile(
            dense: true,
            title: Text(
              siteGroup.sitesGroupName ?? '',
              style: const TextStyle(fontSize: 14),
            ),
            subtitle: siteGroup.sitesGroupDescription != null
                ? Text(
                    siteGroup.sitesGroupDescription!,
                    style: const TextStyle(fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                : null,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.visibility, size: 20),
                  onPressed: () {
                    // TODO: Navigate to site group detail page
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSitesList() {
    final siteConfig = widget.moduleInfo.module.complement?.configuration?.site;
    final sites = widget.moduleInfo.module.sites ?? [];

    return ListView.builder(
      itemCount: sites.length,
      itemBuilder: (context, index) {
        final site = sites[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: ListTile(
            dense: true,
            title: Text(
              site.baseSiteName ?? '',
              style: const TextStyle(fontSize: 14),
            ),
            subtitle: site.baseSiteDescription != null
                ? Text(
                    site.baseSiteDescription!,
                    style: const TextStyle(fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                : null,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.visibility, size: 20),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SiteDetailPage(
                          site: site,
                          moduleInfo: widget.moduleInfo,
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
              ],
            ),
          ),
        );
      },
    );
  }
}

class ModuleSiteGroupsPage extends StatelessWidget {
  final ModuleInfo moduleInfo;

  const ModuleSiteGroupsPage({super.key, required this.moduleInfo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Site Groups'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: moduleInfo.module.sitesGroup!.length,
        itemBuilder: (context, index) {
          final siteGroup = moduleInfo.module.sitesGroup![index];
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
