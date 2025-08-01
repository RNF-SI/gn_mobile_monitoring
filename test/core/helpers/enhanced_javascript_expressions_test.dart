import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/core/helpers/hidden_expression_evaluator.dart';

void main() {
  group('Enhanced JavaScript Expressions Tests', () {
    late HiddenExpressionEvaluator evaluator;

    setUp(() {
      evaluator = HiddenExpressionEvaluator();
    });

    group('New Triple Equals (===) Operator', () {
      test('should evaluate strict equality correctly for same type and value', () {
        final context = {
          'value': {'presence': 'Oui'}
        };

        final result = evaluator.evaluateExpression(
          "({value}) => value.presence === 'Oui'",
          context,
        );

        expect(result, true);
      });

      test('should evaluate strict inequality for same value but different type', () {
        final context = {
          'value': {'count': 1}
        };

        final result = evaluator.evaluateExpression(
          "({value}) => value.count === '1'",
          context,
        );

        // Should be false because 1 (int) !== '1' (string) in strict comparison
        expect(result, false);
      });

      test('should evaluate strict equality correctly for numbers', () {
        final context = {
          'value': {'cd_nom': 186278}
        };

        final result = evaluator.evaluateExpression(
          "({value}) => value.cd_nom === 186278",
          context,
        );

        expect(result, true);
      });

      test('should evaluate strict inequality (!==) correctly', () {
        final context = {
          'value': {'presence': 'Non'}
        };

        final result = evaluator.evaluateExpression(
          "({value}) => value.presence !== 'Oui'",
          context,
        );

        expect(result, true);
      });
    });

    group('Enhanced Null/Undefined Comparisons', () {
      test('should handle comparison with null correctly', () {
        final context = {
          'value': {'optional_field': null}
        };

        final result = evaluator.evaluateExpression(
          "({value}) => value.optional_field == null",
          context,
        );

        expect(result, true);
      });

      test('should handle undefined fields as null', () {
        final context = <String, dynamic>{
          'value': <String, dynamic>{}
        };

        final result = evaluator.evaluateExpression(
          "({value}) => value.undefined_field == null",
          context,
        );

        expect(result, true);
      });

      test('should handle complex null comparison patterns', () {
        final context = {
          'value': {'cd_nom': 186278}
        };

        // This simulates: value.cd_nom != (null || undefined)
        // Which should be true since cd_nom has a value
        final result = evaluator.evaluateExpression(
          "({value}) => value.cd_nom != null",
          context,
        );

        expect(result, true);
      });
    });

    group('Object.keys().length Support', () {
      test('should evaluate Object.keys().length correctly', () {
        final context = {
          'meta': {
            'dataset': {'id1': 'value1', 'id2': 'value2'}
          }
        };

        final result = evaluator.evaluateExpression(
          "({meta}) => Object.keys(meta.dataset).length == 2",
          context,
        );

        expect(result, true);
      });

      test('should evaluate Object.keys().length with single item', () {
        final context = {
          'meta': {
            'dataset': {'single_id': 'value'}
          }
        };

        final result = evaluator.evaluateExpression(
          "({meta}) => Object.keys(meta.dataset).length == 1",
          context,
        );

        expect(result, true);
      });

      test('should handle empty objects with Object.keys().length', () {
        final context = {
          'meta': {
            'dataset': <String, dynamic>{}
          }
        };

        final result = evaluator.evaluateExpression(
          "({meta}) => Object.keys(meta.dataset).length == 0",
          context,
        );

        expect(result, true);
      });
    });

    group('Complex Conditional Logic', () {
      test('should handle nested conditions correctly', () {
        final context = {
          'value': {
            'presence': 'Oui',
            'type_detection': 'Visuel',
            'count': 5
          }
        };

        final result = evaluator.evaluateExpression(
          "({value}) => value.presence === 'Oui' && value.type_detection === 'Visuel' && value.count > 3",
          context,
        );

        expect(result, true);
      });

      test('should handle OR conditions with null checks', () {
        final context = {
          'value': {
            'field1': null,
            'field2': 'value'
          }
        };

        final result = evaluator.evaluateExpression(
          "({value}) => value.field1 == null || value.field2 != null",
          context,
        );

        expect(result, true);
      });
    });

    group('Integration with Real Form Scenarios', () {
      test('should handle PopReptile-like configuration', () {
        final context = {
          'value': {
            'presence': 'Non',
            'cd_nom': 186278,
            'count_min': 1
          }
        };

        // cd_nom should be hidden when presence is 'Non'
        final cdNomHidden = evaluator.evaluateExpression(
          "({value}) => value.presence === 'Non'",
          context,
        );

        // count_min should be visible when presence is 'Oui' (so hidden when 'Non')
        final countHidden = evaluator.evaluateExpression(
          "({value}) => value.presence !== 'Oui'",
          context,
        );

        expect(cdNomHidden, true);
        expect(countHidden, true);
      });

      test('should handle RHOMEOAmphibien-like scenarios with nomenclatures', () {
        final context = {
          'value': {
            'typ_detection': 'Visuel',
            'duree_peche': 10
          },
          'meta': {
            'nomenclatures': {
              'TYP_DETECTION': [
                {'code': 'Visuel', 'label': 'Observation visuelle'},
                {'code': 'Peche', 'label': 'Pêche au troubleau'}
              ]
            }
          }
        };

        // duree_peche should be hidden when typ_detection is 'Visuel'
        final result = evaluator.evaluateExpression(
          "({value}) => value.typ_detection === 'Visuel'",
          context,
        );

        expect(result, true);
      });
    });

    group('Error Handling and Edge Cases', () {
      test('should handle malformed expressions gracefully', () {
        final context = {'value': {'field': 'value'}};

        final result = evaluator.evaluateExpression(
          "invalid javascript syntax",
          context,
        );

        expect(result, null);
      });

      test('should handle missing context properties', () {
        final context = {
          'value': <String, dynamic>{} // Empty value object
        };

        final result = evaluator.evaluateExpression(
          "({value}) => value.nonexistent === 'test'",
          context,
        );

        // L'évaluateur retourne false quand la propriété n'existe pas mais le contexte existe
        expect(result, false);
      });

      test('should handle empty context', () {
        final context = <String, dynamic>{};

        final result = evaluator.evaluateExpression(
          "({value}) => true",
          context,
        );

        expect(result, null);
      });
    });
  });
}