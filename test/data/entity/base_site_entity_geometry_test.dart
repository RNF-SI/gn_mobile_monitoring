import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/data/entity/base_site_entity.dart';

void main() {
  group('BaseSiteEntity geometry parsing', () {
    test('should parse geometry from Map<String, dynamic> object', () {
      // Arrange - GeoJSON object comme retourné par l'API
      final geoJsonObject = {
        'type': 'Point',
        'coordinates': [2.123456, 46.789012]
      };
      
      final json = {
        'id_base_site': 1,
        'base_site_name': 'Test Site',
        'geometry': geoJsonObject,
      };

      // Act
      final entity = BaseSiteEntity.fromJson(json);

      // Assert
      expect(entity.geom, isNotNull);
      expect(entity.geom, equals(jsonEncode(geoJsonObject)));
      
      // Verify it can be parsed back to original object
      final parsedGeom = jsonDecode(entity.geom!);
      expect(parsedGeom, equals(geoJsonObject));
    });

    test('should parse geometry from JSON string', () {
      // Arrange - GeoJSON déjà encodé en string
      final geoJsonObject = {
        'type': 'Point',
        'coordinates': [2.123456, 46.789012]
      };
      final geoJsonString = jsonEncode(geoJsonObject);
      
      final json = {
        'id_base_site': 1,
        'base_site_name': 'Test Site',
        'geometry': geoJsonString,
      };

      // Act
      final entity = BaseSiteEntity.fromJson(json);

      // Assert
      expect(entity.geom, equals(geoJsonString));
    });

    test('should handle null geometry', () {
      // Arrange
      final json = {
        'id_base_site': 1,
        'base_site_name': 'Test Site',
        'geometry': null,
      };

      // Act
      final entity = BaseSiteEntity.fromJson(json);

      // Assert
      expect(entity.geom, isNull);
    });

    test('should handle missing geometry', () {
      // Arrange
      final json = {
        'id_base_site': 1,
        'base_site_name': 'Test Site',
      };

      // Act
      final entity = BaseSiteEntity.fromJson(json);

      // Assert
      expect(entity.geom, isNull);
    });

    test('should fallback to geom field when geometry is not present', () {
      // Arrange
      final geoJsonString = jsonEncode({
        'type': 'Point',
        'coordinates': [2.123456, 46.789012]
      });
      
      final json = {
        'id_base_site': 1,
        'base_site_name': 'Test Site',
        'geom': geoJsonString, // Utilise 'geom' au lieu de 'geometry'
      };

      // Act
      final entity = BaseSiteEntity.fromJson(json);

      // Assert
      expect(entity.geom, equals(geoJsonString));
    });

    test('should handle complex GeoJSON geometry', () {
      // Arrange - Polygon complexe
      final complexGeoJson = {
        'type': 'Polygon',
        'coordinates': [
          [
            [2.123456, 46.789012],
            [2.234567, 46.890123],
            [2.345678, 46.901234],
            [2.123456, 46.789012]
          ]
        ]
      };
      
      final json = {
        'id_base_site': 1,
        'base_site_name': 'Test Site',
        'geometry': complexGeoJson,
      };

      // Act
      final entity = BaseSiteEntity.fromJson(json);

      // Assert
      expect(entity.geom, isNotNull);
      final parsedGeom = jsonDecode(entity.geom!);
      expect(parsedGeom, equals(complexGeoJson));
    });
  });
}