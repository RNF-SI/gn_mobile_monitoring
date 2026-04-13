import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';

part 'map_feature.freezed.dart';

/// Représente une feature géographique sur la carte.
/// Sealed class avec trois variantes : Point, Polyline, Polygon.
@freezed
sealed class MapFeature with _$MapFeature {
  /// Feature de type point (marker)
  const factory MapFeature.point({
    required LatLng point,
    required Map<String, dynamic> properties,
    int? siteId,
  }) = MapPointFeature;

  /// Feature de type ligne (polyline)
  const factory MapFeature.polyline({
    required List<LatLng> points,
    required Map<String, dynamic> properties,
    int? siteId,
  }) = MapPolylineFeature;

  /// Feature de type polygone
  const factory MapFeature.polygon({
    required List<LatLng> points,
    required Map<String, dynamic> properties,
    int? siteId,
  }) = MapPolygonFeature;
}

/// Extension pour faciliter l'accès aux propriétés communes
extension MapFeatureExtension on MapFeature {
  /// Retourne les propriétés de la feature
  Map<String, dynamic> get featureProperties => switch (this) {
        MapPointFeature(:final properties) => properties,
        MapPolylineFeature(:final properties) => properties,
        MapPolygonFeature(:final properties) => properties,
      };

  /// Retourne l'ID du site associé (si disponible)
  int? get featureSiteId => switch (this) {
        MapPointFeature(:final siteId) => siteId,
        MapPolylineFeature(:final siteId) => siteId,
        MapPolygonFeature(:final siteId) => siteId,
      };

  /// Retourne tous les points de la feature
  List<LatLng> get allPoints => switch (this) {
        MapPointFeature(:final point) => [point],
        MapPolylineFeature(:final points) => points,
        MapPolygonFeature(:final points) => points,
      };
}
