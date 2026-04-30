import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/core/helpers/form_config_parser.dart';
import 'package:gn_mobile_monitoring/core/helpers/value_formatter.dart';
import 'package:gn_mobile_monitoring/core/theme/app_colors.dart';
import 'package:gn_mobile_monitoring/domain/domain_module.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/map_feature.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';
import 'package:gn_mobile_monitoring/presentation/model/module_info.dart';
import 'package:gn_mobile_monitoring/presentation/state/map_state.dart';
import 'package:gn_mobile_monitoring/presentation/view/site/site_detail_page.dart';
import 'package:gn_mobile_monitoring/presentation/view/site/site_form_page.dart';
import 'package:gn_mobile_monitoring/presentation/view/site_group_detail_page.dart';
import 'package:gn_mobile_monitoring/presentation/view/visit/visit_form_page.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/map_viewmodel.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/map/compass_widget.dart';
import 'package:latlong2/latlong.dart';

// ---------------------------
// Widget Geometries (Carte avec géométries)
// ---------------------------
class GeometriesMapWidget extends ConsumerStatefulWidget {
  final String? geojsonData;
  final bool showAddMarkerButton;
  final List<String>? displayList;
  final ObjectConfig? siteConfig;
  final CustomConfig? customConfig;
  final ModuleInfo? moduleInfo;
  final SiteGroup? siteGroup;

  const GeometriesMapWidget({
    super.key,
    required this.geojsonData,
    this.showAddMarkerButton = false,
    this.displayList,
    this.siteConfig,
    this.customConfig,
    this.moduleInfo,
    this.siteGroup,
  });

  @override
  ConsumerState<GeometriesMapWidget> createState() =>
      _GeometriesMapWidgetState();
}

class _GeometriesMapWidgetState extends ConsumerState<GeometriesMapWidget> {
  late final MapController mapController;
  List<Marker> userMarkers = [];
  bool _hasInitiallyFitBounds = false;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  /// Retourne les paramètres pour le ViewModel
  MapViewModelParams get _viewModelParams => MapViewModelParams(
        geoJsonData: widget.geojsonData,
        displayList: widget.displayList,
        siteConfig: widget.siteConfig,
        customConfig: widget.customConfig,
        moduleInfo: widget.moduleInfo,
        siteGroup: widget.siteGroup,
      );

