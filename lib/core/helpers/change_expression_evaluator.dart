import 'package:gn_mobile_monitoring/core/helpers/hidden_expression_evaluator.dart';
import 'package:gn_mobile_monitoring/domain/model/nomenclature.dart';

/// Représente une règle de changement parsée depuis le format JavaScript
class ParsedChangeRule {
  /// Condition de la règle (ex: "objForm.value.presence === 'Non'")
  /// null signifie une règle inconditionnelle (toujours appliquée)
  final String? condition;

  /// Valeurs à appliquer quand la condition est vraie (ou toujours si condition est null)
  final Map<String, dynamic> patchValues;

  const ParsedChangeRule({
    this.condition,
    required this.patchValues,
  });

  @override
  String toString() => 'ParsedChangeRule(condition: $condition, patchValues: $patchValues)';
}

/// Évaluateur d'expressions pour les règles de changement
///
/// Supporte le format JavaScript existant (tableau de strings) :
/// ```json
/// "change": [
///   "({objForm, meta}) => {",
///   "if (objForm.value.presence === 'Non') {",
///   "objForm.patchValue({count_min: 0, count_max: 0})",
///   "}",
///   ...
/// ]
/// ```
class ChangeExpressionEvaluator extends HiddenExpressionEvaluator {
  /// Cache des nomenclatures indexé par ID
  final Map<int, Nomenclature> nomenclatureCache;

  /// Variable scope built during 2-pass parsing (const declarations)
  Map<String, dynamic> _variableScope = {};

  ChangeExpressionEvaluator({
    this.nomenclatureCache = const {},
  });

  /// Parse un tableau de strings JavaScript en liste de règles (2-pass interpreter)
  ///
  /// Pass 1: Build variable scope from const declarations
  /// Pass 2: Extract all patchValue calls (conditional, ternary, unconditional)
  List<ParsedChangeRule> parseJavaScriptChangeRules(List<dynamic> changeArray) {
    // Reconstituer le code complet
    final fullCode = changeArray.map((e) => e.toString()).join('\n');

    // Extract function body
    final body = _extractFunctionBody(fullCode);
    if (body.isEmpty) return [];

    // Split into statements
    final statements = _splitStatements(body);

    // Pass 1: Build variable scope
    _variableScope = _buildVariableScope(statements);

    // Pass 2: Extract all patchValue calls
    return _extractAllPatchValueCalls(statements);
  }

  /// Extracts the function body from the arrow function wrapper
  String _extractFunctionBody(String fullCode) {
    // Match: ({objForm, meta}) => { ... }
    final match = RegExp(
      r'\(\{[^}]*\}\)\s*=>\s*\{(.*)\}',
      dotAll: true,
    ).firstMatch(fullCode);

    return match?.group(1)?.trim() ?? '';
  }

  /// Splits the function body into individual statements
  ///
  /// Handles semicolons at depth 0 and if-blocks as atomic units.
  /// Tracks brace depth and paren depth separately so that
  /// object literals inside function calls (e.g. patchValue({...}))
  /// are not mistaken for block-level braces.
  List<String> _splitStatements(String body) {
    final List<String> statements = [];
    int braceDepth = 0;
    int parenDepth = 0;
    int start = 0;
    bool inString = false;
    String? stringChar;

    for (int i = 0; i < body.length; i++) {
      final char = body[i];

      if (!inString && (char == "'" || char == '"')) {
        inString = true;
        stringChar = char;
      } else if (inString && char == stringChar) {
        inString = false;
        stringChar = null;
      } else if (!inString) {
        if (char == '(') {
          parenDepth++;
        } else if (char == ')') {
          parenDepth--;
        } else if (char == '{') {
          braceDepth++;
        } else if (char == '}') {
          braceDepth--;
          // End of a block-level brace (e.g. if-block) at depth 0
          // Only treat as block boundary when not inside parentheses
          if (braceDepth == 0 && parenDepth == 0 && start < i) {
            final stmt = body.substring(start, i + 1).trim();
            if (stmt.isNotEmpty) {
              statements.add(stmt);
            }
            start = i + 1;
          }
        } else if (char == ';' && braceDepth == 0 && parenDepth == 0) {
          final stmt = body.substring(start, i).trim();
          if (stmt.isNotEmpty) {
            statements.add(stmt);
          }
          start = i + 1;
        } else if (char == '\n' && braceDepth == 0 && parenDepth == 0) {
          // Newlines at depth 0 also act as statement separators
          // (handles JS code without semicolons)
          final stmt = body.substring(start, i).trim();
          if (stmt.isNotEmpty) {
            statements.add(stmt);
          }
          start = i + 1;
        }
      }
    }

    // Add trailing statement without semicolon
    if (start < body.length) {
      final stmt = body.substring(start).trim();
      if (stmt.isNotEmpty) {
        statements.add(stmt);
      }
    }

    return statements;
  }

