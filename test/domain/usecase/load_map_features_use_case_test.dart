import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/data/service/geojson_parser_service_impl.dart';
import 'package:gn_mobile_monitoring/domain/model/map_feature.dart';
import 'package:gn_mobile_monitoring/domain/usecase/load_map_features_use_case_impl.dart';

void main() {
  late LoadMapFeaturesUseCaseImpl useCase;

  setUp(() {
    useCase = const LoadMapFeaturesUseCaseImpl(GeoJsonParserServiceImpl());
  });

  group('LoadMapFeaturesUseCase', () {
    test('should return empty list for null input', () {
      final result = useCase.execute(null);
      expect(result, isEmpty);
    });

    test('should return empty list for empty string', () {
      final result = useCase.execute('');
      expect(result, isEmpty);
    });

    test('should parse Point features correctly', () {
      final geoJson = jsonEncode([
        {
          'id': 1,
          'name': 'Site 1',
          'geom': {
            'type': 'Point',
            'coordinates': [2.35, 48.85],
          },
        },
      ]);

      final result = useCase.execute(geoJson);

      expect(result, hasLength(1));
      expect(result.first, isA<MapPointFeature>());

      final feature = result.first as MapPointFeature;
      expect(feature.point.latitude, closeTo(48.85, 0.001));
      expect(feature.point.longitude, closeTo(2.35, 0.001));
      expect(feature.siteId, equals(1));
    });

    test('should parse LineString features correctly', () {
      final geoJson = jsonEncode([
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

      final result = useCase.execute(geoJson);

      expect(result, hasLength(1));
      expect(result.first, isA<MapPolylineFeature>());

      final feature = result.first as MapPolylineFeature;
      expect(feature.points, hasLength(2));
    });

    test('should parse Polygon features correctly', () {
      final geoJson = jsonEncode([
        {
          'id': 3,
          'geom': {
            'type': 'Polygon',
            'coordinates': [
              [
                [2.35, 48.85],
                [2.36, 48.85],
                [2.36, 48.86],
                [2.35, 48.85],
              ],
            ],
          },
        },
      ]);

      final result = useCase.execute(geoJson);

      expect(result, hasLength(1));
      expect(result.first, isA<MapPolygonFeature>());

      final feature = result.first as MapPolygonFeature;
      expect(feature.points, hasLength(4));
    });

    test('should parse mixed feature types', () {
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
        {
          'id': 3,
          'geom': {
            'type': 'Polygon',
            'coordinates': [
              [
                [2.35, 48.85],
                [2.36, 48.85],
                [2.36, 48.86],
                [2.35, 48.85],
              ],
            ],
          },
        },
      ]);

      final result = useCase.execute(geoJson);

      expect(result, hasLength(3));
      expect(result[0], isA<MapPointFeature>());
      expect(result[1], isA<MapPolylineFeature>());
      expect(result[2], isA<MapPolygonFeature>());
    });

    test('should handle malformed JSON gracefully', () {
      final result = useCase.execute('invalid json');
      expect(result, isEmpty);
    });
  });
}
