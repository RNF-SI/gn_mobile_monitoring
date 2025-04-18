import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/core/helpers/ts_to_dart_converter.dart';

void main() {
  group('TsToDartConverter', () {
    test('should convert simple property access expression', () {
      final input = '({value}) => value.test_detectabilite';
      final expected = '(value) => value[\'test_detectabilite\'] as bool';
      
      final result = TsToDartConverter.convertToDart(input);
      
      expect(result, expected);
    });
    
    test('should convert Object.keys expression', () {
      final input = '({meta}) => meta.dataset && Object.keys(meta.dataset).length == 1';
      final expected = '(meta) => meta[\'dataset\'] && (meta[\'dataset\'] as Map).keys.length == 1';
      
      final result = TsToDartConverter.convertToDart(input);
      
      expect(result, expected);
    });
    
    test('should handle complex expressions with multiple conditions', () {
      final input = '({meta, value}) => !meta.bChainInput && value.id_base_site';
      final expected = '(meta, value) => !meta[\'bChainInput\'] && value[\'id_base_site\'] as bool';
      
      final result = TsToDartConverter.convertToDart(input);
      
      expect(result, expected);
    });
  });
  
  group('extractHiddenFunctions', () {
    test('should extract hidden functions from configuration', () {
      final config = {
        'visit': {
          'generic': {
            'id_base_site': {
              'attribut_label': 'Site',
              'hidden': '({meta, value}) => !meta.bChainInput && value.id_base_site',
            }
          }
        },
        'module': {
          'specific': {
            'id_dataset': {
              'attribut_label': 'Jeu de données',
              'hidden': '({meta}) => meta.dataset && Object.keys(meta.dataset).length == 1',
            }
          }
        }
      };
      
      final result = extractHiddenFunctions(config);
      
      expect(result.length, 2);
      expect(result.containsKey('id_base_site'), true);
      expect(result.containsKey('id_dataset'), true);
      expect(result['id_base_site'], contains('(meta, value) =>'));
      expect(result['id_dataset'], contains('(meta) =>'));
    });
  });
}