  /// Pass 1: Build a scope of variables from const declarations
  Map<String, dynamic> _buildVariableScope(List<String> statements) {
    final Map<String, dynamic> scope = {};

    for (final stmt in statements) {
      if (!stmt.startsWith('const ')) continue;

      // Remove 'const ' prefix
      final declaration = stmt.substring(6).trim();

      // Find the first '=' that is the assignment operator
      final eqIndex = _findAssignmentEquals(declaration);
      if (eqIndex == -1) continue;

      final lhs = declaration.substring(0, eqIndex).trim();
      final rhs = declaration.substring(eqIndex + 1).trim();

      // Handle chained assignment: a = b = c = expr
      // The LHS may contain chained names separated by '='
      final varNames = <String>[];

      // Split the full "lhs = rhs" by finding all variable names
      // For "presence_arbre_1 = presence_arbre_2 = ... = expr"
      // lhs is the first var, and rhs may contain more "var = ..." chains
      varNames.add(lhs);
      String currentRhs = rhs;

      // Keep extracting chained assignments
      while (true) {
        final chainEqIdx = _findAssignmentEquals(currentRhs);
        if (chainEqIdx == -1) break;

        final chainVar = currentRhs.substring(0, chainEqIdx).trim();
        // Verify it's a valid variable name (not an expression)
        if (!RegExp(r'^\w+$').hasMatch(chainVar)) break;

        varNames.add(chainVar);
        currentRhs = currentRhs.substring(chainEqIdx + 1).trim();
      }

      // currentRhs is now the final expression value
      final value = _parseConstExpression(currentRhs);

      // Assign the same value to all variables in the chain
      for (final varName in varNames) {
        scope[varName] = value;
      }
    }

    return scope;
  }

  /// Finds the index of the assignment '=' operator (not ==, ===, !=, !==)
  int _findAssignmentEquals(String expr) {
    bool inString = false;
    String? stringChar;
    int depth = 0;

    for (int i = 0; i < expr.length; i++) {
      final char = expr[i];

      if (!inString && (char == "'" || char == '"')) {
        inString = true;
        stringChar = char;
      } else if (inString && char == stringChar) {
        inString = false;
        stringChar = null;
      } else if (!inString) {
        if (char == '(' || char == '{') {
          depth++;
        } else if (char == ')' || char == '}') {
          depth--;
        } else if (char == '=' && depth == 0) {
          // Check it's not == or ===
          final next = (i + 1 < expr.length) ? expr[i + 1] : '';
          final prev = (i > 0) ? expr[i - 1] : '';
          if (next != '=' && prev != '!' && prev != '<' && prev != '>') {
            return i;
          }
        }
      }
    }

    return -1;
  }

  /// Parses a const expression RHS into a storable value
  ///
  /// Supports: literals, objForm.value.xxx, fallback ||, ternary, arithmetic
  dynamic _parseConstExpression(String expr) {
    final trimmed = expr.trim();

    // Remove wrapping parentheses
    final unwrapped = _unwrapParens(trimmed);

    // Literal values
    if (unwrapped == 'null') return null;
    if (unwrapped == 'true') return true;
    if (unwrapped == 'false') return false;
    final numVal = num.tryParse(unwrapped);
    if (numVal != null) return numVal;

    // String literals
    if ((unwrapped.startsWith("'") && unwrapped.endsWith("'")) ||
        (unwrapped.startsWith('"') && unwrapped.endsWith('"'))) {
      return unwrapped.substring(1, unwrapped.length - 1);
    }

    // Simple objForm.value.xxx reference
    if (unwrapped.startsWith('objForm.value.') &&
        RegExp(r'^objForm\.value\.\w+$').hasMatch(unwrapped)) {
      return '@value.${unwrapped.substring('objForm.value.'.length)}';
    }

    // For complex expressions (ternary, arithmetic, fallback ||), store as @expr:
    // Check if it contains operators that indicate a complex expression
    if (_containsOperatorAtDepth0(unwrapped, '?') ||
        _containsOperatorAtDepth0(unwrapped, '+') ||
        _containsOperatorAtDepth0(unwrapped, '||')) {
      return '@expr:$unwrapped';
    }

    // Simple objForm.value.xxx with fallback — already caught by || above
    // Any remaining objForm.value references
    if (unwrapped.startsWith('objForm.value.')) {
      return '@value.${unwrapped.substring('objForm.value.'.length)}';
    }

    // Unknown expression — store as @expr: for runtime evaluation
    return '@expr:$unwrapped';
  }

