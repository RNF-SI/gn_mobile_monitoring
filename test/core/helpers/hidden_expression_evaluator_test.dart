import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/core/helpers/hidden_expression_evaluator.dart';

void main() {
  group('HiddenExpressionEvaluator', () {
    late HiddenExpressionEvaluator evaluator;

    setUp(() {
      evaluator = HiddenExpressionEvaluator();
    });

    test('should evaluate simple property access expression', () {
      final input = '({value}) => value.test_detectabilite';
      final context = {
        'value': {'test_detectabilite': true}
      };
      
      final result = evaluator.evaluateExpression(input, context);
      
      expect(result, isTrue);
    });
    
    test('should evaluate false when property is false', () {
      final input = '({value}) => value.test_detectabilite';
      final context = {
        'value': {'test_detectabilite': false}
      };
      
      final result = evaluator.evaluateExpression(input, context);
      
      expect(result, isFalse);
    });
    
    test('should evaluate negation correctly', () {
      final input = '({value}) => !value.test_detectabilite';
      final context = {
        'value': {'test_detectabilite': true}
      };
      
      final result = evaluator.evaluateExpression(input, context);
      
      expect(result, isFalse);
    });
    
    test('should evaluate Object.keys expression', () {
      final input = '({meta}) => meta.dataset && Object.keys(meta.dataset).length == 1';
      final context = {
        'meta': {'dataset': {'id': 123}}
      };
      
      final result = evaluator.evaluateExpression(input, context);
      
      expect(result, isTrue);
    });
    
    test('should evaluate Object.keys expression as false when length is different', () {
      final input = '({meta}) => meta.dataset && Object.keys(meta.dataset).length == 1';
      final context = {
        'meta': {'dataset': {'id': 123, 'name': 'test'}}
      };
      
      final result = evaluator.evaluateExpression(input, context);
      
      expect(result, isFalse);
    });
    
    test('should handle complex expressions with multiple conditions', () {
      final input = '({meta, value}) => !meta.bChainInput && value.id_base_site';
      final context = {
        'meta': {'bChainInput': false},
        'value': {'id_base_site': 123}
      };
      
      final result = evaluator.evaluateExpression(input, context);
      
      expect(result, isTrue);
    });
    
    test('should handle case where property does not exist', () {
      final input = '({value}) => value.non_existent_property';
      final context = {
        'value': {'test_detectabilite': true}
      };
      
      final result = evaluator.evaluateExpression(input, context);
      
      expect(result, isFalse);
    });
    
    test('should handle complex and conditions', () {
      final input = '({meta}) => meta.dataset && meta.user && meta.module';
      final context = {
        'meta': {
          'dataset': {'id': 123},
          'user': {'id': 456},
          'module': {'id': 789},
        }
      };
      
      final result = evaluator.evaluateExpression(input, context);
      
      expect(result, isTrue);
    });
    
    test('should handle numerical comparisons', () {
      final input = '({value}) => value.count > 5';
      final context = {
        'value': {'count': 10}
      };
      
      final result = evaluator.evaluateExpression(input, context);
      
      expect(result, isTrue);
    });
  });
}