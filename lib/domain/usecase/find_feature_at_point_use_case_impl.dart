import 'package:gn_mobile_monitoring/domain/model/map_feature.dart';
import 'package:gn_mobile_monitoring/domain/service/map_geometry_service.dart';
import 'package:gn_mobile_monitoring/domain/usecase/find_feature_at_point_use_case.dart';
import 'package:latlong2/latlong.dart';

/// Implémentation du use case pour trouver une feature à un point donné.
class FindFeatureAtPointUseCaseImpl implements FindFeatureAtPointUseCase {
  final MapGeometryService _mapGeometryService;

  const FindFeatureAtPointUseCaseImpl(this._mapGeometryService);

  @override
  MapFeature? execute({
    required LatLng tappedPoint,
    required List<MapFeature> features,
    Map<LatLng, MapFeature>? labelCentroids,
    double markerThresholdDegrees = 0.0005,
    double lineThresholdMeters = 50.0,
  }) {
    // 1. Vérifier d'abord les labels (centroids des géométries)
    if (labelCentroids != null && labelCentroids.isNotEmpty) {
      final labelFeature = _findClosestLabel(
        tappedPoint,
        labelCentroids,
        markerThresholdDegrees,
      );
      if (labelFeature != null) return labelFeature;
    }

    // 2. Vérifier les polygones
    final polygonFeature = _findPolygonAtPoint(tappedPoint, features);
    if (polygonFeature != null) return polygonFeature;

    // 3. Vérifier les polylines
    final polylineFeature = _findClosestPolyline(
      tappedPoint,
      features,
      lineThresholdMeters,
    );
    if (polylineFeature != null) return polylineFeature;

    // 4. Vérifier les markers (points)
    final markerFeature = _findClosestMarker(
      tappedPoint,
      features,
      markerThresholdDegrees,
    );
    return markerFeature;
  }

  /// Trouve le label le plus proche du point cliqué
  MapFeature? _findClosestLabel(
    LatLng tappedPoint,
    Map<LatLng, MapFeature> labelCentroids,
    double thresholdDegrees,
  ) {
    MapFeature? closestFeature;
    double minDistance = double.infinity;

    for (final entry in labelCentroids.entries) {
      if (_mapGeometryService.isPointNearTarget(
        tappedPoint,
        entry.key,
        thresholdDegrees,
      )) {
        final distance = _calculateSimpleDistance(tappedPoint, entry.key);
        if (distance < minDistance) {
          minDistance = distance;
          closestFeature = entry.value;
        }
      }
    }

    return closestFeature;
  }

  /// Trouve un polygone contenant le point cliqué
  MapFeature? _findPolygonAtPoint(LatLng tappedPoint, List<MapFeature> features) {
    for (final feature in features) {
      if (feature is MapPolygonFeature) {
        if (_mapGeometryService.isPointInPolygon(tappedPoint, feature.points)) {
          return feature;
        }
      }
    }
    return null;
  }

  /// Trouve la polyline la plus proche du point cliqué
  MapFeature? _findClosestPolyline(
    LatLng tappedPoint,
    List<MapFeature> features,
    double thresholdMeters,
  ) {
    MapFeature? closestFeature;
    double minDistance = double.infinity;

    for (final feature in features) {
      if (feature is MapPolylineFeature) {
        final distance =
            _mapGeometryService.distanceToLine(tappedPoint, feature.points);
        if (distance < thresholdMeters && distance < minDistance) {
          minDistance = distance;
          closestFeature = feature;
        }
      }
    }

    return closestFeature;
  }

  /// Trouve le marker le plus proche du point cliqué
  MapFeature? _findClosestMarker(
    LatLng tappedPoint,
    List<MapFeature> features,
    double thresholdDegrees,
  ) {
    MapFeature? closestFeature;
    double minDistance = double.infinity;

    for (final feature in features) {
      if (feature is MapPointFeature) {
        if (_mapGeometryService.isPointNearTarget(
          tappedPoint,
          feature.point,
          thresholdDegrees,
        )) {
          final distance = _calculateSimpleDistance(tappedPoint, feature.point);
          if (distance < minDistance) {
            minDistance = distance;
            closestFeature = feature;
          }
        }
      }
    }

    return closestFeature;
  }

  /// Calcul simple de distance en degrés
  double _calculateSimpleDistance(LatLng point1, LatLng point2) {
    return (point1.latitude - point2.latitude).abs() +
        (point1.longitude - point2.longitude).abs();
  }
}
