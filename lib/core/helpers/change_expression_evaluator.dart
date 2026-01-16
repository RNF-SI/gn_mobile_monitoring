import 'package:gn_mobile_monitoring/core/helpers/hidden_expression_evaluator.dart';
import 'package:gn_mobile_monitoring/domain/model/nomenclature.dart';

/// Représente une règle de changement parsée depuis le format JavaScript
class ParsedChangeRule {
  /// Condition de la règle (ex: "objForm.value.presence === 'Non'")
  final String condition;

  /// Valeurs à appliquer quand la condition est vraie
  final Map<String, dynamic> patchValues;

  const ParsedChangeRule({
    required this.condition,
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

  ChangeExpressionEvaluator({
    this.nomenclatureCache = const {},
  });

  /// Parse un tableau de strings JavaScript en liste de règles
  ///
  /// Format d'entrée (tableau de strings formant une fonction JS):
  /// ```
  /// ["({objForm, meta}) => {",
  ///  "if (objForm.value.presence === 'Non') {",
  ///  "objForm.patchValue({...})",
  ///  "}",
  ///  ...]
  /// ```
  List<ParsedChangeRule> parseJavaScriptChangeRules(List<dynamic> changeArray) {
    final List<ParsedChangeRule> rules = [];

    // Reconstituer le code complet
    final fullCode = changeArray.map((e) => e.toString()).join('\n');

    // Extraire tous les blocs if/patchValue
    // Pattern pour matcher: if (condition) { patchValue({...}) }
    final ifBlockPattern = RegExp(
      r'if\s*\((.+?)\)\s*\{[^}]*?(?:objForm\.)?patchValue\s*\((\{.+?\})(?:\s*,\s*\{[^}]*\})?\s*\)',
      multiLine: true,
      dotAll: true,
    );

    final matches = ifBlockPattern.allMatches(fullCode);

    for (final match in matches) {
      final condition = match.group(1)?.trim() ?? '';
      final patchValueStr = match.group(2)?.trim() ?? '{}';

      // Parser l'objet patchValue
      final patchValues = _parseJavaScriptObject(patchValueStr);

      if (condition.isNotEmpty && patchValues.isNotEmpty) {
        rules.add(ParsedChangeRule(
          condition: condition,
          patchValues: patchValues,
        ));
      }
    }

    return rules;
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

      if (colonIndex == -1) continue;

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

  /// Évalue une condition JavaScript
  ///
  /// Convertit les références objForm.value.xxx en value.xxx
  /// et utilise HiddenExpressionEvaluator pour l'évaluation
  bool? evaluateJsCondition(String condition, Map<String, dynamic> context) {
    // Convertir objForm.value.xxx en value.xxx
    String normalizedCondition = condition
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
  Map<String, dynamic> resolvePatchValues(
    Map<String, dynamic> patchValues,
    Map<String, dynamic> formValues,
  ) {
    final resolved = <String, dynamic>{};

    for (final entry in patchValues.entries) {
      final key = entry.key;
      final value = entry.value;

      if (value is String && value.startsWith('@value.')) {
        // Résoudre la référence
        final fieldName = value.substring('@value.'.length);
        resolved[key] = formValues[fieldName];
      } else if (value is Map<String, dynamic>) {
        // Récursivement résoudre les maps imbriqués
        resolved[key] = resolvePatchValues(value, formValues);
      } else if (value is Map) {
        resolved[key] = resolvePatchValues(
          Map<String, dynamic>.from(value),
          formValues,
        );
      } else {
        resolved[key] = value;
      }
    }

    return resolved;
  }
}
