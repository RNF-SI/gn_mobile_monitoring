import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/core/helpers/form_config_parser.dart';
import 'package:gn_mobile_monitoring/core/helpers/value_formatter.dart';
import 'package:gn_mobile_monitoring/data/data_module.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/domain/model/site_complement.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';
import 'package:gn_mobile_monitoring/presentation/model/module_info.dart';
import 'package:gn_mobile_monitoring/presentation/view/map/gen_map.dart';
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
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Fil d'Ariane pour la navigation
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 12.0),
                    child: BreadcrumbNavigation(
                      items: [
                        BreadcrumbItem(
                          label: 'Module',
                          value:
                              widget.moduleInfo.module.moduleLabel ?? 'Module',
                          onTap: () {
                            Navigator.of(context)
                                .pop(); // Retour à la page précédente
                          },
                        ),
                        BreadcrumbItem(
                          label: widget.moduleInfo.module.complement
                                  ?.configuration?.sitesGroup?.label ??
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
                        _buildPropertyRow(groupNameLabel,
                            widget.siteGroup.sitesGroupName ?? ''),
                        _buildPropertyRow(groupCodeLabel,
                            widget.siteGroup.sitesGroupCode ?? ''),
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
                child: Text(
                  widget.moduleInfo.module.complement?.configuration?.site
                          ?.labelList ??
                      widget.moduleInfo.module.complement?.configuration?.site
                          ?.label ??
                      'Sites associés',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
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
                    siteConfig,
                    customConfig,
                    parsedSiteConfig,
                  ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
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
          // Bouton carto en bas à droite
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const GeometriesMapWidget(
                          geojsonData: null)), // replace null by geojson data
                );
              },
              child: const Icon(Icons.map),
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
    ObjectConfig? siteConfig,
    CustomConfig? customConfig,
    Map<String, dynamic> parsedSiteConfig,
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
            title: FutureBuilder<SiteComplement?>(
              future: _getSiteComplement(site.idBaseSite),
              builder: (context, snapshot) {
                // Construire les données du site (base + complément)
                final Map<String, dynamic> siteData = {};

                // Ajouter les champs de base
                if (site.baseSiteCode != null) {
                  siteData['base_site_code'] = site.baseSiteCode;
                }
                if (site.baseSiteName != null) {
                  siteData['base_site_name'] = site.baseSiteName;
                }
                if (site.baseSiteDescription != null) {
                  siteData['base_site_description'] = site.baseSiteDescription;
                }
                if (site.firstUseDate != null) {
                  siteData['first_use_date'] = site.firstUseDate!.toString();
                }

                // Ajouter les données du complément si disponibles
                if (snapshot.hasData && snapshot.data?.data != null) {
                  try {
                    Map<String, dynamic> complementData = {};
                    if (snapshot.data!.data is String) {
                      complementData = Map<String, dynamic>.from(
                          jsonDecode(snapshot.data!.data as String));
                    } else {
                      complementData =
                          Map<String, dynamic>.from(snapshot.data!.data as Map);
                    }
                    siteData.addAll(complementData);
                  } catch (e) {
                    debugPrint(
                        'Erreur lors du décodage des données complémentaires: $e');
                  }
                }

                // Récupérer le premier champ de display_list
                final List<String>? displayProperties =
                    siteConfig?.displayList ?? siteConfig?.displayProperties;

                String displayText = site.baseSiteName ?? 'Site sans nom';

                if (displayProperties != null && displayProperties.isNotEmpty) {
                  final firstProperty = displayProperties.first;
                  if (siteData.containsKey(firstProperty)) {
                    final rawValue = siteData[firstProperty];
                    displayText = ValueFormatter.format(rawValue);
                  }
                }

                return Text(
                  displayText,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                );
              },
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
              _buildSiteProperties(
                  site, siteConfig, customConfig, parsedSiteConfig),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSiteProperties(
    BaseSite site,
    ObjectConfig? siteConfig,
    CustomConfig? customConfig,
    Map<String, dynamic> parsedSiteConfig,
  ) {
    // Récupérer les données complémentaires
    return FutureBuilder<SiteComplement?>(
      future: _getSiteComplement(site.idBaseSite),
      builder: (context, snapshot) {
        // Construire les données du site (base + complément)
        final Map<String, dynamic> siteData = {};

        // Ajouter les champs de base
        if (site.baseSiteCode != null) {
          siteData['base_site_code'] = site.baseSiteCode;
        }
        if (site.baseSiteName != null) {
          siteData['base_site_name'] = site.baseSiteName;
        }
        if (site.baseSiteDescription != null) {
          siteData['base_site_description'] = site.baseSiteDescription;
        }
        if (site.firstUseDate != null) {
          siteData['first_use_date'] = site.firstUseDate!.toString();
        }

        // Ajouter les données du complément si disponibles
        if (snapshot.hasData && snapshot.data?.data != null) {
          try {
            Map<String, dynamic> complementData = {};
            if (snapshot.data!.data is String) {
              complementData = Map<String, dynamic>.from(
                  jsonDecode(snapshot.data!.data as String));
            } else {
              complementData =
                  Map<String, dynamic>.from(snapshot.data!.data as Map);
            }
            siteData.addAll(complementData);
          } catch (e) {
            debugPrint(
                'Erreur lors du décodage des données complémentaires: $e');
          }
        }

        // Si pas de données, afficher un message
        if (siteData.isEmpty) {
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

        // Déterminer les colonnes à afficher (uniquement display_list)
        List<String>? displayProperties =
            siteConfig?.displayList ?? siteConfig?.displayProperties;

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

        // Exclure le premier item de display_list (déjà affiché dans le title)
        final propertiesToShow = displayProperties.length > 1
            ? displayProperties.sublist(1)
            : <String>[];

        // Si plus rien à afficher après exclusion du premier item
        if (propertiesToShow.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Aucune information supplémentaire à afficher',
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),
          );
        }

        // Filtrer les propriétés meta et ne garder que celles présentes dans les données
        final filteredProperties = propertiesToShow.where((key) {
          return !key.startsWith('meta_') && siteData.containsKey(key);
        }).toList();

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: filteredProperties.map((propertyKey) {
              final rawValue = siteData[propertyKey];

              // Obtenir le label depuis la configuration
              String label = propertyKey;
              if (parsedSiteConfig.containsKey(propertyKey)) {
                label = parsedSiteConfig[propertyKey]['attribut_label'] ??
                    propertyKey;
              }

              // Formater la valeur
              String displayValue = ValueFormatter.format(rawValue);

              return _buildPropertyRow(label, displayValue);
            }).toList(),
          ),
        );
      },
    );
  }

  Future<SiteComplement?> _getSiteComplement(int siteId) async {
    try {
      final sitesDatabase = ref.read(siteDatabaseProvider);
      final allComplements = await sitesDatabase.getAllSiteComplements();
      final complement = allComplements
          .where(
            (complement) => complement.idBaseSite == siteId,
          )
          .firstOrNull;
      return complement;
    } catch (e) {
      debugPrint('Erreur lors de la récupération du complément: $e');
      return null;
    }
  }
}
