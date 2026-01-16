import 'package:flutter_test/flutter_test.dart';

/// Tests for the change rules conversion that happens at module download time
/// These test functions mirror the private methods in ModulesRepositoryImpl
void main() {
  group('Change Rules Conversion at Download Time', () {
    group('convertChangeRulesToStructured', () {
      test('should convert simple if/patchValue block', () {
        final changeArray = [
          "({objForm, meta}) => {",
          "if (objForm.value.presence === 'Non') {",
          "objForm.patchValue({count_min : 0, count_max : 0})",
          "}",
          "}",
        ];

        final rules = _convertChangeRulesToStructured(changeArray);

        expect(rules.length, equals(1));
        expect(rules[0]['condition'], contains("presence === 'Non'"));
        expect(rules[0]['patchValues']['count_min'], equals(0));
        expect(rules[0]['patchValues']['count_max'], equals(0));
      });

      test('should convert multiple rules', () {
        final changeArray = [
          "({objForm, meta}) => {",
          "if (objForm.value.presence === 'Non') {",
          "objForm.patchValue({count_min : 0})",
          "}",
          "if (objForm.value.presence === 'Oui') {",
          "objForm.patchValue({count_min : 1})",
          "}",
          "}",
        ];

        final rules = _convertChangeRulesToStructured(changeArray);

        expect(rules.length, equals(2));
      });

      test('should handle nested objects in patchValue', () {
        final changeArray = [
          "({objForm, meta}) => {",
          "if (objForm.value.presence === 'Non') {",
          "objForm.patchValue({cd_nom : {'cd_nom': 914450, 'lb_nom': 'Amphibia'}})",
          "}",
          "}",
        ];

        final rules = _convertChangeRulesToStructured(changeArray);

        expect(rules.length, equals(1));
        expect(rules[0]['patchValues']['cd_nom'], isA<Map>());
        final cdNom = rules[0]['patchValues']['cd_nom'] as Map;
        expect(cdNom['cd_nom'], equals(914450));
        expect(cdNom['lb_nom'], equals('Amphibia'));
      });

      test('should handle null values', () {
        final changeArray = [
          "({objForm, meta}) => {",
          "if (objForm.value.presence === 'Non') {",
          "objForm.patchValue({id_nomenclature_typ_denbr : null})",
          "}",
          "}",
        ];

        final rules = _convertChangeRulesToStructured(changeArray);

        expect(rules.length, equals(1));
        expect(rules[0]['patchValues']['id_nomenclature_typ_denbr'], isNull);
      });

      test('should handle dynamic references', () {
        final changeArray = [
          "({objForm, meta}) => {",
          "if (objForm.value.count_max < objForm.value.count_min) {",
          "objForm.patchValue({count_max : objForm.value.count_min})",
          "}",
          "}",
        ];

        final rules = _convertChangeRulesToStructured(changeArray);

        expect(rules.length, equals(1));
        expect(rules[0]['patchValues']['count_max'], equals('@value.count_min'));
      });

      test('should handle full PopAmphibien config', () {
        final changeArray = [
          "({objForm, meta}) => {",
          "if (objForm.value.presence === 'Non') {",
          "objForm.patchValue({id_nomenclature_typ_denbr : null, count_min : 0, count_max : 0, id_nomenclature_sex : null, id_nomenclature_stade: null, cd_nom : {'cd_nom': 914450, 'lb_nom': 'Amphibia', 'nom_valide': 'Amphibia', 'nom_vern' : 'Amphibiens, batraciens'}}, {emitEvent : false})",
          "}",
          "if (objForm.value.presence === 'Oui' && objForm.value.count_min === 0) {",
          "objForm.patchValue({count_min : null, count_max : null}, {emitEvent : false})",
          "}",
          "if (!!objForm.value.count_min && objForm.value.count_max < objForm.value.count_min) {",
          "objForm.patchValue({count_max : objForm.value.count_min}, {emitEvent : false})",
          "}",
          "}",
        ];

        final rules = _convertChangeRulesToStructured(changeArray);

        expect(rules.length, equals(3));

        // First rule: presence === 'Non'
        expect(rules[0]['patchValues']['count_min'], equals(0));
        expect(rules[0]['patchValues']['count_max'], equals(0));
        expect(rules[0]['patchValues']['id_nomenclature_typ_denbr'], isNull);
        expect(rules[0]['patchValues']['cd_nom'], isA<Map>());

        // Second rule: presence === 'Oui' && count_min === 0
        expect(rules[1]['patchValues']['count_min'], isNull);
        expect(rules[1]['patchValues']['count_max'], isNull);

        // Third rule: count_max < count_min
        expect(rules[2]['patchValues']['count_max'], equals('@value.count_min'));
      });
    });
  });
}

