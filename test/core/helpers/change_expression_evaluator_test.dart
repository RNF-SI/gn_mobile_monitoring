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
  });
}
