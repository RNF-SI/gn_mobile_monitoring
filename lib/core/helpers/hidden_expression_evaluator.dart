import 'package:flutter/foundation.dart';

/// Évaluateur d'expressions de masquage (hidden)
/// 
/// Ce service permet d'évaluer dynamiquement les expressions de masquage des champs
/// provenant des configurations JSON, directement lors de l'affichage des formulaires.
class HiddenExpressionEvaluator {
  /// Évalue une expression de masquage au format chaîne TypeScript
  /// 
  /// Exemple: 
  /// - Expression: "({value}) => value.test_detectabilite"
  /// - Contexte: {"value": {"test_detectabilite": true}}
  /// - Résultat: true
  /// 
  /// Paramètres:
  /// - expression: L'expression de masquage au format TypeScript arrow function
  /// - context: Le contexte d'évaluation (valeurs du formulaire, métadonnées)
  /// 
  /// Retourne:
  /// - true si le champ doit être masqué
  /// - false si le champ doit être affiché
  /// - null en cas d'erreur d'évaluation (le champ sera affiché par défaut)
  bool? evaluateExpression(String expression, Map<String, dynamic> context) {
    try {
      // Support des deux formats: Dart "(value) => ..." et JS "({value}) => ..."
      RegExp? arrowFnPattern;
      
      if (expression.trim().startsWith('({')) {
        // Ancien format JS: ({value}) => ...
        arrowFnPattern = RegExp(r'^\(\{(.+)\}\)\s*=>\s*(.+)$');
      } else if (expression.trim().startsWith('(')) {
        // Nouveau format Dart: (value) => ...
        arrowFnPattern = RegExp(r'^\((.+)\)\s*=>\s*(.+)$');
      }
      
      if (arrowFnPattern == null) {
        return null;
      }
      
      final Match? match = arrowFnPattern.firstMatch(expression);
      
      if (match == null) {
        return null;
      }
      
      // Extraire les noms des paramètres (value, meta, etc.)
      final String paramsStr = match.group(1)!.trim();
      final List<String> params = paramsStr.split(',').map((p) => p.trim()).toList();
      
      // Extraire le corps de l'expression
      final String body = match.group(2)!.trim();
      
      // Évaluer l'expression en fonction de son type
      return _evaluateExpressionBody(body, params, context);
    } catch (e) {
      // Log l'erreur pour faciliter le débogage
      debugPrint('Erreur lors de l\'évaluation de l\'expression: $e');
      return null;
    }
  }
  
  /// Évalue le corps de l'expression en fonction de son type
  bool? _evaluateExpressionBody(String body, List<String> params, Map<String, dynamic> context) {
    // Cas simple: accès à une propriété (value.prop)
    if (_isSimplePropertyAccess(body)) {
      return _evaluatePropertyAccess(body, params, context);
    }
    
    // Cas d'accès à une propriété avec crochets
    if (_isBracketAccess(body)) {
      return _evaluateBracketAccess(body, params, context);
    }
    
    // Cas avec opérateur logique && 
    if (body.contains('&&')) {
      return _evaluateLogicalAnd(body, params, context);
    }
    
    // Cas avec opérateur logique ||
    if (body.contains('||')) {
      return _evaluateLogicalOr(body, params, context);
    }
    
    // Cas avec négation !
    if (body.startsWith('!')) {
      return _evaluateNegation(body, params, context);
    }
    
    // Cas avec comparaison (==, !=, >, <, >=, <=)
    if (_containsComparisonOperator(body)) {
      return _evaluateComparison(body, params, context);
    }
    
    // Si on ne reconnaît pas l'expression, par défaut ne pas masquer
    return null;
  }
  
  /// Vérifie si l'expression est un simple accès à une propriété
  bool _isSimplePropertyAccess(String expr) {
    // Format: paramName.propName (ex: value.test_detectabilite)
    final propertyAccessRegex = RegExp(r'^(\w+)\.(\w+)$');
    return propertyAccessRegex.hasMatch(expr);
  }
  
