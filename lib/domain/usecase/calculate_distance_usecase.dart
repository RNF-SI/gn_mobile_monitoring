import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';
import 'package:point_in_polygon/point_in_polygon.dart' as pip;

// Provider pour le use case
final calculateDistanceUseCaseProvider = Provider<CalculateDistanceUseCase>(
  (ref) => CalculateDistanceUseCaseImpl(),
);

/// Interface pour le calcul de distances
/// Respecte la Clean Architecture en définissant un contrat
abstract class CalculateDistanceUseCase {

  /// Calcule la distance entre la position utilisateur et un groupe de sites
  Future<double?> calculateGroupDistance(SiteGroup group, Position userPosition);

  /// Calcule les distances pour une liste de groupes en parallèle
  Future<Map<int, double?>> calculateGroupDistances(List<SiteGroup> groups, Position userPosition);

  /// Trie une liste de groupes par distance
  List<SiteGroup> sortGroupsByDistance(List<SiteGroup> groups, Map<int, double?> distances);

  /// Vide le cache des distances
  void clearCache();
}

/// Implémentation du calcul de distances
/// Respecte la Clean Architecture en séparant l'interface de l'implémentation
class CalculateDistanceUseCaseImpl implements CalculateDistanceUseCase {
  // Cache des distances calculées (SiteGroup.idSitesGroup -> distance)
  final Map<int, double?> _distanceCache = {};
  Position? _lastUserPosition;

  @override
  Future<double?> calculateGroupDistance(
    SiteGroup group,
    Position userPosition,
  ) async {
    // Vérifier si la position a changé (invalider le cache si nécessaire)
    if (_lastUserPosition == null ||
        _hasPositionChanged(_lastUserPosition!, userPosition)) {
      _distanceCache.clear();
      _lastUserPosition = userPosition;
    }

    // Vérifier le cache
    if (_distanceCache.containsKey(group.idSitesGroup)) {
      return _distanceCache[group.idSitesGroup];
    }

    // Calculer la distance de manière asynchrone
    final distance = await _calculateDistanceAsync(group, userPosition);
    
    // Mettre en cache le résultat
    _distanceCache[group.idSitesGroup] = distance;
    
    return distance;
  }

  @override
  Future<Map<int, double?>> calculateGroupDistances(
    List<SiteGroup> groups,
    Position userPosition,
  ) async {
    // Vérifier si la position a changé
    if (_lastUserPosition == null ||
        _hasPositionChanged(_lastUserPosition!, userPosition)) {
      _distanceCache.clear();
      _lastUserPosition = userPosition;
    }

    // Identifier les groupes pour lesquels on a déjà la distance
    final groupsToCalculate = groups
        .where((group) => !_distanceCache.containsKey(group.idSitesGroup))
        .toList();

    // Calculer les distances manquantes en parallèle
    if (groupsToCalculate.isNotEmpty) {
      final futures = groupsToCalculate.map((group) async {
        final distance = await _calculateDistanceAsync(group, userPosition);
        return MapEntry(group.idSitesGroup, distance);
      });

      final results = await Future.wait(futures);
      
      // Mettre à jour le cache
      for (final entry in results) {
        _distanceCache[entry.key] = entry.value;
      }
    }

    // Retourner toutes les distances (cache + nouvelles)
    return Map.fromEntries(
      groups.map((group) => MapEntry(
        group.idSitesGroup,
        _distanceCache[group.idSitesGroup],
      )),
    );
  }

  @override
  List<SiteGroup> sortGroupsByDistance(
    List<SiteGroup> groups,
    Map<int, double?> distances,
  ) {
    final sortedGroups = List<SiteGroup>.from(groups);
    
    sortedGroups.sort((a, b) {
      final distanceA = distances[a.idSitesGroup];
      final distanceB = distances[b.idSitesGroup];

      // Si les deux distances sont disponibles, trier par distance
      if (distanceA != null && distanceB != null) {
        return distanceA.compareTo(distanceB);
      }
      // Si seule la distance A est disponible, A vient en premier
      if (distanceA != null && distanceB == null) {
        return -1;
      }
      // Si seule la distance B est disponible, B vient en premier
      if (distanceA == null && distanceB != null) {
        return 1;
      }
      // Si aucune distance n'est disponible, conserver l'ordre original
      return 0;
    });

    return sortedGroups;
  }

  @override
  void clearCache() {
    _distanceCache.clear();
    _lastUserPosition = null;
  }

  /// Calcule la distance de manière asynchrone
  Future<double?> _calculateDistanceAsync(
    SiteGroup group,
    Position userPosition,
  ) async {
    if (group.geom == null || group.geom!.isEmpty) {
      return null;
    }

    try {
      // Utiliser un Isolate pour les calculs complexes afin d'éviter le blocage du thread principal
      final calculationData = _DistanceCalculationData(
        geomJson: group.geom!,
        userLatitude: userPosition.latitude,
        userLongitude: userPosition.longitude,
      );

      // Pour des calculs simples (Point), on peut les faire directement
      final geomData = jsonDecode(group.geom!);
      if (geomData is Map<String, dynamic> && geomData['type'] == 'Point') {
        final coordinates = geomData['coordinates'] as List;
        if (coordinates.length >= 2) {
          return Geolocator.distanceBetween(
            userPosition.latitude,
            userPosition.longitude,
            coordinates[1].toDouble(),
            coordinates[0].toDouble(),
          );
        }
      }

      // Pour des géométries complexes (Polygon, MultiPolygon), utiliser compute
      return await compute(_calculateDistanceInIsolate, calculationData);
    } catch (e) {
      print('Erreur lors du calcul de distance pour le groupe ${group.idSitesGroup}: $e');
      return null;
    }
  }