  /// Removes matching outer parentheses from an expression
  String _unwrapParens(String expr) {
    var s = expr.trim();
    while (s.startsWith('(') && s.endsWith(')')) {
      // Verify the parens actually match (aren't part of separate sub-expressions)
      int depth = 0;
      bool matches = true;
      for (int i = 0; i < s.length - 1; i++) {
        if (s[i] == '(') {
          depth++;
        } else if (s[i] == ')') {
          depth--;
        }
        if (depth == 0) {
          matches = false;
          break;
        }
      }
      if (matches) {
        s = s.substring(1, s.length - 1).trim();
      } else {
        break;
      }
    }
    return s;
  }

  /// Checks if an operator appears at depth 0 (not inside parens/braces/strings)
  bool _containsOperatorAtDepth0(String expr, String op) {
    bool inString = false;
    String? stringChar;
    int depth = 0;

    for (int i = 0; i <= expr.length - op.length; i++) {
      final char = expr[i];

      if (!inString && (char == "'" || char == '"')) {
        inString = true;
        stringChar = char;
      } else if (inString && char == stringChar) {
        inString = false;
        stringChar = null;
      } else if (!inString) {
        if (char == '(' || char == '{') {
          depth++;
        } else if (char == ')' || char == '}') {
          depth--;
        } else if (depth == 0 && expr.substring(i).startsWith(op)) {
          // For '||', make sure we don't match inside other operators
          // For '?', make sure it's not part of '?.' optional chaining
          if (op == '?' && i + 1 < expr.length && expr[i + 1] == '.') {
            continue;
          }
          return true;
        }
      }
    }

    return false;
  }

  /// Pass 2: Extract all patchValue calls from statements
  List<ParsedChangeRule> _extractAllPatchValueCalls(List<String> statements) {
    final List<ParsedChangeRule> rules = [];

    for (final stmt in statements) {
      // Skip const declarations and console.log
      if (stmt.startsWith('const ') || stmt.startsWith('console.')) continue;

      // Pattern 1: if (condition) { ... patchValue({...}) }
      if (stmt.startsWith('if')) {
        final ifRules = _parseIfBlock(stmt);
        rules.addAll(ifRules);
        continue;
      }

      // Pattern 2: (condition ? objForm.patchValue({...}) : '')
      final ternaryRule = _parseTernaryPatchValue(stmt);
      if (ternaryRule != null) {
        rules.add(ternaryRule);
        continue;
      }

      // Pattern 3: objForm.patchValue({...}) — unconditional
      final unconditionalRule = _parseUnconditionalPatchValue(stmt);
      if (unconditionalRule != null) {
        rules.add(unconditionalRule);
        continue;
      }
    }

    return rules;
  }