  /// Vérifie si l'expression est un accès à une propriété avec crochets
  bool _isBracketAccess(String expr) {
    // Nettoyer l'expression de tout cast à la fin
    String cleanExpr = expr;
    if (cleanExpr.contains(' as ')) {
      cleanExpr = cleanExpr.split(' as ')[0].trim();
    }
    
    // Utilisation de RegExp pour détecter un accès par crochets dans sa forme la plus simple
    final regex = RegExp(r"""^(\w+)\[(['"])(.+?)\2\]$""");
    return regex.hasMatch(cleanExpr);
  }
  
  /// Évalue un accès simple à une propriété (style JS)
  bool? _evaluatePropertyAccess(String expr, List<String> params, Map<String, dynamic> context) {
    final propertyAccessRegex = RegExp(r'^(\w+)\.(\w+)$');
    final match = propertyAccessRegex.firstMatch(expr);
    
    if (match == null) return null;
    
    final paramName = match.group(1)!;
    final propName = match.group(2)!;
    
    // Vérifier que le paramètre existe dans le contexte
    if (!context.containsKey(paramName)) {
      return null;
    }
    
    // Récupérer la valeur du paramètre
    final paramValue = context[paramName];
    if (paramValue is! Map<String, dynamic>) {
      return null;
    }
    
    // Accéder à la propriété
    if (!paramValue.containsKey(propName)) {
      // Si la propriété n'existe pas, on considère que c'est false
      return false;
    }
    
    final propValue = paramValue[propName];
    
    // Si c'est déjà un booléen, le retourner directement
    if (propValue is bool) {
      return propValue;
    }
    
    // Sinon, considérer que la présence d'une valeur non-null comme true
    return propValue != null;
  }
  
  /// Évalue un accès à une propriété avec crochets (style Dart)
  bool? _evaluateBracketAccess(String expr, List<String> params, Map<String, dynamic> context) {
    // Prétraitement: retirer le "as bool" ou autres casts
    String cleanExpr = expr;
    bool hasAsBool = false;
    
    if (cleanExpr.contains(' as ')) {
      final parts = cleanExpr.split(' as ');
      cleanExpr = parts[0].trim();
      hasAsBool = parts[1].trim() == 'bool';
    }
    
    // Exemple: value['test_detectabilite']
    final regex = RegExp(r"""^(\w+)\[(['"])(.+?)\2\]$""");
    final match = regex.firstMatch(cleanExpr);
    
    if (match == null) {
      // Si ce n'est pas un accès par crochets simple, il pourrait s'agir d'une comparaison
      if (_containsComparisonOperator(cleanExpr)) {
        return _evaluateComparison(expr, params, context);
      }
      return null;
    }
    
    final paramName = match.group(1)!;
    final propName = match.group(3)!;
    
    // Vérifier que le paramètre existe dans le contexte
    if (!context.containsKey(paramName)) {
      return null;
    }
    
    // Récupérer la valeur du paramètre
    final paramValue = context[paramName];
    if (paramValue is! Map<String, dynamic>) {
      return null;
    }
    
    // Accéder à la propriété
    if (!paramValue.containsKey(propName)) {
      // Si la propriété n'existe pas, on considère que c'est false
      return false;
    }
    
    final propValue = paramValue[propName];
    
    // Si l'expression originale contient une comparaison, déléguer à _evaluateComparison
    if (_containsComparisonOperator(expr)) {
      return _evaluateComparison(expr, params, context);
    }
    
    // Si c'est un accès simple
    // Si c'est déjà un booléen, le retourner directement
    if (propValue is bool) {
      return propValue;
    }
    
    // Sinon, considérer que la présence d'une valeur non-null comme true
    return propValue != null;
  }
  
  /// Évalue une expression avec opérateur logique AND (&&)
  bool? _evaluateLogicalAnd(String expr, List<String> params, Map<String, dynamic> context) {
    final parts = expr.split('&&').map((p) => p.trim()).toList();
    
    // Pour un AND, si une partie est false, le résultat est false
    for (final part in parts) {
      final partResult = _evaluateExpressionBody(part, params, context);
      
      // Si une partie est explicitement false, le résultat est false
      if (partResult == false) {
        return false;
      }
      
      // Si une partie n'a pas pu être évaluée, le résultat est incertain
      if (partResult == null) {
        return null;
      }
    }
    
    // Si toutes les parties sont true, le résultat est true
    return true;
  }
  
