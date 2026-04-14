import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/domain/domain_module.dart';
import 'package:gn_mobile_monitoring/domain/usecase/load_map_tile_layers_use_case.dart';
import 'package:latlong2/latlong.dart';

/// Résultat du dessin d'une géométrie sur [LocationPickerPage].
/// Les coordonnées sont dans l'ordre de saisie (sans fermeture explicite
/// pour les polygones — c'est au caller de répéter le premier point s'il
/// sérialise en GeoJSON).
class GeometryDrawResult {
  final String geometryType;
  final List<LatLng> coordinates;

  const GeometryDrawResult({
    required this.geometryType,
    required this.coordinates,
  });

  /// Parse un GeoJSON Point / LineString / Polygon et retourne le résultat.
  /// Pour un polygone, le point de fermeture (dupliqué du premier) est retiré.
  /// Retourne `null` si la chaîne est invalide ou si le type n'est pas supporté.
  static GeometryDrawResult? parseGeoJson(String raw) {
    try {
      final geojson = jsonDecode(raw) as Map<String, dynamic>;
      final type = geojson['type'] as String?;
      final coords = geojson['coordinates'] as List<dynamic>;
      LatLng pair(List<dynamic> p) => LatLng(
            (p[1] as num).toDouble(),
            (p[0] as num).toDouble(),
          );

      switch (type) {
        case 'Point':
          if (coords.length < 2) return null;
          return GeometryDrawResult(
            geometryType: 'Point',
            coordinates: [pair(coords)],
          );
        case 'LineString':
          final verts = coords.cast<List<dynamic>>().map(pair).toList();
          if (verts.length < 2) return null;
          return GeometryDrawResult(
            geometryType: 'LineString',
            coordinates: verts,
          );
        case 'Polygon':
          if (coords.isEmpty) return null;
          final ring = (coords.first as List<dynamic>).cast<List<dynamic>>();
          final verts = ring.map(pair).toList();
          if (verts.length >= 4 && verts.first == verts.last) {
            verts.removeLast();
          }
          if (verts.length < 3) return null;
          return GeometryDrawResult(
            geometryType: 'Polygon',
            coordinates: verts,
          );
      }
    } catch (_) {
      return null;
    }
    return null;
  }
}

/// Page plein écran pour saisir la géométrie d'un site (point, ligne, polygone).
///
/// - `Point` : la carte se déplace sous une épingle centrale, la confirmation
///   retourne le centre courant.
/// - `LineString` / `Polygon` : tap pour ajouter un sommet, appui long sur la
///   carte pour retirer le dernier sommet. La confirmation est bloquée tant
///   que le nombre minimal de sommets n'est pas atteint (2 pour une ligne,
///   3 pour un polygone).
class LocationPickerPage extends ConsumerStatefulWidget {
  final LatLng initialCenter;
  final String geometryType;
  final List<LatLng>? initialVertices;

  const LocationPickerPage({
    super.key,
    required this.initialCenter,
    this.geometryType = 'Point',
    this.initialVertices,
  });

