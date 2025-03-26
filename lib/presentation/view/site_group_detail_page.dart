import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/core/helpers/form_config_parser.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';
import 'package:gn_mobile_monitoring/presentation/model/module_info.dart';
import 'package:gn_mobile_monitoring/presentation/view/site_detail_page.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/site_group_detail_viewmodel.dart';

class SiteGroupDetailPage extends ConsumerWidget {
  final SiteGroup siteGroup;
  final ModuleInfo moduleInfo;

  const SiteGroupDetailPage({
    Key? key,
    required this.siteGroup,
    required this.moduleInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sitesState = ref.watch(siteGroupDetailViewModelProvider(siteGroup));

    // Récupérer la configuration pour personnaliser les libellés
    final module = moduleInfo.module;

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

    // Configuration des groupes de sites pour les libellés
    final sitesGroupConfig = module.complement?.configuration?.sitesGroup;
    Map<String, dynamic> parsedGroupConfig = {};

    if (sitesGroupConfig != null) {
      parsedGroupConfig = FormConfigParser.generateUnifiedSchema(
          sitesGroupConfig, customConfig);
    }

    final String groupNameLabel =
        parsedGroupConfig.containsKey('sites_group_name')
            ? parsedGroupConfig['sites_group_name']['attribut_label'] ??
                'Nom du groupe'
            : 'Nom du groupe';

    final String groupCodeLabel =
        parsedGroupConfig.containsKey('sites_group_code')
            ? parsedGroupConfig['sites_group_code']['attribut_label'] ??
                'Code du groupe'
            : 'Code du groupe';

    final String groupDescriptionLabel =
        parsedGroupConfig.containsKey('sites_group_description')
            ? parsedGroupConfig['sites_group_description']['attribut_label'] ??
                'Description'
            : 'Description';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${moduleInfo.module.complement?.configuration?.sitesGroup?.label ?? 'Groupe'}: ${siteGroup.sitesGroupName ?? 'Détail du groupe'}'
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Group Properties Card
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      moduleInfo.module.complement?.configuration?.sitesGroup?.label ?? 'Propriétés du groupe',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                    ),
                    const SizedBox(height: 8),
                    _buildPropertyRow(
                        groupNameLabel, siteGroup.sitesGroupName ?? ''),
                    _buildPropertyRow(
                        groupCodeLabel, siteGroup.sitesGroupCode ?? ''),
                    if (siteGroup.sitesGroupDescription != null &&
                        siteGroup.sitesGroupDescription!.isNotEmpty)
                      _buildPropertyRow(groupDescriptionLabel,
                          siteGroup.sitesGroupDescription!),
                  ],
                ),
              ),
            ),
          ),

          // Sites Table Section
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  moduleInfo.module.complement?.configuration?.site?.labelList ?? 
                  moduleInfo.module.complement?.configuration?.site?.label ?? 
                  'Sites associés',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          // Sites Table
          Expanded(
            child: sitesState.when(
              data: (sites) => _buildSitesTable(
                sites,
                context,
                baseSiteNameLabel,
                baseSiteCodeLabel,
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text(
                  'Erreur lors du chargement des sites: $error',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),
          ),
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

  Widget _buildSitesTable(
    List<BaseSite> sites,
    BuildContext context,
    String baseSiteNameLabel,
    String baseSiteCodeLabel,
  ) {
    if (sites.isEmpty) {
      return const Center(
        child: Text('Aucun site associé à ce groupe'),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Table(
          columnWidths: const {
            0: FixedColumnWidth(80), // Action column
            1: FlexColumnWidth(80), // Name column
            2: FixedColumnWidth(100), // Code column
            3: FixedColumnWidth(120), // Description column
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(baseSiteCodeLabel,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('Description',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            ...sites.map((site) => TableRow(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                                moduleInfo: moduleInfo,
                              ),
                            ),
                          );
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 36,
                          minHeight: 36,
                        ),
                        tooltip: 'Voir les détails',
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
                        site.baseSiteDescription != null &&
                                site.baseSiteDescription!.isNotEmpty
                            ? site.baseSiteDescription!.length > 25
                                ? '${site.baseSiteDescription!.substring(0, 22)}...'
                                : site.baseSiteDescription!
                            : '-',
                        overflow: TextOverflow.ellipsis,
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