  /// Évalue une expression avec opérateur logique OR (||)
  bool? _evaluateLogicalOr(String expr, List<String> params, Map<String, dynamic> context) {
    final parts = expr.split('||').map((p) => p.trim()).toList();
    
    // Pour un OR, si une partie est true, le résultat est true
    for (final part in parts) {
      final partResult = _evaluateExpressionBody(part, params, context);
      
      // Si une partie est explicitement true, le résultat est true
      if (partResult == true) {
        return true;
      }
    }
    
    // Si aucune partie n'est true, le résultat est false
    return false;
  }
  
  /// Évalue une expression avec négation (!)
  bool? _evaluateNegation(String expr, List<String> params, Map<String, dynamic> context) {
    // Supprimer le ! et évaluer le reste
    final innerExpr = expr.substring(1).trim();
    final innerResult = _evaluateExpressionBody(innerExpr, params, context);
    
    // Si le résultat interne est null, le résultat total est incertain
    if (innerResult == null) {
      return null;
    }
    
    // Inverser le résultat
    return !innerResult;
  }
  
  /// Vérifie si l'expression contient un opérateur de comparaison
  bool _containsComparisonOperator(String expr) {
    return expr.contains('==') || 
           expr.contains('!=') ||
           expr.contains('>=') ||
           expr.contains('<=') ||
           expr.contains('>') || 
           expr.contains('<');
  }
  
  /// Évalue une expression avec un opérateur de comparaison
  bool? _evaluateComparison(String expr, List<String> params, Map<String, dynamic> context) {
    // Traiter le cas spécial "as bool" qui peut être présent à la fin de l'expression
    bool hasAsBool = false;
    if (expr.endsWith(' as bool')) {
      expr = expr.substring(0, expr.length - 8).trim();
      hasAsBool = true;
    }
    
    // Détecter quel opérateur est utilisé
    String operator;
    
    if (expr.contains('==')) {
      operator = '==';
    } else if (expr.contains('!=')) {
      operator = '!=';
    } else if (expr.contains('>=')) {
      operator = '>=';
    } else if (expr.contains('<=')) {
      operator = '<=';
    } else if (expr.contains('>')) {
      operator = '>';
    } else if (expr.contains('<')) {
      operator = '<';
    } else {
      return null;
    }
    
    // Séparer l'expression en parties gauche et droite
    final parts = expr.split(operator);
    if (parts.length != 2) return null;
    
    final leftExpr = parts[0].trim();
    final rightExpr = parts[1].trim();
    
    // Évaluer les parties gauche et droite
    final leftValue = _evaluateValue(leftExpr, params, context);
    
    // Gérer le cas où la partie droite contient également "as [type]"
    String cleanRightExpr = rightExpr;
    if (cleanRightExpr.contains(' as ')) {
      cleanRightExpr = cleanRightExpr.split(' as ')[0].trim();
    }
    
    final rightValue = _evaluateValue(cleanRightExpr, params, context);
    
    // Si une des valeurs n'a pas pu être évaluée, le résultat est incertain
    if (leftValue == null || rightValue == null) {
      return null;
    }
    
    // Effectuer la comparaison en fonction de l'opérateur
    bool? result;
    switch (operator) {
      case '==': 
        result = leftValue == rightValue;
        break;
      case '!=': 
        result = leftValue != rightValue;
        break;
      case '>=': 
        result = _compareValues(leftValue, rightValue) >= 0;
        break;
      case '<=': 
        result = _compareValues(leftValue, rightValue) <= 0;
        break;
      case '>': 
        result = _compareValues(leftValue, rightValue) > 0;
        break;
      case '<': 
        result = _compareValues(leftValue, rightValue) < 0;
        break;
      default: 
        return null;
    }
    
    return result;
  }
  