  /// Parses an if-block statement into rules
  List<ParsedChangeRule> _parseIfBlock(String stmt) {
    final List<ParsedChangeRule> rules = [];

    // Extract condition: if (CONDITION) { BODY }
    final ifMatch = RegExp(r'^if\s*\((.+)\)\s*\{(.*)\}$', dotAll: true)
        .firstMatch(stmt);
    if (ifMatch == null) return rules;

    // Need to find matching paren for condition
    // Start after 'if ('
    final ifIdx = stmt.indexOf('(');
    if (ifIdx == -1) return rules;

    int depth = 0;
    int condEnd = -1;
    for (int i = ifIdx; i < stmt.length; i++) {
      if (stmt[i] == '(') {
        depth++;
      } else if (stmt[i] == ')') {
        depth--;
        if (depth == 0) {
          condEnd = i;
          break;
        }
      }
    }

    if (condEnd == -1) return rules;

    final condition = stmt.substring(ifIdx + 1, condEnd).trim();

    // Extract body (between { and })
    final bodyStart = stmt.indexOf('{', condEnd);
    if (bodyStart == -1) return rules;

    // Find matching closing brace
    depth = 0;
    int bodyEnd = -1;
    for (int i = bodyStart; i < stmt.length; i++) {
      if (stmt[i] == '{') {
        depth++;
      } else if (stmt[i] == '}') {
        depth--;
        if (depth == 0) {
          bodyEnd = i;
          break;
        }
      }
    }

    if (bodyEnd == -1) return rules;

    final body = stmt.substring(bodyStart + 1, bodyEnd).trim();

    // Find all patchValue calls within the body
    final patchValuePattern = RegExp(
      r'(?:objForm\.)?patchValue\s*\((\{.+?\})(?:\s*,\s*\{[^}]*\})?\s*\)',
      dotAll: true,
    );

    for (final match in patchValuePattern.allMatches(body)) {
      final patchValueStr = match.group(1)?.trim() ?? '{}';
      final patchValues = _parseJavaScriptObject(patchValueStr);
      if (patchValues.isNotEmpty) {
        rules.add(ParsedChangeRule(
          condition: condition,
          patchValues: patchValues,
        ));
      }
    }

    return rules;
  }

  /// Parses a ternary expression containing patchValue
  /// Pattern: (condition ? objForm.patchValue({...}) : '')
  ParsedChangeRule? _parseTernaryPatchValue(String stmt) {
    // Remove trailing semicolons and wrapping parens
    var cleaned = stmt.trim();
    if (cleaned.endsWith(';')) {
      cleaned = cleaned.substring(0, cleaned.length - 1).trim();
    }
    cleaned = _unwrapParens(cleaned);

    // Find the '?' at depth 0
    final qIdx = _findOperatorAtDepth0(cleaned, '?');
    if (qIdx == -1) return null;

    final condition = cleaned.substring(0, qIdx).trim();

    // Find the ':' at depth 0 after '?'
    final rest = cleaned.substring(qIdx + 1);
    final colonIdx = _findOperatorAtDepth0(rest, ':');
    if (colonIdx == -1) return null;

    final trueBranch = rest.substring(0, colonIdx).trim();
    // falseBranch is rest.substring(colonIdx + 1).trim() — we don't need it

    // Check if trueBranch contains patchValue
    final patchMatch = RegExp(
      r'(?:objForm\.)?patchValue\s*\((\{.+?\})(?:\s*,\s*\{[^}]*\})?\s*\)',
      dotAll: true,
    ).firstMatch(trueBranch);

    if (patchMatch == null) return null;

    final patchValueStr = patchMatch.group(1)?.trim() ?? '{}';
    final patchValues = _parseJavaScriptObject(patchValueStr);

    if (patchValues.isEmpty) return null;

    return ParsedChangeRule(
      condition: condition,
      patchValues: patchValues,
    );
  }

  /// Parses an unconditional patchValue call
  /// Pattern: objForm.patchValue({...})
  ParsedChangeRule? _parseUnconditionalPatchValue(String stmt) {
    final patchMatch = RegExp(
      r'(?:objForm\.)?patchValue\s*\((\{.+?\})(?:\s*,\s*\{[^}]*\})?\s*\)',
      dotAll: true,
    ).firstMatch(stmt);

    if (patchMatch == null) return null;

    final patchValueStr = patchMatch.group(1)?.trim() ?? '{}';
    final patchValues = _parseJavaScriptObject(patchValueStr);

    if (patchValues.isEmpty) return null;

    return ParsedChangeRule(
      condition: null,
      patchValues: patchValues,
    );
  }

  /// Finds the index of an operator at depth 0
  int _findOperatorAtDepth0(String expr, String op) {
    bool inString = false;
    String? stringChar;
    int depth = 0;

    for (int i = 0; i <= expr.length - op.length; i++) {
      final char = expr[i];

      if (!inString && (char == "'" || char == '"')) {
        inString = true;
        stringChar = char;
      } else if (inString && char == stringChar) {
        inString = false;
        stringChar = null;
      } else if (!inString) {
        if (char == '(' || char == '{') {
          depth++;
        } else if (char == ')' || char == '}') {
          depth--;
        } else if (depth == 0 && expr.substring(i, i + op.length) == op) {
          // For '?', make sure it's not part of '?.' optional chaining
          if (op == '?' && i + 1 < expr.length && expr[i + 1] == '.') {
            continue;
          }
          return i;
        }
      }
    }

    return -1;
  }

