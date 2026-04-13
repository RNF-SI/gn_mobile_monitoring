import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/data/service/map_geometry_service_impl.dart';
import 'package:gn_mobile_monitoring/domain/model/map_feature.dart';
import 'package:gn_mobile_monitoring/domain/usecase/find_feature_at_point_use_case_impl.dart';
import 'package:latlong2/latlong.dart';

void main() {
  late FindFeatureAtPointUseCaseImpl useCase;

  setUp(() {
    useCase = const FindFeatureAtPointUseCaseImpl(MapGeometryServiceImpl());
  });

  group('FindFeatureAtPointUseCase', () {
    group('Point features', () {
      test('should find point feature when tap is close enough', () {
        final features = [
          const MapFeature.point(
            point: LatLng(48.85, 2.35),
            properties: {'name': 'Test Point'},
            siteId: 1,
          ),
        ];

        final result = useCase.execute(
          tappedPoint: const LatLng(48.8501, 2.3501),
          features: features,
          markerThresholdDegrees: 0.001,
        );

        expect(result, isNotNull);
        expect(result, isA<MapPointFeature>());
        expect((result as MapPointFeature).siteId, equals(1));
      });

      test('should return null when tap is too far from point', () {
        final features = [
          const MapFeature.point(
            point: LatLng(48.85, 2.35),
            properties: {'name': 'Test Point'},
            siteId: 1,
          ),
        ];

        final result = useCase.execute(
          tappedPoint: const LatLng(48.90, 2.40),
          features: features,
          markerThresholdDegrees: 0.0005,
        );

        expect(result, isNull);
      });

      test('should find closest point when multiple points are nearby', () {
        final features = [
          const MapFeature.point(
            point: LatLng(48.85, 2.35),
            properties: {'name': 'Point 1'},
            siteId: 1,
          ),
          const MapFeature.point(
            point: LatLng(48.851, 2.351),
            properties: {'name': 'Point 2'},
            siteId: 2,
          ),
        ];

        final result = useCase.execute(
          tappedPoint: const LatLng(48.8509, 2.3509),
          features: features,
          markerThresholdDegrees: 0.01,
        );

        expect(result, isNotNull);
        expect((result as MapPointFeature).siteId, equals(2));
      });
    });

    group('Polygon features', () {
      test('should find polygon when tap is inside', () {
        final features = [
          const MapFeature.polygon(
            points: [
              LatLng(48.85, 2.35),
              LatLng(48.85, 2.36),
              LatLng(48.86, 2.36),
              LatLng(48.86, 2.35),
              LatLng(48.85, 2.35),
            ],
            properties: {'name': 'Test Polygon'},
            siteId: 1,
          ),
        ];

        final result = useCase.execute(
          tappedPoint: const LatLng(48.855, 2.355),
          features: features,
        );

        expect(result, isNotNull);
        expect(result, isA<MapPolygonFeature>());
        expect((result as MapPolygonFeature).siteId, equals(1));
      });

      test('should return null when tap is outside polygon', () {
        final features = [
          const MapFeature.polygon(
            points: [
              LatLng(48.85, 2.35),
              LatLng(48.85, 2.36),
              LatLng(48.86, 2.36),
              LatLng(48.86, 2.35),
              LatLng(48.85, 2.35),
            ],
            properties: {'name': 'Test Polygon'},
            siteId: 1,
          ),
        ];

        final result = useCase.execute(
          tappedPoint: const LatLng(48.87, 2.37),
          features: features,
        );

        expect(result, isNull);
      });
    });

    group('Polyline features', () {
      test('should find polyline when tap is close to line', () {
        final features = [
          const MapFeature.polyline(
            points: [
              LatLng(48.85, 2.35),
              LatLng(48.86, 2.36),
            ],
            properties: {'name': 'Test Line'},
            siteId: 1,
          ),
        ];

        // Tap close to the midpoint of the line
        final result = useCase.execute(
          tappedPoint: const LatLng(48.855, 2.355),
          features: features,
          lineThresholdMeters: 100.0,
        );

        expect(result, isNotNull);
        expect(result, isA<MapPolylineFeature>());
        expect((result as MapPolylineFeature).siteId, equals(1));
      });

      test('should return null when tap is too far from polyline', () {
        final features = [
          const MapFeature.polyline(
            points: [
              LatLng(48.85, 2.35),
              LatLng(48.86, 2.36),
            ],
            properties: {'name': 'Test Line'},
            siteId: 1,
          ),
        ];

        final result = useCase.execute(
          tappedPoint: const LatLng(48.90, 2.40),
          features: features,
          lineThresholdMeters: 50.0,
        );

        expect(result, isNull);
      });
    });

    group('Priority order', () {
      test('should prioritize polygon over polyline and point', () {
        final features = [
          const MapFeature.point(
            point: LatLng(48.855, 2.355),
            properties: {'name': 'Point'},
            siteId: 1,
          ),
          const MapFeature.polyline(
            points: [
              LatLng(48.85, 2.35),
              LatLng(48.86, 2.36),
            ],
            properties: {'name': 'Line'},
            siteId: 2,
          ),
          const MapFeature.polygon(
            points: [
              LatLng(48.85, 2.35),
              LatLng(48.85, 2.36),
              LatLng(48.86, 2.36),
              LatLng(48.86, 2.35),
              LatLng(48.85, 2.35),
            ],
            properties: {'name': 'Polygon'},
            siteId: 3,
          ),
        ];

        final result = useCase.execute(
          tappedPoint: const LatLng(48.855, 2.355),
          features: features,
          markerThresholdDegrees: 0.01,
          lineThresholdMeters: 500.0,
        );

        expect(result, isNotNull);
        expect(result, isA<MapPolygonFeature>());
        expect((result as MapPolygonFeature).siteId, equals(3));
      });

      test('should prioritize label centroids over other features', () {
        final polygonFeature = const MapFeature.polygon(
          points: [
            LatLng(48.85, 2.35),
            LatLng(48.85, 2.36),
            LatLng(48.86, 2.36),
            LatLng(48.86, 2.35),
            LatLng(48.85, 2.35),
          ],
          properties: {'name': 'Polygon'},
          siteId: 1,
        );

        final labelCentroids = <LatLng, MapFeature>{
          const LatLng(48.855, 2.355): polygonFeature,
        };

        final pointFeature = const MapFeature.point(
          point: LatLng(48.855, 2.355),
          properties: {'name': 'Point'},
          siteId: 2,
        );

        final result = useCase.execute(
          tappedPoint: const LatLng(48.855, 2.355),
          features: [pointFeature, polygonFeature],
          labelCentroids: labelCentroids,
          markerThresholdDegrees: 0.01,
        );

        expect(result, isNotNull);
        expect(result, isA<MapPolygonFeature>());
        expect((result as MapPolygonFeature).siteId, equals(1));
      });
    });

    group('Empty features', () {
      test('should return null for empty features list', () {
        final result = useCase.execute(
          tappedPoint: const LatLng(48.85, 2.35),
          features: [],
        );

        expect(result, isNull);
      });
    });
  });
}
