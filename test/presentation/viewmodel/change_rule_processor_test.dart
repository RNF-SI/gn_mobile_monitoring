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

      test('should evaluate nomenclature condition when form value is a Map (NomenclatureSelectorWidget format)', () {
        final nomenclatureCache = {
          42: const Nomenclature(
            id: 42,
            idType: 10,
            cdNomenclature: 'Co',
            labelDefault: 'Compté',
          ),
        };

        final processorWithCache = ChangeRuleProcessor(
          nomenclatureByIdCache: nomenclatureCache,
        );

        // Le NomenclatureSelectorWidget stocke la valeur comme {'id': 42}
        final formValues = {
          'count_min': 5,
          'count_max': 10,
          'id_nomenclature_typ_denbr': {'id': 42},
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

      test('should evaluate nomenclature condition when form value is a String', () {
        final nomenclatureCache = {
          42: const Nomenclature(
            id: 42,
            idType: 10,
            cdNomenclature: 'Co',
            labelDefault: 'Compté',
          ),
        };

        final processorWithCache = ChangeRuleProcessor(
          nomenclatureByIdCache: nomenclatureCache,
        );

        // La valeur peut aussi être une String (depuis TextEditingController)
        final formValues = {
          'count_min': 5,
          'count_max': 10,
          'id_nomenclature_typ_denbr': '42',
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

      test('should handle unconditional rules in structured format', () {
        final formValues = {'field1': 'value1'};
        final changeConfig = [
          {
            'condition': null,
            'patchValues': {'field2': 42},
          },
        ];

        final result = processor.processChangeRules(
          formValues: formValues,
          changeConfig: changeConfig,
          triggerFieldName: 'field1',
        );

        expect(result.hasChanges, isTrue);
        expect(result.fieldsToUpdate['field2'], equals(42));
      });

      test('should handle empty condition as unconditional in structured format', () {
        final formValues = {'field1': 'value1'};
        final changeConfig = [
          {
            'condition': '',
            'patchValues': {'field2': 42},
          },
        ];

        final result = processor.processChangeRules(
          formValues: formValues,
          changeConfig: changeConfig,
          triggerFieldName: 'field1',
        );

        expect(result.hasChanges, isTrue);
        expect(result.fieldsToUpdate['field2'], equals(42));
      });
    });

    group('integration - suivi_phytocio', () {
      test('should compute surf_releve from surf_releve_c when type is C', () {
        final formValues = {
          'type_placette': 'C',
          'surf_releve_c': 25.0,
          'surf_releve_q': 4.0,
        };
        final changeConfig = [
          "({objForm, meta}) => {",
          "const surf_releve = (objForm.value.type_placette == 'C' ? objForm.value.surf_releve_c : objForm.value.surf_releve_q)",
          "objForm.patchValue({surf_releve})",
          "}",
          "",
        ];

        final result = processor.processChangeRules(
          formValues: formValues,
          changeConfig: changeConfig,
          triggerFieldName: 'type_placette',
        );

        expect(result.hasChanges, isTrue);
        expect(result.fieldsToUpdate['surf_releve'], equals(25.0));
      });

      test('should compute surf_releve from surf_releve_q when type is Q', () {
        final formValues = {
          'type_placette': 'Q',
          'surf_releve_c': 25.0,
          'surf_releve_q': 4.0,
        };
        final changeConfig = [
          "({objForm, meta}) => {",
          "const surf_releve = (objForm.value.type_placette == 'C' ? objForm.value.surf_releve_c : objForm.value.surf_releve_q)",
          "objForm.patchValue({surf_releve})",
          "}",
          "",
        ];

        final result = processor.processChangeRules(
          formValues: formValues,
          changeConfig: changeConfig,
          triggerFieldName: 'type_placette',
        );

        expect(result.hasChanges, isTrue);
        expect(result.fieldsToUpdate['surf_releve'], equals(4.0));
      });
    });

    group('integration - petite_chouette_montagne', () {
      test('should compute nb_total as sum of nb_before_rep and nb_repasse', () {
        final formValues = {
          'nb_before_rep': 2,
          'nb_repasse': 3,
          'cd_nom': 3507,
          'hulotte': 'Oui',
        };
        final changeConfig = [
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

        final result = processor.processChangeRules(
          formValues: formValues,
          changeConfig: changeConfig,
          triggerFieldName: 'nb_before_rep',
        );

        expect(result.hasChanges, isTrue);
        // nb_total should be 2 + 3 = 5
        expect(result.fieldsToUpdate['nb_total'], equals(5));
        // cd_nom is 3507, so the ternary conditions (cd_nom != 3507) are false
        // → nb_passereau, chev_chant, sexe should NOT be in fieldsToUpdate
        expect(result.fieldsToUpdate.containsKey('nb_passereau'), isFalse);
        expect(result.fieldsToUpdate.containsKey('chev_chant'), isFalse);
        expect(result.fieldsToUpdate.containsKey('sexe'), isFalse);
        // hulotte is 'Oui', so nb_hulotte condition (hulotte != 'Oui') is false
        expect(result.fieldsToUpdate.containsKey('nb_hulotte'), isFalse);
      });

      test('should reset fields when cd_nom is not 3507', () {
        final formValues = {
          'nb_before_rep': 1,
          'nb_repasse': 1,
          'cd_nom': 1234,
          'hulotte': 'Non entendue',
        };
        final changeConfig = [
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

        final result = processor.processChangeRules(
          formValues: formValues,
          changeConfig: changeConfig,
          triggerFieldName: 'cd_nom',
        );

        expect(result.hasChanges, isTrue);
        // nb_total = 1 + 1 = 2
        expect(result.fieldsToUpdate['nb_total'], equals(2));
        // cd_nom is 1234 (not null, not 3507) → reset fields
        expect(result.fieldsToUpdate['nb_passereau'], isNull);
        expect(result.fieldsToUpdate['chev_chant'], isNull);
        expect(result.fieldsToUpdate['sexe'], isNull);
        // hulotte is 'Non entendue' → reset nb_hulotte
        expect(result.fieldsToUpdate['nb_hulotte'], equals(0));
      });

      test('should handle cd_nom being null', () {
        final formValues = {
          'nb_before_rep': 0,
          'nb_repasse': 0,
          'cd_nom': null,
          'hulotte': 'Non entendue',
        };
        final changeConfig = [
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

        final result = processor.processChangeRules(
          formValues: formValues,
          changeConfig: changeConfig,
          triggerFieldName: 'cd_nom',
        );

        expect(result.hasChanges, isTrue);
        // nb_total = 0 + 0 = 0
        expect(result.fieldsToUpdate['nb_total'], equals(0));
        // cd_nom is null → first part of AND (cd_nom != null) is false
        // → ternaries don't fire for nb_passereau, chev_chant, sexe
        expect(result.fieldsToUpdate.containsKey('nb_passereau'), isFalse);
        expect(result.fieldsToUpdate.containsKey('chev_chant'), isFalse);
        expect(result.fieldsToUpdate.containsKey('sexe'), isFalse);
        // hulotte is 'Non entendue' → reset nb_hulotte
        expect(result.fieldsToUpdate['nb_hulotte'], equals(0));
      });
    });

    group('integration - lichgen_bio_indicateurs', () {
      test('should apply chained const values when no fields are dirty', () {
        final formValues = {
          'tout_cocher': true,
        };
        final changeConfig = [
          "({objForm, meta}) => {",
          "console.log( objForm.value.tout_cocher );",
          "const presence_arbre_1 = presence_arbre_2 = presence_arbre_3 = presence_arbre_4 = presence_arbre_5 = presence_arbre_6 = presence_arbre_7 = presence_arbre_8 = presence_arbre_9 = presence_arbre_10 = objForm.value.tout_cocher || false;",
          "if (!objForm.controls.presence_arbre_1.dirty && !objForm.controls.presence_arbre_2.dirty && !objForm.controls.presence_arbre_3.dirty && !objForm.controls.presence_arbre_4.dirty && !objForm.controls.presence_arbre_5.dirty && !objForm.controls.presence_arbre_6.dirty && !objForm.controls.presence_arbre_7.dirty && !objForm.controls.presence_arbre_8.dirty && !objForm.controls.presence_arbre_9.dirty && !objForm.controls.presence_arbre_10.dirty ) {",
          "objForm.patchValue({presence_arbre_1, presence_arbre_2, presence_arbre_3, presence_arbre_4, presence_arbre_5, presence_arbre_6, presence_arbre_7, presence_arbre_8, presence_arbre_9, presence_arbre_10})",
          "}",
          "}",
          "",
        ];

        final result = processor.processChangeRules(
          formValues: formValues,
          changeConfig: changeConfig,
          triggerFieldName: 'tout_cocher',
          dirtyFields: <String>{}, // no dirty fields
        );

        expect(result.hasChanges, isTrue);
        // All 10 presence_arbre fields should be set to true (from tout_cocher || false)
        for (int i = 1; i <= 10; i++) {
          expect(result.fieldsToUpdate['presence_arbre_$i'], equals(true),
              reason: 'presence_arbre_$i should be true');
        }
      });

      test('should not apply when any field is dirty', () {
        final formValues = {
          'tout_cocher': true,
        };
        final changeConfig = [
          "({objForm, meta}) => {",
          "console.log( objForm.value.tout_cocher );",
          "const presence_arbre_1 = presence_arbre_2 = presence_arbre_3 = presence_arbre_4 = presence_arbre_5 = presence_arbre_6 = presence_arbre_7 = presence_arbre_8 = presence_arbre_9 = presence_arbre_10 = objForm.value.tout_cocher || false;",
          "if (!objForm.controls.presence_arbre_1.dirty && !objForm.controls.presence_arbre_2.dirty && !objForm.controls.presence_arbre_3.dirty && !objForm.controls.presence_arbre_4.dirty && !objForm.controls.presence_arbre_5.dirty && !objForm.controls.presence_arbre_6.dirty && !objForm.controls.presence_arbre_7.dirty && !objForm.controls.presence_arbre_8.dirty && !objForm.controls.presence_arbre_9.dirty && !objForm.controls.presence_arbre_10.dirty ) {",
          "objForm.patchValue({presence_arbre_1, presence_arbre_2, presence_arbre_3, presence_arbre_4, presence_arbre_5, presence_arbre_6, presence_arbre_7, presence_arbre_8, presence_arbre_9, presence_arbre_10})",
          "}",
          "}",
          "",
        ];

        final result = processor.processChangeRules(
          formValues: formValues,
          changeConfig: changeConfig,
          triggerFieldName: 'tout_cocher',
          dirtyFields: <String>{'presence_arbre_3'}, // one field is dirty
        );

        // Should NOT apply because condition requires all fields to be not dirty
        expect(result.hasChanges, isFalse);
      });

      test('should apply false when tout_cocher is falsy', () {
        final formValues = {
          'tout_cocher': null,
        };
        final changeConfig = [
          "({objForm, meta}) => {",
          "console.log( objForm.value.tout_cocher );",
          "const presence_arbre_1 = presence_arbre_2 = presence_arbre_3 = presence_arbre_4 = presence_arbre_5 = presence_arbre_6 = presence_arbre_7 = presence_arbre_8 = presence_arbre_9 = presence_arbre_10 = objForm.value.tout_cocher || false;",
          "if (!objForm.controls.presence_arbre_1.dirty && !objForm.controls.presence_arbre_2.dirty && !objForm.controls.presence_arbre_3.dirty && !objForm.controls.presence_arbre_4.dirty && !objForm.controls.presence_arbre_5.dirty && !objForm.controls.presence_arbre_6.dirty && !objForm.controls.presence_arbre_7.dirty && !objForm.controls.presence_arbre_8.dirty && !objForm.controls.presence_arbre_9.dirty && !objForm.controls.presence_arbre_10.dirty ) {",
          "objForm.patchValue({presence_arbre_1, presence_arbre_2, presence_arbre_3, presence_arbre_4, presence_arbre_5, presence_arbre_6, presence_arbre_7, presence_arbre_8, presence_arbre_9, presence_arbre_10})",
          "}",
          "}",
          "",
        ];

        final result = processor.processChangeRules(
          formValues: formValues,
          changeConfig: changeConfig,
          triggerFieldName: 'tout_cocher',
          dirtyFields: <String>{},
        );

        expect(result.hasChanges, isTrue);
        // All 10 presence_arbre fields should be false (from null || false)
        for (int i = 1; i <= 10; i++) {
          expect(result.fieldsToUpdate['presence_arbre_$i'], equals(false),
              reason: 'presence_arbre_$i should be false');
        }
      });
    });
  });
}
