import 'package:latlong2/latlong.dart';

/// Service pour les calculs géométriques de la carte
/// Contient la logique métier pour les opérations géométriques
abstract class MapGeometryService {
  /// Calcule le centroïde d'une liste de points
  LatLng calculateCentroid(List<LatLng> points);

  /// Calcule les bornes globales d'une liste de points
  LatLngBounds? computeBounds(List<LatLng> points);

  /// Vérifie si un point est à l'intérieur d'un polygone (ray casting)
  bool isPointInPolygon(LatLng point, List<LatLng> polygonPoints);

  /// Retourne `true` si le polygone défini par [vertices] est simple (pas
  /// d'auto-intersection). Les sommets doivent être dans l'ordre de dessin,
  /// sans répéter le point de fermeture : le segment de retour du dernier
  /// vers le premier sommet est testé implicitement.
  ///
  /// Un polygone auto-intersecté fait échouer les triggers PostGIS côté
  /// serveur (erreur `TopologyException: side location conflict`), d'où
  /// la nécessité de valider avant l'envoi.
  bool isPolygonSimple(List<LatLng> vertices);

  /// Calcule la distance minimale d'un point à une ligne
  double distanceToLine(LatLng point, List<LatLng> linePoints);

  /// Calcule la distance (en mètres) entre [point] et la géométrie GeoJSON
  /// sérialisée dans [geoJson]. Supporte les types Point, LineString, Polygon,
  /// MultiPoint, MultiLineString et MultiPolygon. Retourne `0` quand [point]
  /// est à l'intérieur d'un polygone. Retourne `null` si la chaîne est
  /// invalide, si le type n'est pas supporté, ou si la géométrie est vide.
  double? distanceToGeoJson(String geoJson, LatLng point);

  /// Calcule la distance d'un point à un segment de ligne
  double distanceToSegment(
    double lat,
    double lon,
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  );

  /// Calcule la distance entre deux points en mètres
  double distanceBetween(LatLng point1, LatLng point2);

  /// Vérifie si un point est proche d'une cible (dans un rayon donné)
  bool isPointNearTarget(LatLng point, LatLng target, double thresholdDegrees);
}

/// Représente les bornes géographiques
class LatLngBounds {
  final LatLng southWest;
  final LatLng northEast;

  const LatLngBounds({
    required this.southWest,
    required this.northEast,
  });

  /// Crée des bornes à partir d'une liste de points
  factory LatLngBounds.fromPoints(List<LatLng> points) {
    if (points.isEmpty) {
      throw ArgumentError('Points list cannot be empty');
    }

    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (final point in points) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    return LatLngBounds(
      southWest: LatLng(minLat, minLng),
      northEast: LatLng(maxLat, maxLng),
    );
  }

  /// Retourne le centre des bornes
  LatLng get center => LatLng(
        (southWest.latitude + northEast.latitude) / 2,
        (southWest.longitude + northEast.longitude) / 2,
      );
}
