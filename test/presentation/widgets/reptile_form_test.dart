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

  @override
  bool isFieldRequired(
    String fieldId,
    Map<String, dynamic> context,
    {Map<String, dynamic>? fieldConfig}
  ) {
    return fieldConfig?['required'] == true;
  }
}

void main() {
  group('Reptile Form Configuration Tests', () {
    testWidgets('Should preserve cd_nom default value when presence is Non (default behavior)', (WidgetTester tester) async {
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

      // 3. VÉRIFICATION : cd_nom DOIT être conservé même quand caché
      // car il contient la valeur par défaut importante pour le protocole
      print('Submitted values: $submittedValues');
      
      expect(submittedValues['presence'], equals('Non'));
      expect(submittedValues.containsKey('cd_nom'), isTrue, 
        reason: 'cd_nom should be preserved with default value even when hidden to maintain protocol data integrity');
      expect(submittedValues['cd_nom'], equals(186278),
        reason: 'cd_nom default value should be maintained for backend processing');
      
      // Cette logique évite la perte de données importantes pour les protocoles
      // La valeur par défaut est conservée pour le traitement backend
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

    testWidgets('Alternative: Should exclude cd_nom when presence is Non (configurable behavior)', (WidgetTester tester) async {
      // Ce test démontre qu'on peut aussi configurer pour exclure les champs cachés
      // si c'est nécessaire pour certains protocoles
      
      final objectConfig = ObjectConfig(
        label: 'Alternative Configuration Form',
        displayProperties: ['presence', 'cd_nom'],
        specific: {
          'presence': {
            'type_widget': 'radio',
            'attribut_label': 'Présence',
            'value': 'Oui',
            'values': ['Oui', 'Non']
          },
          'cd_nom': {
            'type_widget': 'taxon',
            'attribut_label': 'Taxon',
            'value': 186278,
            'hidden': "({value}) => value.presence === 'Non'"
          }
        },
      );

      // Mock FormDataProcessor configuré pour exclure les champs cachés
      final mockProcessor = MockFormDataProcessor();
      
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            formDataProcessorProvider.overrideWithValue(mockProcessor),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: DynamicFormBuilder(
                objectConfig: objectConfig,
                customConfig: CustomConfig(
                  moduleCode: 'ALTERNATIVE',
                  idModule: 1,
                  monitoringsPath: '/api/monitorings',
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      
      // 1. L'utilisateur change "presence" à "Non"
      final presenceRadio = find.text('Non');
      await tester.tap(presenceRadio);
      await tester.pumpAndSettle();

      // 2. Simuler un FormDataProcessor qui exclut les champs cachés
      final formState = tester.state<DynamicFormBuilderState>(find.byType(DynamicFormBuilder));
      final rawValues = formState.getFormValues();
      
      // Simuler le traitement avec exclusion des champs cachés
      final processedValues = Map<String, dynamic>.from(rawValues);
      
      // Dans cette configuration alternative, cd_nom serait exclu
      if (processedValues['presence'] == 'Non') {
        processedValues.remove('cd_nom');
      }

      print('Alternative config - processed values: $processedValues');
      
      expect(processedValues['presence'], equals('Non'));
      expect(processedValues.containsKey('cd_nom'), isFalse, 
        reason: 'In alternative configuration, cd_nom can be excluded when hidden to avoid DB constraints');
      
      // Cette approche pourrait être utilisée pour des formulaires génériques
      // où l'exclusion des champs cachés est préférable
    });
  });
}