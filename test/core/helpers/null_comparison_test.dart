import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/core/helpers/hidden_expression_evaluator.dart';

void main() {
  group('Null Comparison Tests', () {
    late HiddenExpressionEvaluator evaluator;

    setUp(() {
      evaluator = HiddenExpressionEvaluator();
    });

    test('Should handle null != string comparison correctly', () {
      final context = {
        'value': {
          // type_denombrement n'existe pas (null)
        },
      };

      // Test le cas problématique où type_denombrement est null
      final result = evaluator.evaluateExpression(
        "({value}) => value.type_denombrement != 'Compté'",
        context,
      );

      expect(result, isTrue, reason: 'null != "Compté" should be true');
    });

    test('Should handle null != string comparison with bracket notation', () {
      final context = {
        'value': {
          // type_denombrement n'existe pas (null)
        },
      };

      final result = evaluator.evaluateExpression(
        "(value) => value['type_denombrement'] != 'Compté'",
        context,
      );

      expect(result, isTrue, reason: 'null != "Compté" should be true');
    });

    test('Should handle string != string comparison correctly', () {
      final context = {
        'value': {
          'type_denombrement': 'Estimé',
        },
      };

      final result = evaluator.evaluateExpression(
        "(value) => value['type_denombrement'] != 'Compté'",
        context,
      );

      expect(result, isTrue, reason: '"Estimé" != "Compté" should be true');
    });

    test('Should handle string == string comparison correctly', () {
      final context = {
        'value': {
          'type_denombrement': 'Compté',
        },
      };

      final result = evaluator.evaluateExpression(
        "(value) => value['type_denombrement'] != 'Compté'",
        context,
      );

      expect(result, isFalse, reason: '"Compté" != "Compté" should be false');
    });

    test('Real world scenario - nombre_compte visibility', () {
      // Cas initial : type_denombrement n'est pas défini
      var context = {
        'value': {
          'presence': 'Oui',
          // type_denombrement absent
        },
      };

      var result = evaluator.evaluateExpression(
        "({value}) => value.type_denombrement != 'Compté'",
        context,
      );

      expect(result, isTrue, reason: 'nombre_compte should be hidden when type_denombrement is null');

      // Cas après sélection de "Compté"
      context = {
        'value': {
          'presence': 'Oui',
          'type_denombrement': 'Compté',
        },
      };

      result = evaluator.evaluateExpression(
        "({value}) => value.type_denombrement != 'Compté'",
        context,
      );

      expect(result, isFalse, reason: 'nombre_compte should be visible when type_denombrement is Compté');

      // Cas après sélection de "Estimé"
      context = {
        'value': {
          'presence': 'Oui',
          'type_denombrement': 'Estimé',
        },
      };

      result = evaluator.evaluateExpression(
        "({value}) => value.type_denombrement != 'Compté'",
        context,
      );

      expect(result, isTrue, reason: 'nombre_compte should be hidden when type_denombrement is Estimé');
    });

    test('Real world scenario - nombre_estime_min visibility', () {
      // Cas initial : type_denombrement n'est pas défini
      var context = {
        'value': {
          'presence': 'Oui',
          // type_denombrement absent
        },
      };

      var result = evaluator.evaluateExpression(
        "({value}) => value.type_denombrement != 'Estimé'",
        context,
      );

      expect(result, isTrue, reason: 'nombre_estime_min should be hidden when type_denombrement is null');

      // Cas après sélection de "Estimé"
      context = {
        'value': {
          'presence': 'Oui',
          'type_denombrement': 'Estimé',
        },
      };

      result = evaluator.evaluateExpression(
        "({value}) => value.type_denombrement != 'Estimé'",
        context,
      );

      expect(result, isFalse, reason: 'nombre_estime_min should be visible when type_denombrement is Estimé');
    });
  });
}