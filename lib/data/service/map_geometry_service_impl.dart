import 'package:geolocator/geolocator.dart';
import 'package:gn_mobile_monitoring/domain/service/map_geometry_service.dart';
import 'package:latlong2/latlong.dart';

/// Implémentation du service de calculs géométriques pour la carte
class MapGeometryServiceImpl implements MapGeometryService {
  const MapGeometryServiceImpl();

  @override
  LatLng calculateCentroid(List<LatLng> points) {
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

  @override
  LatLngBounds? computeBounds(List<LatLng> points) {
    if (points.isEmpty) return null;
    return LatLngBounds.fromPoints(points);
  }

  @override
  bool isPointInPolygon(LatLng point, List<LatLng> polygonPoints) {
    if (polygonPoints.length < 3) return false;

    return _isPointInPolygonRobust(
      point.latitude,
      point.longitude,
      polygonPoints,
    );
  }

  /// Vérifie si un point est à l'intérieur d'un polygone (algorithme ray casting robuste)
  bool _isPointInPolygonRobust(
      double lat, double lon, List<LatLng> polygon) {
    if (polygon.length < 3) {
      return false;
    }

    // Algorithme ray casting : compter les intersections avec un rayon horizontal
    // Le rayon va de (lat, lon) vers (lat, +infini) en longitude
    bool inside = false;
    int j = polygon.length - 1;

    for (int i = 0; i < polygon.length; i++) {
      final xi = polygon[i].longitude;
      final yi = polygon[i].latitude;
      final xj = polygon[j].longitude;
      final yj = polygon[j].latitude;

      // Vérifier si le segment (i, j) intersecte le rayon horizontal
      final latStraddles = ((yi > lat) != (yj > lat));

      if (latStraddles) {
        final latDiff = yj - yi;
        if (latDiff.abs() > 1e-10) {
          final lonIntersection = xi + (xj - xi) * (lat - yi) / latDiff;

          if (lon < lonIntersection) {
            inside = !inside;
          }
        }
      }
      j = i;
    }

    return inside;
  }

  @override
  double distanceToLine(LatLng point, List<LatLng> linePoints) {
    if (linePoints.isEmpty) return double.infinity;
    if (linePoints.length == 1) {
      return distanceBetween(point, linePoints[0]);
    }

    double minDistance = double.infinity;
    for (int i = 0; i < linePoints.length - 1; i++) {
      final p1 = linePoints[i];
      final p2 = linePoints[i + 1];

      final distance = distanceToSegment(
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

  @override
  double distanceToSegment(
    double lat,
    double lon,
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
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

    return Geolocator.distanceBetween(lat, lon, xx, yy);
  }

  @override
  double distanceBetween(LatLng point1, LatLng point2) {
    return Geolocator.distanceBetween(
      point1.latitude,
      point1.longitude,
      point2.latitude,
      point2.longitude,
    );
  }

  @override
  bool isPointNearTarget(LatLng point, LatLng target, double thresholdDegrees) {
    final distance = (point.latitude - target.latitude).abs() +
        (point.longitude - target.longitude).abs();
    return distance < thresholdDegrees;
  }
}
