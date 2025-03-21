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

      // Les sites dans widget.moduleInfo.module.sites sont déjà filtrés
      // pour ce module spécifique via la relation cor_site_module
      final sitesForModule = widget.moduleInfo.module.sites ?? [];
      _displayedSites = sitesForModule.take(_sitesPerPage).toList();

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

    // Les sites dans widget.moduleInfo.module.sites sont déjà filtrés
    // pour ce module spécifique via la relation cor_site_module
    final allSitesForModule = widget.moduleInfo.module.sites ?? [];

    if (startIndex < allSitesForModule.length) {
      setState(() {
        _displayedSites.addAll(
          allSitesForModule.getRange(
            startIndex,
            endIndex > allSitesForModule.length
                ? allSitesForModule.length
                : endIndex,
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
        widget.moduleInfo.module.complement?.configuration?.site;

    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Module: ${widget.moduleInfo.module.moduleLabel ?? 'Module Details'}'),
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
          if (_childrenTypes.isNotEmpty) ...[
            // Tab Bar
            TabBar(
              controller: _tabController,
              tabs: [
                if (_childrenTypes.contains('sites_group'))
                  Tab(
                      text:
                          '${sitesGroupConfig?.labelList ?? 'Groupes'} (${widget.moduleInfo.module.sitesGroup?.length ?? 0})'),
                if (_childrenTypes.contains('site'))
                  Tab(text: siteConfig?.labelList ?? 'Sites'),
              ],
            ),
            // Tab Views
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  if (_childrenTypes.contains('sites_group')) _buildGroupsTab(),
                  if (_childrenTypes.contains('site')) _buildSitesTab(),
                ],
              ),
            ),
          ],
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

    // Vérifier si des groupes sont associés à ce module
    final sitesGroup = widget.moduleInfo.module.sitesGroup ?? [];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: sitesGroup.isEmpty
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
                  0: FixedColumnWidth(80), // Reduced width for single icon
                  1: FlexColumnWidth(2), // Name column
                  2: FixedColumnWidth(80), // Sites count
                  3: FixedColumnWidth(80), // Visits count
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
                        child: Text(groupNameLabel,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
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
                  ...widget.moduleInfo.module.sitesGroup!.map((group) =>
                      TableRow(
                        children: [
                          Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(group.sitesGroupName ?? ''),
                          ),
                          Container(
                            height: 48,
                            alignment: Alignment.centerLeft,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child:
                                const Text('0'), // TODO: Implement actual count
                          ),
                          Container(
                            height: 48,
                            alignment: Alignment.centerLeft,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child:
                                const Text('0'), // TODO: Implement actual count
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
                        3: FixedColumnWidth(80), // Altitude column
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
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(altitudeLabel,
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
                                Container(
                                  height: 48,
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
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
