import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gn_mobile_monitoring/domain/model/map_feature.dart';
import 'package:gn_mobile_monitoring/domain/model/site_complement.dart';
import 'package:gn_mobile_monitoring/domain/usecase/load_map_tile_layers_use_case.dart';
import 'package:latlong2/latlong.dart';

part 'map_state.freezed.dart';

/// État de la carte, géré par le MapViewModel.
@freezed
class MapState with _$MapState {
  const MapState._();

  const factory MapState({
    /// Liste des features à afficher sur la carte
    @Default([]) List<MapFeature> features,

    /// Liste des couches de tuiles disponibles
    @Default([]) List<TileLayerConfig> tileLayers,

    /// Couche de tuiles sélectionnée
    TileLayerConfig? selectedLayer,

    /// Position GPS de l'utilisateur
    LatLng? userPosition,

    /// Précision GPS en mètres
    double? userAccuracy,

    /// Indique si les données sont en cours de chargement
    @Default(false) bool isLoading,

    /// Indique si le recentrage automatique a déjà été effectué
    @Default(false) bool hasAutoCentered,

    /// Indique si l'utilisateur a bougé la carte manuellement
    @Default(false) bool userMovedMap,

    /// Message d'erreur éventuel
    String? errorMessage,

    /// Compléments de sites chargés (cache)
    @Default({}) Map<int, SiteComplement?> siteComplements,

    /// Centroids des labels pour les géométries (polygones/lignes)
    @Default({}) Map<LatLng, MapFeature> labelCentroids,
  }) = _MapState;

  /// État initial
  factory MapState.initial() => const MapState(isLoading: true);

  /// Retourne les features de type point
  List<MapPointFeature> get pointFeatures =>
      features.whereType<MapPointFeature>().toList();

  /// Retourne les features de type polyline
  List<MapPolylineFeature> get polylineFeatures =>
      features.whereType<MapPolylineFeature>().toList();

  /// Retourne les features de type polygon
  List<MapPolygonFeature> get polygonFeatures =>
      features.whereType<MapPolygonFeature>().toList();

  /// Vérifie si des features sont chargées
  bool get hasFeatures => features.isNotEmpty;

  /// Vérifie si la position utilisateur est connue
  bool get hasUserPosition => userPosition != null;
}
