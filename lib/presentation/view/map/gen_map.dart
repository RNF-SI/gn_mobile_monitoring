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

  @override
  void initState() {
    super.initState();
    loadTileLayers();
    loadGeometriesSafely();
    loadUserLocation();
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

      setState(() {
        userPosition = LatLng(pos.latitude, pos.longitude);

        markers.add(
          Marker(
            point: userPosition!,
            width: 40,
            height: 40,
            child: const Icon(Icons.my_location, color: Colors.blue, size: 34),
          ),
        );

        print("Localisation affichée ✔");
      });
    } catch (e) {
      print("Erreur localisation : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    LatLng initialCenter = userPosition ?? LatLng(48.85, 2.35);

  return Column(
    children: [
      // Dropdown pour choisir la couche
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
              options: MapOptions(
                initialCenter: initialCenter,
                initialZoom: userPosition != null ? 15 : 12,
              ),
              children: [
                if (selectedLayer != null)
                  TileLayer(
                    urlTemplate: selectedLayer!["urlTemplate"]!,
                    userAgentPackageName:
                        'com.example.gn_mobile_monitoring',
                  ),
                PolylineLayer(polylines: polylines),
                PolygonLayer(polygons: polygons),
                MarkerLayer(markers: markers),
              ],
            ),
            // Attribution en bas à droite
            if (selectedLayer != null)
              Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  color: Colors.white70,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
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
    );
  }
}