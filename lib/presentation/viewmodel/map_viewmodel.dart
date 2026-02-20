import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/domain/domain_module.dart';
import 'package:gn_mobile_monitoring/domain/model/map_feature.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/domain/model/site_complement.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';
import 'package:gn_mobile_monitoring/domain/service/map_geometry_service.dart';
import 'package:gn_mobile_monitoring/domain/usecase/find_feature_at_point_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_user_location_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/load_map_features_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/load_map_tile_layers_use_case.dart';
import 'package:gn_mobile_monitoring/presentation/model/module_info.dart';
import 'package:gn_mobile_monitoring/presentation/state/map_state.dart';
import 'package:latlong2/latlong.dart';

/// Paramètres pour créer un MapViewModel
class MapViewModelParams {
  final String? geoJsonData;
  final List<String>? displayList;
  final ObjectConfig? siteConfig;
  final CustomConfig? customConfig;
  final ModuleInfo? moduleInfo;
  final SiteGroup? siteGroup;

  const MapViewModelParams({
    this.geoJsonData,
    this.displayList,
    this.siteConfig,
    this.customConfig,
    this.moduleInfo,
    this.siteGroup,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MapViewModelParams &&
          runtimeType == other.runtimeType &&
          geoJsonData == other.geoJsonData;

  @override
  int get hashCode => geoJsonData.hashCode;
}

/// Provider pour le MapViewModel
final mapViewModelProvider =
    StateNotifierProvider.family<MapViewModel, MapState, MapViewModelParams>(
  (ref, params) {
    final loadMapFeaturesUseCase = ref.watch(loadMapFeaturesUseCaseProvider);
    final loadMapTileLayersUseCase = ref.watch(loadMapTileLayersUseCaseProvider);
    final getUserLocationUseCase = ref.watch(getUserLocationUseCaseProvider);
    final findFeatureAtPointUseCase =
        ref.watch(findFeatureAtPointUseCaseProvider);
    final mapGeometryService = ref.watch(mapGeometryServiceProvider);
    final getSiteComplementsUseCase =
        ref.watch(getSiteComplementsUseCaseProvider);

    return MapViewModel(
      loadMapFeaturesUseCase: loadMapFeaturesUseCase,
      loadMapTileLayersUseCase: loadMapTileLayersUseCase,
      getUserLocationUseCase: getUserLocationUseCase,
      findFeatureAtPointUseCase: findFeatureAtPointUseCase,
      mapGeometryService: mapGeometryService,
      getSiteComplementsUseCase: getSiteComplementsUseCase,
      params: params,
    );
  },
);

/// ViewModel pour la carte.
/// Orchestre les use cases et gère l'état de la carte.
class MapViewModel extends StateNotifier<MapState> {
  final LoadMapFeaturesUseCase _loadMapFeaturesUseCase;
  final LoadMapTileLayersUseCase _loadMapTileLayersUseCase;
  final GetUserLocationUseCase _getUserLocationUseCase;
  final FindFeatureAtPointUseCase _findFeatureAtPointUseCase;
  final MapGeometryService _mapGeometryService;
  final dynamic _getSiteComplementsUseCase;
  final MapViewModelParams params;

  StreamSubscription<UserLocationResult>? _positionSubscription;
  bool _mounted = true;

  MapViewModel({
    required LoadMapFeaturesUseCase loadMapFeaturesUseCase,
    required LoadMapTileLayersUseCase loadMapTileLayersUseCase,
    required GetUserLocationUseCase getUserLocationUseCase,
    required FindFeatureAtPointUseCase findFeatureAtPointUseCase,
    required MapGeometryService mapGeometryService,
    required dynamic getSiteComplementsUseCase,
    required this.params,
  })  : _loadMapFeaturesUseCase = loadMapFeaturesUseCase,
        _loadMapTileLayersUseCase = loadMapTileLayersUseCase,
        _getUserLocationUseCase = getUserLocationUseCase,
        _findFeatureAtPointUseCase = findFeatureAtPointUseCase,
        _mapGeometryService = mapGeometryService,
        _getSiteComplementsUseCase = getSiteComplementsUseCase,
        super(MapState.initial()) {
    _initialize();
  }

  /// Initialise le ViewModel en chargeant les données
  Future<void> _initialize() async {
    await Future.wait([
      _loadTileLayers(),
      _loadFeatures(),
      _loadUserLocation(),
    ]);

    if (_mounted) {
      state = state.copyWith(isLoading: false);
      // Charger les compléments après les features
      _loadSiteComplements();
    }
  }

  /// Charge les couches de tuiles
  Future<void> _loadTileLayers() async {
    try {
      final tileLayers = await _loadMapTileLayersUseCase.execute();
      if (_mounted) {
        state = state.copyWith(
          tileLayers: tileLayers,
          selectedLayer: tileLayers.isNotEmpty ? tileLayers.first : null,
        );
      }
    } catch (e) {
      debugPrint('MapViewModel: Erreur chargement tile layers: $e');
    }
  }

  /// Charge les features depuis les données GeoJSON
  Future<void> _loadFeatures() async {
    try {
      final features = _loadMapFeaturesUseCase.execute(params.geoJsonData);
      final labelCentroids = _computeLabelCentroids(features);

      if (_mounted) {
        state = state.copyWith(
          features: features,
          labelCentroids: labelCentroids,
        );
      }
    } catch (e) {
      debugPrint('MapViewModel: Erreur chargement features: $e');
      if (_mounted) {
        state = state.copyWith(errorMessage: 'Erreur chargement des géométries');
      }
    }
  }

  /// Calcule les centroids pour les labels des polygones et polylines
  Map<LatLng, MapFeature> _computeLabelCentroids(List<MapFeature> features) {
    final centroids = <LatLng, MapFeature>{};

    for (final feature in features) {
      if (feature is MapPolygonFeature || feature is MapPolylineFeature) {
        final points = feature.allPoints;
        if (points.isNotEmpty) {
          final centroid = _mapGeometryService.calculateCentroid(points);
          centroids[centroid] = feature;
        }
      }
    }

    return centroids;
  }

  /// Charge la position utilisateur et démarre le tracking
  Future<void> _loadUserLocation() async {
    try {
      // Récupérer la position initiale
      final locationResult = await _getUserLocationUseCase.execute();
      if (locationResult != null && _mounted) {
        state = state.copyWith(
          userPosition: locationResult.position,
          userAccuracy: locationResult.accuracy,
        );
      }

      // Démarrer le tracking en continu
      _positionSubscription =
          _getUserLocationUseCase.watchPosition().listen((result) {
        if (_mounted) {
          state = state.copyWith(
            userPosition: result.position,
            userAccuracy: result.accuracy,
          );

          // Auto-centrage si nécessaire
          if (!state.hasAutoCentered && !state.userMovedMap) {
            state = state.copyWith(hasAutoCentered: true);
          }
        }
      });
    } catch (e) {
      debugPrint('MapViewModel: Erreur localisation: $e');
    }
  }

  /// Charge les compléments de sites pour enrichir les données
  Future<void> _loadSiteComplements() async {
    if (!_mounted) return;

    // Extraire les IDs de sites des features
    final siteIds = state.features
        .where((f) => f.featureSiteId != null)
        .map((f) => f.featureSiteId!)
        .toList();

    if (siteIds.isEmpty) return;

    try {
      final complements =
          await _getSiteComplementsUseCase.executeForSites(siteIds);
      if (_mounted) {
        state = state.copyWith(siteComplements: complements);
        // Enrichir les features avec les données des compléments
        _enrichFeaturesWithComplements(complements);
      }
    } catch (e) {
      debugPrint('MapViewModel: Erreur chargement compléments: $e');
    }
  }

  /// Enrichit les features avec les données des compléments
  void _enrichFeaturesWithComplements(Map<int, SiteComplement?> complements) {
    final enrichedFeatures = state.features.map((feature) {
      final siteId = feature.featureSiteId;
      if (siteId == null) return feature;

      final complement = complements[siteId];
      if (complement?.data == null) return feature;

      try {
        Map<String, dynamic> complementData = {};
        if (complement!.data is String) {
          complementData =
              Map<String, dynamic>.from(jsonDecode(complement.data as String));
        } else {
          complementData =
              Map<String, dynamic>.from(complement.data as Map);
        }

        // Fusionner les propriétés
        final mergedProperties = Map<String, dynamic>.from(feature.featureProperties);
        mergedProperties.addAll(complementData);

        // Créer une nouvelle feature avec les propriétés enrichies
        return switch (feature) {
          MapPointFeature(:final point, :final siteId) => MapFeature.point(
              point: point,
              properties: mergedProperties,
              siteId: siteId,
            ),
          MapPolylineFeature(:final points, :final siteId) => MapFeature.polyline(
              points: points,
              properties: mergedProperties,
              siteId: siteId,
            ),
          MapPolygonFeature(:final points, :final siteId) => MapFeature.polygon(
              points: points,
              properties: mergedProperties,
              siteId: siteId,
            ),
        };
      } catch (e) {
        debugPrint('MapViewModel: Erreur enrichissement feature $siteId: $e');
        return feature;
      }
    }).toList();

    if (_mounted) {
      state = state.copyWith(features: enrichedFeatures);
    }
  }

  /// Trouve une feature au point cliqué
  MapFeature? findFeatureAtPoint(LatLng tappedPoint) {
    return _findFeatureAtPointUseCase.execute(
      tappedPoint: tappedPoint,
      features: state.features,
      labelCentroids: state.labelCentroids,
    );
  }

  /// Change la couche de tuiles sélectionnée
  void selectTileLayer(TileLayerConfig layer) {
    if (_mounted) {
      state = state.copyWith(selectedLayer: layer);
    }
  }

  /// Marque que l'utilisateur a bougé la carte
  void onUserMovedMap() {
    if (_mounted && !state.userMovedMap) {
      state = state.copyWith(userMovedMap: true);
    }
  }

  /// Réinitialise le flag userMovedMap (pour recentrage manuel)
  void resetUserMovedMap() {
    if (_mounted) {
      state = state.copyWith(userMovedMap: false, hasAutoCentered: true);
    }
  }

  /// Calcule le centroïde de toutes les features
  LatLng? computeCentroid() {
    final allPoints = <LatLng>[];
    for (final feature in state.features) {
      allPoints.addAll(feature.allPoints);
    }
    if (allPoints.isEmpty) return null;
    return _mapGeometryService.calculateCentroid(allPoints);
  }

  /// Calcule les bornes globales de toutes les features
  LatLngBounds? computeGlobalBounds() {
    final allPoints = <LatLng>[];
    for (final feature in state.features) {
      allPoints.addAll(feature.allPoints);
    }
    if (allPoints.isEmpty) return null;
    return _mapGeometryService.computeBounds(allPoints);
  }

  @override
  void dispose() {
    _mounted = false;
    _positionSubscription?.cancel();
    super.dispose();
  }
}
