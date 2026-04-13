import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/data/service/geojson_parser_service_impl.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/map_feature.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';
import 'package:latlong2/latlong.dart';

void main() {
  late GeoJsonParserServiceImpl service;

  setUp(() {
    service = const GeoJsonParserServiceImpl();
  });

  group('parseGeoJson', () {
    test('should return empty list for null input', () {
      final result = service.parseGeoJson(null);
      expect(result, isEmpty);
    });

    test('should return empty list for empty string', () {
      final result = service.parseGeoJson('');
      expect(result, isEmpty);
    });

    test('should return empty list for whitespace string', () {
      final result = service.parseGeoJson('   ');
      expect(result, isEmpty);
    });

    test('should return empty list for empty JSON array', () {
      final result = service.parseGeoJson('[]');
      expect(result, isEmpty);
    });

    test('should return empty list for malformed JSON', () {
      final result = service.parseGeoJson('not valid json');
      expect(result, isEmpty);
    });

    test('should parse Point feature correctly', () {
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

      final result = service.parseGeoJson(geoJson);

      expect(result, hasLength(1));
      expect(result.first, isA<MapPointFeature>());

      final pointFeature = result.first as MapPointFeature;
      expect(pointFeature.point.latitude, closeTo(48.85, 0.001));
      expect(pointFeature.point.longitude, closeTo(2.35, 0.001));
      expect(pointFeature.siteId, equals(1));
      expect(pointFeature.properties['name'], equals('Test Site'));
    });

    test('should parse LineString feature correctly', () {
      final geoJson = jsonEncode([
        {
          'id': 2,
          'name': 'Test Line',
          'geom': {
            'type': 'LineString',
            'coordinates': [
              [2.35, 48.85],
              [2.36, 48.86],
              [2.37, 48.87],
            ],
          },
        },
      ]);

      final result = service.parseGeoJson(geoJson);

      expect(result, hasLength(1));
      expect(result.first, isA<MapPolylineFeature>());

      final polylineFeature = result.first as MapPolylineFeature;
      expect(polylineFeature.points, hasLength(3));
      expect(polylineFeature.points[0].latitude, closeTo(48.85, 0.001));
      expect(polylineFeature.points[0].longitude, closeTo(2.35, 0.001));
      expect(polylineFeature.siteId, equals(2));
      expect(polylineFeature.properties['name'], equals('Test Line'));
    });

    test('should parse Polygon feature correctly', () {
      final geoJson = jsonEncode([
        {
          'id': 3,
          'name': 'Test Polygon',
          'geom': {
            'type': 'Polygon',
            'coordinates': [
              [
                [2.35, 48.85],
                [2.36, 48.85],
                [2.36, 48.86],
                [2.35, 48.86],
                [2.35, 48.85],
              ],
            ],
          },
        },
      ]);

      final result = service.parseGeoJson(geoJson);

      expect(result, hasLength(1));
      expect(result.first, isA<MapPolygonFeature>());

      final polygonFeature = result.first as MapPolygonFeature;
      expect(polygonFeature.points, hasLength(5));
      expect(polygonFeature.siteId, equals(3));
      expect(polygonFeature.properties['name'], equals('Test Polygon'));
    });

    test('should skip features without geom', () {
      final geoJson = jsonEncode([
        {
          'id': 1,
          'name': 'No Geom',
        },
        {
          'id': 2,
          'name': 'With Geom',
          'geom': {
            'type': 'Point',
            'coordinates': [2.35, 48.85],
          },
        },
      ]);

      final result = service.parseGeoJson(geoJson);

      expect(result, hasLength(1));
      expect((result.first as MapPointFeature).properties['name'],
          equals('With Geom'));
    });

    test('should parse multiple features of different types', () {
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

      final result = service.parseGeoJson(geoJson);

      expect(result, hasLength(3));
      expect(result[0], isA<MapPointFeature>());
      expect(result[1], isA<MapPolylineFeature>());
      expect(result[2], isA<MapPolygonFeature>());
    });

    test('should extract all properties except geom', () {
      final geoJson = jsonEncode([
        {
          'id': 1,
          'name': 'Test',
          'description': 'A test feature',
          'custom_field': 'custom_value',
          'geom': {
            'type': 'Point',
            'coordinates': [2.35, 48.85],
          },
        },
      ]);

      final result = service.parseGeoJson(geoJson);
      final properties = result.first.featureProperties;

      expect(properties['id'], equals(1));
      expect(properties['name'], equals('Test'));
      expect(properties['description'], equals('A test feature'));
      expect(properties['custom_field'], equals('custom_value'));
      expect(properties.containsKey('geom'), isFalse);
    });
  });

  group('sitesToGeoJson', () {
    test('should return null for empty list', () {
      final result = service.sitesToGeoJson([]);
      expect(result, isNull);
    });

    test('should return null for sites without geometry', () {
      final sites = [
        const BaseSite(idBaseSite: 1, baseSiteName: 'Site 1'),
        const BaseSite(idBaseSite: 2, baseSiteName: 'Site 2'),
      ];

      final result = service.sitesToGeoJson(sites);
      expect(result, isNull);
    });

    test('should convert site with Point geometry', () {
      final sites = [
        const BaseSite(
          idBaseSite: 1,
          baseSiteName: 'Test Site',
          baseSiteCode: 'TS1',
          baseSiteDescription: 'A test site',
          geom: '{"type":"Point","coordinates":[2.35,48.85]}',
        ),
      ];

      final result = service.sitesToGeoJson(sites);
      expect(result, isNotNull);

      final parsed = jsonDecode(result!) as List;
      expect(parsed, hasLength(1));
      expect(parsed[0]['id'], equals(1));
      expect(parsed[0]['name'], equals('Test Site'));
      expect(parsed[0]['base_site_name'], equals('Test Site'));
      expect(parsed[0]['base_site_code'], equals('TS1'));
      expect(parsed[0]['geom']['type'], equals('Point'));
    });

    test('should include data field in output', () {
      final sites = [
        const BaseSite(
          idBaseSite: 1,
          baseSiteName: 'Test Site',
          geom: '{"type":"Point","coordinates":[2.35,48.85]}',
          data: {'custom_field': 'custom_value'},
        ),
      ];

      final result = service.sitesToGeoJson(sites);
      final parsed = jsonDecode(result!) as List;

      expect(parsed[0]['custom_field'], equals('custom_value'));
    });
  });

  group('siteGroupsToGeoJson', () {
    test('should return null for empty list', () {
      final result = service.siteGroupsToGeoJson([]);
      expect(result, isNull);
    });

    test('should return null for groups without geometry', () {
      final groups = [
        const SiteGroup(idSitesGroup: 1, sitesGroupName: 'Group 1'),
        const SiteGroup(idSitesGroup: 2, sitesGroupName: 'Group 2'),
      ];

      final result = service.siteGroupsToGeoJson(groups);
      expect(result, isNull);
    });

    test('should convert group with Polygon geometry', () {
      final groups = [
        const SiteGroup(
          idSitesGroup: 1,
          sitesGroupName: 'Test Group',
          sitesGroupCode: 'TG1',
          sitesGroupDescription: 'A test group',
          altitudeMin: 100,
          altitudeMax: 500,
          geom:
              '{"type":"Polygon","coordinates":[[[2.35,48.85],[2.36,48.85],[2.36,48.86],[2.35,48.85]]]}',
        ),
      ];

      final result = service.siteGroupsToGeoJson(groups);
      expect(result, isNotNull);

      final parsed = jsonDecode(result!) as List;
      expect(parsed, hasLength(1));
      expect(parsed[0]['id'], equals(1));
      expect(parsed[0]['name'], equals('Test Group'));
      expect(parsed[0]['sites_group_name'], equals('Test Group'));
      expect(parsed[0]['sites_group_code'], equals('TG1'));
      expect(parsed[0]['altitude_min'], equals(100));
      expect(parsed[0]['altitude_max'], equals(500));
      expect(parsed[0]['geom']['type'], equals('Polygon'));
    });

    test('should include data field when it is a JSON string', () {
      final groups = [
        const SiteGroup(
          idSitesGroup: 1,
          sitesGroupName: 'Test Group',
          geom: '{"type":"Point","coordinates":[2.35,48.85]}',
          data: '{"custom_field":"custom_value"}',
        ),
      ];

      final result = service.siteGroupsToGeoJson(groups);
      final parsed = jsonDecode(result!) as List;

      expect(parsed[0]['custom_field'], equals('custom_value'));
    });
  });
}
