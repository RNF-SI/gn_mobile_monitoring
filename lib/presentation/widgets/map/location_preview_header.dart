import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

/// Widget affichant un aperçu de la position GPS sur une mini-carte non interactive.
/// Utilisé dans le header du formulaire de création/édition de site.
class LocationPreviewHeader extends StatelessWidget {
  final LatLng? position;
  final bool isLoading;
  final bool isAdjusted;
  final VoidCallback onAdjustPressed;

  const LocationPreviewHeader({
    super.key,
    required this.position,
    required this.isLoading,
    required this.isAdjusted,
    required this.onAdjustPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Mini-carte ou placeholder
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: SizedBox(
            height: 200,
            child: _buildMapContent(context),
          ),
        ),
        const SizedBox(height: 8),
        // Statut et coordonnées
        _buildLocationInfo(context),
        const SizedBox(height: 8),
        // Bouton "Ajuster sur la carte"
        OutlinedButton.icon(
          onPressed: position != null ? onAdjustPressed : null,
          icon: const Icon(Icons.map),
          label: const Text('Ajuster sur la carte'),
        ),
      ],
    );
  }

  Widget _buildMapContent(BuildContext context) {
    if (isLoading) {
      return Container(
        color: Colors.grey[200],
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (position == null) {
      return Container(
        color: Colors.grey[200],
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_off, size: 48, color: Colors.grey[500]),
              const SizedBox(height: 8),
              Text(
                'Position GPS indisponible',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    return AbsorbPointer(
      child: FlutterMap(
        options: MapOptions(
          initialCenter: position!,
          initialZoom: 15,
          interactionOptions: const InteractionOptions(
            flags: InteractiveFlag.none,
          ),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.gn_mobile_monitoring',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: position!,
                width: 40,
                height: 40,
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationInfo(BuildContext context) {
    if (isLoading) {
      return Text(
        'Récupération de la position GPS...',
        style: TextStyle(
          fontSize: 13,
          color: Colors.grey[600],
          fontStyle: FontStyle.italic,
        ),
      );
    }

    if (position == null) {
      return Text(
        'Aucune position disponible',
        style: TextStyle(
          fontSize: 13,
          color: Colors.grey[600],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isAdjusted ? 'Position ajustée' : 'Position GPS actuelle',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isAdjusted ? Colors.orange[800] : Colors.green[700],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'Lat: ${position!.latitude.toStringAsFixed(6)}, Lon: ${position!.longitude.toStringAsFixed(6)}',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }
}