  @override
  Widget build(BuildContext context) {
    final mapState = ref.watch(mapViewModelProvider(_viewModelParams));
    final viewModel = ref.read(mapViewModelProvider(_viewModelParams).notifier);

    // Fit bounds when features are loaded and not yet fitted
    if (!_hasInitiallyFitBounds && mapState.hasFeatures && !mapState.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _fitBoundsToFeatures(viewModel);
        _hasInitiallyFitBounds = true;
      });
    }

    // Build markers from features
    final siteMarkers = _buildSiteMarkers(mapState);
    final geometryLabelMarkers = _buildGeometryLabelMarkers(mapState, viewModel);
    final userLocationMarkers = _buildUserLocationMarkers(mapState);

    // Build polylines and polygons
    final polylines = _buildPolylines(mapState);
    final polygons = _buildPolygons(mapState);

    // Build accuracy circle
    final accuracyCircle = mapState.userPosition != null && mapState.userAccuracy != null
        ? CircleMarker(
            point: mapState.userPosition!,
            radius: mapState.userAccuracy!,
            useRadiusInMeter: true,
            color: Colors.blue.withValues(alpha: 0.15),
            borderStrokeWidth: 1.5,
            borderColor: Colors.blue,
          )
        : null;

    final initialCenter = mapState.userPosition ??
        viewModel.computeCentroid() ??
        const LatLng(48.85, 2.35);

    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  FlutterMap(
                    mapController: mapController,
                    options: MapOptions(
                      initialCenter: initialCenter,
                      initialZoom: mapState.userPosition != null ? 15 : 12,
                      onPointerDown: (_, __) {
                        viewModel.onUserMovedMap();
                      },
                      onTap: (tapPosition, point) {
                        _handleMapTap(context, point, mapState, viewModel);
                      },
                    ),
                    children: [
                      if (mapState.selectedLayer != null)
                        TileLayer(
                          urlTemplate: mapState.selectedLayer!.urlTemplate,
                          userAgentPackageName: 'com.example.gn_mobile_monitoring',
                        ),
                      if (accuracyCircle != null)
                        CircleLayer(circles: [accuracyCircle]),
                      PolylineLayer(polylines: polylines),
                      PolygonLayer(polygons: polygons),
                      MarkerClusterLayerWidget(
                        options: MarkerClusterLayerOptions(
                          maxClusterRadius: 80,
                          size: const Size(50, 50),
                          markers: siteMarkers,
                          builder: (context, markers) {
                            return Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.3),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  markers.length.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            );
                          },
                          onMarkerTap: (marker) {
                            final feature = _findFeatureForMarker(marker.point, mapState);
                            if (feature != null) {
                              _showFeaturePopup(context, marker.point, feature);
                            }
                          },
                          onClusterTap: (cluster) {
                            final bounds = LatLngBounds.fromPoints(
                              cluster.markers.map((m) => m.point).toList(),
                            );
                            mapController.fitCamera(
                              CameraFit.bounds(
                                bounds: bounds,
                                padding: const EdgeInsets.all(50),
                              ),
                            );
                          },
                        ),
                      ),
                      MarkerLayer(markers: userLocationMarkers),
                      MarkerLayer(markers: geometryLabelMarkers),
                    ],
                  ),
                  if (mapState.selectedLayer != null)
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        color: Colors.white70,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 2),
                        child: Text(
                          mapState.selectedLayer?.attribution ?? '',
                          style: const TextStyle(fontSize: 10),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        // Layer selection button
        if (mapState.tileLayers.isNotEmpty)
          Positioned(
            top: 16,
            right: 16,
            child: _buildLayerButton(context, mapState, viewModel),
          ),
        // Add marker button
        if (widget.showAddMarkerButton)
          Positioned(
            bottom: 130,
            right: 20,
            child: FloatingActionButton(
              backgroundColor: AppColors.dark,
              foregroundColor: Colors.white,
              onPressed: () => _addMarkerAtCenter(viewModel),
              child: const Icon(Icons.add_location),
            ),
          ),
        // Center on user button
        if (mapState.userPosition != null)
          Positioned(
            bottom: 60,
            right: 20,
            child: FloatingActionButton(
              backgroundColor: AppColors.dark,
              foregroundColor: Colors.white,
              child: const Icon(Icons.my_location),
              onPressed: () {
                mapController.move(mapState.userPosition!, 17);
                viewModel.resetUserMovedMap();
              },
            ),
          ),
        CompassWidget(mapController: mapController),
      ],
    );
  }

  /// Fit map bounds to all features
  void _fitBoundsToFeatures(MapViewModel viewModel) {
    final bounds = viewModel.computeGlobalBounds();
    if (bounds != null) {
      mapController.fitCamera(
        CameraFit.bounds(
          bounds: LatLngBounds.fromPoints([bounds.southWest, bounds.northEast]),
          padding: const EdgeInsets.all(40),
        ),
      );
    }
  }

  /// Build site markers from point features
  List<Marker> _buildSiteMarkers(MapState mapState) {
    return mapState.pointFeatures.map((feature) {
      String? labelText;
      if (widget.displayList != null &&
          widget.displayList!.isNotEmpty &&
          feature.properties.containsKey(widget.displayList!.first)) {
        final firstProperty = widget.displayList!.first;
        final rawValue = feature.properties[firstProperty];
        labelText = ValueFormatter.format(rawValue);
      }

      return Marker(
        point: feature.point,
        width: 60,
        height: 60,
        rotate: true,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            const Icon(Icons.location_on, color: Colors.red, size: 50),
            if (labelText != null && labelText.isNotEmpty)
              Positioned(
                bottom: 55,
                child: _buildLabelContainer(labelText),
              ),
          ],
        ),
      );
    }).toList();
  }

  /// Build geometry label markers for polylines and polygons
  List<Marker> _buildGeometryLabelMarkers(MapState mapState, MapViewModel viewModel) {
    final markers = <Marker>[];
    final mapGeometryService = ref.read(mapGeometryServiceProvider);

    for (final feature in [...mapState.polylineFeatures, ...mapState.polygonFeatures]) {
      String? labelText;
      if (widget.displayList != null &&
          widget.displayList!.isNotEmpty &&
          feature.featureProperties.containsKey(widget.displayList!.first)) {
        final firstProperty = widget.displayList!.first;
        final rawValue = feature.featureProperties[firstProperty];
        labelText = ValueFormatter.format(rawValue);
      }

      if (labelText != null && labelText.isNotEmpty) {
        final centroid = mapGeometryService.calculateCentroid(feature.allPoints);

        final textPainter = TextPainter(
          text: TextSpan(
            text: labelText,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          maxLines: 2,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout(maxWidth: 150);
        final labelHeight = (textPainter.height + 8).clamp(30.0, 60.0);

        markers.add(
          Marker(
            point: centroid,
            width: 150,
            height: labelHeight,
            rotate: true,
            child: _buildLabelContainer(labelText),
          ),
        );
      }
    }

    return markers;
  }

  /// Build user location markers
  List<Marker> _buildUserLocationMarkers(MapState mapState) {
    if (mapState.userPosition == null) return [];

    return [
      Marker(
        point: mapState.userPosition!,
        width: 30,
        height: 30,
        child: const Icon(Icons.my_location, color: Colors.blue, size: 25),
      ),
    ];
  }

  /// Build polylines from features
  List<Polyline> _buildPolylines(MapState mapState) {
    return mapState.polylineFeatures
        .map((feature) => Polyline(
              points: feature.points,
              strokeWidth: 4,
              color: Colors.blue,
            ))
        .toList();
  }

  /// Build polygons from features
  List<Polygon> _buildPolygons(MapState mapState) {
    return mapState.polygonFeatures
        .map((feature) => Polygon(
              points: feature.points,
              color: Colors.green.withValues(alpha: 0.3),
              borderColor: Colors.green,
              borderStrokeWidth: 3,
            ))
        .toList();
  }

  /// Build label container widget
  Widget _buildLabelContainer(String text) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 150,
        minWidth: 40,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
      ),
    );
  }

  /// Build layer selection button
  Widget _buildLayerButton(BuildContext context, MapState mapState, MapViewModel viewModel) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(8),
      color: AppColors.dark,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Choisir une couche',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...mapState.tileLayers.map((layer) {
                    final isSelected = mapState.selectedLayer == layer;
                    return ListTile(
                      title: Text(layer.name),
                      leading: Icon(
                        isSelected
                            ? Icons.check_circle
                            : Icons.circle_outlined,
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      ),
                      onTap: () {
                        viewModel.selectTileLayer(layer);
                        Navigator.pop(context);
                      },
                    );
                  }),
                ],
              ),
            ),
          );
        },
        child: const Padding(
          padding: EdgeInsets.all(12.0),
          child: Icon(
            Icons.layers,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  /// Handle map tap
  void _handleMapTap(BuildContext context, LatLng point, MapState mapState, MapViewModel viewModel) {
    final feature = viewModel.findFeatureAtPoint(point);
    if (feature != null) {
      _showFeaturePopup(context, point, feature);
    }
  }

  /// Find feature for a marker point
  MapFeature? _findFeatureForMarker(LatLng point, MapState mapState) {
    for (final feature in mapState.pointFeatures) {
      if (feature.point == point) {
        return feature;
      }
    }
    return null;
  }

  /// Add marker at map center
  void _addMarkerAtCenter(MapViewModel viewModel) {
    final center = mapController.camera.center;
    setState(() {
      userMarkers.clear();
      userMarkers.add(
        Marker(
          point: center,
          width: 40,
          height: 40,
          child: const Icon(
            Icons.location_on,
            color: Colors.blueGrey,
            size: 40,
          ),
        ),
      );
    });
  }

  /// Show popup for a feature
  void _showFeaturePopup(BuildContext context, LatLng point, MapFeature feature) {
    final properties = feature.featureProperties;

    // Generate unified schema for labels
    Map<String, dynamic> parsedSiteConfig = {};
    if (widget.siteConfig != null) {
      parsedSiteConfig = FormConfigParser.generateUnifiedSchema(
          widget.siteConfig!, widget.customConfig);
    }

    // Determine popup title
    String title = 'Point';
    if (widget.displayList != null &&
        widget.displayList!.isNotEmpty &&
        properties.containsKey(widget.displayList!.first)) {
      final firstProperty = widget.displayList!.first;
      final rawValue = properties[firstProperty];
      title = ValueFormatter.format(rawValue);
    } else {
      title = properties['name']?.toString() ??
          properties['base_site_name']?.toString() ??
          properties['sites_group_name']?.toString() ??
          'Point';
    }

    // Build display properties
    final displayProperties = <Widget>[];

    if (widget.displayList != null && widget.displayList!.isNotEmpty) {
      final propertiesToShow = widget.displayList!.length > 1
          ? widget.displayList!.sublist(1)
          : <String>[];

      for (final key in propertiesToShow) {
        if (properties.containsKey(key) && properties[key] != null) {
          final value = properties[key];
          if (value.toString().trim().isNotEmpty) {
            String label = key;
            if (parsedSiteConfig.containsKey(key)) {
              label = parsedSiteConfig[key]['attribut_label'] ?? key;
            } else {
              label = ValueFormatter.formatLabel(key);
            }

            displayProperties.add(_buildPropertyRow(
              label,
              ValueFormatter.format(value),
            ));
          }
        }
      }
    } else {
      final priorityKeys = [
        'name',
        'base_site_name',
        'sites_group_name',
        'base_site_code',
        'sites_group_code',
        'description',
        'base_site_description',
        'sites_group_description'
      ];

      for (final key in priorityKeys) {
        if (properties.containsKey(key) && properties[key] != null) {
          final value = properties[key];
          if (value.toString().trim().isNotEmpty) {
            displayProperties.add(_buildPropertyRow(
              ValueFormatter.formatLabel(key),
              ValueFormatter.format(value),
            ));
          }
        }
      }

      properties.forEach((key, value) {
        if (!priorityKeys.contains(key) &&
            !key.startsWith('meta_') &&
            !key.startsWith('id_') &&
            value != null &&
            value.toString().trim().isNotEmpty) {
          displayProperties.add(_buildPropertyRow(
            ValueFormatter.formatLabel(key),
            ValueFormatter.format(value),
          ));
        }
      });
    }

    if (displayProperties.isEmpty && widget.siteGroup != null) {
      displayProperties.add(
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Aucune information disponible',
            style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
          ),
        ),
      );
    }

    final siteId = properties['id'] as int?;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...displayProperties,
              // Show sites count for site groups
              if (widget.siteGroup == null && siteId != null)
                _buildSiteGroupSitesList(context, siteId),
              // Action buttons
              if (siteId != null && widget.moduleInfo != null)
                _buildActionButtons(context, properties, siteId),
            ],
          ),
        ),
      ),
    );
  }

  /// Build property row for popup
  Widget _buildPropertyRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  /// Build sites list for site group popup
  Widget _buildSiteGroupSitesList(BuildContext context, int siteId) {
    // Quand la popup est ouverte dans le contexte d'un module, filtrer les
    // sites par ce module (issue #169). Fallback sans filtre si la carte
    // est utilisée hors contexte module (moduleInfo null).
    final moduleId = widget.moduleInfo?.module.id;
    final sitesFuture = moduleId != null
        ? ref
            .read(getSitesBySiteGroupAndModuleUseCaseProvider)
            .execute(siteId, moduleId)
        : ref.read(getSitesBySiteGroupUseCaseProvider).execute(siteId);
    return FutureBuilder<List<BaseSite>>(
      future: sitesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Erreur lors du chargement des sites: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        final sites = snapshot.data ?? [];
        final sitesCount = sites.length;

        final siteConfig =
            widget.moduleInfo?.module.complement?.configuration?.site;
        final siteLabelSingular = (siteConfig?.label ?? 'site').toLowerCase();
        final siteLabelPlural =
            (siteConfig?.labelList ?? siteConfig?.label ?? 'sites').toLowerCase();
        final siteLabel = sitesCount > 1 ? siteLabelPlural : siteLabelSingular;

        if (sitesCount == 0) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Aucun $siteLabelSingular dans ce groupe',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.grey[600],
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Nombre de $siteLabel: $sitesCount',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Liste des $siteLabel :',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            sitesCount > 10
                ? _buildScrollableSitesList(sites)
                : _buildSimpleSitesList(sites),
          ],
        );
      },
    );
  }

  Widget _buildScrollableSitesList(List<BaseSite> sites) {
    final scrollController = ScrollController();
    return SizedBox(
      height: 200,
      child: Scrollbar(
        controller: scrollController,
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: sites.map((site) => _buildSiteListItem(site)).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildSimpleSitesList(List<BaseSite> sites) {
    return Column(
      children: sites.map((site) => _buildSiteListItem(site)).toList(),
    );
  }

  Widget _buildSiteListItem(BaseSite site) {
    final siteName = site.baseSiteName ?? site.baseSiteCode ?? 'Site ${site.idBaseSite}';
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, top: 4.0, bottom: 4.0),
      child: Row(
        children: [
          const Icon(Icons.location_on, size: 16, color: Colors.red),
          const SizedBox(width: 8),
          Expanded(
            child: Text(siteName, style: const TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  /// Build action buttons for popup
  Widget _buildActionButtons(
      BuildContext context, Map<String, dynamic> properties, int siteId) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () async {
                Navigator.of(context).pop();
                await _navigateToDetails(context, properties, siteId);
              },
              icon: const Icon(Icons.visibility),
              label: const Text('Voir les détails'),
            ),
          ),
          const SizedBox(height: 8),
          _buildAddButton(context, properties, siteId),
        ],
      ),
    );
  }

  Widget _buildAddButton(
      BuildContext context, Map<String, dynamic> properties, int siteId) {
    if (widget.siteGroup == null) {
      // Site group context - add site button
      if (widget.moduleInfo!.module.complement?.configuration?.site != null) {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () async {
              Navigator.of(context).pop();
              await _navigateToAddSite(context, properties);
            },
            icon: const Icon(Icons.add_circle_outline),
            label: Text(
              'Ajouter un ${widget.moduleInfo?.module.complement?.configuration?.site?.label ?? 'site'}',
            ),
          ),
        );
      }
    } else {
      // Site context - add visit button
      if (widget.moduleInfo!.module.complement?.configuration?.visit != null) {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () async {
              Navigator.of(context).pop();
              await _navigateToAddVisit(context, siteId);
            },
            icon: const Icon(Icons.add_circle_outline),
            label: Text(
              widget.moduleInfo?.module.complement?.configuration?.visit?.label ??
                  'Ajouter une visite',
            ),
          ),
        );
      }
    }
    return const SizedBox.shrink();
  }

  Future<void> _navigateToDetails(
      BuildContext context, Map<String, dynamic> properties, int siteId) async {
    if (widget.siteGroup == null) {
      // Navigate to site group details
      final groupId = properties['id'] as int?;
      if (groupId != null) {
        final getSiteGroupByIdUseCase = ref.read(getSiteGroupByIdUseCaseProvider);
        final group = await getSiteGroupByIdUseCase.execute(groupId);

        if (group != null && widget.moduleInfo != null && mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SiteGroupDetailPage(
                siteGroup: group,
                moduleInfo: widget.moduleInfo!,
              ),
            ),
          );
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Impossible de charger le groupe de sites'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else {
      // Navigate to site details
      final getSiteByIdUseCase = ref.read(getSiteByIdUseCaseProvider);
      final site = await getSiteByIdUseCase.execute(siteId);

      if (site != null && mounted) {
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
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Impossible de charger le site'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _navigateToAddSite(
      BuildContext context, Map<String, dynamic> properties) async {
    final groupId = properties['id'] as int?;
    if (groupId != null) {
      final getSiteGroupByIdUseCase = ref.read(getSiteGroupByIdUseCaseProvider);
      final group = await getSiteGroupByIdUseCase.execute(groupId);

      if (group != null && mounted) {
        final siteConfig =
            widget.moduleInfo!.module.complement?.configuration?.site;
        if (siteConfig != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SiteFormPage(
                siteConfig: siteConfig,
                customConfig: widget.customConfig,
                moduleId: widget.moduleInfo!.module.id,
                moduleInfo: widget.moduleInfo,
                siteGroup: group,
              ),
            ),
          );
        }
      }
    }
  }

  Future<void> _navigateToAddVisit(BuildContext context, int siteId) async {
    final getSiteByIdUseCase = ref.read(getSiteByIdUseCaseProvider);
    final site = await getSiteByIdUseCase.execute(siteId);

    if (site != null && mounted) {
      final visitConfig =
          widget.moduleInfo!.module.complement?.configuration?.visit;
      if (visitConfig != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VisitFormPage(
              site: site,
              visitConfig: visitConfig,
              customConfig: widget.customConfig,
              moduleId: widget.moduleInfo!.module.id,
              moduleInfo: widget.moduleInfo,
              siteGroup: widget.siteGroup,
            ),
          ),
        );
      }
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Impossible de charger le site'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
