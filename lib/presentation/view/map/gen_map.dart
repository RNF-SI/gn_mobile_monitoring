import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gn_mobile_monitoring/core/helpers/form_config_parser.dart';
import 'package:gn_mobile_monitoring/core/helpers/value_formatter.dart';
import 'package:gn_mobile_monitoring/data/data_module.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/domain/model/site_complement.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';
import 'package:gn_mobile_monitoring/presentation/model/module_info.dart';
import 'package:gn_mobile_monitoring/presentation/view/site/site_detail_page.dart';
import 'package:gn_mobile_monitoring/presentation/view/visit/visit_form_page.dart';
import 'package:latlong2/latlong.dart';

// ---------------------------
// Widget Boussole
// ---------------------------
class CompassWidget extends StatefulWidget {
  final MapController mapController;
  const CompassWidget({super.key, required this.mapController});

  @override
  State<CompassWidget> createState() => _CompassWidgetState();
}

class _CompassWidgetState extends State<CompassWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;
  double currentRotation = 0.0;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    // Écoute les mouvements et rotations de la carte
    widget.mapController.mapEventStream.listen((event) {
      if (event is MapEventMove || event is MapEventRotate) {
        setState(() {
          currentRotation = widget.mapController.camera.rotationRad;
        });
      }
    });
  }

  void resetNorth() {
    final startRotation = widget.mapController.camera.rotation;
    final endRotation = 0.0;

    _rotationAnimation = Tween<double>(
      begin: startRotation,
      end: endRotation,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    )..addListener(() {
        widget.mapController.rotate(_rotationAnimation.value);
      });

    _animationController.forward(from: 0);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 16,
      left: 16,
      child: GestureDetector(
        onTap: resetNorth,
        child: Transform.rotate(
          angle: currentRotation,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(Icons.navigation, color: Colors.red, size: 28),
          ),
        ),
      ),
    );
  }
}

// ---------------------------
// Widget Geometries
// ---------------------------
class GeometriesMapWidget extends ConsumerStatefulWidget {
  final String? geojsonData; // <--- nullable
  final List<String>? displayList; // Liste des propriétés à afficher
  final ObjectConfig? siteConfig; // Configuration du site
  final CustomConfig? customConfig; // Configuration personnalisée
  final ModuleInfo? moduleInfo; // Information sur le module (pour navigation)
  final SiteGroup? siteGroup; // Groupe de sites parent (optionnel)

