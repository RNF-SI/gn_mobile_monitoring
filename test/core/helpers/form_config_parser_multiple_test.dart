import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/core/helpers/form_config_parser.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';

void main() {
  group('FormConfigParser - Multiple property handling', () {
    test('should preserve multiple property in unified schema for nomenclature fields', () {
      // Configuration similaire à methode_de_prospection du POPamphibien
      final objectConfig = ObjectConfig(
        generic: {},
        specific: {
          'methode_de_prospection': {
            'type_widget': 'datalist',
            'attribut_label': 'Méthode(s) de prospection',
            'api': 'nomenclatures/nomenclature/METHODE_PROSPECTION',
            'application': 'GeoNature',
            'keyValue': 'id_nomenclature',
            'keyLabel': 'label_fr',
            'multiple': true,
            'data_path': 'values',
            'type_util': 'nomenclature',
            'required': true,
          }
        },
      );

      final unifiedSchema = FormConfigParser.generateUnifiedSchema(
        objectConfig,
        null,
      );

      // Vérifier que le champ est présent
      expect(unifiedSchema.containsKey('methode_de_prospection'), true);

      final fieldConfig = unifiedSchema['methode_de_prospection'];

      // Vérifier que la propriété multiple est préservée
      expect(fieldConfig['multiple'], true);

      // Vérifier que le widget type est NomenclatureSelector
      expect(fieldConfig['widget_type'], 'NomenclatureSelector');

      // Vérifier que les autres propriétés sont présentes
      expect(fieldConfig['api'], 'nomenclatures/nomenclature/METHODE_PROSPECTION');
      expect(fieldConfig['type_util'], 'nomenclature');
      expect(fieldConfig['required'], true);
    });

    test('should preserve multiple: false in unified schema', () {
      final objectConfig = ObjectConfig(
        generic: {},
        specific: {
          'test_field': {
            'type_widget': 'datalist',
            'attribut_label': 'Test',
            'api': 'nomenclatures/nomenclature/TEST',
            'multiple': false,
            'type_util': 'nomenclature',
          }
        },
      );

      final unifiedSchema = FormConfigParser.generateUnifiedSchema(
        objectConfig,
        null,
      );

      final fieldConfig = unifiedSchema['test_field'];
      expect(fieldConfig['multiple'], false);
    });

    test('should not include multiple property when not specified', () {
      final objectConfig = ObjectConfig(
        generic: {},
        specific: {
          'test_field': {
            'type_widget': 'datalist',
            'attribut_label': 'Test',
            'api': 'nomenclatures/nomenclature/TEST',
            'type_util': 'nomenclature',
          }
        },
      );

      final unifiedSchema = FormConfigParser.generateUnifiedSchema(
        objectConfig,
        null,
      );

      final fieldConfig = unifiedSchema['test_field'];
      // La propriété ne devrait pas exister si elle n'est pas définie
      expect(fieldConfig.containsKey('multiple'), false);
    });

    test('should handle multiple property for regular select fields', () {
      final objectConfig = ObjectConfig(
        generic: {},
        specific: {
          'test_select': {
            'type_widget': 'select',
            'attribut_label': 'Test Select',
            'values': ['Option 1', 'Option 2', 'Option 3'],
            'multiple': true,
          }
        },
      );

      final unifiedSchema = FormConfigParser.generateUnifiedSchema(
        objectConfig,
        null,
      );

      final fieldConfig = unifiedSchema['test_select'];
      expect(fieldConfig['multiple'], true);
      expect(fieldConfig['widget_type'], 'DropdownButton');
    });

    test('should merge multiple property from specific config', () {
      final objectConfig = ObjectConfig(
        generic: {},
        specific: {
          'test_field': {
            'type_widget': 'datalist',
            'attribut_label': 'Test',
            'api': 'nomenclatures/nomenclature/TEST',
            'type_util': 'nomenclature',
            'multiple': true,
            'required': true,
          }
        },
      );

      final unifiedSchema = FormConfigParser.generateUnifiedSchema(
        objectConfig,
        null,
      );

      final fieldConfig = unifiedSchema['test_field'];
      // La propriété multiple de specific devrait être fusionnée
      expect(fieldConfig['multiple'], true);
      expect(fieldConfig['required'], true);
    });
  });
}