  /// Parse un objet JavaScript en Map Dart
  ///
  /// Supporte:
  /// - Propriétés simples: count_min: 0
  /// - Strings: presence: 'Non'
  /// - null: id_nomenclature_typ_denbr: null
  /// - Objets imbriqués: cd_nom: {'cd_nom': 914450, 'lb_nom': 'Amphibia'}
  Map<String, dynamic> _parseJavaScriptObject(String jsObject) {
    final Map<String, dynamic> result = {};

    // Retirer les accolades externes
    String content = jsObject.trim();
    if (content.startsWith('{')) {
      content = content.substring(1);
    }
    if (content.endsWith('}')) {
      content = content.substring(0, content.length - 1);
    }

    // Parser les propriétés en gérant les objets imbriqués
    int depth = 0;
    int start = 0;
    final List<String> properties = [];

    for (int i = 0; i < content.length; i++) {
      final char = content[i];
      if (char == '{') {
        depth++;
      } else if (char == '}') {
        depth--;
      } else if (char == ',' && depth == 0) {
        properties.add(content.substring(start, i).trim());
        start = i + 1;
      }
    }
    // Ajouter la dernière propriété
    if (start < content.length) {
      properties.add(content.substring(start).trim());
    }

    // Parser chaque propriété
    for (final prop in properties) {
      if (prop.isEmpty) continue;

      // Trouver le premier ':' qui n'est pas dans un objet imbriqué ou une string
      int colonIndex = -1;
      int depth2 = 0;
      bool inString = false;
      String? stringChar;

      for (int i = 0; i < prop.length; i++) {
        final char = prop[i];

        // Gérer les strings
        if (!inString && (char == "'" || char == '"')) {
          inString = true;
          stringChar = char;
        } else if (inString && char == stringChar) {
          inString = false;
          stringChar = null;
        } else if (!inString) {
          if (char == '{') {
            depth2++;
          } else if (char == '}') {
            depth2--;
          } else if (char == ':' && depth2 == 0) {
            colonIndex = i;
            break;
          }
        }
      }

      if (colonIndex == -1) {
        // Shorthand property: {varName} → look up varName in scope
        final varName = prop.trim();
        if (varName.isNotEmpty && RegExp(r'^\w+$').hasMatch(varName)) {
          result[varName] = _resolveShorthandProperty(varName);
        }
        continue;
      }

      String key = prop.substring(0, colonIndex).trim();

      // Retirer les guillemets de la clé si présents
      if ((key.startsWith("'") && key.endsWith("'")) ||
          (key.startsWith('"') && key.endsWith('"'))) {
        key = key.substring(1, key.length - 1);
      }

      final valueStr = prop.substring(colonIndex + 1).trim();

      // Parser la valeur
      result[key] = _parseJavaScriptValue(valueStr);
    }

    return result;
  }

  /// Parse une valeur JavaScript individuelle
  dynamic _parseJavaScriptValue(String valueStr) {
    final trimmed = valueStr.trim();

    // null
    if (trimmed == 'null') {
      return null;
    }

    // Booléen
    if (trimmed == 'true') {
      return true;
    }
    if (trimmed == 'false') {
      return false;
    }

    // Nombre
    final numValue = num.tryParse(trimmed);
    if (numValue != null) {
      return numValue;
    }

    // String (simple ou double quotes)
    if ((trimmed.startsWith("'") && trimmed.endsWith("'")) ||
        (trimmed.startsWith('"') && trimmed.endsWith('"'))) {
      return trimmed.substring(1, trimmed.length - 1);
    }

    // Objet imbriqué
    if (trimmed.startsWith('{') && trimmed.endsWith('}')) {
      return _parseJavaScriptObject(trimmed);
    }

    // Référence dynamique (objForm.value.xxx)
    if (trimmed.startsWith('objForm.value.')) {
      return '@value.${trimmed.substring('objForm.value.'.length)}';
    }

    // Retourner comme string par défaut
    return trimmed;
  }

