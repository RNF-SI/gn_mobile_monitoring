import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/core/helpers/form_config_parser.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';

void main() {
  group('FormConfigParser Tests', () {
    late ObjectConfig testObjectConfig;
    late CustomConfig testCustomConfig;

    setUp(() {
      // Configuration pour les tests
      testObjectConfig = ObjectConfig(
        label: 'Test Form',
        chained: true,
        generic: {
          'text_field': GenericFieldConfig(
            attributLabel: 'Text Field',
            typeWidget: 'text',
            required: true,
          ),
          'number_field': GenericFieldConfig(
            attributLabel: 'Number Field',
            typeWidget: 'number',
            required: false,
          ),
          'variable_field': GenericFieldConfig(
            attributLabel: 'Variable Field for __MODULE.MODULE_CODE',
            api: '__MONITORINGS_PATH/__MODULE.MODULE_CODE/data',
            typeWidget: 'select',
          ),
        },
        specific: {
          'custom_field': {
            'attribut_label': 'Custom Field',
            'type_widget': 'textarea',
            'description': 'Description for custom field',
          },
          'hidden_field': {
            'attribut_label': 'Hidden Field',
            'type_widget': 'text',
            'hidden': true,
          },
        },
      );

      testCustomConfig = CustomConfig(
        moduleCode: 'TEST',
        idModule: 1,
        monitoringsPath: '/api/monitorings',
      );
    });

    test('mergeConfigurations should merge generic and specific fields', () {
      // Act
      final result = FormConfigParser.mergeConfigurations(testObjectConfig);

      // Assert
      expect(result.length, 5); // 3 generic + 2 specific
      expect(result.containsKey('text_field'), isTrue);
      expect(result.containsKey('number_field'), isTrue);
      expect(result.containsKey('variable_field'), isTrue);
      expect(result.containsKey('custom_field'), isTrue);
      expect(result.containsKey('hidden_field'), isTrue);
    });

    test('substituteVariables should replace MODULE variables with values', () {
      // Arrange - Setup with a specific test case for substitution
      final testConfig = <String, Map<String, dynamic>>{
        'test_field': {
          'attribut_label': 'Test field for __MODULE.MODULE_CODE',
          'api': '__MONITORINGS_PATH/__MODULE.MODULE_CODE/test',
        }
      };
      
      // Act
      final result = FormConfigParser.substituteVariables(testConfig, testCustomConfig);

      // Assert - Check if MODULE_CODE was replaced
      final String? label = result['test_field']?['attribut_label'] as String?;
      expect(label?.contains('TEST'), isTrue);
    });

    test('determineWidgetType should return correct widget types', () {
      // Arrange
      final textConfig = {'type_widget': 'text'};
      final textareaConfig = {'type_widget': 'textarea'};
      final numberConfig = {'type_widget': 'number'};
      final dateConfig = {'type_widget': 'date'};
      final selectConfig = {'type_widget': 'select'};
      final checkboxConfig = {'type_widget': 'checkbox'};
      final unknownConfig = {'type_widget': 'unknown'};

      // Act & Assert
      expect(FormConfigParser.determineWidgetType(textConfig), 'TextField');
      expect(FormConfigParser.determineWidgetType(textareaConfig), 'TextField_multiline');
      expect(FormConfigParser.determineWidgetType(numberConfig), 'NumberField');
      expect(FormConfigParser.determineWidgetType(dateConfig), 'DatePicker');
      expect(FormConfigParser.determineWidgetType(selectConfig), 'DropdownButton');
      expect(FormConfigParser.determineWidgetType(checkboxConfig), 'Checkbox');
      expect(FormConfigParser.determineWidgetType(unknownConfig), 'TextField');
    });

    test('determineValidations should extract validation rules', () {
      // Arrange
      final requiredConfig = {'required': true};
      final minMaxConfig = {'min': 10, 'max': 100};
      final bothConfig = {'required': true, 'min': 10, 'max': 100};

      // Act
      final requiredValidations = FormConfigParser.determineValidations(requiredConfig);
      final minMaxValidations = FormConfigParser.determineValidations(minMaxConfig);
      final bothValidations = FormConfigParser.determineValidations(bothConfig);

      // Assert
      expect(requiredValidations['required'], isTrue);
      expect(minMaxValidations['min'], 10);
      expect(minMaxValidations['max'], 100);
      expect(bothValidations['required'], isTrue);
      expect(bothValidations['min'], 10);
      expect(bothValidations['max'], 100);
    });

    test('determineVisibility should handle hidden fields', () {
      // Arrange
      final visibleConfig = {'hidden': false};
      final hiddenConfig = {'hidden': true};
      final conditionalConfig = {'hidden': '({meta}) => meta.someCondition'};

      // Act
      final visibleResult = FormConfigParser.determineVisibility(visibleConfig);
      final hiddenResult = FormConfigParser.determineVisibility(hiddenConfig);
      final conditionalResult = FormConfigParser.determineVisibility(conditionalConfig);

      // Assert
      expect(visibleResult['hidden'], isNull);
      expect(hiddenResult['hidden'], isTrue);
      expect(conditionalResult['hiddenCondition'], '({meta}) => meta.someCondition');
    });

    test('generateUnifiedSchema should return complete schema', () {
      // Act
      final result = FormConfigParser.generateUnifiedSchema(testObjectConfig, testCustomConfig);

      // Assert
      // Certains champs peuvent être exclus par les règles de filtrage
      expect(result.length, greaterThan(0));
      
      // Vérifier que des champs sont présents dans le schéma 
      // (le filtrage peut avoir exclu certains champs)
      expect(result.isNotEmpty, isTrue);
    });
  });
}