import 'package:gn_mobile_monitoring/domain/model/map_feature.dart';
import 'package:latlong2/latlong.dart';

/// Use case pour trouver une feature à un point donné sur la carte.
/// Gère la priorité de sélection : labels > polygons > polylines > markers.
abstract class FindFeatureAtPointUseCase {
  /// Trouve la feature la plus proche du point donné.
  ///
  /// [tappedPoint] - Le point cliqué sur la carte
  /// [features] - Liste des features à rechercher
  /// [labelCentroids] - Centroids des labels de géométries (polygones/lignes)
  /// [markerThresholdDegrees] - Seuil de distance pour les markers (environ 50m = 0.0005)
  /// [lineThresholdMeters] - Seuil de distance pour les lignes (en mètres)
  ///
  /// Retourne la feature trouvée ou null si aucune feature n'est à proximité.
  MapFeature? execute({
    required LatLng tappedPoint,
    required List<MapFeature> features,
    Map<LatLng, MapFeature>? labelCentroids,
    double markerThresholdDegrees = 0.0005,
    double lineThresholdMeters = 50.0,
  });
}
