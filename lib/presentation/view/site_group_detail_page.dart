import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gn_mobile_monitoring/core/helpers/form_config_parser.dart';
import 'package:gn_mobile_monitoring/core/helpers/value_formatter.dart';
import 'package:gn_mobile_monitoring/core/theme/app_colors.dart';
import 'package:gn_mobile_monitoring/data/data_module.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/domain/model/site_complement.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';
import 'package:gn_mobile_monitoring/presentation/model/module_info.dart';
import 'package:gn_mobile_monitoring/presentation/view/map/gen_map.dart';
import 'package:gn_mobile_monitoring/presentation/view/site/site_detail_page.dart';
import 'package:gn_mobile_monitoring/presentation/view/site/site_form_page.dart';
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
  Position? _userPosition;
  bool _sortByDistance = true; // true = par distance, false = alphabétique

  @override
  void initState() {
    super.initState();
    // Actualiser les données à l’ouverture de la page
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(siteGroupDetailViewModelProvider(widget.siteGroup).notifier)
          .refresh();
      _loadUserLocation();
    });
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

  /// Calcule la distance entre la position de l'utilisateur et un site
  double? _calculateDistance(BaseSite site) {
    if (_userPosition == null || site.geom == null) {
      return null;
    }

    try {
      // Parser la géométrie GeoJSON
      final geomData = jsonDecode(site.geom!);
      double? siteLat;
      double? siteLon;

      // Extraire les coordonnées selon le type de géométrie
      if (geomData is Map<String, dynamic>) {
        final type = geomData['type'];
        final coordinates = geomData['coordinates'];

        if (type == 'Point' && coordinates is List && coordinates.length >= 2) {
          // Format GeoJSON: [longitude, latitude]
          siteLon = coordinates[0].toDouble();
          siteLat = coordinates[1].toDouble();
        }
      }

      if (siteLat == null || siteLon == null) {
        return null;
      }

      // Calculer la distance en mètres
      return Geolocator.distanceBetween(
        _userPosition!.latitude,
        _userPosition!.longitude,
        siteLat,
        siteLon,
      );
    } catch (e) {
      debugPrint(
          'Erreur lors du calcul de la distance pour le site ${site.idBaseSite}: $e');
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

          // Propriétés supplémentaires du groupe
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                              widget.moduleInfo.module.complement?.configuration
                                      ?.sitesGroup?.label ??
                                  'Propriétés du groupe',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
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
                Row(
                  children: [
                    Text(
                      widget.moduleInfo.module.complement?.configuration?.site
                              ?.labelList ??
                          widget.moduleInfo.module.complement?.configuration
                              ?.site?.label ??
                          'Sites associés',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () {
                        final siteConfig =
                            module.complement?.configuration?.site;
                        if (siteConfig != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SiteFormPage(
                                siteConfig: siteConfig,
                                customConfig:
                                    module.complement?.configuration?.custom,
                                moduleId: module.id,
                                moduleInfo: widget.moduleInfo,
                                siteGroup: widget.siteGroup,
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Configuration de site non disponible'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.add_circle),
                      tooltip: 'Ajouter ${(module.complement?.configuration?.site?.genre == 'F') ? 'une' : 'un'} ${module.complement?.configuration?.site?.label ?? 'site'}',
                    ),
                  ],
                ),
                // Bouton pour basculer entre tri par distance et alphabétique
                if (_userPosition != null)
                  ActionChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _sortByDistance
                              ? Icons.sort_by_alpha
                              : Icons.location_on,
                          size: 16,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _sortByDistance ? 'Alphabétique' : 'Distance',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    side: BorderSide.none,
                    backgroundColor: AppColors.primary,
                    onPressed: () {
                      setState(() {
                        _sortByDistance = !_sortByDistance;
                      });
                    },
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
                siteConfig,
                customConfig,
                parsedSiteConfig,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => Scaffold(
                appBar: AppBar(
                  title: const Text('Carte des sites'),
                ),
                body: sitesState.when(
                  data: (sites) => GeometriesMapWidget(
                    geojsonData: _convertSitesToGeoJSON(sites),
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
            ),
          );
        },
        child: const Icon(Icons.map),
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

    // Trier les sites selon le mode sélectionné
    List<BaseSite> sortedSites = List.from(sites);

    if (_sortByDistance && _userPosition != null) {
      // Tri par distance
      sortedSites.sort((a, b) {
        final distanceA = _calculateDistance(a);
        final distanceB = _calculateDistance(b);

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
      // Tri alphabétique par le premier champ de display_properties
      final List<String>? displayProperties =
          siteConfig?.displayList ?? siteConfig?.displayProperties;

      if (displayProperties != null && displayProperties.isNotEmpty) {
        final firstProperty = displayProperties.first;

        sortedSites.sort((a, b) {
          // Récupérer les valeurs pour le tri
          String valueA = _getSitePropertyValue(
              a, firstProperty, siteConfig, customConfig, parsedSiteConfig);
          String valueB = _getSitePropertyValue(
              b, firstProperty, siteConfig, customConfig, parsedSiteConfig);

          return valueA.compareTo(valueB);
        });
      }
    }

    return ListView.builder(
      itemCount: sortedSites.length,
      itemBuilder: (context, index) {
        final site = sortedSites[index];
        // Trouver l'index original pour gérer l'expansion
        final originalIndex = sites.indexOf(site);
        final isExpanded = _expandedPanelIndex == originalIndex;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: ExpansionTile(
            key: ValueKey('expansion_${originalIndex}_$_expandedPanelIndex'),
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
            title: Row(
              children: [
                Expanded(
                  child: FutureBuilder<SiteComplement?>(
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
                        siteData['base_site_description'] =
                            site.baseSiteDescription;
                      }
                      if (site.firstUseDate != null) {
                        siteData['first_use_date'] =
                            site.firstUseDate!.toString();
                      }

                      // Ajouter les données du complément si disponibles
                      if (snapshot.hasData && snapshot.data?.data != null) {
                        try {
                          Map<String, dynamic> complementData = {};
                          if (snapshot.data!.data is String) {
                            complementData = Map<String, dynamic>.from(
                                jsonDecode(snapshot.data!.data as String));
                          } else {
                            complementData = Map<String, dynamic>.from(
                                snapshot.data!.data as Map);
                          }
                          siteData.addAll(complementData);
                        } catch (e) {
                          debugPrint(
                              'Erreur lors du décodage des données complémentaires: $e');
                        }
                      }

                      // Récupérer le premier champ de display_list
                      final List<String>? displayProperties =
                          siteConfig?.displayList ??
                              siteConfig?.displayProperties;

                      String displayText = site.baseSiteName ?? 'Site sans nom';

                      if (displayProperties != null &&
                          displayProperties.isNotEmpty) {
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
                ),
                // Afficher la distance à droite
                if (_userPosition != null && site.geom != null)
                  _buildDistanceBadge(site),
              ],
            ),
            initiallyExpanded: isExpanded,
            onExpansionChanged: (bool expanded) {
              setState(() {
                if (expanded) {
                  _expandedPanelIndex = originalIndex;
                } else if (_expandedPanelIndex == originalIndex) {
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

  /// Convert list of BaseSite to GeoJSON format expected by GeometriesMapWidget
  String? _convertSitesToGeoJSON(List<BaseSite> sites) {
    if (sites.isEmpty) return null;

    final List<Map<String, dynamic>> geoJsonFeatures = [];

    for (final site in sites) {
      if (site.geom == null || site.geom!.isEmpty) continue;

      try {
        // Parse the geometry JSON string
        final Map<String, dynamic> geometry = jsonDecode(site.geom!);

        // Create a feature with site information
        final feature = {
          'id': site.idBaseSite,
          'name': site.baseSiteName ?? 'Site ${site.idBaseSite}',
          'description': site.baseSiteDescription ?? '',
          'geom': geometry,
        };

        geoJsonFeatures.add(feature);
      } catch (e) {
        print('Erreur parsing geometry pour site ${site.idBaseSite}: $e');
        // Skip this site if geometry parsing fails
      }
    }

    if (geoJsonFeatures.isEmpty) return null;

    return jsonEncode(geoJsonFeatures);
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

  /// Récupère la valeur d'une propriété d'un site pour le tri (synchrone, utilise uniquement les données de base)
  String _getSitePropertyValue(
    BaseSite site,
    String propertyKey,
    ObjectConfig? siteConfig,
    CustomConfig? customConfig,
    Map<String, dynamic> parsedSiteConfig,
  ) {
    // Construire les données du site (uniquement les champs de base pour le tri synchrone)
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

    // Récupérer la valeur
    if (siteData.containsKey(propertyKey)) {
      final rawValue = siteData[propertyKey];
      return ValueFormatter.format(rawValue);
    }

    // Valeur par défaut si la propriété n'existe pas dans les données de base
    // (les compléments sont asynchrones et ne peuvent pas être utilisés pour le tri)
    return '';
  }

  /// Construit le badge de distance pour le header
  Widget _buildDistanceBadge(BaseSite site) {
    final distance = _calculateDistance(site);

    if (distance == null) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(left: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.blue.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.location_on,
            color: Colors.blue,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            _formatDistance(distance),
            style: const TextStyle(
              fontSize: 12,
              color: Colors.blue,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
