import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

/// Widget affichant un aperçu de la géométrie (point, ligne, polygone) sur
/// une mini-carte non interactive. Utilisé dans l'en-tête des formulaires
/// de création/édition de site.
///
/// - [geometryType] : `Point`, `LineString`, `Polygon` ou `null` (inconnu).
/// - [vertices] : sommets dans l'ordre de saisie. Pour un `Point`, une
///   seule entrée ; pour un polygone, ne pas inclure le point de fermeture.
/// - [previewCenter] : point à utiliser pour centrer la carte si [vertices]
///   est vide (typiquement la position GPS courante).
class LocationPreviewHeader extends StatelessWidget {
  final String? geometryType;
  final List<LatLng> vertices;
  final LatLng? previewCenter;
  final bool isLoading;
  final bool isAdjusted;

  /// Callback déclenché par le bouton "Ajuster sur la carte". Si `null`, le
  /// bouton n'est pas rendu (mode lecture seule — p. ex. page de détail d'un
  /// site).
  final VoidCallback? onAdjustPressed;

  /// Position GPS courante de l'utilisateur. Si fournie, un marker
  /// `Icons.my_location` bleu est affiché sur la mini-carte pour indiquer
  /// où se trouve l'observateur par rapport à la géométrie du site.
  final LatLng? userPosition;

  const LocationPreviewHeader({
    super.key,
    required this.geometryType,
    required this.vertices,
    required this.previewCenter,
    required this.isLoading,
    required this.isAdjusted,
    this.onAdjustPressed,
    this.userPosition,
  });

  bool get _isLine => geometryType == 'LineString';
  bool get _isPolygon => geometryType == 'Polygon';
  bool get _isPoint => geometryType == 'Point';

  bool get _canAdjust => previewCenter != null || vertices.isNotEmpty;

  LatLng? get _center =>
      vertices.isNotEmpty ? vertices.first : previewCenter;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: SizedBox(
            height: 200,
            child: _buildMapContent(context),
          ),
        ),
        const SizedBox(height: 8),
        _buildLocationInfo(context),
        if (onAdjustPressed != null) ...[
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: _canAdjust ? onAdjustPressed : null,
            icon: const Icon(Icons.map),
            label: Text(_adjustButtonLabel()),
          ),
        ],
      ],
    );
  }

  String _adjustButtonLabel() {
    if (_isLine) return 'Tracer / modifier la ligne';
    if (_isPolygon) return 'Tracer / modifier le polygone';
    return 'Ajuster sur la carte';
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

    final center = _center;
    if (center == null) {
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
          initialCenter: center,
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
          if (_isPolygon && vertices.length >= 3)
            PolygonLayer(
              polygons: [
                Polygon(
                  points: vertices,
                  color: Colors.red.withValues(alpha: 0.25),
                  borderColor: Colors.red,
                  borderStrokeWidth: 3,
                ),
              ],
            ),
          if (_isLine && vertices.length >= 2)
            PolylineLayer(
              polylines: [
                Polyline(
                  points: vertices,
                  color: Colors.red,
                  strokeWidth: 3,
                ),
              ],
            ),
          if (_isPoint || vertices.length == 1)
            MarkerLayer(
              markers: [
                Marker(
                  point: center,
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
          // Marker "vous êtes ici" par-dessus le reste, pour contextualiser
          // la position du site par rapport à celle de l'observateur.
          if (userPosition != null)
            MarkerLayer(
              markers: [
                Marker(
                  point: userPosition!,
                  width: 30,
                  height: 30,
                  child: const Icon(
                    Icons.my_location,
                    color: Colors.blue,
                    size: 25,
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

    final center = _center;
    if (center == null) {
      return Text(
        'Aucune position disponible',
        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
      );
    }

    final statusLabel = _statusLabel();
    final detail = _detailLabel(center);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          statusLabel,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isAdjusted ? Colors.orange[800] : Colors.green[700],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          detail,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
            fontFamily: _isPoint ? 'monospace' : null,
          ),
        ),
      ],
    );
  }

  String _statusLabel() {
    if (_isLine) {
      if (vertices.length < 2) return 'Aucune ligne tracée';
      return isAdjusted ? 'Ligne modifiée' : 'Ligne tracée';
    }
    if (_isPolygon) {
      if (vertices.length < 3) return 'Aucun polygone tracé';
      return isAdjusted ? 'Polygone modifié' : 'Polygone tracé';
    }
    return isAdjusted ? 'Position ajustée' : 'Position GPS actuelle';
  }

  String _detailLabel(LatLng center) {
    if (_isLine || _isPolygon) {
      return '${vertices.length} sommet(s)';
    }
    return 'Lat: ${center.latitude.toStringAsFixed(6)}, Lon: ${center.longitude.toStringAsFixed(6)}';
  }
}