  const GeometriesMapWidget({
    super.key,
    required this.geojsonData,
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
  List<Marker> siteMarkers = []; // Markers de sites (pour clustering)
  List<Marker> userMarkers =
      []; // Markers de position utilisateur (pas de clustering)
  List<Polyline> polylines = [];
  List<Polygon> polygons = [];
  LatLng? userPosition;

  // Stocker les propriétés de chaque marker pour les tooltips
  Map<LatLng, Map<String, dynamic>> markerProperties = {};

  // Stocker les IDs des sites pour charger les compléments
  Map<LatLng, int> markerSiteIds = {};

  // Stocker les compléments chargés
  Map<int, SiteComplement?> siteComplements = {};

  List<Map<String, String>> tileLayers = [];
  Map<String, String>? selectedLayer;

  late final MapController mapController;
  bool hasAutoCentered = false; // recentrage automatique unique
  bool userMovedMap = false; // stoppe l'auto-recentrage

  StreamSubscription<Position>? positionStream;
  CircleMarker? accuracyCircle; // cercle de précision

  LatLng? computeCentroid() {
    List<LatLng> allPoints = [];

    // Récupère tous les points des markers de sites
    for (var m in siteMarkers) {
      allPoints.add(m.point);
    }

    // Récupère les points des polylines
    for (var poly in polylines) {
      allPoints.addAll(poly.points);
    }

    // Récupère les points des polygons
    for (var polygon in polygons) {
      allPoints.addAll(polygon.points);
    }

    if (allPoints.isEmpty) return null;

    double sumLat = 0;
    double sumLng = 0;

    for (var p in allPoints) {
      sumLat += p.latitude;
      sumLng += p.longitude;
    }

    return LatLng(
      sumLat / allPoints.length,
      sumLng / allPoints.length,
    );
  }

  // Calcul de l'emprise global des sites
  LatLngBounds? computeGlobalBounds() {
    final points = <LatLng>[];

    // Markers
    points.addAll(siteMarkers.map((m) => m.point));

    // Polylines
    for (var poly in polylines) {
      points.addAll(poly.points);
    }

    // Polygons
    for (var poly in polygons) {
      points.addAll(poly.points);
    }

    if (points.isEmpty) return null;

    return LatLngBounds.fromPoints(points);
  }

  @override
  void initState() {
    super.initState();
    mapController = MapController(); // 🔥 Initialisation du controller

    loadTileLayers();
    loadGeometriesSafely();
    loadUserLocation();
    // Les compléments seront chargés après le chargement des géométries

    // Écoute la rotation de la carte pour mettre à jour les markers
    mapController.mapEventStream.listen((event) {
      if (event is MapEventRotate) {
        setState(() {
          // Reconstruire les markers avec la rotation mise à jour
          _rebuildMarkers();
        });
      }
    });
  }

  /// Charge les compléments de sites de manière asynchrone
  Future<void> _loadSiteComplements() async {
    if (markerSiteIds.isEmpty) return;

    try {
      final sitesDatabase = ref.read(siteDatabaseProvider);
      final allComplements = await sitesDatabase.getAllSiteComplements();

      final Map<int, SiteComplement?> loadedComplements = {};
      for (final siteId in markerSiteIds.values) {
        final complement =
            allComplements.where((c) => c.idBaseSite == siteId).firstOrNull;
        loadedComplements[siteId] = complement;
      }

      if (mounted) {
        setState(() {
          siteComplements = loadedComplements;
          // Mettre à jour les propriétés des markers avec les compléments
          _enrichMarkerProperties();
        });
      }
    } catch (e) {
      debugPrint('Erreur lors du chargement des compléments: $e');
    }
  }

  /// Enrichit les propriétés des markers avec les données des compléments
  void _enrichMarkerProperties() {
    markerSiteIds.forEach((point, siteId) {
      final complement = siteComplements[siteId];
      if (complement != null && complement.data != null) {
        try {
          Map<String, dynamic> complementData = {};
          if (complement.data is String) {
            complementData = Map<String, dynamic>.from(
                jsonDecode(complement.data as String));
          } else {
            complementData = Map<String, dynamic>.from(complement.data as Map);
          }

          // Fusionner les données du complément avec les propriétés existantes
          final existingProperties = markerProperties[point] ?? {};
          existingProperties.addAll(complementData);
          markerProperties[point] = existingProperties;
        } catch (e) {
          debugPrint(
              'Erreur lors du décodage du complément pour site $siteId: $e');
        }
      }
    });

    // Reconstruire les markers avec les nouvelles propriétés
    _rebuildMarkers();
  }

  /// Reconstruit les markers avec les propriétés enrichies
  void _rebuildMarkers() {
    final newMarkers = <Marker>[];

    for (final marker in siteMarkers) {
      // Vérifier que c'est un marker de site
      if (!markerSiteIds.containsKey(marker.point)) {
        continue;
      }

      final properties = markerProperties[marker.point];
      if (properties == null) {
        newMarkers.add(marker);
        continue;
      }

      // Récupérer le premier item de display_list pour l'étiquette
      String? labelText;
      if (widget.displayList != null &&
          widget.displayList!.isNotEmpty &&
          properties.containsKey(widget.displayList!.first)) {
        final firstProperty = widget.displayList!.first;
        final rawValue = properties[firstProperty];
        labelText = ValueFormatter.format(rawValue);
      }

      newMarkers.add(
        Marker(
          point: marker.point,
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
                  child: Container(
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
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      labelText,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    }

    setState(() {
      siteMarkers = newMarkers;
    });
  }

  @override
  void dispose() {
    positionStream?.cancel();
    super.dispose();
  }

  // -------------------------
  // Charger les layers depuis le JSON de config
  // -------------------------
  Future<void> loadTileLayers() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/settings.json');

      final Map<String, dynamic> jsonData = jsonDecode(jsonString);

      final List<dynamic> layers = jsonData["layers"] ?? [];

      setState(() {
        tileLayers = layers
            .map<Map<String, String>>((e) => {
                  "name": e["name"],
                  "urlTemplate": e["urlTemplate"],
                  "attribution": e["attribution"] ?? "",
                })
            .toList();

        // Valeur par défaut
        if (tileLayers.isNotEmpty) {
          selectedLayer = tileLayers.first;
        }
      });
    } catch (e) {
      print("Erreur chargement settings.json : $e");
    }
  }

  // -------------------------
  // Chargement sécurisé du JSON
  // -------------------------
  void loadGeometriesSafely() {
    if (widget.geojsonData == null || widget.geojsonData!.trim().isEmpty) {
      print("⚠️ JSON absent, aucune géométrie chargée.");
      return;
    }

    try {
      final List data = jsonDecode(widget.geojsonData!);

      if (data.isEmpty) {
        print("⚠️ JSON vide, aucune géométrie chargée.");
        return;
      }

      loadGeometries(data);
      // Charger les compléments après le chargement des géométries
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadSiteComplements();
      });
    } catch (e) {
      print("❌ Erreur lors du parsing JSON : $e");
    }
  }

  // -------------------------------
  // Lecture des géométries depuis le JSON
  // -------------------------------
  void loadGeometries(List data) {
    for (var feature in data) {
      if (feature["geom"] == null) continue;

      final geom = feature["geom"];
      final type = geom["type"];
      final coords = geom["coordinates"];

      switch (type) {
        case "Point":
          final point = LatLng(coords[1], coords[0]);
          // Stocker les propriétés du feature (sauf geom)
          final properties = <String, dynamic>{};
          feature.forEach((key, value) {
            if (key != 'geom') {
              properties[key] = value;
            }
          });
          markerProperties[point] = properties;

          // Stocker l'ID du site si disponible
          if (feature['id'] != null) {
            markerSiteIds[point] = feature['id'] as int;
          }

          // Récupérer le premier item de display_list pour l'étiquette
          String? labelText;
          if (widget.displayList != null &&
              widget.displayList!.isNotEmpty &&
              properties.containsKey(widget.displayList!.first)) {
            final firstProperty = widget.displayList!.first;
            final rawValue = properties[firstProperty];
            labelText = ValueFormatter.format(rawValue);
          }

          siteMarkers.add(
            Marker(
              point: point,
              width: 60,
              height: 60,
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.location_on, color: Colors.red, size: 50),
                  if (labelText != null && labelText.isNotEmpty)
                    Positioned(
                      bottom: 55,
                      child: Container(
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
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          labelText,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
          break;

        case "LineString":
          polylines.add(
            Polyline(
              points: coords.map<LatLng>((c) => LatLng(c[1], c[0])).toList(),
              strokeWidth: 4,
              color: Colors.blue,
            ),
          );
          break;

        case "Polygon":
          polygons.add(
            Polygon(
              points: coords[0].map<LatLng>((c) => LatLng(c[1], c[0])).toList(),
              color: Colors.green.withValues(alpha: 0.3),
              borderColor: Colors.green,
              borderStrokeWidth: 3,
            ),
          );
          break;
      }
    }
  }

  // -------------------------------
  // Récupération de la position de l'appareil
  // -------------------------------
  Future<void> loadUserLocation() async {
    try {
      // Vérifier si le service GPS est activé
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print("GPS désactivé → pas d'affichage de la localisation.");
        _centerOnGeometries();
        return; // ⛔️ ne rien afficher
      }

      // Vérifier les permissions
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print("Permission refusée → pas de localisation.");
          _centerOnGeometries();
          return; // ⛔️ ne rien afficher
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print("Permission bloquée définitivement → pas de localisation.");
        _centerOnGeometries();
        return; // ⛔️ ne rien afficher
      }

      // OK → récupérer la position
      Position pos = await Geolocator.getCurrentPosition();
      _updateUserPosition(pos);

      // Tracking en continu
      positionStream = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.best,
          distanceFilter: 2, // mise à jour tous les 2 m
        ),
      ).listen((Position newPos) {
        _updateUserPosition(newPos);
      });
    } catch (e) {
      print("Erreur localisation : $e");
      _centerOnGeometries();
    }
  }

