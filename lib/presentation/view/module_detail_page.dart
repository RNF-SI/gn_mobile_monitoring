import 'package:flutter/material.dart';
import 'package:gn_mobile_monitoring/presentation/model/moduleInfo.dart';

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

  @override
  void initState() {
    super.initState();
    _childrenTypes = widget.moduleInfo.module.complement!.configuration?.module
            ?.childrenTypes ??
        [];
    _tabController = TabController(length: _childrenTypes.length, vsync: this);
  }

  @override
  void dispose() {
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
                    _buildPropertyRow(
                        'Nom', widget.moduleInfo.module.moduleLabel ?? ''),
                    _buildPropertyRow('Description',
                        widget.moduleInfo.module.moduleDesc ?? ''),
                    _buildPropertyRow('Jeu de données',
                        'Contact aléatoire tous règnes confondus'),
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
            const TableRow(
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Text('Action',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('Nom du groupe',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('Sites',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Padding(
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
    final siteConfig = widget.moduleInfo.module.complement?.configuration?.site;
    final baseSiteNameConfig = siteConfig?.generic?['base_site_name'];
    final baseSiteNameLabel = baseSiteNameConfig?.attributLabel ?? 'Nom';

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
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
                  padding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Text('Action',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(baseSiteNameLabel,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('Code',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('Altitude',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            if (widget.moduleInfo.module.sites != null)
              ...widget.moduleInfo.module.sites!.map((site) => TableRow(
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
                        child: Text(site.baseSiteName ?? ''),
                      ),
                      Container(
                        height: 48,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(site.baseSiteCode ?? ''),
                      ),
                      Container(
                        height: 48,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          site.altitudeMin != null && site.altitudeMax != null
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
