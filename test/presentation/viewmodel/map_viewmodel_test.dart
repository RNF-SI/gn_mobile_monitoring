import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/data/service/geojson_parser_service_impl.dart';
import 'package:gn_mobile_monitoring/data/service/map_geometry_service_impl.dart';
import 'package:gn_mobile_monitoring/domain/model/map_feature.dart';
import 'package:gn_mobile_monitoring/domain/model/site_complement.dart';
import 'package:gn_mobile_monitoring/domain/service/geojson_parser_service.dart';
import 'package:gn_mobile_monitoring/domain/service/map_geometry_service.dart';
import 'package:gn_mobile_monitoring/domain/usecase/find_feature_at_point_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/find_feature_at_point_use_case_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_site_complements_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_user_location_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/load_map_features_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/load_map_features_use_case_impl.dart';
import 'package:gn_mobile_monitoring/domain/usecase/load_map_tile_layers_use_case.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/map_viewmodel.dart';
import 'package:latlong2/latlong.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'map_viewmodel_test.mocks.dart';

@GenerateMocks([
  LoadMapTileLayersUseCase,
  GetUserLocationUseCase,
  GetSiteComplementsUseCase,
])
void main() {
  late MockLoadMapTileLayersUseCase mockLoadTileLayersUseCase;
  late MockGetUserLocationUseCase mockGetUserLocationUseCase;
  late MockGetSiteComplementsUseCase mockGetSiteComplementsUseCase;
  late LoadMapFeaturesUseCase loadMapFeaturesUseCase;
  late FindFeatureAtPointUseCase findFeatureAtPointUseCase;
  late MapGeometryService mapGeometryService;

  setUp(() {
    mockLoadTileLayersUseCase = MockLoadMapTileLayersUseCase();
    mockGetUserLocationUseCase = MockGetUserLocationUseCase();
    mockGetSiteComplementsUseCase = MockGetSiteComplementsUseCase();

    // Use real implementations for parsing and geometry
    const geoJsonParser = GeoJsonParserServiceImpl();
    loadMapFeaturesUseCase = const LoadMapFeaturesUseCaseImpl(geoJsonParser);
    mapGeometryService = const MapGeometryServiceImpl();
    findFeatureAtPointUseCase =
        FindFeatureAtPointUseCaseImpl(mapGeometryService);

    // Default mock behavior
    when(mockLoadTileLayersUseCase.execute()).thenAnswer((_) async => [
          const TileLayerConfig(
            name: 'OpenStreetMap',
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            attribution: 'OSM',
          ),
        ]);

    when(mockGetUserLocationUseCase.execute()).thenAnswer((_) async => null);
    when(mockGetUserLocationUseCase.watchPosition())
        .thenAnswer((_) => const Stream.empty());

    when(mockGetSiteComplementsUseCase.executeForSites(any))
        .thenAnswer((_) async => <int, SiteComplement?>{});
  });

  MapViewModel createViewModel({String? geoJsonData}) {
    return MapViewModel(
      loadMapFeaturesUseCase: loadMapFeaturesUseCase,
      loadMapTileLayersUseCase: mockLoadTileLayersUseCase,
      getUserLocationUseCase: mockGetUserLocationUseCase,
      findFeatureAtPointUseCase: findFeatureAtPointUseCase,
      mapGeometryService: mapGeometryService,
      getSiteComplementsUseCase: mockGetSiteComplementsUseCase,
      params: MapViewModelParams(geoJsonData: geoJsonData),
    );
  }

  group('MapViewModel', () {
    test('should start with loading state', () {
      final viewModel = createViewModel();
      expect(viewModel.state.isLoading, isTrue);
      viewModel.dispose();
    });

    test('should load tile layers on initialization', () async {
      final viewModel = createViewModel();

      // Wait for async initialization
      await Future.delayed(const Duration(milliseconds: 100));

      expect(viewModel.state.tileLayers, hasLength(1));
      expect(viewModel.state.tileLayers.first.name, equals('OpenStreetMap'));
      expect(viewModel.state.selectedLayer, isNotNull);

      viewModel.dispose();
    });

    test('should parse features from GeoJSON data', () async {
      final geoJson = jsonEncode([
        {
          'id': 1,
          'name': 'Test Site',
          'geom': {
            'type': 'Point',
            'coordinates': [2.35, 48.85],
          },
        },
      ]);

      final viewModel = createViewModel(geoJsonData: geoJson);

      // Wait for async initialization
      await Future.delayed(const Duration(milliseconds: 100));

      expect(viewModel.state.features, hasLength(1));
      expect(viewModel.state.features.first, isA<MapPointFeature>());
      expect(viewModel.state.isLoading, isFalse);

      viewModel.dispose();
    });

    test('should handle empty GeoJSON data', () async {
      final viewModel = createViewModel(geoJsonData: null);

      await Future.delayed(const Duration(milliseconds: 100));

      expect(viewModel.state.features, isEmpty);
      expect(viewModel.state.isLoading, isFalse);

      viewModel.dispose();
    });

    test('should select tile layer', () async {
      final viewModel = createViewModel();

      await Future.delayed(const Duration(milliseconds: 100));

      final newLayer = const TileLayerConfig(
        name: 'Satellite',
        urlTemplate: 'https://satellite.example.com/{z}/{x}/{y}.png',
      );

      viewModel.selectTileLayer(newLayer);

      expect(viewModel.state.selectedLayer, equals(newLayer));

      viewModel.dispose();
    });

    test('should track user moved map', () async {
      final viewModel = createViewModel();

      await Future.delayed(const Duration(milliseconds: 100));

      expect(viewModel.state.userMovedMap, isFalse);

      viewModel.onUserMovedMap();

      expect(viewModel.state.userMovedMap, isTrue);

      viewModel.dispose();
    });

    test('should reset user moved map', () async {
      final viewModel = createViewModel();

      await Future.delayed(const Duration(milliseconds: 100));

      viewModel.onUserMovedMap();
      expect(viewModel.state.userMovedMap, isTrue);

      viewModel.resetUserMovedMap();

      expect(viewModel.state.userMovedMap, isFalse);
      expect(viewModel.state.hasAutoCentered, isTrue);

      viewModel.dispose();
    });

    test('should find feature at point', () async {
      final geoJson = jsonEncode([
        {
          'id': 1,
          'name': 'Test Site',
          'geom': {
            'type': 'Point',
            'coordinates': [2.35, 48.85],
          },
        },
      ]);

      final viewModel = createViewModel(geoJsonData: geoJson);

      await Future.delayed(const Duration(milliseconds: 100));

      final feature = viewModel.findFeatureAtPoint(const LatLng(48.85, 2.35));

      expect(feature, isNotNull);
      expect(feature, isA<MapPointFeature>());
      expect((feature as MapPointFeature).siteId, equals(1));

      viewModel.dispose();
    });

    test('should return null when no feature at point', () async {
      final geoJson = jsonEncode([
        {
          'id': 1,
          'name': 'Test Site',
          'geom': {
            'type': 'Point',
            'coordinates': [2.35, 48.85],
          },
        },
      ]);

      final viewModel = createViewModel(geoJsonData: geoJson);

      await Future.delayed(const Duration(milliseconds: 100));

      final feature = viewModel.findFeatureAtPoint(const LatLng(50.0, 5.0));

      expect(feature, isNull);

      viewModel.dispose();
    });

    test('should compute centroid of all features', () async {
      final geoJson = jsonEncode([
        {
          'id': 1,
          'geom': {
            'type': 'Point',
            'coordinates': [2.0, 48.0],
          },
        },
        {
          'id': 2,
          'geom': {
            'type': 'Point',
            'coordinates': [4.0, 50.0],
          },
        },
      ]);

      final viewModel = createViewModel(geoJsonData: geoJson);

      await Future.delayed(const Duration(milliseconds: 100));

      final centroid = viewModel.computeCentroid();

      expect(centroid, isNotNull);
      expect(centroid!.latitude, closeTo(49.0, 0.001));
      expect(centroid.longitude, closeTo(3.0, 0.001));

      viewModel.dispose();
    });

    test('should compute global bounds of all features', () async {
      final geoJson = jsonEncode([
        {
          'id': 1,
          'geom': {
            'type': 'Point',
            'coordinates': [2.0, 48.0],
          },
        },
        {
          'id': 2,
          'geom': {
            'type': 'Point',
            'coordinates': [4.0, 50.0],
          },
        },
      ]);

      final viewModel = createViewModel(geoJsonData: geoJson);

      await Future.delayed(const Duration(milliseconds: 100));

      final bounds = viewModel.computeGlobalBounds();

      expect(bounds, isNotNull);
      expect(bounds!.southWest.latitude, closeTo(48.0, 0.001));
      expect(bounds.southWest.longitude, closeTo(2.0, 0.001));
      expect(bounds.northEast.latitude, closeTo(50.0, 0.001));
      expect(bounds.northEast.longitude, closeTo(4.0, 0.001));

      viewModel.dispose();
    });

    test('should update user position from location service', () async {
      final locationResult = UserLocationResult(
        position: const LatLng(48.85, 2.35),
        accuracy: 10.0,
      );

      when(mockGetUserLocationUseCase.execute())
          .thenAnswer((_) async => locationResult);

      final viewModel = createViewModel();

      await Future.delayed(const Duration(milliseconds: 100));

      expect(viewModel.state.userPosition, isNotNull);
      expect(viewModel.state.userPosition!.latitude, closeTo(48.85, 0.001));
      expect(viewModel.state.userAccuracy, equals(10.0));

      viewModel.dispose();
    });

    test('should provide point features accessor', () async {
      final geoJson = jsonEncode([
        {
          'id': 1,
          'geom': {
            'type': 'Point',
            'coordinates': [2.35, 48.85],
          },
        },
        {
          'id': 2,
          'geom': {
            'type': 'LineString',
            'coordinates': [
              [2.35, 48.85],
              [2.36, 48.86],
            ],
          },
        },
      ]);

      final viewModel = createViewModel(geoJsonData: geoJson);

      await Future.delayed(const Duration(milliseconds: 100));

      expect(viewModel.state.pointFeatures, hasLength(1));
      expect(viewModel.state.polylineFeatures, hasLength(1));

      viewModel.dispose();
    });
  });
}