  void _updateUserPosition(Position pos) {
    setState(() {
      userPosition = LatLng(pos.latitude, pos.longitude);

      // Supprimer ancien marker bleu
      userMarkers.clear();

      // Ajouter marker bleu
      userMarkers.add(
        Marker(
          point: userPosition!,
          width: 30,
          height: 30,
          child: const Icon(Icons.my_location, color: Colors.blue, size: 25),
        ),
      );

      // Dès que la position GPS est connue, recentrer sur l'emprise du cluster
      final bounds = computeGlobalBounds();
      if (bounds != null && !userMovedMap) {
        mapController.fitCamera(
          CameraFit.bounds(
            bounds: bounds,
            padding: const EdgeInsets.all(40),
          ),
        );
        hasAutoCentered = true;
      }

      // 🔵 Cercle de précision
      accuracyCircle = CircleMarker(
        point: userPosition!,
        radius: pos.accuracy, // précision GPS en mètres
        useRadiusInMeter: true,
        color: Colors.blue.withOpacity(0.15),
        borderStrokeWidth: 1.5,
        borderColor: Colors.blue,
      );
    });

    // Recentrage automatique UNE seule fois si l'utilisateur n'a pas bougé
    if (!hasAutoCentered && !userMovedMap) {
      mapController.move(userPosition!, 17);
      hasAutoCentered = true;
    }
  }