  @override
  ConsumerState<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends ConsumerState<LocationPickerPage> {
  late final MapController _mapController;
  late LatLng _currentCenter;
  late List<LatLng> _vertices;
  List<TileLayerConfig> _tileLayers = [];
  TileLayerConfig? _selectedLayer;
  StreamSubscription<MapEvent>? _mapEventSubscription;

  bool get _isPoint => widget.geometryType == 'Point';
  bool get _isLine => widget.geometryType == 'LineString';
  bool get _isPolygon => widget.geometryType == 'Polygon';

  int get _minVertices => _isPolygon ? 3 : (_isLine ? 2 : 1);

  /// `true` si le polygone courant a au moins le nombre minimum de sommets
  /// mais est auto-intersecté (segments qui se croisent). On ne teste pas
  /// les lignes — le serveur accepte les LineString auto-sécantes.
  bool get _isPolygonInvalid {
    if (!_isPolygon || _vertices.length < 4) return false;
    return !ref
        .read(mapGeometryServiceProvider)
        .isPolygonSimple(_vertices);
  }

  bool get _canConfirm {
    if (_isPoint) return true;
    if (_vertices.length < _minVertices) return false;
    return !_isPolygonInvalid;
  }

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _currentCenter = widget.initialCenter;
    _vertices = List<LatLng>.from(widget.initialVertices ?? const []);
    _loadTileLayers();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mapEventSubscription = _mapController.mapEventStream.listen((event) {
        if (_isPoint && (event is MapEventMove || event is MapEventMoveEnd)) {
          setState(() {
            _currentCenter = _mapController.camera.center;
          });
        }
      });
    });
  }

  Future<void> _loadTileLayers() async {
    final useCase = ref.read(loadMapTileLayersUseCaseProvider);
    final layers = await useCase.execute();
    if (mounted && layers.isNotEmpty) {
      setState(() {
        _tileLayers = layers;
        _selectedLayer = layers.first;
      });
    }
  }

  @override
  void dispose() {
    _mapEventSubscription?.cancel();
    _mapController.dispose();
    super.dispose();
  }

  void _handleMapTap(TapPosition _, LatLng point) {
    if (_isPoint) return;
    setState(() {
      _vertices = [..._vertices, point];
    });
  }

  void _handleMapLongPress(TapPosition _, LatLng __) {
    if (_isPoint || _vertices.isEmpty) return;
    setState(() {
      _vertices = _vertices.sublist(0, _vertices.length - 1);
    });
  }

  void _confirm() {
    if (!_canConfirm) return;
    final result = _isPoint
        ? GeometryDrawResult(
            geometryType: 'Point',
            coordinates: [_currentCenter],
          )
        : GeometryDrawResult(
            geometryType: widget.geometryType,
            coordinates: List.unmodifiable(_vertices),
          );
    Navigator.pop(context, result);
  }

  String _appBarTitle() {
    if (_isLine) return 'Tracer une ligne';
    if (_isPolygon) return 'Tracer un polygone';
    return 'Ajuster la position';
  }

  String _instructions() {
    final remaining = _minVertices - _vertices.length;
    if (_isLine) {
      if (remaining > 0) {
        return 'Touchez la carte pour ajouter des sommets (encore $remaining minimum). Appui long pour retirer le dernier.';
      }
      return 'Sommets : ${_vertices.length}. Appui long pour retirer le dernier.';
    }
    if (_isPolygon) {
      if (remaining > 0) {
        return 'Touchez la carte pour ajouter des sommets (encore $remaining minimum). Appui long pour retirer le dernier.';
      }
      if (_isPolygonInvalid) {
        return '⚠️ Polygone invalide : les segments se croisent. Retirez des sommets (appui long) ou recommencez.';
      }
      return 'Sommets : ${_vertices.length}. Appui long pour retirer le dernier.';
    }
    return 'Lat: ${_currentCenter.latitude.toStringAsFixed(6)}, Lon: ${_currentCenter.longitude.toStringAsFixed(6)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitle()),
        actions: [
          if (!_isPoint && _vertices.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              tooltip: 'Tout effacer',
              onPressed: () => setState(() => _vertices = []),
            ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: widget.initialCenter,
              initialZoom: 17,
              onTap: _handleMapTap,
              onLongPress: _handleMapLongPress,
            ),
            children: [
              TileLayer(
                urlTemplate: _selectedLayer?.urlTemplate ??
                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.gn_mobile_monitoring',
              ),
              if (_isPolygon && _vertices.length >= 3)
                PolygonLayer(
                  polygons: [
                    Polygon(
                      points: _vertices,
                      // Couleur orange/warning quand le polygone s'auto-
                      // intersecte, rouge sinon (comportement par défaut).
                      // Rend visible à l'utilisateur qu'il faut corriger
                      // avant de pouvoir valider.
                      color: (_isPolygonInvalid ? Colors.orange : Colors.red)
                          .withValues(alpha: 0.25),
                      borderColor:
                          _isPolygonInvalid ? Colors.orange : Colors.red,
                      borderStrokeWidth: _isPolygonInvalid ? 4 : 3,
                    ),
                  ],
                ),
              if (_isLine && _vertices.length >= 2)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _vertices,
                      color: Colors.red,
                      strokeWidth: 3,
                    ),
                  ],
                ),
              if (!_isPoint && _vertices.isNotEmpty)
                MarkerLayer(
                  markers: [
                    for (int i = 0; i < _vertices.length; i++)
                      Marker(
                        point: _vertices[i],
                        width: 24,
                        height: 24,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.red, width: 2),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${i + 1}',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
            ],
          ),

          if (_isPoint)
            const Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 40.0),
                child: Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 50,
                ),
              ),
            ),

          Positioned(
            top: 16,
            left: 16,
            right: 80,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                _instructions(),
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: _isPoint ? 'monospace' : null,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          if (_tileLayers.length > 1)
            Positioned(
              top: 16,
              right: 16,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: _showLayerSelector,
                  child: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Icon(Icons.layers),
                  ),
                ),
              ),
            ),

          Positioned(
            bottom: 32,
            left: 16,
            right: 16,
            child: FilledButton.icon(
              onPressed: _canConfirm ? _confirm : null,
              icon: const Icon(Icons.check),
              label: Text(_isPoint ? 'Confirmer la position' : 'Valider la géométrie'),
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLayerSelector() {
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
            ..._tileLayers.map((layer) {
              final isSelected = _selectedLayer == layer;
              return ListTile(
                title: Text(layer.name),
                leading: Icon(
                  isSelected ? Icons.check_circle : Icons.circle_outlined,
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : null,
                ),
                onTap: () {
                  setState(() {
                    _selectedLayer = layer;
                  });
                  Navigator.pop(context);
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
