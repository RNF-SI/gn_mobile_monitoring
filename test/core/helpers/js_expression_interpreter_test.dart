import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/core/helpers/js_expression_interpreter.dart';
import 'package:gn_mobile_monitoring/core/helpers/ts_to_dart_converter.dart';

/// Compare l'interpréteur au moteur JavaScript de référence (Node) sur le
/// corpus `test/fixtures/js_expressions_corpus.json` : expressions
/// hidden/required des protocoles (PnX-SI/protocoles_suivi et fork
/// Geomaticien-shf) + cas synthétiques couvrant les bugs de l'audit 09/2026.
///
/// Régénération : scripts/protocoles_audit/generate_corpus.sh
void main() {
  final corpus = (jsonDecode(
          File('test/fixtures/js_expressions_corpus.json').readAsStringSync())
      as List)
      .cast<Map<String, dynamic>>();
  final interpreter = JsExpressionInterpreter();

  final byExpr = <String, List<Map<String, dynamic>>>{};
  for (final c in corpus) {
    byExpr.putIfAbsent(c['expr'] as String, () => []).add(c);
  }

  group('Corpus JavaScript (référence Node)', () {
    for (final entry in byExpr.entries) {
      final source = entry.value.first['source'];
      test('$source : ${entry.key}', () {
        final failures = <String>[];
        for (final c in entry.value) {
          final context = Map<String, dynamic>.from(c['context'] as Map);
          final actual = interpreter.evaluateTruthy(entry.key, context);
          // Une exception JS donne null (champ affiché / non requis).
          final expected = c.containsKey('error') ? null : c['expected'];
          if (actual != expected) {
            failures.add('contexte ${jsonEncode(context)} : '
                'attendu $expected, obtenu $actual');
          }
        }
        expect(failures, isEmpty, reason: failures.join('\n'));
      });
    }
  });

  // Les modules installés avant 09/2026 stockent les `hidden` convertis au
  // format Dart par TsToDartConverter : ils doivent donner le même résultat.
  group('Expressions converties au format Dart (compatibilité)', () {
    final protocolHidden = byExpr.entries.where((e) =>
        e.value.first['source'] != 'synthetic' &&
        e.key.trim().startsWith('({') &&
        (e.value.first['source'] as String).endsWith('.hidden'));
    for (final entry in protocolHidden) {
      test(entry.key, () {
        final converted = TsToDartConverter.convertToDart(entry.key);
        final failures = <String>[];
        for (final c in entry.value) {
          final context = Map<String, dynamic>.from(c['context'] as Map);
          final expected = c.containsKey('error') ? null : c['expected'];
          final actual = interpreter.evaluateTruthy(converted, context);
          if (actual != expected) {
            failures.add('$converted, contexte ${jsonEncode(context)} : '
                'attendu $expected, obtenu $actual');
          }
        }
        expect(failures, isEmpty, reason: failures.join('\n'));
      });
    }
  });

  group('Valeurs brutes', () {
    dynamic eval(String e, [Map<String, dynamic> ctx = const {}]) =>
        interpreter.evaluate(e, ctx);

    test('arithmétique et concaténation JavaScript', () {
      expect(eval("'T' + 3 + 'Q' + 5"), 'T3Q5');
      expect(eval('1 + 2'), 3);
      expect(eval("'1' + 2"), '12');
      expect(eval("'6' - 2"), 4);
      expect(eval('0.1 * 3 > 0.3'), isTrue);
      expect(eval('7 % 3'), 1);
      expect((eval('0 / 0') as num).isNaN, isTrue);
    });

    test('undefined et null', () {
      expect(eval('({value}) => value.x', {'value': {}}), same(undefined));
      expect(eval('({value}) => value.x', {'value': {'x': null}}), isNull);
      expect(eval('null ?? 3'), 3);
    });

    test('Map Dart à clés entières (meta.nomenclatures)', () {
      final ctx = {
        'value': {'t': 12},
        'meta': {
          'nomenclatures': {
            12: {'cd_nomenclature': 'Co'}
          }
        },
      };
      expect(
          eval('({value, meta}) => meta.nomenclatures[value.t].cd_nomenclature',
              ctx),
          'Co');
    });

    test('controls.x.dirty (règles change)', () {
      final ctx = {
        'value': {'a': 1},
        'dirtyFields': {'a'},
      };
      expect(eval('({value}) => controls.a.dirty', ctx), isTrue);
      expect(eval('({value}) => controls.b.dirty', ctx), isFalse);
    });

    test('format Dart hérité : (value) lié aux valeurs du formulaire', () {
      // Forme produite par TsToDartConverter : `value` = context['value'].
      final ctx = {
        'value': {'a': 'x', 'b': null},
      };
      expect(interpreter.evaluateTruthy("(value) => value['a'] || value['b']", ctx),
          isTrue);
      expect(
          interpreter.evaluateTruthy(
              "(value) => value['a'] == value['b'] as bool", ctx),
          isFalse);
      expect(
          interpreter.evaluateTruthy(
              "(meta) => meta['dataset'] && (meta['dataset'] as Map).keys.length == 1",
              {
                'meta': {
                  'dataset': {'1': {}}
                }
              }),
          isTrue);
    });

    test('erreur de syntaxe → null', () {
      expect(interpreter.evaluateTruthy('({value}) => value.', {}), isNull);
      expect(interpreter.evaluateTruthy('({value}) => (a', {}), isNull);
    });
  });
}
