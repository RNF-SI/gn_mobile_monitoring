import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/core/helpers/form_config_parser.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';
import 'package:gn_mobile_monitoring/presentation/model/module_info.dart';
import 'package:gn_mobile_monitoring/presentation/view/site/site_detail_page.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/site_group_detail_viewmodel.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/breadcrumb_navigation.dart';

class SiteGroupDetailPage extends ConsumerStatefulWidget {
  final SiteGroup siteGroup;
  final ModuleInfo moduleInfo;

  const SiteGroupDetailPage({
    super.key,
    required this.siteGroup,
    required this.moduleInfo,
  });

  @override
  ConsumerState<SiteGroupDetailPage> createState() =>
      _SiteGroupDetailPageState();
}

class _SiteGroupDetailPageState extends ConsumerState<SiteGroupDetailPage> {
  int? _expandedPanelIndex;

  @override
  void initState() {
    super.initState();
    // Refresh data when page is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(siteGroupDetailViewModelProvider(widget.siteGroup).notifier)
          .refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final sitesState =
        ref.watch(siteGroupDetailViewModelProvider(widget.siteGroup));

    // Récupérer la configuration pour personnaliser les libellés
    final module = widget.moduleInfo.module;

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
            '${widget.moduleInfo.module.complement?.configuration?.sitesGroup?.label ?? 'Groupe'}: ${widget.siteGroup.sitesGroupName ?? 'Détail du groupe'}'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fil d'Ariane pour la navigation
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                child: BreadcrumbNavigation(
                  items: [
                    BreadcrumbItem(
                      label: 'Module',
                      value: widget.moduleInfo.module.moduleLabel ?? 'Module',
                      onTap: () {
                        Navigator.of(context)
                            .pop(); // Retour à la page précédente
                      },
                    ),
                    BreadcrumbItem(
                      label: widget.moduleInfo.module.complement?.configuration
                              ?.sitesGroup?.label ??
                          'Groupe',
                      value: widget.siteGroup.sitesGroupName ??
                          widget.siteGroup.sitesGroupCode ??
                          'Groupe',
                    ),
                  ],
                ),
              ),
            ),
          ),
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
                        widget.moduleInfo.module.complement?.configuration
                                ?.sitesGroup?.label ??
                            'Propriétés du groupe',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    _buildPropertyRow(
                        groupNameLabel, widget.siteGroup.sitesGroupName ?? ''),
                    _buildPropertyRow(
                        groupCodeLabel, widget.siteGroup.sitesGroupCode ?? ''),
                    if (widget.siteGroup.sitesGroupDescription != null &&
                        widget.siteGroup.sitesGroupDescription!.isNotEmpty)
                      _buildPropertyRow(groupDescriptionLabel,
                          widget.siteGroup.sitesGroupDescription!),
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
                  widget.moduleInfo.module.complement?.configuration?.site
                          ?.labelList ??
                      widget.moduleInfo.module.complement?.configuration?.site
                          ?.label ??
                      'Sites associés',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          // Sites Expansion Panel List
          Expanded(
            child: sitesState.when(
              data: (sites) => _buildSitesExpansionPanelList(
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

  Widget _buildSitesExpansionPanelList(
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

    return ListView.builder(
      itemCount: sites.length,
      itemBuilder: (context, index) {
        final site = sites[index];
        final isExpanded = _expandedPanelIndex == index;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: ExpansionTile(
            key: ValueKey('expansion_${index}_$_expandedPanelIndex'),
            shape: const RoundedRectangleBorder(
              side: BorderSide.none,
            ),
            collapsedShape: const RoundedRectangleBorder(
              side: BorderSide.none,
            ),
            tilePadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            childrenPadding: EdgeInsets.zero,
            leading: IconButton(
              icon: const Icon(Icons.visibility, size: 20),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SiteDetailPage(
                      site: site,
                      moduleInfo: widget.moduleInfo,
                      fromSiteGroup: widget.siteGroup,
                    ),
                  ),
                );
              },
              tooltip: 'Voir les détails',
            ),
            title: Text(
              site.baseSiteName ?? 'Site sans nom',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            initiallyExpanded: isExpanded,
            onExpansionChanged: (bool expanded) {
              setState(() {
                if (expanded) {
                  _expandedPanelIndex = index;
                } else if (_expandedPanelIndex == index) {
                  _expandedPanelIndex = null;
                }
              });
            },
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: site.baseSiteDescription != null &&
                        site.baseSiteDescription!.isNotEmpty
                    ? Text(
                        site.baseSiteDescription!,
                        style: const TextStyle(fontSize: 14),
                      )
                    : const Text(
                        'Aucune description disponible',
                        style: TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
