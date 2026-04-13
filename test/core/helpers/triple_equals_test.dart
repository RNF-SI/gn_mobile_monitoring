import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/core/helpers/hidden_expression_evaluator.dart';

void main() {
  group('Triple Equals (===) Support Tests', () {
    late HiddenExpressionEvaluator evaluator;

    setUp(() {
      evaluator = HiddenExpressionEvaluator();
    });

    test('Should support === operator for string equality', () {
      final context = {
        'value': {
          'presence': 'Non',
        },
      };

      // Test l'expression exacte du problème
      final result = evaluator.evaluateExpression(
        "({value}) => value.presence === 'Non'",
        context,
      );

      expect(result, isTrue);
    });

    test('Should support === operator for string inequality', () {
      final context = {
        'value': {
          'presence': 'Oui',
        },
      };

      // Test l'expression exacte du problème
      final result = evaluator.evaluateExpression(
        "({value}) => value.presence === 'Non'",
        context,
      );

      expect(result, isFalse);
    });

    test('Should support bracket notation with ===', () {
      final context = {
        'value': {
          'presence': 'Non',
        },
      };

      // Test avec la notation par crochets
      final result = evaluator.evaluateExpression(
        "({value}) => value['presence'] === 'Non'",
        context,
      );

      expect(result, isTrue);
    });

    test('Should handle type differences with ===', () {
      final context = {
        'value': {
          'count': 5,
        },
      };

      // Comparaison number vs string devrait échouer avec ===
      final result = evaluator.evaluateExpression(
        "({value}) => value.count === '5'",
        context,
      );

      expect(result, isFalse); // Triple égal JavaScript est strict sur les types
    });

    test('Should support !== operator', () {
      final context = {
        'value': {
          'type_denombrement': 'Estimé',
        },
      };

      final result = evaluator.evaluateExpression(
        "({value}) => value.type_denombrement !== 'Compté'",
        context,
      );

      expect(result, isTrue);
    });

    test('Real world example - cd_nom should be hidden when presence is Non', () {
      final context = {
        'value': {
          'presence': 'Non',
        },
      };

      final result = evaluator.evaluateExpression(
        "({value}) => value.presence === 'Non'",
        context,
      );

      expect(result, isTrue, reason: 'cd_nom should be hidden when presence is Non');
    });

    test('Real world example - cd_nom should be visible when presence is Oui', () {
      final context = {
        'value': {
          'presence': 'Oui',
        },
      };

      final result = evaluator.evaluateExpression(
        "({value}) => value.presence === 'Non'",
        context,
      );

      expect(result, isFalse, reason: 'cd_nom should be visible when presence is Oui');
    });
  });
}