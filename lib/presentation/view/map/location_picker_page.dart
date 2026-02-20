import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/domain/domain_module.dart';
import 'package:gn_mobile_monitoring/domain/usecase/load_map_tile_layers_use_case.dart';
import 'package:latlong2/latlong.dart';

/// Page plein écran pour ajuster la position du site sur une carte interactive.
/// L'utilisateur déplace la carte sous une épingle fixe au centre de l'écran,
/// puis confirme la position.
class LocationPickerPage extends ConsumerStatefulWidget {
  final LatLng initialPosition;

  const LocationPickerPage({
    super.key,
    required this.initialPosition,
  });

  @override
  ConsumerState<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends ConsumerState<LocationPickerPage> {
  late final MapController _mapController;
  late LatLng _currentCenter;
  List<TileLayerConfig> _tileLayers = [];
  TileLayerConfig? _selectedLayer;
  StreamSubscription<MapEvent>? _mapEventSubscription;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _currentCenter = widget.initialPosition;
    _loadTileLayers();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mapEventSubscription = _mapController.mapEventStream.listen((event) {
        if (event is MapEventMove || event is MapEventMoveEnd) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajuster la position'),
      ),
      body: Stack(
        children: [
          // Carte interactive
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: widget.initialPosition,
              initialZoom: 17,
            ),
            children: [
              TileLayer(
                urlTemplate: _selectedLayer?.urlTemplate ??
                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.gn_mobile_monitoring',
              ),
            ],
          ),

          // Épingle fixe au centre de l'écran
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

          // Affichage des coordonnées en temps réel
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
                'Lat: ${_currentCenter.latitude.toStringAsFixed(6)}, Lon: ${_currentCenter.longitude.toStringAsFixed(6)}',
                style: const TextStyle(
                  fontSize: 13,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          // Bouton de changement de couche
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

          // Bouton "Confirmer la position"
          Positioned(
            bottom: 32,
            left: 16,
            right: 16,
            child: FilledButton.icon(
              onPressed: () {
                Navigator.pop(context, _currentCenter);
              },
              icon: const Icon(Icons.check),
              label: const Text('Confirmer la position'),
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
