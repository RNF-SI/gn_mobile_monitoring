import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';

void main() {
  group('ModuleConfiguration', () {
    test('should parse observation_detail in ModuleConfiguration', () {
      // Arrange
      final Map<String, dynamic> testJson = {
        'module': {
          'id_module': 1,
          'module_code': 'TEST',
        },
        'observation_detail': {
          'chained': true,
          'children_types': [],
          'description_field_name': 'id_observation_detail',
          'display_list': ['hauteur_strate', 'denombrement'],
          'display_properties': ['hauteur_strate', 'denombrement'],
          'specific': {
            'denombrement': {
              'attribut_label': 'Dénombrement',
              'min': 0,
              'type_widget': 'number'
            },
            'hauteur_strate': {
              'attribut_label': 'Strate',
              'type_widget': 'select',
              'values': ['entre 0 et 5 cm', 'entre 5 et 12,5 cm']
            }
          }
        }
      };

      // Act
      final result = ModuleConfiguration.fromJson(testJson);

      // Assert
      expect(result.observationDetail, isNotNull);
      expect(result.observationDetail!.specific!['hauteur_strate'], isNotNull);
      expect(result.observationDetail!.specific!['denombrement'], isNotNull);
    });

    test('should return null for observationDetail when not present', () {
      // Arrange
      final Map<String, dynamic> testJson = {
        'module': {
          'id_module': 1,
          'module_code': 'TEST',
        }
      };

      // Act
      final result = ModuleConfiguration.fromJson(testJson);

      // Assert
      expect(result.observationDetail, isNull);
    });

    test('toJson should include observationDetail when present', () {
      // Arrange
      final moduleConfig = ModuleConfiguration(
        module: ModuleConfig(idModule: 1),
        observationDetail: ObjectConfig(
          label: 'Observation détail',
          specific: {
            'hauteur_strate': {
              'attribut_label': 'Strate',
              'type_widget': 'select'
            }
          }
        )
      );

      // Act
      final json = moduleConfig.toJson();

      // Assert
      expect(json.containsKey('observation_detail'), isTrue);
      expect(json['observation_detail']['label'], 'Observation détail');
    });
  });

  group('ObjectConfig geometry_type', () {
    ObjectConfig parseSiteConfig(dynamic geometryTypeValue) {
      return ObjectConfig.fromJson({
        if (geometryTypeValue != null) 'geometry_type': geometryTypeValue,
      });
    }

    test('accepts a single string ("Point")', () {
      final config = parseSiteConfig('Point');
      expect(config.geometryType, ['Point']);
      expect(config.allowedGeometryTypes, ['Point']);
    });

    test('accepts a single string ("LineString") for transect modules', () {
      final config = parseSiteConfig('LineString');
      expect(config.geometryType, ['LineString']);
      expect(config.allowedGeometryTypes, ['LineString']);
    });

    test('accepts a list (generic default)', () {
      final config = parseSiteConfig(['Point', 'LineString', 'Polygon']);
      expect(config.geometryType, ['Point', 'LineString', 'Polygon']);
      expect(config.allowedGeometryTypes, ['Point', 'LineString', 'Polygon']);
    });

    test('null geometry_type defaults allowedGeometryTypes to [Point]', () {
      final config = parseSiteConfig(null);
      expect(config.geometryType, isNull);
      expect(config.allowedGeometryTypes, ['Point']);
    });

    test('empty string is treated as absent', () {
      final config = parseSiteConfig('');
      expect(config.geometryType, isNull);
      expect(config.allowedGeometryTypes, ['Point']);
    });

    test('empty list is treated as absent', () {
      final config = parseSiteConfig(<String>[]);
      expect(config.geometryType, isNull);
      expect(config.allowedGeometryTypes, ['Point']);
    });

    test('list entries are trimmed and empty entries dropped', () {
      final config = parseSiteConfig(['  Point  ', '', ' LineString']);
      expect(config.geometryType, ['Point', 'LineString']);
    });

    test('invalid type (e.g. int) falls back to null', () {
      final config = parseSiteConfig(42);
      expect(config.geometryType, isNull);
      expect(config.allowedGeometryTypes, ['Point']);
    });

    test('toJson re-emits the list as stored', () {
      final config = ObjectConfig(geometryType: const ['Point', 'LineString']);
      expect(config.toJson()['geometry_type'], ['Point', 'LineString']);
    });
  });
}