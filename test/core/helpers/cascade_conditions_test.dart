import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/core/helpers/hidden_expression_evaluator.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/form_data_processor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Mock pour Ref
class MockRef extends Fake implements Ref {}

void main() {
  group('Cascade Conditions Tests', () {
    late FormDataProcessor processor;
    late MockRef mockRef;

    setUp(() {
      mockRef = MockRef();
      processor = FormDataProcessor(mockRef);
    });

    test('Should cascade hide fields when parent field becomes hidden', () {
      // Configuration d'un scénario à 3 niveaux :
      // - fieldA : toujours visible
      // - fieldB : caché si fieldA == 'hide'
      // - fieldC : caché si fieldB est undefined/null
      final allFieldsConfig = {
        'fieldA': {
          'widget_type': 'RadioButton',
          'values': ['show', 'hide'],
          // Pas de condition hidden - toujours visible
        },
        'fieldB': {
          'widget_type': 'TextField',
          'hidden': "({value}) => value.fieldA === 'hide'", // Caché si fieldA = 'hide'
        },
        'fieldC': {
          'widget_type': 'TextField', 
          'hidden': "({value}) => !value.fieldB", // Caché si fieldB n'existe pas/est vide
        },
      };

      // Scénario 1: fieldA = 'show' - tous les champs visibles
      var context = {
        'value': {
          'fieldA': 'show',
          'fieldB': 'some_value',
          'fieldC': 'some_other_value',
        }
      };

      // fieldB ne devrait pas être caché
      var fieldBHidden = processor.isFieldHidden(
        'fieldB', 
        context, 
        fieldConfig: allFieldsConfig['fieldB']!,
        allFieldsConfig: allFieldsConfig
      );
      expect(fieldBHidden, isFalse, reason: 'fieldB should be visible when fieldA is "show"');

      // fieldC ne devrait pas être caché car fieldB existe
      var fieldCHidden = processor.isFieldHidden(
        'fieldC', 
        context, 
        fieldConfig: allFieldsConfig['fieldC']!,
        allFieldsConfig: allFieldsConfig
      );
      expect(fieldCHidden, isFalse, reason: 'fieldC should be visible when fieldB exists');

      // Scénario 2: fieldA = 'hide' - cascade hide
      context = {
        'value': {
          'fieldA': 'hide',
          'fieldB': 'some_value', // Cette valeur devrait être ignorée dans le contexte cascade
          'fieldC': 'some_other_value',
        }
      };

      // fieldB devrait être caché directement à cause de fieldA
      fieldBHidden = processor.isFieldHidden(
        'fieldB', 
        context, 
        fieldConfig: allFieldsConfig['fieldB']!,
        allFieldsConfig: allFieldsConfig
      );
      expect(fieldBHidden, isTrue, reason: 'fieldB should be hidden when fieldA is "hide"');

      // fieldC devrait aussi être caché EN CASCADE car fieldB est caché
      fieldCHidden = processor.isFieldHidden(
        'fieldC', 
        context, 
        fieldConfig: allFieldsConfig['fieldC']!,
        allFieldsConfig: allFieldsConfig
      );
      expect(fieldCHidden, isTrue, reason: 'fieldC should be hidden in cascade when fieldB is hidden');
    });

    test('Should handle complex cascade scenarios with multiple dependencies', () {
      // Configuration plus complexe:
      // - presence: radio button (Oui/Non)  
      // - type_denombrement: caché si presence == 'Non'
      // - nombre_compte: caché si type_denombrement != 'Compté'
      // - nombre_estime_min: caché si type_denombrement != 'Estimé'
      final allFieldsConfig = {
        'presence': {
          'widget_type': 'RadioButton',
          'values': ['Oui', 'Non'],
        },
        'type_denombrement': {
          'widget_type': 'RadioButton',
          'values': ['Compté', 'Estimé'],
          'hidden': "({value}) => value.presence === 'Non'",
        },
        'nombre_compte': {
          'widget_type': 'NumberField',
          'hidden': "({value}) => value.type_denombrement !== 'Compté'",
        },
        'nombre_estime_min': {
          'widget_type': 'NumberField',
          'hidden': "({value}) => value.type_denombrement !== 'Estimé'",
        },
      };

      // Scénario 1: presence = 'Oui', type_denombrement = 'Compté'
      var context = {
        'value': {
          'presence': 'Oui',
          'type_denombrement': 'Compté',
          'nombre_compte': 5,
          'nombre_estime_min': 10,
        }
      };

      // type_denombrement devrait être visible
      var isHidden = processor.isFieldHidden('type_denombrement', context,
          fieldConfig: allFieldsConfig['type_denombrement']!, allFieldsConfig: allFieldsConfig);
      expect(isHidden, isFalse);

      // nombre_compte devrait être visible (type_denombrement == 'Compté')
      isHidden = processor.isFieldHidden('nombre_compte', context,
          fieldConfig: allFieldsConfig['nombre_compte']!, allFieldsConfig: allFieldsConfig);
      expect(isHidden, isFalse);

      // nombre_estime_min devrait être caché (type_denombrement != 'Estimé')
      isHidden = processor.isFieldHidden('nombre_estime_min', context,
          fieldConfig: allFieldsConfig['nombre_estime_min']!, allFieldsConfig: allFieldsConfig);
      expect(isHidden, isTrue);

      // Scénario 2: presence = 'Non' - CASCADE
      context = {
        'value': {
          'presence': 'Non',
          'type_denombrement': 'Compté', // Devrait être ignoré à cause de la cascade
          'nombre_compte': 5,
          'nombre_estime_min': 10,
        }
      };

      // type_denombrement devrait être caché
      isHidden = processor.isFieldHidden('type_denombrement', context,
          fieldConfig: allFieldsConfig['type_denombrement']!, allFieldsConfig: allFieldsConfig);
      expect(isHidden, isTrue);

      // nombre_compte devrait être caché EN CASCADE (type_denombrement n'existe plus)
      isHidden = processor.isFieldHidden('nombre_compte', context,
          fieldConfig: allFieldsConfig['nombre_compte']!, allFieldsConfig: allFieldsConfig);
      expect(isHidden, isTrue, reason: 'nombre_compte should be hidden in cascade when type_denombrement is hidden');

      // nombre_estime_min devrait aussi être caché EN CASCADE
      isHidden = processor.isFieldHidden('nombre_estime_min', context,
          fieldConfig: allFieldsConfig['nombre_estime_min']!, allFieldsConfig: allFieldsConfig);
      expect(isHidden, isTrue, reason: 'nombre_estime_min should be hidden in cascade when type_denombrement is hidden');
    });

    test('Should handle self-referencing field conditions correctly', () {
      // Test pour s'assurer qu'un champ ne se cache pas lui-même
      final allFieldsConfig = {
        'fieldA': {
          'widget_type': 'TextField',
          'hidden': "({value}) => value.fieldA === 'hide_me'", // Auto-référence
        },
      };

      // Scénario où le champ tente de se cacher lui-même
      final context = {
        'value': {
          'fieldA': 'hide_me',
        }
      };

      final isHidden = processor.isFieldHidden('fieldA', context,
          fieldConfig: allFieldsConfig['fieldA']!, allFieldsConfig: allFieldsConfig);
      
      // Le champ devrait être caché selon sa condition
      expect(isHidden, isTrue, reason: 'Field should be able to hide itself based on its own value');
    });

    test('Should prevent infinite cascade loops', () {
      // Configuration qui pourrait créer une boucle infinie
      final allFieldsConfig = {
        'fieldA': {
          'widget_type': 'TextField',
          'hidden': "({value}) => !value.fieldB", // Caché si fieldB n'existe pas
        },
        'fieldB': {
          'widget_type': 'TextField', 
          'hidden': "({value}) => !value.fieldA", // Caché si fieldA n'existe pas
        },
      };

      final context = {
        'value': <String, dynamic>{
          // Aucun champ n'a de valeur initialement
        }
      };

      // Les deux champs devraient être cachés mais l'évaluation ne devrait pas boucler infiniment
      final fieldAHidden = processor.isFieldHidden('fieldA', context,
          fieldConfig: allFieldsConfig['fieldA']!, allFieldsConfig: allFieldsConfig);
      
      final fieldBHidden = processor.isFieldHidden('fieldB', context,
          fieldConfig: allFieldsConfig['fieldB']!, allFieldsConfig: allFieldsConfig);

      // Les deux champs devraient être cachés
      expect(fieldAHidden, isTrue, reason: 'fieldA should be hidden when fieldB does not exist');
      expect(fieldBHidden, isTrue, reason: 'fieldB should be hidden when fieldA does not exist');
    });
  });
}