/// Mirror of the private method in ModulesRepositoryImpl
/// This allows testing the conversion logic directly
List<Map<String, dynamic>> _convertChangeRulesToStructured(
    List<dynamic> changeArray) {
  final List<Map<String, dynamic>> rules = [];

  // Reconstituer le code complet
  final fullCode = changeArray.map((e) => e.toString()).join('\n');

  // Extraire tous les blocs if/patchValue
  final ifBlockPattern = RegExp(
    r'if\s*\((.+?)\)\s*\{[^}]*?(?:objForm\.)?patchValue\s*\((\{.+?\})(?:\s*,\s*\{[^}]*\})?\s*\)',
    multiLine: true,
    dotAll: true,
  );

  final matches = ifBlockPattern.allMatches(fullCode);

  for (final match in matches) {
    final condition = match.group(1)?.trim() ?? '';
    final patchValueStr = match.group(2)?.trim() ?? '{}';

    if (condition.isNotEmpty) {
      final patchValues = _parseJavaScriptObject(patchValueStr);

      rules.add({
        'condition': condition,
        'patchValues': patchValues,
      });
    }
  }

  return rules;
}

Map<String, dynamic> _parseJavaScriptObject(String jsObject) {
  final Map<String, dynamic> result = {};

  String content = jsObject.trim();
  if (content.startsWith('{')) {
    content = content.substring(1);
  }
  if (content.endsWith('}')) {
    content = content.substring(0, content.length - 1);
  }

  int depth = 0;
  int start = 0;
  bool inString = false;
  String? stringChar;
  final List<String> properties = [];

  for (int i = 0; i < content.length; i++) {
    final char = content[i];

    if (!inString && (char == "'" || char == '"')) {
      inString = true;
      stringChar = char;
    } else if (inString && char == stringChar) {
      inString = false;
      stringChar = null;
    } else if (!inString) {
      if (char == '{') {
        depth++;
      } else if (char == '}') {
        depth--;
      } else if (char == ',' && depth == 0) {
        properties.add(content.substring(start, i).trim());
        start = i + 1;
      }
    }
  }

  if (start < content.length) {
    properties.add(content.substring(start).trim());
  }

  for (final prop in properties) {
    if (prop.isEmpty) continue;

    int colonIndex = -1;
    int depth2 = 0;
    bool inStr = false;
    String? strChar;

    for (int i = 0; i < prop.length; i++) {
      final char = prop[i];

      if (!inStr && (char == "'" || char == '"')) {
        inStr = true;
        strChar = char;
      } else if (inStr && char == strChar) {
        inStr = false;
        strChar = null;
      } else if (!inStr) {
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

    if ((key.startsWith("'") && key.endsWith("'")) ||
        (key.startsWith('"') && key.endsWith('"'))) {
      key = key.substring(1, key.length - 1);
    }

    final valueStr = prop.substring(colonIndex + 1).trim();
    result[key] = _parseJavaScriptValue(valueStr);
  }

  return result;
}

dynamic _parseJavaScriptValue(String valueStr) {
  final trimmed = valueStr.trim();

  if (trimmed == 'null') return null;
  if (trimmed == 'true') return true;
  if (trimmed == 'false') return false;

  final numValue = num.tryParse(trimmed);
  if (numValue != null) return numValue;

  if ((trimmed.startsWith("'") && trimmed.endsWith("'")) ||
      (trimmed.startsWith('"') && trimmed.endsWith('"'))) {
    return trimmed.substring(1, trimmed.length - 1);
  }

  if (trimmed.startsWith('{') && trimmed.endsWith('}')) {
    return _parseJavaScriptObject(trimmed);
  }

  if (trimmed.startsWith('objForm.value.')) {
    return '@value.${trimmed.substring('objForm.value.'.length)}';
  }

  return trimmed;
}
