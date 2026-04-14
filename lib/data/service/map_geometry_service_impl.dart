import 'dart:convert';

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

  @override
  bool isPolygonSimple(List<LatLng> vertices) {
    final n = vertices.length;
    // Un polygone à ≤3 sommets distincts est toujours simple (triangle ou moins).
    if (n < 4) return true;

    // Construire n arêtes cycliques (i → (i+1) mod n) et tester chaque paire
    // de segments non-adjacents. Deux arêtes sont adjacentes si elles partagent
    // un sommet : (i, i+1) partage i+1 avec (i+1, i+2) et, pour le cycle, la
    // première arête (0, 1) partage le sommet 0 avec la dernière (n-1, 0).
    for (int i = 0; i < n; i++) {
      for (int j = i + 2; j < n; j++) {
        if (i == 0 && j == n - 1) continue; // arêtes qui partagent le sommet 0

        final a = vertices[i];
        final b = vertices[(i + 1) % n];
        final c = vertices[j];
        final d = vertices[(j + 1) % n];

        if (_segmentsIntersect(a, b, c, d)) return false;
      }
    }
    return true;
  }

  /// Test d'intersection entre les segments [p1,p2] et [p3,p4].
  /// Algo classique par signes des orientations. Les cas colinéaires (points
  /// exactement sur la ligne) sont traités comme non-intersectants, ce qui
  /// évite les faux positifs pour les polygones dessinés au tap (toucher
  /// exactement le même point deux fois est rare et généralement intentionnel).
  bool _segmentsIntersect(LatLng p1, LatLng p2, LatLng p3, LatLng p4) {
    final o1 = _orientation(p1, p2, p3);
    final o2 = _orientation(p1, p2, p4);
    final o3 = _orientation(p3, p4, p1);
    final o4 = _orientation(p3, p4, p2);
    return o1 != o2 && o3 != o4 && o1 != 0 && o2 != 0 && o3 != 0 && o4 != 0;
  }

  /// Retourne +1 si (a,b,c) est dans le sens trigonométrique (CCW), -1 dans
  /// le sens horaire (CW), 0 si les trois points sont colinéaires.
  int _orientation(LatLng a, LatLng b, LatLng c) {
    final ax = a.longitude, ay = a.latitude;
    final bx = b.longitude, by = b.latitude;
    final cx = c.longitude, cy = c.latitude;
    final val = (bx - ax) * (cy - by) - (by - ay) * (cx - bx);
    if (val.abs() < 1e-12) return 0;
    return val > 0 ? 1 : -1;
  }

  @override
  double? distanceToGeoJson(String geoJson, LatLng point) {
    try {
      final decoded = jsonDecode(geoJson);
      if (decoded is! Map<String, dynamic>) return null;
      final type = decoded['type'] as String?;
      final coordinates = decoded['coordinates'];
      if (type == null || coordinates == null) return null;

      switch (type) {
        case 'Point':
          return _distanceToPointCoord(coordinates, point);
        case 'LineString':
          return _distanceToLineCoords(coordinates, point);
        case 'Polygon':
          return _distanceToPolygonCoords(coordinates, point);
        case 'MultiPoint':
          // Coordinates = [[lon,lat], …]. Distance min aux points individuels.
          if (coordinates is! List) return null;
          return _minDistanceAcross(
            coordinates,
            point,
            (c) => _distanceToPointCoord(c, point),
          );
        case 'MultiLineString':
          // Coordinates = [[[lon,lat], …], …]. Distance min aux lignes.
          if (coordinates is! List) return null;
          return _minDistanceAcross(
            coordinates,
            point,
            (c) => _distanceToLineCoords(c, point),
          );
        case 'MultiPolygon':
          if (coordinates is! List) return null;
          return _minDistanceAcross(
            coordinates,
            point,
            (c) => _distanceToPolygonCoords(c, point),
          );
        default:
          return null;
      }
    } catch (_) {
      return null;
    }
  }

  /// Coordonnées GeoJSON d'un Point (`[lon, lat]`) → distance en mètres.
  double? _distanceToPointCoord(dynamic coords, LatLng point) {
    if (coords is! List || coords.length < 2) return null;
    final target = LatLng(
      (coords[1] as num).toDouble(),
      (coords[0] as num).toDouble(),
    );
    return distanceBetween(point, target);
  }

  /// Coordonnées GeoJSON d'une LineString (`[[lon, lat], ...]`).
  double? _distanceToLineCoords(dynamic coords, LatLng point) {
    final pts = _toLatLngList(coords);
    if (pts == null || pts.isEmpty) return null;
    return distanceToLine(point, pts);
  }

  /// Coordonnées GeoJSON d'un Polygon (`[[[lon, lat], ...], ...]`).
  /// On ne considère que l'anneau extérieur.
  double? _distanceToPolygonCoords(dynamic coords, LatLng point) {
    if (coords is! List || coords.isEmpty) return null;
    final ring = _toLatLngList(coords.first);
    if (ring == null || ring.length < 3) return null;
    if (isPointInPolygon(point, ring)) return 0;
    // Distance au contour fermé : on ajoute le premier point à la fin si
    // l'anneau n'est pas explicitement fermé, pour couvrir le dernier segment.
    final closed = ring.first == ring.last ? ring : [...ring, ring.first];
    return distanceToLine(point, closed);
  }

  /// Calcule le min d'un mapping distance sur une liste de sous-géométries.
  /// Retourne 0 dès qu'une sous-géométrie renvoie 0 (court-circuit).
  double? _minDistanceAcross(
    List<dynamic> items,
    LatLng point,
    double? Function(dynamic item) compute,
  ) {
    double? minDistance;
    for (final item in items) {
      final d = compute(item);
      if (d == null) continue;
      if (d == 0) return 0;
      if (minDistance == null || d < minDistance) {
        minDistance = d;
      }
    }
    return minDistance;
  }

  List<LatLng>? _toLatLngList(dynamic coords) {
    if (coords is! List) return null;
    final pts = <LatLng>[];
    for (final c in coords) {
      if (c is! List || c.length < 2) return null;
      pts.add(LatLng(
        (c[1] as num).toDouble(),
        (c[0] as num).toDouble(),
      ));
    }
    return pts;
  }
}