  /// Évalue une valeur qui peut être soit une propriété d'un paramètre, soit une valeur littérale
  dynamic _evaluateValue(String expr, List<String> params, Map<String, dynamic> context) {
    // Traitement préliminaire: retirer les conversions de type "as X"
    String cleanExpr = expr;
    if (cleanExpr.contains(' as ')) {
      cleanExpr = cleanExpr.split(' as ')[0].trim();
    }
    
    // Cas 1a: Accès à une propriété style TypeScript (param.prop)
    if (_isSimplePropertyAccess(cleanExpr)) {
      final propertyAccessRegex = RegExp(r'^(\w+)\.(\w+)$');
      final match = propertyAccessRegex.firstMatch(cleanExpr);
      
      if (match != null) {
        final paramName = match.group(1)!;
        final propName = match.group(2)!;
        
        if (context.containsKey(paramName) && 
            context[paramName] is Map<String, dynamic> &&
            (context[paramName] as Map<String, dynamic>).containsKey(propName)) {
          final value = (context[paramName] as Map<String, dynamic>)[propName];
          return value;
        }
        
        return null;
      }
    }
    
    // Cas 1b: Accès à une propriété style Dart (param['prop'])
    if (_isBracketAccess(cleanExpr)) {
      final regex = RegExp(r"""^(\w+)\[(['"])(.+?)\2\]$""");
      final bracketMatch = regex.firstMatch(cleanExpr);
      
      if (bracketMatch != null) {
        final paramName = bracketMatch.group(1)!;
        final propName = bracketMatch.group(3)!;
        
        if (context.containsKey(paramName) && 
            context[paramName] is Map<String, dynamic>) {
          final paramValue = context[paramName] as Map<String, dynamic>;
          
          if (paramValue.containsKey(propName)) {
            final value = paramValue[propName];
            return value;
          }
        }
      }
      
      return null;
    }
    
    // Cas 2: Référence à une fonction Object.keys
    if (cleanExpr.contains('Object.keys') && cleanExpr.contains('.length')) {
      final objectKeysRegex = RegExp(r'Object\.keys\((\w+)\.(\w+)\)\.length');
      final match = objectKeysRegex.firstMatch(cleanExpr);
      
      if (match != null) {
        final paramName = match.group(1)!;
        final propName = match.group(2)!;
        
        if (context.containsKey(paramName) && 
            context[paramName] is Map<String, dynamic> &&
            (context[paramName] as Map<String, dynamic>).containsKey(propName)) {
          final propValue = (context[paramName] as Map<String, dynamic>)[propName];
          if (propValue is Map<String, dynamic>) {
            return propValue.keys.length;
          }
        }
        
        return 0; // Si la propriété n'existe pas ou n'est pas un Map, la longueur est 0
      }
    }
    
    // Cas 3: Valeur littérale (nombre, booléen, chaîne)
    // Nombre - différents formats possibles
    final numberRegexes = [
      RegExp(r'^\d+$'),            // Entier: 123
      RegExp(r'^\d+\.\d+$'),       // Flottant: 123.45
      RegExp(r'^\d+[eE][+-]?\d+$') // Notation scientifique: 1e3, 2E-4
    ];
    
    for (final regex in numberRegexes) {
      if (regex.hasMatch(cleanExpr)) {
        if (cleanExpr.contains('.') || cleanExpr.contains('e') || cleanExpr.contains('E')) {
          // C'est un nombre à virgule flottante
          return double.parse(cleanExpr);
        } else {
          // C'est un entier
          return int.parse(cleanExpr);
        }
      }
    }
    
    // Booléen
    if (cleanExpr == 'true') {
      return true;
    }
    if (cleanExpr == 'false') {
      return false;
    }
    
    // Chaîne (entre guillemets)
    if ((cleanExpr.startsWith("'") && cleanExpr.endsWith("'")) || 
        (cleanExpr.startsWith('"') && cleanExpr.endsWith('"'))) {
      return cleanExpr.substring(1, cleanExpr.length - 1);
    }
    
    // Si on ne peut pas évaluer, retourner null
    return null;
  }
  
  /// Compare deux valeurs de types potentiellement différents
  int _compareValues(dynamic a, dynamic b) {
    // Si les deux valeurs sont du même type et comparables
    if (a is num && b is num) {
      return a.compareTo(b);
    }
    
    if (a is String && b is String) {
      return a.compareTo(b);
    }
    
    if (a is bool && b is bool) {
      return a == b ? 0 : (a ? 1 : -1);
    }
    
    // Si les types sont différents, convertir en chaîne pour comparer
    return a.toString().compareTo(b.toString());
  }
}