  /// Resolves a shorthand property {varName} by looking up the variable scope
  ///
  /// If varName is found in scope, returns its value.
  /// Otherwise, treats it as a reference to objForm.value.varName
  dynamic _resolveShorthandProperty(String varName) {
    if (_variableScope.containsKey(varName)) {
      return _variableScope[varName];
    }
    // Default: assume it refers to the form field with the same name
    return '@value.$varName';
  }

  /// Évalue une condition JavaScript
  ///
  /// Convertit les références objForm.value.xxx en value.xxx
  /// et utilise HiddenExpressionEvaluator pour l'évaluation
  bool? evaluateJsCondition(String condition, Map<String, dynamic> context) {
    // Normaliser (null || undefined) → null
    String normalizedCondition = condition
        .replaceAll('(null || undefined)', 'null')
        .replaceAll('(undefined || null)', 'null');

    // Convertir objForm.controls.xxx.dirty en accès au context dirtyFields
    normalizedCondition = normalizedCondition.replaceAllMapped(
      RegExp(r'objForm\.controls\.(\w+)\.dirty'),
      (match) => 'controls.${match.group(1)}.dirty',
    );

    // Convertir objForm.value.xxx en value.xxx
    normalizedCondition = normalizedCondition
        .replaceAll('objForm.value.', 'value.')
        .replaceAll('objForm.value', 'value');

    // Gérer le cas !!value.xxx (double négation = vérifier existence)
    if (normalizedCondition.contains('!!')) {
      normalizedCondition = normalizedCondition.replaceAllMapped(
        RegExp(r'!!\s*(value\.\w+)'),
        (match) => '${match.group(1)} != null',
      );
    }

    // Gérer l'accès aux nomenclatures: meta.nomenclatures[value.id_xxx].cd_nomenclature
    final nomenclaturePattern = RegExp(
      r'meta\.nomenclatures\[value\.(\w+)\]\.(\w+)',
    );

    if (nomenclaturePattern.hasMatch(normalizedCondition)) {
      // Remplacer par la valeur réelle si possible
      normalizedCondition = normalizedCondition.replaceAllMapped(
        nomenclaturePattern,
        (match) {
          final fieldName = match.group(1)!;
          final property = match.group(2)!;

          final formValues = context['value'] as Map<String, dynamic>?;
          if (formValues == null) return "'_UNKNOWN_'";

          final nomenclatureId = formValues[fieldName];
          if (nomenclatureId == null) return "'_NULL_'";

          final nomenclature = nomenclatureCache[nomenclatureId];
          if (nomenclature == null) return "'_NOT_FOUND_'";

          String? propValue;
          switch (property) {
            case 'cd_nomenclature':
              propValue = nomenclature.cdNomenclature;
              break;
            case 'label_default':
              propValue = nomenclature.labelDefault;
              break;
            case 'label_fr':
              propValue = nomenclature.labelFr;
              break;
            case 'mnemonique':
              propValue = nomenclature.mnemonique;
              break;
          }

          return propValue != null ? "'$propValue'" : "'_NULL_'";
        },
      );
    }

    // Créer une expression arrow function pour l'évaluateur
    final expression = '({value, meta}) => $normalizedCondition';

    return evaluateExpression(expression, context);
  }

  /// Résout les références dynamiques dans les valeurs patchValue
  ///
  /// Convertit @value.xxx en valeur réelle du formulaire
  /// Évalue @expr:EXPRESSION avec les valeurs courantes
  Map<String, dynamic> resolvePatchValues(
    Map<String, dynamic> patchValues,
    Map<String, dynamic> formValues, {
    Set<String>? dirtyFields,
  }) {
    final resolved = <String, dynamic>{};

    for (final entry in patchValues.entries) {
      final key = entry.key;
      final value = entry.value;

      if (value is String && value.startsWith('@value.')) {
        // Résoudre la référence
        final fieldName = value.substring('@value.'.length);
        resolved[key] = formValues[fieldName];
      } else if (value is String && value.startsWith('@expr:')) {
        // Évaluer l'expression dynamique
        final expr = value.substring('@expr:'.length);
        resolved[key] = _evaluateRuntimeExpression(expr, formValues, dirtyFields: dirtyFields);
      } else if (value is Map<String, dynamic>) {
        // Récursivement résoudre les maps imbriqués
        resolved[key] = resolvePatchValues(value, formValues, dirtyFields: dirtyFields);
      } else if (value is Map) {
        resolved[key] = resolvePatchValues(
          Map<String, dynamic>.from(value),
          formValues,
          dirtyFields: dirtyFields,
        );
      } else {
        resolved[key] = value;
      }
    }

    return resolved;
  }

