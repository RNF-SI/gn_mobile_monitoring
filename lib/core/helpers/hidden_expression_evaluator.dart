import 'package:gn_mobile_monitoring/core/helpers/js_expression_interpreter.dart';

/// Évaluateur des expressions conditionnelles des configurations de module
/// (`hidden`, `required`, conditions des règles `change`).
///
/// Délègue à [JsExpressionInterpreter], qui reproduit la sémantique
/// JavaScript du module web (qui exécute ces chaînes avec `eval`).
class HiddenExpressionEvaluator {
  final JsExpressionInterpreter _interpreter = JsExpressionInterpreter();

  /// Évalue une expression au format fonction fléchée
  ///
  /// Exemple:
  /// - Expression: "({value}) => value.test_detectabilite"
  /// - Contexte: {"value": {"test_detectabilite": true}}
  /// - Résultat: true
  ///
  /// Paramètres:
  /// - expression: fonction fléchée JavaScript (`({value, meta}) => …`) ou
  ///   forme convertie par TsToDartConverter (`(value) => value['x'] as bool`)
  /// - context: le contexte d'évaluation (`value`, `meta`, `dirtyFields`…)
  ///
  /// Retourne:
  /// - la valeur de vérité JavaScript du résultat
  /// - null si l'expression est invalide ou lève une erreur
  bool? evaluateExpression(String expression, Map<String, dynamic> context) =>
      _interpreter.evaluateTruthy(expression, context);
}
