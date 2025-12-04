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
import 'package:gn_mobile_monitoring/core/theme/app_colors.dart';
import 'package:gn_mobile_monitoring/data/data_module.dart';
import 'package:gn_mobile_monitoring/domain/domain_module.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/domain/model/site_complement.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';
import 'package:gn_mobile_monitoring/presentation/model/module_info.dart';
import 'package:gn_mobile_monitoring/presentation/view/site/site_detail_page.dart';
import 'package:gn_mobile_monitoring/presentation/view/site/site_form_page_with_type_selection.dart';
import 'package:gn_mobile_monitoring/presentation/view/site_group_detail_page.dart';
import 'package:gn_mobile_monitoring/presentation/view/visit/visit_form_page.dart';
import 'package:latlong2/latlong.dart';
import 'package:point_in_polygon/point_in_polygon.dart' as pip;

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

  final bool showAddMarkerButton;
  final List<String>? displayList; // Liste des propriétés à afficher
  final ObjectConfig? siteConfig; // Configuration du site
  final CustomConfig? customConfig; // Configuration personnalisée
  final ModuleInfo? moduleInfo; // Information sur le module (pour navigation)
  final SiteGroup? siteGroup; // Groupe de sites parent (optionnel)

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

  // Stocker les associations polygone -> propriétés et polyline -> propriétés
  Map<Polygon, Map<String, dynamic>> polygonProperties = {};
  Map<Polyline, Map<String, dynamic>> polylineProperties = {};

  // Markers pour les étiquettes des polygones et lignes (cliquables)
  List<Marker> geometryLabelMarkers = [];

  // Stocker l'association centroïde -> propriétés pour les étiquettes
  Map<LatLng, Map<String, dynamic>> geometryLabelProperties = {};

  List<Map<String, String>> tileLayers = [];
  Map<String, String>? selectedLayer;

  late final MapController mapController;
  bool hasAutoCentered = false; // recentrage automatique unique
  bool userMovedMap = false; // stoppe l'auto-recentrage

  StreamSubscription<Position>? positionStream;
  CircleMarker? accuracyCircle; // cercle de précision

  /// Calcule le centroïde d'une liste de points
  LatLng _calculateCentroid(List<LatLng> points) {
    if (points.isEmpty) {
      return const LatLng(0, 0);
    }

    double sumLat = 0;
    double sumLng = 0;

    for (var p in points) {
      sumLat += p.latitude;
      sumLng += p.longitude;
    }

    return LatLng(
      sumLat / points.length,
      sumLng / points.length,
    );
  }

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

    return _calculateCentroid(allPoints);
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
          // Les étiquettes sont fixes avec rotate: true, pas besoin de reconstruction
        });
      }
    });
  }

  void _addMarkerAtCenter() {
    final LatLng center = mapController.camera.center;

    // Supprime l'ancien marker
    userMarkers.clear();

    final newMarker = Marker(
      point: center,
      width: 40,
      height: 40,
      child: const Icon(
        Icons.location_on,
        color: Colors.blueGrey,
        size: 40,
      ),
    );

    setState(() {
      userMarkers.add(newMarker);

      markerProperties[center] = {
        'type': 'user',
        'addedAt': DateTime.now().toIso8601String(),
      };
      markerSiteIds[center] = -1;
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
          final linePoints =
              coords.map<LatLng>((c) => LatLng(c[1], c[0])).toList();

          // Stocker les propriétés du feature (sauf geom)
          final properties = <String, dynamic>{};
          feature.forEach((key, value) {
            if (key != 'geom') {
              properties[key] = value;
            }
          });

          final polyline = Polyline(
            points: linePoints,
            strokeWidth: 4,
            color: Colors.blue,
          );
          polylines.add(polyline);

          // Stocker les propriétés associées à cette ligne
          polylineProperties[polyline] = properties;

          // Calculer le centroïde de la ligne pour placer l'étiquette
          final centroid = _calculateCentroid(linePoints);

          // Récupérer le premier item de display_list pour l'étiquette
          String? labelText;
          if (widget.displayList != null &&
              widget.displayList!.isNotEmpty &&
              properties.containsKey(widget.displayList!.first)) {
            final firstProperty = widget.displayList!.first;
            final rawValue = properties[firstProperty];
            labelText = ValueFormatter.format(rawValue);
          }

          // Créer un marker cliquable au centroïde pour l'étiquette
          if (labelText != null && labelText.isNotEmpty) {
            // Stocker les propriétés associées à ce centroïde
            geometryLabelProperties[centroid] = properties;

            // Calculer la hauteur nécessaire pour le texte
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

            // Hauteur = hauteur du texte + padding vertical (4px * 2 = 8px)
            final labelHeight = (textPainter.height + 8).clamp(30.0, 60.0);

            geometryLabelMarkers.add(
              Marker(
                point: centroid,
                width: 150,
                height: labelHeight,
                rotate: true,
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
            );
          }
          break;

        case "Polygon":
          final polygonPoints =
              coords[0].map<LatLng>((c) => LatLng(c[1], c[0])).toList();

          // Stocker les propriétés du feature (sauf geom)
          final properties = <String, dynamic>{};
          feature.forEach((key, value) {
            if (key != 'geom') {
              properties[key] = value;
            }
          });

          final polygon = Polygon(
            points: polygonPoints,
            color: Colors.green.withValues(alpha: 0.3),
            borderColor: Colors.green,
            borderStrokeWidth: 3,
          );
          polygons.add(polygon);

          // Stocker les propriétés associées à ce polygone
          polygonProperties[polygon] = properties;

          // Calculer le centroïde du polygone pour placer l'étiquette
          final centroid = _calculateCentroid(polygonPoints);

          // Récupérer le premier item de display_list pour l'étiquette
          String? labelText;
          if (widget.displayList != null &&
              widget.displayList!.isNotEmpty &&
              properties.containsKey(widget.displayList!.first)) {
            final firstProperty = widget.displayList!.first;
            final rawValue = properties[firstProperty];
            labelText = ValueFormatter.format(rawValue);
          }

          // Créer un marker cliquable au centroïde pour l'étiquette
          if (labelText != null && labelText.isNotEmpty) {
            // Stocker les propriétés associées à ce centroïde
            geometryLabelProperties[centroid] = properties;

            // Calculer la hauteur nécessaire pour le texte
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

            // Hauteur = hauteur du texte + padding vertical (4px * 2 = 8px)
            final labelHeight = (textPainter.height + 8).clamp(30.0, 60.0);

            geometryLabelMarkers.add(
              Marker(
                point: centroid,
                width: 150,
                height: labelHeight,
                rotate: true,
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
            );
          }
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

  /// Vérifie si un point est à l'intérieur d'un polygone
  bool _isPointInPolygon(LatLng point, Polygon polygon) {
    final polygonPoints = polygon.points;
    if (polygonPoints.length < 3) return false;

    // Convertir en format pip.Point (x=longitude, y=latitude)
    final pipPoints = polygonPoints
        .map((p) => pip.Point(x: p.longitude, y: p.latitude))
        .toList();

    // Utiliser l'algorithme ray casting pour vérifier si le point est dans le polygone
    return _isPointInPolygonRobust(
      point.latitude,
      point.longitude,
      pipPoints,
    );
  }

  /// Vérifie si un point est à l'intérieur d'un polygone (algorithme ray casting robuste)
  /// Les points du polygone sont en format pip.Point (x=longitude, y=latitude)
  bool _isPointInPolygonRobust(
      double lat, double lon, List<pip.Point> polygon) {
    if (polygon.length < 3) {
      return false;
    }

    // Algorithme ray casting : compter les intersections avec un rayon horizontal
    // Le rayon va de (lat, lon) vers (lat, +infini) en longitude
    bool inside = false;
    int j = polygon.length - 1;

    for (int i = 0; i < polygon.length; i++) {
      final xi = polygon[i].x; // longitude du point i
      final yi = polygon[i].y; // latitude du point i
      final xj = polygon[j].x; // longitude du point j
      final yj = polygon[j].y; // latitude du point j

      // Vérifier si le segment (i, j) intersecte le rayon horizontal
      // Le segment intersecte si :
      // 1. Les latitudes du segment encadrent la latitude du point
      // 2. La longitude d'intersection est à droite du point
      final latStraddles = ((yi > lat) != (yj > lat));

      if (latStraddles) {
        // Éviter la division par zéro
        final latDiff = yj - yi;
        if (latDiff.abs() > 1e-10) {
          // Calculer la longitude d'intersection du segment avec le rayon horizontal
          // Équation de la droite : x = xi + (xj - xi) * (lat - yi) / (yj - yi)
          final lonIntersection = xi + (xj - xi) * (lat - yi) / latDiff;

          // L'intersection est à droite du point si lon < lonIntersection
          if (lon < lonIntersection) {
            inside = !inside;
          }
        }
      }
      j = i;
    }

    return inside;
  }

  /// Calcule la distance minimale d'un point à une ligne
  double _distanceToLine(LatLng point, List<LatLng> linePoints) {
    if (linePoints.isEmpty) return double.infinity;
    if (linePoints.length == 1) {
      return Geolocator.distanceBetween(
        point.latitude,
        point.longitude,
        linePoints[0].latitude,
        linePoints[0].longitude,
      );
    }

    double minDistance = double.infinity;
    for (int i = 0; i < linePoints.length - 1; i++) {
      final p1 = linePoints[i];
      final p2 = linePoints[i + 1];

      // Calculer la distance au segment
      final distance = _distanceToSegment(
        point.latitude,
        point.longitude,
        p1.latitude,
        p1.longitude,
        p2.latitude,
        p2.longitude,
      );

      if (distance < minDistance) {
        minDistance = distance;
      }
    }

    return minDistance;
  }

  /// Calcule la distance d'un point à un segment de ligne
  double _distanceToSegment(
    double lat,
    double lon,
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    // Calculer la distance en mètres
    final A = lat - lat1;
    final B = lon - lon1;
    final C = lat2 - lat1;
    final D = lon2 - lon1;

    final dot = A * C + B * D;
    final lenSq = C * C + D * D;
    double param = -1;

    if (lenSq != 0) {
      param = dot / lenSq;
    }

    double xx, yy;

    if (param < 0) {
      xx = lat1;
      yy = lon1;
    } else if (param > 1) {
      xx = lat2;
      yy = lon2;
    } else {
      xx = lat1 + param * C;
      yy = lon1 + param * D;
    }

    final dx = lat - xx;
    final dy = lon - yy;

    // Convertir en distance en mètres (approximation)
    return Geolocator.distanceBetween(lat, lon, xx, yy);
  }

  // Gérer les clics sur la carte
  void _handleMapTap(BuildContext context, LatLng tappedPoint) {
    // 1. Vérifier d'abord si le point est proche d'une étiquette (dans un rayon de ~50m)
    Marker? closestLabelMarker;
    double minLabelDistance = double.infinity;
    const double labelThreshold = 0.0005; // Environ 50 mètres

    for (final marker in geometryLabelMarkers) {
      final distance = (marker.point.latitude - tappedPoint.latitude).abs() +
          (marker.point.longitude - tappedPoint.longitude).abs();

      if (distance < labelThreshold && distance < minLabelDistance) {
        minLabelDistance = distance;
        closestLabelMarker = marker;
      }
    }

    // Si une étiquette a été cliquée, afficher son popup
    if (closestLabelMarker != null &&
        geometryLabelProperties.containsKey(closestLabelMarker.point)) {
      _showMarkerPopup(
        context,
        closestLabelMarker.point,
        geometryLabelProperties[closestLabelMarker.point]!,
      );
      return;
    }

    // 2. Vérifier ensuite si le point est dans un polygone
    for (final polygon in polygons) {
      if (polygonProperties.containsKey(polygon) &&
          _isPointInPolygon(tappedPoint, polygon)) {
        _showMarkerPopup(context, tappedPoint, polygonProperties[polygon]!);
        return;
      }
    }

    // 2. Vérifier si le point est proche d'une ligne (dans un rayon de ~50m)
    const double lineThreshold = 50.0; // 50 mètres
    Polyline? closestPolyline;
    double minLineDistance = double.infinity;

    for (final polyline in polylines) {
      if (polylineProperties.containsKey(polyline)) {
        final distance = _distanceToLine(tappedPoint, polyline.points);
        if (distance < lineThreshold && distance < minLineDistance) {
          minLineDistance = distance;
          closestPolyline = polyline;
        }
      }
    }

    if (closestPolyline != null) {
      _showMarkerPopup(
          context, tappedPoint, polylineProperties[closestPolyline]!);
      return;
    }

    // 3. Chercher le marker le plus proche du point cliqué (dans un rayon de ~50m)
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

    // Ne pas afficher "Aucune information disponible" si c'est un groupe de sites
    // (les sites seront affichés dans le FutureBuilder)
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
              // Afficher le nombre de sites et la liste si c'est un groupe de sites
              if (widget.siteGroup == null && siteId != null)
                FutureBuilder<List<BaseSite>>(
                  future: ref
                      .read(getSitesBySiteGroupUseCaseProvider)
                      .execute(siteId),
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

                    // Récupérer le label des sites depuis la configuration
                    final siteConfig = widget
                        .moduleInfo?.module.complement?.configuration?.site;
                    final siteLabelSingular =
                        (siteConfig?.label ?? 'site').toLowerCase();
                    final siteLabelPlural =
                        (siteConfig?.labelList ?? siteConfig?.label ?? 'sites')
                            .toLowerCase();

                    // Utiliser le pluriel si plus d'un site, sinon le singulier
                    final siteLabel =
                        sitesCount > 1 ? siteLabelPlural : siteLabelSingular;

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
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 0,
                          ),
                          child: Text(
                            'Nombre de $siteLabel: $sitesCount ',
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
                            ? Builder(
                                builder: (context) {
                                  final scrollController = ScrollController();
                                  return SizedBox(
                                    height: 200, // Hauteur fixe pour le slider
                                    child: Scrollbar(
                                      controller: scrollController,
                                      thumbVisibility: true,
                                      child: SingleChildScrollView(
                                        controller: scrollController,
                                        child: Column(
                                          children: sites.map((site) {
                                            final siteName =
                                                site.baseSiteName ??
                                                    site.baseSiteCode ??
                                                    'Site ${site.idBaseSite}';
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                left: 8.0,
                                                top: 4.0,
                                                bottom: 4.0,
                                              ),
                                              child: Row(
                                                children: [
                                                  const Icon(
                                                    Icons.location_on,
                                                    size: 16,
                                                    color: Colors.red,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Expanded(
                                                    child: Text(
                                                      siteName,
                                                      style: const TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Column(
                                children: sites.map((site) {
                                  final siteName = site.baseSiteName ??
                                      site.baseSiteCode ??
                                      'Site ${site.idBaseSite}';
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                      left: 8.0,
                                      top: 4.0,
                                      bottom: 4.0,
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.location_on,
                                          size: 16,
                                          color: Colors.red,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            siteName,
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                      ],
                    );
                  },
                ),
              // Boutons d'action
              if (siteId != null && widget.moduleInfo != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Column(
                    children: [
                      // Bouton pour voir les détails (du site ou du groupe de sites)
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            // Fermer le popup
                            Navigator.of(context).pop();

                            if (widget.siteGroup == null) {
                              // On affiche la carte des groupes de sites → naviguer vers la page de détail du groupe
                              final groupId = properties['id'] as int?;
                              if (groupId != null) {
                                // Récupérer le groupe depuis la base de données
                                final sitesDatabase =
                                    ref.read(siteDatabaseProvider);
                                final allGroups =
                                    await sitesDatabase.getAllSiteGroups();
                                final group = allGroups
                                    .where((g) => g.idSitesGroup == groupId)
                                    .firstOrNull;

                                if (group != null &&
                                    widget.moduleInfo != null &&
                                    mounted) {
                                  // Naviguer vers la page de détails du groupe de sites
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SiteGroupDetailPage(
                                        siteGroup: group,
                                        moduleInfo: widget.moduleInfo!,
                                      ),
                                    ),
                                  );
                                } else {
                                  // Afficher un message d'erreur
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Impossible de charger le groupe de sites'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              }
                            } else {
                              // On affiche la carte des sites → naviguer vers la page de détail du site
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
                            }
                          },
                          icon: const Icon(Icons.visibility),
                          label: const Text('Voir les détails'),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Bouton pour ajouter un site (si on affiche les groupes de sites) ou une visite (si on affiche les sites)
                      if (widget.siteGroup == null)
                        // On affiche la carte des groupes de sites → bouton "+ site" pour ajouter un site au groupe
                        if (widget.moduleInfo!.module.complement?.configuration
                                ?.site !=
                            null)
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                // Fermer le popup
                                Navigator.of(context).pop();

                                // Récupérer le groupe de sites depuis les propriétés du marker
                                final groupId = properties['id'] as int?;
                                if (groupId != null) {
                                  // Récupérer le groupe depuis la base de données
                                  final sitesDatabase =
                                      ref.read(siteDatabaseProvider);
                                  final allGroups =
                                      await sitesDatabase.getAllSiteGroups();
                                  final group = allGroups
                                      .where((g) => g.idSitesGroup == groupId)
                                      .firstOrNull;

                                  if (group != null && mounted) {
                                    // Naviguer vers le formulaire d'ajout de site
                                    final siteConfig = widget.moduleInfo!.module
                                        .complement?.configuration?.site;
                                    if (siteConfig != null) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              SiteFormPageWithTypeSelection(
                                            siteConfig: siteConfig,
                                            customConfig: widget.customConfig,
                                            moduleId:
                                                widget.moduleInfo!.module.id,
                                            moduleInfo: widget.moduleInfo,
                                            siteGroup: group,
                                          ),
                                        ),
                                      );
                                    } else {
                                      // Afficher un message d'erreur
                                      if (mounted) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Configuration de site non disponible'),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    }
                                  } else {
                                    // Afficher un message d'erreur
                                    if (mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Impossible de charger le groupe de sites'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                }
                              },
                              icon: const Icon(Icons.add_circle_outline),
                              label: Text(
                                'Ajouter un ${widget.moduleInfo?.module.complement?.configuration?.site?.label ?? 'site'}',
                              ),
                            ),
                          )
                        else
                          const SizedBox.shrink()
                      else
                      // On affiche la carte des sites → bouton "+ visite" pour ajouter une visite au site
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
                      // 🔵 Étiquettes des polygones et lignes (non cliquables)
                      MarkerLayer(markers: geometryLabelMarkers),
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
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

        if (widget.showAddMarkerButton)
          Positioned(
            bottom: 130,
            right: 20,
            child: FloatingActionButton(
              backgroundColor: AppColors.dark, // couleur du bouton
              foregroundColor: Colors.white, // couleur de l'icône
              onPressed: _addMarkerAtCenter,
              child: const Icon(Icons.add_location),
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
              backgroundColor: AppColors.dark, // couleur du bouton
              foregroundColor: Colors.white, // couleur de l'icône
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