  /// Evaluates a runtime expression with current form values
  ///
  /// Supports:
  /// - objForm.value.xxx → form field lookup
  /// - Arithmetic: a + b
  /// - Ternary: condition ? trueVal : falseVal
  /// - Fallback: objForm.value.xxx || defaultValue
  /// - Literals: null, true, false, numbers, strings
  dynamic _evaluateRuntimeExpression(
    String expr,
    Map<String, dynamic> formValues, {
    Set<String>? dirtyFields,
  }) {
    final trimmed = _unwrapParens(expr.trim());

    // Normalize (null || undefined) → null
    final normalized = trimmed
        .replaceAll('(null || undefined)', 'null')
        .replaceAll('(undefined || null)', 'null');

    // Check for ternary at depth 0
    final qIdx = _findOperatorAtDepth0(normalized, '?');
    if (qIdx != -1) {
      final condition = normalized.substring(0, qIdx).trim();
      final rest = normalized.substring(qIdx + 1);
      final colonIdx = _findOperatorAtDepth0(rest, ':');
      if (colonIdx != -1) {
        final trueExpr = rest.substring(0, colonIdx).trim();
        final falseExpr = rest.substring(colonIdx + 1).trim();

        // Evaluate condition as boolean
        final context = {'value': formValues};
        final condResult = evaluateJsCondition(condition, context);

        if (condResult == true) {
          return _evaluateRuntimeExpression(trueExpr, formValues, dirtyFields: dirtyFields);
        } else {
          return _evaluateRuntimeExpression(falseExpr, formValues, dirtyFields: dirtyFields);
        }
      }
    }

    // Check for arithmetic '+' at depth 0
    final plusIdx = _findOperatorAtDepth0(normalized, '+');
    if (plusIdx != -1) {
      final left = normalized.substring(0, plusIdx).trim();
      final right = normalized.substring(plusIdx + 1).trim();

      final leftVal = _evaluateRuntimeExpression(left, formValues, dirtyFields: dirtyFields);
      final rightVal = _evaluateRuntimeExpression(right, formValues, dirtyFields: dirtyFields);

      if (leftVal is num && rightVal is num) {
        return leftVal + rightVal;
      }
      // String concatenation
      return '${leftVal ?? ''}${rightVal ?? ''}';
    }

    // Check for fallback '||' at depth 0
    final orIdx = _findOperatorAtDepth0(normalized, '||');
    if (orIdx != -1) {
      final left = normalized.substring(0, orIdx).trim();
      final right = normalized.substring(orIdx + 2).trim();

      final leftVal = _evaluateRuntimeExpression(left, formValues, dirtyFields: dirtyFields);
      // JS-like falsy check: null, false, 0, '' are falsy
      if (leftVal == null || leftVal == false || leftVal == 0 || leftVal == '') {
        return _evaluateRuntimeExpression(right, formValues, dirtyFields: dirtyFields);
      }
      return leftVal;
    }

    // Simple references and literals
    if (normalized.startsWith('objForm.value.')) {
      final fieldName = normalized.substring('objForm.value.'.length);
      return formValues[fieldName];
    }

    // objForm.controls.xxx.dirty
    final dirtyMatch = RegExp(r'^objForm\.controls\.(\w+)\.dirty$').firstMatch(normalized);
    if (dirtyMatch != null) {
      final fieldName = dirtyMatch.group(1)!;
      return dirtyFields?.contains(fieldName) ?? false;
    }

    // Literals
    if (normalized == 'null' || normalized == 'undefined') return null;
    if (normalized == 'true') return true;
    if (normalized == 'false') return false;
    final numVal = num.tryParse(normalized);
    if (numVal != null) return numVal;
    if ((normalized.startsWith("'") && normalized.endsWith("'")) ||
        (normalized.startsWith('"') && normalized.endsWith('"'))) {
      return normalized.substring(1, normalized.length - 1);
    }

    return null;
  }
}
