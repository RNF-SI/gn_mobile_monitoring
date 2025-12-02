import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class GeometriesMapWidget extends StatefulWidget {
  final String? geojsonData; // <--- nullable

  const GeometriesMapWidget({super.key, required this.geojsonData});

  @override
  State<GeometriesMapWidget> createState() => _GeometriesMapWidgetState();
}

class _GeometriesMapWidgetState extends State<GeometriesMapWidget> {
  List<Marker> markers = [];
  List<Polyline> polylines = [];
  List<Polygon> polygons = [];
  LatLng? userPosition;

  List<Map<String, String>> tileLayers = [];
  Map<String, String>? selectedLayer;

  late final MapController mapController;
  bool hasAutoCentered = false; // recentrage automatique unique
  bool userMovedMap = false;    // stoppe l'auto-recentrage

  StreamSubscription<Position>? positionStream;
  CircleMarker? accuracyCircle; // cercle de précision

  @override
  void initState() {
    super.initState();
    mapController = MapController();   // 🔥 Initialisation du controller

    loadTileLayers();
    loadGeometriesSafely();
    loadUserLocation();
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
          await rootBundle.loadString('assets/layers_config.json');
      final List data = jsonDecode(jsonString);
      setState(() {
        tileLayers = data
            .map<Map<String, String>>((e) => {
                  "name": e["name"],
                  "urlTemplate": e["urlTemplate"],
                  "attribution": e["attribution"] ?? "",
                })
            .toList();

        // Valeur par défaut
        if (tileLayers.isNotEmpty) selectedLayer = tileLayers.first;
      });
    } catch (e) {
      print("Erreur chargement layers.json : $e");
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
          markers.add(
            Marker(
              point: LatLng(coords[1], coords[0]),
              width: 40,
              height: 40,
              child: const Icon(Icons.location_on, color: Colors.red),
            ),
          );
          break;

        case "LineString":
          polylines.add(
            Polyline(
              points: coords
                  .map<LatLng>((c) => LatLng(c[1], c[0]))
                  .toList(),
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
        return; // ⛔️ ne rien afficher
      }

      // Vérifier les permissions
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print("Permission refusée → pas de localisation.");
          return; // ⛔️ ne rien afficher
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print("Permission bloquée définitivement → pas de localisation.");
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
    }
  }

  void _updateUserPosition(Position pos) {
    setState(() {
      userPosition = LatLng(pos.latitude, pos.longitude);

      // Supprimer ancien marker bleu
      markers.removeWhere((m) =>
          m.child is Icon &&
          (m.child as Icon).icon == Icons.my_location);

      // Ajouter marker bleu
      markers.add(
        Marker(
          point: userPosition!,
          width: 40,
          height: 40,
          child: const Icon(Icons.my_location, color: Colors.blue, size: 34),
        ),
      );

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

  @override
  Widget build(BuildContext context) {
    LatLng initialCenter = userPosition ?? LatLng(48.85, 2.35);

    return Stack(
      children: [
        Column(
          children: [
            // Dropdown
            if (tileLayers.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButton<Map<String, String>>(
                  value: selectedLayer,
                  items: tileLayers
                      .map((layer) => DropdownMenuItem(
                            value: layer,
                            child: Text(layer["name"] ?? "Layer"),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedLayer = value;
                    });
                  },
                ),
              ),

            Expanded(
              child: Stack(
                children: [
                  FlutterMap(
                    mapController: mapController,
                    options: MapOptions(
                      initialCenter: initialCenter,
                      initialZoom:
                          userPosition != null ? 15 : 12,

                      // 🔥 Si l'utilisateur touche la carte → on arrête l'auto recentrage
                      onPointerDown: (_, __) {
                        userMovedMap = true;
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
                      // 🔵 Marker de l’utilisateur
                      MarkerLayer(markers: markers),
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
      ],
    );
  }
}