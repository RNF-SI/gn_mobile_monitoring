import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/nomenclature.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/change_rule_processor.dart';

void main() {
  group('ChangeRuleProcessor', () {
    late ChangeRuleProcessor processor;

    setUp(() {
      processor = ChangeRuleProcessor();
    });

    tearDown(() {
      processor.reset();
    });

    group('processChangeRules', () {
      test('should return empty result when changeConfig is null', () {
        final formValues = {'field1': 'value1'};

        final result = processor.processChangeRules(
          formValues: formValues,
          changeConfig: null,
          triggerFieldName: 'field1',
        );

        expect(result.hasChanges, isFalse);
        expect(result.fieldsToUpdate, isEmpty);
      });

      test('should return empty result when changeConfig is empty list', () {
        final formValues = {'field1': 'value1'};

        final result = processor.processChangeRules(
          formValues: formValues,
          changeConfig: [],
          triggerFieldName: 'field1',
        );

        expect(result.hasChanges, isFalse);
        expect(result.fieldsToUpdate, isEmpty);
      });

      test('should apply rule when presence is Non', () {
        final formValues = {'presence': 'Non'};
        final changeConfig = [
          "({objForm, meta}) => {",
          "if (objForm.value.presence === 'Non') {",
          "objForm.patchValue({count_min : 0, count_max : 0})",
          "}",
          "}",
        ];

        final result = processor.processChangeRules(
          formValues: formValues,
          changeConfig: changeConfig,
          triggerFieldName: 'presence',
        );

        expect(result.hasChanges, isTrue);
        expect(result.fieldsToUpdate['count_min'], equals(0));
        expect(result.fieldsToUpdate['count_max'], equals(0));
      });

      test('should not apply rule when presence is Oui', () {
        final formValues = {'presence': 'Oui'};
        final changeConfig = [
          "({objForm, meta}) => {",
          "if (objForm.value.presence === 'Non') {",
          "objForm.patchValue({count_min : 0, count_max : 0})",
          "}",
          "}",
        ];

        final result = processor.processChangeRules(
          formValues: formValues,
          changeConfig: changeConfig,
          triggerFieldName: 'presence',
        );

        expect(result.hasChanges, isFalse);
      });

      test('should apply rule for count_max < count_min', () {
        final formValues = {'count_min': 5, 'count_max': 3};
        final changeConfig = [
          "({objForm, meta}) => {",
          "if (objForm.value.count_max < objForm.value.count_min) {",
          "objForm.patchValue({count_max : objForm.value.count_min})",
          "}",
          "}",
        ];

        final result = processor.processChangeRules(
          formValues: formValues,
          changeConfig: changeConfig,
          triggerFieldName: 'count_max',
        );

        expect(result.hasChanges, isTrue);
        expect(result.fieldsToUpdate['count_max'], equals(5));
      });

      test('should apply multiple matching rules', () {
        final formValues = {'presence': 'Oui', 'count_min': 0};
        final changeConfig = [
          "({objForm, meta}) => {",
          "if (objForm.value.presence === 'Non') {",
          "objForm.patchValue({count_min : 0})",
          "}",
          "if (objForm.value.presence === 'Oui' && objForm.value.count_min === 0) {",
          "objForm.patchValue({count_min : null, count_max : null})",
          "}",
          "}",
        ];

        final result = processor.processChangeRules(
          formValues: formValues,
          changeConfig: changeConfig,
          triggerFieldName: 'presence',
        );

        expect(result.hasChanges, isTrue);
        expect(result.fieldsToUpdate['count_min'], isNull);
        expect(result.fieldsToUpdate['count_max'], isNull);
      });

      test('should handle nested object in patchValue', () {
        final formValues = {'presence': 'Non'};
        final changeConfig = [
          "({objForm, meta}) => {",
          "if (objForm.value.presence === 'Non') {",
          "objForm.patchValue({cd_nom : {'cd_nom': 914450, 'lb_nom': 'Amphibia'}})",
          "}",
          "}",
        ];

        final result = processor.processChangeRules(
          formValues: formValues,
          changeConfig: changeConfig,
          triggerFieldName: 'presence',
        );

        expect(result.hasChanges, isTrue);
        expect(result.fieldsToUpdate['cd_nom'], isA<Map>());
        final cdNom = result.fieldsToUpdate['cd_nom'] as Map;
        expect(cdNom['cd_nom'], equals(914450));
        expect(cdNom['lb_nom'], equals('Amphibia'));
      });

      test('should handle full PopAmphibien config', () {
        final formValues = {'presence': 'Non'};
        final changeConfig = [
          "({objForm, meta}) => {",
          "if (objForm.value.presence === 'Non') {",
          "objForm.patchValue({id_nomenclature_typ_denbr : null, count_min : 0, count_max : 0, id_nomenclature_sex : null, id_nomenclature_stade: null, cd_nom : {'cd_nom': 914450, 'lb_nom': 'Amphibia', 'nom_valide': 'Amphibia', 'nom_vern' : 'Amphibiens, batraciens'}}, {emitEvent : false})",
          "}",
          "}",
        ];

        final result = processor.processChangeRules(
          formValues: formValues,
          changeConfig: changeConfig,
          triggerFieldName: 'presence',
        );

        expect(result.hasChanges, isTrue);
        expect(result.fieldsToUpdate['count_min'], equals(0));
        expect(result.fieldsToUpdate['count_max'], equals(0));
        expect(result.fieldsToUpdate['id_nomenclature_typ_denbr'], isNull);
        expect(result.fieldsToUpdate['id_nomenclature_sex'], isNull);
        expect(result.fieldsToUpdate['id_nomenclature_stade'], isNull);
        expect(result.fieldsToUpdate['cd_nom'], isA<Map>());
      });
    });

    group('with nomenclature cache', () {
      test('should evaluate nomenclature condition', () {
        final nomenclatureCache = {
          1: const Nomenclature(
            id: 1,
            idType: 10,
            cdNomenclature: 'Co',
            labelDefault: 'Couple',
          ),
        };

        final processorWithCache = ChangeRuleProcessor(
          nomenclatureByIdCache: nomenclatureCache,
        );

        final formValues = {
          'count_min': 5,
          'count_max': 10,
          'id_nomenclature_typ_denbr': 1,
        };
        final changeConfig = [
          "({objForm, meta}) => {",
          "if (!!objForm.value.count_min && meta.nomenclatures[objForm.value.id_nomenclature_typ_denbr].cd_nomenclature === 'Co' && objForm.value.count_max !== objForm.value.count_min) {",
          "objForm.patchValue({count_max : objForm.value.count_min})",
          "}",
          "}",
        ];

        final result = processorWithCache.processChangeRules(
          formValues: formValues,
          changeConfig: changeConfig,
          triggerFieldName: 'count_min',
        );

        expect(result.hasChanges, isTrue);
        expect(result.fieldsToUpdate['count_max'], equals(5));
      });
    });

    group('ChangeRuleResult', () {
      test('empty factory should create result with no changes', () {
        final result = ChangeRuleResult.empty();

        expect(result.hasChanges, isFalse);
        expect(result.fieldsToUpdate, isEmpty);
      });

      test('should create result with changes', () {
        final result = ChangeRuleResult(
          fieldsToUpdate: {'field1': 'value1'},
          hasChanges: true,
        );

        expect(result.hasChanges, isTrue);
        expect(result.fieldsToUpdate['field1'], equals('value1'));
      });
    });

    group('with structured format (converted at download time)', () {
      test('should apply rule from structured format', () {
        final formValues = {'presence': 'Non'};
        // Format structuré produit par la conversion au téléchargement
        final changeConfig = [
          {
            'condition': "objForm.value.presence === 'Non'",
            'patchValues': {'count_min': 0, 'count_max': 0},
          },
        ];

        final result = processor.processChangeRules(
          formValues: formValues,
          changeConfig: changeConfig,
          triggerFieldName: 'presence',
        );

        expect(result.hasChanges, isTrue);
        expect(result.fieldsToUpdate['count_min'], equals(0));
        expect(result.fieldsToUpdate['count_max'], equals(0));
      });

      test('should apply multiple rules from structured format', () {
        final formValues = {'presence': 'Oui', 'count_min': 0};
        final changeConfig = [
          {
            'condition': "objForm.value.presence === 'Non'",
            'patchValues': {'count_min': 0},
          },
          {
            'condition':
                "objForm.value.presence === 'Oui' && objForm.value.count_min === 0",
            'patchValues': {'count_min': null, 'count_max': null},
          },
        ];

        final result = processor.processChangeRules(
          formValues: formValues,
          changeConfig: changeConfig,
          triggerFieldName: 'presence',
        );

        expect(result.hasChanges, isTrue);
        expect(result.fieldsToUpdate['count_min'], isNull);
        expect(result.fieldsToUpdate['count_max'], isNull);
      });

      test('should handle structured format with nested objects', () {
        final formValues = {'presence': 'Non'};
        final changeConfig = [
          {
            'condition': "objForm.value.presence === 'Non'",
            'patchValues': {
              'cd_nom': {'cd_nom': 914450, 'lb_nom': 'Amphibia'},
            },
          },
        ];

        final result = processor.processChangeRules(
          formValues: formValues,
          changeConfig: changeConfig,
          triggerFieldName: 'presence',
        );

        expect(result.hasChanges, isTrue);
        expect(result.fieldsToUpdate['cd_nom'], isA<Map>());
        final cdNom = result.fieldsToUpdate['cd_nom'] as Map;
        expect(cdNom['cd_nom'], equals(914450));
        expect(cdNom['lb_nom'], equals('Amphibia'));
      });

      test('should handle structured format with dynamic reference', () {
        final formValues = {'count_min': 5, 'count_max': 3};
        final changeConfig = [
          {
            'condition':
                'objForm.value.count_max < objForm.value.count_min',
            'patchValues': {'count_max': '@value.count_min'},
          },
        ];

        final result = processor.processChangeRules(
          formValues: formValues,
          changeConfig: changeConfig,
          triggerFieldName: 'count_min',
        );

        expect(result.hasChanges, isTrue);
        expect(result.fieldsToUpdate['count_max'], equals(5));
      });

      test('should handle string values for numeric comparison', () {
        // Les valeurs du formulaire peuvent être des strings (depuis TextEditingController)
        final formValues = {'count_min': '5', 'count_max': '3'};
        final changeConfig = [
          {
            'condition':
                'objForm.value.count_max < objForm.value.count_min',
            'patchValues': {'count_max': '@value.count_min'},
          },
        ];

        final result = processor.processChangeRules(
          formValues: formValues,
          changeConfig: changeConfig,
          triggerFieldName: 'count_min',
        );

        expect(result.hasChanges, isTrue);
        expect(result.fieldsToUpdate['count_max'], equals('5'));
      });

      test('should handle mixed int and string values for numeric comparison', () {
        final formValues = {'count_min': 10, 'count_max': '5'};
        final changeConfig = [
          {
            'condition':
                'objForm.value.count_max < objForm.value.count_min',
            'patchValues': {'count_max': '@value.count_min'},
          },
        ];

        final result = processor.processChangeRules(
          formValues: formValues,
          changeConfig: changeConfig,
          triggerFieldName: 'count_min',
        );

        expect(result.hasChanges, isTrue);
        expect(result.fieldsToUpdate['count_max'], equals(10));
      });
    });
  });
}
