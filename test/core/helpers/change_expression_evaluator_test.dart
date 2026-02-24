import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/core/helpers/change_expression_evaluator.dart';
import 'package:gn_mobile_monitoring/domain/model/nomenclature.dart';

void main() {
  group('ChangeExpressionEvaluator', () {
    late ChangeExpressionEvaluator evaluator;

    setUp(() {
      evaluator = ChangeExpressionEvaluator();
    });

    group('parseJavaScriptChangeRules', () {
      test('should parse simple if/patchValue block', () {
        final changeArray = [
          "({objForm, meta}) => {",
          "if (objForm.value.presence === 'Non') {",
          "objForm.patchValue({count_min : 0, count_max : 0})",
          "}",
          "}",
        ];

        final rules = evaluator.parseJavaScriptChangeRules(changeArray);

        expect(rules.length, equals(1));
        expect(rules[0].condition, contains("objForm.value.presence === 'Non'"));
        expect(rules[0].patchValues['count_min'], equals(0));
        expect(rules[0].patchValues['count_max'], equals(0));
      });

      test('should parse multiple if/patchValue blocks', () {
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

        final rules = evaluator.parseJavaScriptChangeRules(changeArray);

        expect(rules.length, equals(2));
      });

      test('should parse nested object in patchValue', () {
        final changeArray = [
          "({objForm, meta}) => {",
          "if (objForm.value.presence === 'Non') {",
          "objForm.patchValue({cd_nom : {'cd_nom': 914450, 'lb_nom': 'Amphibia'}})",
          "}",
          "}",
        ];

        final rules = evaluator.parseJavaScriptChangeRules(changeArray);

        expect(rules.length, equals(1));
        expect(rules[0].patchValues['cd_nom'], isA<Map>());
        final cdNom = rules[0].patchValues['cd_nom'] as Map;
        expect(cdNom['cd_nom'], equals(914450));
        expect(cdNom['lb_nom'], equals('Amphibia'));
      });

      test('should parse null values', () {
        final changeArray = [
          "({objForm, meta}) => {",
          "if (objForm.value.presence === 'Non') {",
          "objForm.patchValue({id_nomenclature_typ_denbr : null})",
          "}",
          "}",
        ];

        final rules = evaluator.parseJavaScriptChangeRules(changeArray);

        expect(rules.length, equals(1));
        expect(rules[0].patchValues['id_nomenclature_typ_denbr'], isNull);
      });

      test('should parse complex PopAmphibien configuration', () {
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

        final rules = evaluator.parseJavaScriptChangeRules(changeArray);

        expect(rules.length, equals(3));

        // First rule: presence === 'Non'
        expect(rules[0].patchValues['count_min'], equals(0));
        expect(rules[0].patchValues['count_max'], equals(0));
        expect(rules[0].patchValues['id_nomenclature_typ_denbr'], isNull);
        expect(rules[0].patchValues['cd_nom'], isA<Map>());

        // Second rule: presence === 'Oui' && count_min === 0
        expect(rules[1].patchValues['count_min'], isNull);
        expect(rules[1].patchValues['count_max'], isNull);

        // Third rule: count_max < count_min
        expect(rules[2].patchValues['count_max'], equals('@value.count_min'));
      });

      group('const declarations and shorthand properties', () {
        test('should parse const declarations with null literal', () {
          final changeArray = [
            "({objForm, meta}) => {",
            "const nb_passereau = null;",
            "objForm.patchValue({nb_passereau});",
            "}",
            "",
          ];

          final rules = evaluator.parseJavaScriptChangeRules(changeArray);

          expect(rules.length, equals(1));
          expect(rules[0].condition, isNull); // unconditional
          expect(rules[0].patchValues['nb_passereau'], isNull);
        });

        test('should parse const declarations with numeric literal', () {
          final changeArray = [
            "({objForm, meta}) => {",
            "const nb_hulotte = 0;",
            "objForm.patchValue({nb_hulotte});",
            "}",
            "",
          ];

          final rules = evaluator.parseJavaScriptChangeRules(changeArray);

          expect(rules.length, equals(1));
          expect(rules[0].patchValues['nb_hulotte'], equals(0));
        });

        test('should parse chained const assignments', () {
          final changeArray = [
            "({objForm, meta}) => {",
            "const a = b = c = false;",
            "objForm.patchValue({a, b, c});",
            "}",
            "",
          ];

          final rules = evaluator.parseJavaScriptChangeRules(changeArray);

          expect(rules.length, equals(1));
          expect(rules[0].patchValues['a'], equals(false));
          expect(rules[0].patchValues['b'], equals(false));
          expect(rules[0].patchValues['c'], equals(false));
        });

        test('should parse const with objForm.value reference and fallback ||', () {
          final changeArray = [
            "({objForm, meta}) => {",
            "const val = objForm.value.tout_cocher || false;",
            "objForm.patchValue({val});",
            "}",
            "",
          ];

          final rules = evaluator.parseJavaScriptChangeRules(changeArray);

          expect(rules.length, equals(1));
          // The value should be stored as @expr: since it contains ||
          expect(rules[0].patchValues['val'], isA<String>());
          expect((rules[0].patchValues['val'] as String).startsWith('@expr:'), isTrue);
        });

        test('should parse const with ternary expression', () {
          final changeArray = [
            "({objForm, meta}) => {",
            "const surf_releve = (objForm.value.type_placette == 'C' ? objForm.value.surf_releve_c : objForm.value.surf_releve_q);",
            "objForm.patchValue({surf_releve});",
            "}",
            "",
          ];

          final rules = evaluator.parseJavaScriptChangeRules(changeArray);

          expect(rules.length, equals(1));
          expect(rules[0].condition, isNull); // unconditional
          expect(rules[0].patchValues['surf_releve'], isA<String>());
          expect((rules[0].patchValues['surf_releve'] as String).startsWith('@expr:'), isTrue);
        });

        test('should parse const with arithmetic expression', () {
          final changeArray = [
            "({objForm, meta}) => {",
            "const nb_total = (objForm.value.nb_before_rep + objForm.value.nb_repasse);",
            "objForm.patchValue({nb_total});",
            "}",
            "",
          ];

          final rules = evaluator.parseJavaScriptChangeRules(changeArray);

          expect(rules.length, equals(1));
          expect(rules[0].patchValues['nb_total'], isA<String>());
          expect((rules[0].patchValues['nb_total'] as String).startsWith('@expr:'), isTrue);
        });
      });

      group('unconditional patchValue', () {
        test('should parse unconditional patchValue', () {
          final changeArray = [
            "({objForm, meta}) => {",
            "objForm.patchValue({field1: 42});",
            "}",
            "",
          ];

          final rules = evaluator.parseJavaScriptChangeRules(changeArray);

          expect(rules.length, equals(1));
          expect(rules[0].condition, isNull);
          expect(rules[0].patchValues['field1'], equals(42));
        });
      });

      group('ternary-conditional patchValue', () {
        test('should parse ternary conditional patchValue', () {
          final changeArray = [
            "({objForm, meta}) => {",
            "const nb_hulotte = 0;",
            "(objForm.value.hulotte != 'Oui' ? objForm.patchValue({nb_hulotte}) : '');",
            "}",
            "",
          ];

          final rules = evaluator.parseJavaScriptChangeRules(changeArray);

          expect(rules.length, equals(1));
          expect(rules[0].condition, equals("objForm.value.hulotte != 'Oui'"));
          expect(rules[0].patchValues['nb_hulotte'], equals(0));
        });

        test('should parse ternary with complex condition', () {
          final changeArray = [
            "({objForm, meta}) => {",
            "const chev_chant = null;",
            "(objForm.value.cd_nom != (null || undefined) && objForm.value.cd_nom != 3507 ? objForm.patchValue({chev_chant}) : '');",
            "}",
            "",
          ];

          final rules = evaluator.parseJavaScriptChangeRules(changeArray);

          expect(rules.length, equals(1));
          expect(rules[0].condition, isNotNull);
          expect(rules[0].patchValues['chev_chant'], isNull);
        });
      });

      group('console.log statements', () {
        test('should skip console.log statements', () {
          final changeArray = [
            "({objForm, meta}) => {",
            "console.log( objForm.value.tout_cocher );",
            "objForm.patchValue({field1: 1});",
            "}",
            "",
          ];

          final rules = evaluator.parseJavaScriptChangeRules(changeArray);

          expect(rules.length, equals(1));
          expect(rules[0].patchValues['field1'], equals(1));
        });
      });

      group('full module configurations', () {
        test('should parse full PopAmphibien config (4 rules)', () {
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
            "if (!!objForm.value.count_min && meta.nomenclatures[objForm.value.id_nomenclature_typ_denbr].cd_nomenclature === 'Co' && objForm.value.count_max !== objForm.value.count_min) {",
            "objForm.patchValue({count_max : objForm.value.count_min}, {emitEvent : false})",
            "}",
            "}",
            "",
          ];

          final rules = evaluator.parseJavaScriptChangeRules(changeArray);

          expect(rules.length, equals(4));

          // Rule 1: presence === 'Non'
          expect(rules[0].condition, contains("presence === 'Non'"));
          expect(rules[0].patchValues.length, equals(6));

          // Rule 2: presence === 'Oui' && count_min === 0
          expect(rules[1].condition, contains("presence === 'Oui'"));
          expect(rules[1].patchValues['count_min'], isNull);

          // Rule 3: count_max < count_min
          expect(rules[2].patchValues['count_max'], equals('@value.count_min'));

          // Rule 4: nomenclature check
          expect(rules[3].condition, contains('meta.nomenclatures'));
        });

        test('should parse full suivi_phytocio config', () {
          final changeArray = [
            "({objForm, meta}) => {",
            "const surf_releve = (objForm.value.type_placette == 'C' ? objForm.value.surf_releve_c : objForm.value.surf_releve_q)",
            "objForm.patchValue({surf_releve})",
            "}",
            "",
          ];

          final rules = evaluator.parseJavaScriptChangeRules(changeArray);

          expect(rules.length, equals(1));
          expect(rules[0].condition, isNull); // unconditional
          expect(rules[0].patchValues.containsKey('surf_releve'), isTrue);
          // surf_releve should be a @expr: since it's a ternary
          final val = rules[0].patchValues['surf_releve'];
          expect(val, isA<String>());
          expect((val as String).startsWith('@expr:'), isTrue);
        });

        test('should parse full petite_chouette_montagne config', () {
          final changeArray = [
            "({objForm, meta}) => {",
            "const nb_passereau = null;",
            "const chev_chant = null;",
            "const sexe = null;",
            "const nb_total = (objForm.value.nb_before_rep + objForm.value.nb_repasse);",
            "const nb_hulotte = 0;",
            "objForm.patchValue({nb_total});",
            "(objForm.value.cd_nom != (null || undefined) && objForm.value.cd_nom != 3507 ? objForm.patchValue({nb_passereau}) : '');",
            "(objForm.value.cd_nom != (null || undefined) && objForm.value.cd_nom != 3507 ? objForm.patchValue({chev_chant}) : '');",
            "(objForm.value.cd_nom != (null || undefined) && objForm.value.cd_nom != 3507 ? objForm.patchValue({sexe}) : '');",
            "(objForm.value.hulotte != 'Oui' ? objForm.patchValue({nb_hulotte}) : '');",
            "}",
            "",
          ];

          final rules = evaluator.parseJavaScriptChangeRules(changeArray);

          expect(rules.length, equals(5));

          // Rule 1: unconditional nb_total
          expect(rules[0].condition, isNull);
          expect(rules[0].patchValues.containsKey('nb_total'), isTrue);

          // Rule 2: ternary conditional nb_passereau
          expect(rules[1].condition, isNotNull);
          expect(rules[1].patchValues['nb_passereau'], isNull);

          // Rule 3: ternary conditional chev_chant
          expect(rules[2].condition, isNotNull);
          expect(rules[2].patchValues['chev_chant'], isNull);

          // Rule 4: ternary conditional sexe
          expect(rules[3].condition, isNotNull);
          expect(rules[3].patchValues['sexe'], isNull);

          // Rule 5: ternary conditional nb_hulotte
          expect(rules[4].condition, contains("hulotte"));
          expect(rules[4].patchValues['nb_hulotte'], equals(0));
        });

        test('should parse full lichgen_bio_indicateurs config', () {
          final changeArray = [
            "({objForm, meta}) => {",
            "console.log( objForm.value.tout_cocher );",
            "const presence_arbre_1 = presence_arbre_2 = presence_arbre_3 = presence_arbre_4 = presence_arbre_5 = presence_arbre_6 = presence_arbre_7 = presence_arbre_8 = presence_arbre_9 = presence_arbre_10 = objForm.value.tout_cocher || false;",
            "if (!objForm.controls.presence_arbre_1.dirty && !objForm.controls.presence_arbre_2.dirty && !objForm.controls.presence_arbre_3.dirty && !objForm.controls.presence_arbre_4.dirty && !objForm.controls.presence_arbre_5.dirty && !objForm.controls.presence_arbre_6.dirty && !objForm.controls.presence_arbre_7.dirty && !objForm.controls.presence_arbre_8.dirty && !objForm.controls.presence_arbre_9.dirty && !objForm.controls.presence_arbre_10.dirty ) {",
            "objForm.patchValue({presence_arbre_1, presence_arbre_2, presence_arbre_3, presence_arbre_4, presence_arbre_5, presence_arbre_6, presence_arbre_7, presence_arbre_8, presence_arbre_9, presence_arbre_10})",
            "}",
            "}",
            "",
          ];

          final rules = evaluator.parseJavaScriptChangeRules(changeArray);

          expect(rules.length, equals(1));

          // Conditional on all dirty checks
          expect(rules[0].condition, isNotNull);
          expect(rules[0].condition, contains('controls'));
          expect(rules[0].condition, contains('dirty'));

          // Should have 10 shorthand properties resolved from scope
          expect(rules[0].patchValues.length, equals(10));
          expect(rules[0].patchValues.containsKey('presence_arbre_1'), isTrue);
          expect(rules[0].patchValues.containsKey('presence_arbre_10'), isTrue);

          // All shorthand properties should resolve to the same @expr value
          // (from chained const assignment with || fallback)
          for (int i = 1; i <= 10; i++) {
            final val = rules[0].patchValues['presence_arbre_$i'];
            expect(val, isA<String>());
            expect((val as String).startsWith('@expr:'), isTrue);
          }
        });
      });
    });

    group('evaluateJsCondition', () {
      test('should evaluate simple equality', () {
        final context = {
          'value': {'presence': 'Non'},
        };

        final result = evaluator.evaluateJsCondition(
          "objForm.value.presence === 'Non'",
          context,
        );

        expect(result, isTrue);
      });

      test('should evaluate equality with different value', () {
        final context = {
          'value': {'presence': 'Oui'},
        };

        final result = evaluator.evaluateJsCondition(
          "objForm.value.presence === 'Non'",
          context,
        );

        expect(result, isFalse);
      });

      test('should evaluate numeric comparison', () {
        final context = {
          'value': {'count_max': 3, 'count_min': 5},
        };

        final result = evaluator.evaluateJsCondition(
          "objForm.value.count_max < objForm.value.count_min",
          context,
        );

        expect(result, isTrue);
      });

      test('should evaluate AND condition', () {
        final context = {
          'value': {'presence': 'Oui', 'count_min': 0},
        };

        final result = evaluator.evaluateJsCondition(
          "objForm.value.presence === 'Oui' && objForm.value.count_min === 0",
          context,
        );

        expect(result, isTrue);
      });

      test('should evaluate double negation (!!)', () {
        final context = {
          'value': {'count_min': 5},
        };

        final result = evaluator.evaluateJsCondition(
          "!!objForm.value.count_min",
          context,
        );

        expect(result, isTrue);
      });

      test('should evaluate double negation with null value', () {
        final context = {
          'value': {'count_min': null},
        };

        final result = evaluator.evaluateJsCondition(
          "!!objForm.value.count_min",
          context,
        );

        expect(result, isFalse);
      });

      test('should normalize (null || undefined) to null in conditions', () {
        final context = {
          'value': {'cd_nom': 3507},
        };

        final result = evaluator.evaluateJsCondition(
          "objForm.value.cd_nom != (null || undefined)",
          context,
        );

        expect(result, isTrue);
      });

      test('should normalize (null || undefined) to null - when value is null', () {
        final context = {
          'value': {'cd_nom': null},
        };

        final result = evaluator.evaluateJsCondition(
          "objForm.value.cd_nom != (null || undefined)",
          context,
        );

        expect(result, isFalse);
      });

      test('should evaluate objForm.controls.xxx.dirty', () {
        final context = {
          'value': <String, dynamic>{},
          'dirtyFields': <String>{'presence_arbre_1'},
        };

        final result = evaluator.evaluateJsCondition(
          "!objForm.controls.presence_arbre_1.dirty",
          context,
        );

        expect(result, isFalse); // !true = false
      });

      test('should evaluate objForm.controls.xxx.dirty when field is not dirty', () {
        final context = {
          'value': <String, dynamic>{},
          'dirtyFields': <String>{},
        };

        final result = evaluator.evaluateJsCondition(
          "!objForm.controls.presence_arbre_1.dirty",
          context,
        );

        expect(result, isTrue); // !false = true
      });

      test('should evaluate AND of multiple dirty checks', () {
        final context = {
          'value': <String, dynamic>{},
          'dirtyFields': <String>{},
        };

        final result = evaluator.evaluateJsCondition(
          "!objForm.controls.presence_arbre_1.dirty && !objForm.controls.presence_arbre_2.dirty",
          context,
        );

        expect(result, isTrue); // !false && !false = true
      });

      test('should evaluate AND of dirty checks when one is dirty', () {
        final context = {
          'value': <String, dynamic>{},
          'dirtyFields': <String>{'presence_arbre_2'},
        };

        final result = evaluator.evaluateJsCondition(
          "!objForm.controls.presence_arbre_1.dirty && !objForm.controls.presence_arbre_2.dirty",
          context,
        );

        expect(result, isFalse); // !false && !true = true && false = false
      });
    });

    group('resolvePatchValues', () {
      test('should resolve dynamic references', () {
        final patchValues = {
          'count_max': '@value.count_min',
          'static_field': 10,
        };
        final formValues = {'count_min': 5};

        final result = evaluator.resolvePatchValues(patchValues, formValues);

        expect(result['count_max'], equals(5));
        expect(result['static_field'], equals(10));
      });

      test('should preserve nested objects', () {
        final patchValues = {
          'cd_nom': {'cd_nom': 914450, 'lb_nom': 'Amphibia'},
        };
        final formValues = <String, dynamic>{};

        final result = evaluator.resolvePatchValues(patchValues, formValues);

        expect(result['cd_nom'], isA<Map>());
        expect((result['cd_nom'] as Map)['cd_nom'], equals(914450));
      });

      test('should resolve @expr: with arithmetic', () {
        final patchValues = {
          'nb_total': '@expr:objForm.value.nb_before_rep + objForm.value.nb_repasse',
        };
        final formValues = {'nb_before_rep': 3, 'nb_repasse': 5};

        final result = evaluator.resolvePatchValues(patchValues, formValues);

        expect(result['nb_total'], equals(8));
      });

      test('should resolve @expr: with ternary', () {
        final patchValues = {
          'surf_releve':
              "@expr:objForm.value.type_placette == 'C' ? objForm.value.surf_releve_c : objForm.value.surf_releve_q",
        };
        final formValues = {
          'type_placette': 'C',
          'surf_releve_c': 25.0,
          'surf_releve_q': 4.0,
        };

        final result = evaluator.resolvePatchValues(patchValues, formValues);

        expect(result['surf_releve'], equals(25.0));
      });

      test('should resolve @expr: with ternary - other branch', () {
        final patchValues = {
          'surf_releve':
              "@expr:objForm.value.type_placette == 'C' ? objForm.value.surf_releve_c : objForm.value.surf_releve_q",
        };
        final formValues = {
          'type_placette': 'Q',
          'surf_releve_c': 25.0,
          'surf_releve_q': 4.0,
        };

        final result = evaluator.resolvePatchValues(patchValues, formValues);

        expect(result['surf_releve'], equals(4.0));
      });

      test('should resolve @expr: with || fallback when value is truthy', () {
        final patchValues = {
          'val': '@expr:objForm.value.tout_cocher || false',
        };
        final formValues = {'tout_cocher': true};

        final result = evaluator.resolvePatchValues(patchValues, formValues);

        expect(result['val'], equals(true));
      });

      test('should resolve @expr: with || fallback when value is falsy', () {
        final patchValues = {
          'val': '@expr:objForm.value.tout_cocher || false',
        };
        final formValues = {'tout_cocher': null};

        final result = evaluator.resolvePatchValues(patchValues, formValues);

        expect(result['val'], equals(false));
      });
    });

    group('with nomenclature cache', () {
      late ChangeExpressionEvaluator evaluatorWithCache;

      setUp(() {
        final nomenclatureCache = {
          1: const Nomenclature(
            id: 1,
            idType: 10,
            cdNomenclature: 'Co',
            labelDefault: 'Couple',
            labelFr: 'Couple',
            mnemonique: 'Co',
          ),
          2: const Nomenclature(
            id: 2,
            idType: 10,
            cdNomenclature: 'In',
            labelDefault: 'Individu',
            labelFr: 'Individu',
            mnemonique: 'In',
          ),
        };
        evaluatorWithCache = ChangeExpressionEvaluator(
          nomenclatureCache: nomenclatureCache,
        );
      });

      test('should evaluate nomenclature condition', () {
        final context = {
          'value': {'id_nomenclature_typ_denbr': 1},
        };

        final result = evaluatorWithCache.evaluateJsCondition(
          "meta.nomenclatures[value.id_nomenclature_typ_denbr].cd_nomenclature === 'Co'",
          context,
        );

        expect(result, isTrue);
      });

      test('should return false for non-matching nomenclature', () {
        final context = {
          'value': {'id_nomenclature_typ_denbr': 2},
        };

        final result = evaluatorWithCache.evaluateJsCondition(
          "meta.nomenclatures[value.id_nomenclature_typ_denbr].cd_nomenclature === 'Co'",
          context,
        );

        expect(result, isFalse);
      });
    });

    group('ParsedChangeRule', () {
      test('should support nullable condition', () {
        const rule = ParsedChangeRule(
          condition: null,
          patchValues: {'field': 42},
        );

        expect(rule.condition, isNull);
        expect(rule.patchValues['field'], equals(42));
      });

      test('should support non-null condition', () {
        const rule = ParsedChangeRule(
          condition: "value.x == 1",
          patchValues: {'field': 42},
        );

        expect(rule.condition, equals("value.x == 1"));
      });
    });
  });
}