  /// Vérifie si la position a significativement changé (plus de 10 mètres)
  bool _hasPositionChanged(Position oldPosition, Position newPosition) {
    final distance = Geolocator.distanceBetween(
      oldPosition.latitude,
      oldPosition.longitude,
      newPosition.latitude,
      newPosition.longitude,
    );
    return distance > 10.0; // Seuil de 10 mètres
  }
}

/// Fonction statique pour calculer la distance dans un isolate
double? _calculateDistanceInIsolate(_DistanceCalculationData data) {
  try {
    final geomData = jsonDecode(data.geomJson);
    
    if (geomData is Map<String, dynamic>) {
      final type = geomData['type'];
      final coordinates = geomData['coordinates'];

      if (type == 'Polygon' && coordinates is List) {
        return _calculateDistanceToPolygon(
          data.userLatitude,
          data.userLongitude,
          coordinates,
        );
      } else if (type == 'MultiPolygon' && coordinates is List) {
        double? minDistance;
        for (var polygon in coordinates) {
          if (polygon is List && polygon.isNotEmpty) {
            final distance = _calculateDistanceToPolygon(
              data.userLatitude,
              data.userLongitude,
              polygon,
            );
            if (distance != null) {
              if (minDistance == null || distance < minDistance) {
                minDistance = distance;
              }
              if (distance == 0) {
                return 0;
              }
            }
          }
        }
        return minDistance;
      }
    }

    return null;
  } catch (e) {
    return null;
  }
}

/// Calcule la distance d'un point à un polygone GeoJSON
double? _calculateDistanceToPolygon(
  double lat,
  double lon,
  List coordinates,
) {
  if (coordinates.isEmpty || coordinates[0] is! List) {
    return null;
  }

  final outerRing = coordinates[0] as List;
  if (outerRing.isEmpty) {
    return null;
  }

  // Convertir les coordonnées du polygone
  final List<pip.Point> polygonPoints = [];
  for (int i = 0; i < outerRing.length; i++) {
    var coord = outerRing[i];
    if (coord is List && coord.length >= 2) {
      final point = pip.Point(x: coord[0].toDouble(), y: coord[1].toDouble());

      // Ignorer le dernier point s'il est identique au premier
      if (i == outerRing.length - 1 && polygonPoints.isNotEmpty) {
        final firstPoint = polygonPoints.first;
        if ((point.x - firstPoint.x).abs() < 1e-10 &&
            (point.y - firstPoint.y).abs() < 1e-10) {
          break;
        }
      }

      polygonPoints.add(point);
    }
  }

  if (polygonPoints.isEmpty) {
    return null;
  }

  // Vérifier si le point est à l'intérieur du polygone
  final isInside = _isPointInPolygonRobust(lat, lon, polygonPoints);

  if (isInside) {
    return 0.0;
  }

  // Calculer la distance minimale à chaque segment du polygone
  double minDistance = double.infinity;
  for (int i = 0; i < polygonPoints.length; i++) {
    final p1 = polygonPoints[i];
    final p2 = polygonPoints[(i + 1) % polygonPoints.length];

    final distance = _distanceToSegment(lat, lon, p1.y, p1.x, p2.y, p2.x);
    if (distance < minDistance) {
      minDistance = distance;
    }
  }

  return minDistance.isFinite ? minDistance : null;
}

/// Vérifie si un point est à l'intérieur d'un polygone (algorithme ray casting)
bool _isPointInPolygonRobust(
  double lat,
  double lon,
  List<pip.Point> polygon,
) {
  if (polygon.length < 3) {
    return false;
  }

  bool inside = false;
  int j = polygon.length - 1;

  for (int i = 0; i < polygon.length; i++) {
    final xi = polygon[i].x;
    final yi = polygon[i].y;
    final xj = polygon[j].x;
    final yj = polygon[j].y;

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

/// Calcule la distance d'un point à un segment de ligne
double _distanceToSegment(
  double lat,
  double lon,
  double lat1,
  double lon1,
  double lat2,
  double lon2,
) {
  final dx = lon2 - lon1;
  final dy = lat2 - lat1;

  if (dx == 0 && dy == 0) {
    return Geolocator.distanceBetween(lat, lon, lat1, lon1);
  }

  final px = lon - lon1;
  final py = lat - lat1;

  final t = (px * dx + py * dy) / (dx * dx + dy * dy);
  final clampedT = t.clamp(0.0, 1.0);

  final closestLon = lon1 + clampedT * dx;
  final closestLat = lat1 + clampedT * dy;

  return Geolocator.distanceBetween(lat, lon, closestLat, closestLon);
}

/// Données nécessaires pour le calcul de distance dans un isolate
class _DistanceCalculationData {
  final String geomJson;
  final double userLatitude;
  final double userLongitude;

  const _DistanceCalculationData({
    required this.geomJson,
    required this.userLatitude,
    required this.userLongitude,
  });
}