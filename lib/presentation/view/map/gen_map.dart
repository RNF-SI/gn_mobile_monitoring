import 'dart:convert';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    loadGeometriesSafely();
    loadUserLocation();
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
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      userPosition = LatLng(position.latitude, position.longitude);

      // Ajout d'un marqueur "Vous êtes ici"
      markers.add(
        Marker(
          point: userPosition!,
          width: 40,
          height: 40,
          child: const Icon(Icons.my_location, color: Colors.blue, size: 35),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    LatLng initialCenter = userPosition ?? LatLng(48.85, 2.35);

    return FlutterMap(
      options: MapOptions(
        initialCenter: initialCenter,
        initialZoom: userPosition != null ? 15 : 12,
      ),
      children: [
        TileLayer(
          urlTemplate:
              "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
          userAgentPackageName: 'com.example.gn_mobile_monitoring', // <-- IMPORTANT
        ),
        PolylineLayer(polylines: polylines),
        PolygonLayer(polygons: polygons),
        MarkerLayer(markers: markers),
      ],
    );
  }
}