import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/dynamic_form_builder.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/form_data_processor.dart';
import 'package:gn_mobile_monitoring/core/helpers/hidden_expression_evaluator.dart';
import 'package:mockito/mockito.dart';

// Mock pour FormDataProcessor
class MockFormDataProcessor extends Mock implements FormDataProcessor {
  @override
  Map<String, dynamic> prepareEvaluationContext({
    required Map<String, dynamic> values,
    Map<String, dynamic>? metadata,
  }) {
    return {
      'value': values,
      ...?metadata,
    };
  }

  @override
  bool isFieldHidden(
    String fieldName,
    Map<String, dynamic> evaluationContext, {
    Map<String, dynamic>? fieldConfig,
    Map<String, dynamic>? allFieldsConfig,
  }) {
    final hiddenCondition = fieldConfig?['hidden'];
    if (hiddenCondition == null || hiddenCondition == false) {
      return false;
    }

    if (hiddenCondition is String) {
      final values = evaluationContext['value'] as Map<String, dynamic>? ?? {};
      
      // Déléguer à l'évaluateur d'expressions réel
      try {
        final HiddenExpressionEvaluator evaluator = HiddenExpressionEvaluator();
        final result = evaluator.evaluateExpression(hiddenCondition, evaluationContext);
        return result ?? false;
      } catch (e) {
        return false;
      }
    }

    return false;
  }
}

void main() {
  group('Reptile Form Bug Reproduction', () {
    testWidgets('Should NOT include cd_nom when presence is Non to avoid database constraint error', (WidgetTester tester) async {
      // Configuration exacte du module POPReptile qui causait l'erreur
      final objectConfig = ObjectConfig(
        label: 'POPReptile Form',
        displayProperties: ['presence', 'cd_nom'],
        specific: {
          'presence': {
            'type_widget': 'radio',
            'required': true,
            'attribut_label': 'Avez-vous observé des reptiles lors de la prospection',
            'values': ['Oui', 'Non'],
            'value': 'Oui', // Par défaut "Oui"
          },
          'cd_nom': {
            'type_widget': 'taxonomy',
            'attribut_label': 'Espèce observée',
            'keyValue': 'cd_nom',
            'keyLabel': '__MODULE.TAXONOMY_DISPLAY_FIELD_NAME',
            'multiple': false,
            'api': 'taxref/allnamebylist/__MODULE.ID_LIST_TAXONOMY',
            'application': 'TaxHub',
            'required': true,
            'type_util': 'taxonomy',
            'value': 186278, // Valeur par défaut qui causait le problème
            'hidden': "({value}) => value.presence === 'Non'", // Condition de masquage
          },
        },
      );

      late DynamicFormBuilderState formState;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            formDataProcessorProvider.overrideWith((ref) => MockFormDataProcessor()),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: DynamicFormBuilder(
                objectConfig: objectConfig,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      formState = tester.state(find.byType(DynamicFormBuilder));

      // SCÉNARIO QUI CAUSAIT L'ERREUR :
      // 1. L'utilisateur sélectionne "Non" à la question "Avez-vous observé des reptiles"
      await tester.tap(find.text('Non'));
      await tester.pumpAndSettle();

      // 2. Il soumet le formulaire
      final submittedValues = formState.getFormValues();

      // 3. VÉRIFICATION CRITIQUE : cd_nom ne doit PAS être dans les valeurs soumises
      // car il est marqué comme caché quand presence = "Non"
      print('Submitted values: $submittedValues');
      
      expect(submittedValues['presence'], equals('Non'));
      expect(submittedValues.containsKey('cd_nom'), isFalse, 
        reason: 'cd_nom should be excluded from submitted values when presence is Non to avoid database NOT NULL constraint error');
      
      // Cela devrait maintenant éviter l'erreur PostgreSQL :
      // "null value in column "cd_nom" of relation "t_observations" violates not-null constraint"
    });

    testWidgets('Should include cd_nom when presence is Oui', (WidgetTester tester) async {
      final objectConfig = ObjectConfig(
        label: 'POPReptile Form',
        displayProperties: ['presence', 'cd_nom'],
        specific: {
          'presence': {
            'type_widget': 'radio',
            'required': true,
            'attribut_label': 'Avez-vous observé des reptiles lors de la prospection',
            'values': ['Oui', 'Non'],
            'value': 'Oui', // Par défaut "Oui"
          },
          'cd_nom': {
            'type_widget': 'taxonomy',
            'attribut_label': 'Espèce observée',
            'required': true,
            'type_util': 'taxonomy',
            'value': 186278,
            'hidden': "({value}) => value.presence === 'Non'",
          },
        },
      );

      late DynamicFormBuilderState formState;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            formDataProcessorProvider.overrideWith((ref) => MockFormDataProcessor()),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: DynamicFormBuilder(
                objectConfig: objectConfig,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      formState = tester.state(find.byType(DynamicFormBuilder));

      // L'utilisateur laisse "Oui" sélectionné et soumet
      final submittedValues = formState.getFormValues();

      print('Submitted values when presence is Oui: $submittedValues');
      
      expect(submittedValues['presence'], equals('Oui'));
      expect(submittedValues['cd_nom'], equals(186278), 
        reason: 'cd_nom should be included when presence is Oui');
    });
  });
}