  // Gérer le centrage sur un groupe de géométries
  void _centerOnGeometries() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bounds = computeGlobalBounds();
      if (bounds == null) return;

      mapController.fitCamera(
        CameraFit.bounds(
          bounds: bounds,
          padding: const EdgeInsets.all(30),
        ),
      );
    });
  }

  // Gérer les clics sur la carte
  void _handleMapTap(BuildContext context, LatLng tappedPoint) {
    // Chercher le marker le plus proche du point cliqué (dans un rayon de ~50m)
    Marker? closestMarker;
    double minDistance = double.infinity;
    const double threshold = 0.0005; // Environ 50 mètres

    // Chercher dans les markers de sites
    for (final marker in siteMarkers) {
      final distance = (marker.point.latitude - tappedPoint.latitude).abs() +
          (marker.point.longitude - tappedPoint.longitude).abs();

      if (distance < threshold && distance < minDistance) {
        minDistance = distance;
        closestMarker = marker;
      }
    }

    // Si un marker a été cliqué, afficher son popup
    if (closestMarker != null &&
        markerProperties.containsKey(closestMarker.point)) {
      _showMarkerPopup(
          context, closestMarker.point, markerProperties[closestMarker.point]!);
    }
  }

  // Afficher un popup avec les propriétés du marker
  void _showMarkerPopup(
    BuildContext context,
    LatLng point,
    Map<String, dynamic> properties,
  ) {
    // Générer le schéma unifié de configuration pour obtenir les labels
    Map<String, dynamic> parsedSiteConfig = {};
    if (widget.siteConfig != null) {
      parsedSiteConfig = FormConfigParser.generateUnifiedSchema(
          widget.siteConfig!, widget.customConfig);
    }

    // Déterminer le titre du popup (premier item de display_list si disponible)
    String title = 'Point';
    if (widget.displayList != null &&
        widget.displayList!.isNotEmpty &&
        properties.containsKey(widget.displayList!.first)) {
      final firstProperty = widget.displayList!.first;
      final rawValue = properties[firstProperty];
      title = ValueFormatter.format(rawValue);
    } else {
      // Fallback sur les propriétés par défaut
      title = properties['name']?.toString() ??
          properties['base_site_name']?.toString() ??
          properties['sites_group_name']?.toString() ??
          'Point';
    }

    // Filtrer et formater les propriétés à afficher selon display_list
    final displayProperties = <Widget>[];

    if (widget.displayList != null && widget.displayList!.isNotEmpty) {
      // Exclure le premier item de display_list (déjà affiché dans le titre)
      final propertiesToShow = widget.displayList!.length > 1
          ? widget.displayList!.sublist(1)
          : <String>[];

      // Afficher uniquement les propriétés de display_list (sauf le premier)
      for (final key in propertiesToShow) {
        if (properties.containsKey(key) && properties[key] != null) {
          final value = properties[key];
          if (value.toString().trim().isNotEmpty) {
            // Obtenir le label depuis la configuration
            String label = key;
            if (parsedSiteConfig.containsKey(key)) {
              label = parsedSiteConfig[key]['attribut_label'] ?? key;
            } else {
              // Fallback sur formatLabel si pas de configuration
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
      // Fallback : afficher les propriétés par défaut si display_list n'est pas défini
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

      // Ensuite, afficher les autres propriétés (sauf celles déjà affichées et les meta)
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

    if (displayProperties.isEmpty) {
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

    // Récupérer l'ID du site depuis les propriétés
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
              // Boutons d'action
              if (siteId != null && widget.moduleInfo != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Column(
                    children: [
                      // Bouton pour voir les détails du site
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            // Fermer le popup
                            Navigator.of(context).pop();

                            // Récupérer le site depuis la base de données
                            final sitesDatabase =
                                ref.read(siteDatabaseProvider);
                            final site =
                                await sitesDatabase.getSiteById(siteId);

                            if (site != null && mounted) {
                              // Naviguer vers la page de détails du site
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
                            } else {
                              // Afficher un message d'erreur
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Impossible de charger le site'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          },
                          icon: const Icon(Icons.visibility),
                          label: const Text('Voir les détails'),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Bouton pour ajouter une visite
                      if (widget.moduleInfo!.module.complement?.configuration
                              ?.visit !=
                          null)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              // Fermer le popup
                              Navigator.of(context).pop();

                              // Récupérer le site depuis la base de données
                              final sitesDatabase =
                                  ref.read(siteDatabaseProvider);
                              final site =
                                  await sitesDatabase.getSiteById(siteId);

                              if (site != null && mounted) {
                                // Naviguer vers le formulaire de visite
                                final visitConfig = widget.moduleInfo!.module
                                    .complement?.configuration?.visit;
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
                              } else {
                                // Afficher un message d'erreur
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Impossible de charger le site'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            },
                            icon: const Icon(Icons.add_circle_outline),
                            label: Text(
                              widget.moduleInfo?.module.complement
                                      ?.configuration?.visit?.label ??
                                  'Ajouter une visite',
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

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

  @override
  Widget build(BuildContext context) {
    LatLng initialCenter =
        userPosition ?? computeCentroid() ?? const LatLng(48.85, 2.35);

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
                      initialZoom: userPosition != null ? 15 : 12,

                      // 🔥 Si l'utilisateur touche la carte → on arrête l'auto recentrage
                      onPointerDown: (_, __) {
                        userMovedMap = true;
                      },

                      // Détecter les clics sur les markers
                      onTap: (tapPosition, point) {
                        _handleMapTap(context, point);
                      },
                    ),
                    children: [
                      if (selectedLayer != null)
                        TileLayer(
                          urlTemplate: selectedLayer!["urlTemplate"]!,
                          userAgentPackageName:
                              'com.example.gn_mobile_monitoring',
                        ),

                      // 🔵 Cercle de précision GPS
                      if (accuracyCircle != null)
                        CircleLayer(circles: [accuracyCircle!]),
                      PolylineLayer(polylines: polylines),
                      PolygonLayer(polygons: polygons),

                      // 🔵 Clustering des markers de sites
                      MarkerClusterLayerWidget(
                        options: MarkerClusterLayerOptions(
                          maxClusterRadius: 80, // Rayon de clustering en pixels
                          size: const Size(50, 50), // Taille du cluster
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
                                    color: Colors.black.withOpacity(0.3),
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
                            if (markerProperties.containsKey(marker.point)) {
                              _showMarkerPopup(
                                context,
                                marker.point,
                                markerProperties[marker.point]!,
                              );
                            }
                          },
                          onClusterTap: (cluster) {
                            // Zoomer sur le cluster
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
                      // 🔵 Marker de l'utilisateur (pas de clustering)
                      MarkerLayer(markers: userMarkers),
                    ],
                  ),

                  // Attribution
                  if (selectedLayer != null)
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        color: Colors.white70,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 2),
                        child: Text(
                          selectedLayer?["attribution"] ?? "",
                          style: const TextStyle(fontSize: 10),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),

        // ---------------------------
        // Bouton "Layers" en haut à droite
        // ---------------------------
        if (tileLayers.isNotEmpty)
          Positioned(
            top: 16,
            right: 16,
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
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
                          ...tileLayers.map((layer) {
                            final isSelected = selectedLayer == layer;
                            return ListTile(
                              title: Text(layer["name"] ?? "Layer"),
                              leading: Icon(
                                isSelected
                                    ? Icons.check_circle
                                    : Icons.circle_outlined,
                                color: isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : null,
                              ),
                              onTap: () {
                                setState(() {
                                  selectedLayer = layer;
                                });
                                Navigator.pop(context);
                              },
                            );
                          }),
                        ],
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Icon(
                    Icons.layers,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          ),

        // ---------------------------
        // Bouton flottant "Centrer"
        // ---------------------------
        if (userPosition != null)
          Positioned(
            bottom: 60,
            right: 20,
            child: FloatingActionButton(
              child: const Icon(Icons.my_location),
              onPressed: () {
                mapController.move(userPosition!, 17);
                userMovedMap = false; // optionnel
                hasAutoCentered = true; // optionnel (empêche auto recentrage)
              },
            ),
          ),
        // ---------------------------
        // Boussole
        // ---------------------------
        CompassWidget(mapController: mapController),
      ],
    );
  }
}
