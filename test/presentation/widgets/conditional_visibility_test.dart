import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/dynamic_form_builder.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/form_data_processor.dart';
import 'package:mockito/mockito.dart';

// Mock pour FormDataProcessor qui simule la logique réelle
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
      
      // Simuler l'évaluation des conditions JavaScript en Dart
      if (hiddenCondition.contains("value.presence === 'Non'")) {
        return values['presence'] == 'Non';
      }
      
      if (hiddenCondition.contains("value.type_denombrement != 'Compté'")) {
        return values['type_denombrement'] != 'Compté';
      }
      
      if (hiddenCondition.contains("value.type_denombrement != 'Estimé'")) {
        return values['type_denombrement'] != 'Estimé';
      }
    }

    return false;
  }
}

void main() {
  group('Conditional Visibility Tests', () {
    testWidgets('Hidden fields should be excluded from form values when presence is Non', (WidgetTester tester) async {
      // Configuration proche du vrai module POPReptile
      final objectConfig = ObjectConfig(
        label: 'Test Reptile Form',
        displayProperties: ['presence', 'cd_nom', 'stade_vie'],
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
            'value': 186278, // Valeur par défaut
            'hidden': "({value}) => value.presence === 'Non'", // Caché si presence = "Non"
          },
          'stade_vie': {
            'type_widget': 'select',
            'required': true,
            'attribut_label': 'Stade de vie',
            'values': ['Indéterminé', 'Nouveaux-nés', 'Juvéniles', 'Adultes'],
            'value': 'Indéterminé',
            'hidden': "({value}) => value.presence === 'Non'",
          },
        },
      );

      late DynamicFormBuilderState formState;

      // Construire le widget avec mock provider
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

      // Test initial : presence = "Oui", les champs taxonomiques sont visibles
      var formValues = formState.getFormValues();
      expect(formValues['presence'], equals('Oui'));
      expect(formValues['cd_nom'], equals(186278)); // Valeur visible
      expect(formValues['stade_vie'], equals('Indéterminé')); // Valeur visible

      // Changer presence à "Non"
      await tester.tap(find.text('Non'));
      await tester.pumpAndSettle();

      // Maintenant les champs cachés ne devraient plus être dans les valeurs du formulaire
      formValues = formState.getFormValues();
      expect(formValues['presence'], equals('Non'));
      expect(formValues.containsKey('cd_nom'), isFalse); // Doit être absent des valeurs !
      expect(formValues.containsKey('stade_vie'), isFalse); // Doit être absent des valeurs !
    });

    testWidgets('Switching back to Oui should restore field values', (WidgetTester tester) async {
      final objectConfig = ObjectConfig(
        label: 'Test Reptile Form',
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
            'value': 186278, // Valeur par défaut
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

      // Initial : presence = "Oui", cd_nom visible
      expect(formState.getFormValues()['cd_nom'], equals(186278));

      // Changer à "Non" - cd_nom devient caché
      await tester.tap(find.text('Non'));
      await tester.pumpAndSettle();
      expect(formState.getFormValues().containsKey('cd_nom'), isFalse);

      // Revenir à "Oui" - cd_nom redevient visible avec sa valeur par défaut
      await tester.tap(find.text('Oui'));
      await tester.pumpAndSettle();
      expect(formState.getFormValues()['cd_nom'], equals(186278));
    });

    testWidgets('Nested conditional visibility should work correctly', (WidgetTester tester) async {
      // Test avec des conditions imbriquées comme type_denombrement
      final objectConfig = ObjectConfig(
        label: 'Test Nested Conditions',
        displayProperties: ['presence', 'type_denombrement', 'nombre_compte', 'nombre_estime_min'],
        specific: {
          'presence': {
            'type_widget': 'radio',
            'attribut_label': 'Présence',
            'values': ['Oui', 'Non'],
            'value': 'Oui',
          },
          'type_denombrement': {
            'type_widget': 'radio',
            'attribut_label': 'Précision du dénombrement',
            'values': ['Compté', 'Estimé'],
            'value': 'Compté',
            'hidden': "({value}) => value.presence === 'Non'",
          },
          'nombre_compte': {
            'type_widget': 'number',
            'attribut_label': 'Nombre (compté)',
            'value': 5,
            'hidden': "({value}) => value.type_denombrement != 'Compté'",
          },
          'nombre_estime_min': {
            'type_widget': 'number',
            'attribut_label': 'Nombre minimal (estimé)',
            'value': 2,
            'hidden': "({value}) => value.type_denombrement != 'Estimé'",
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

      // État initial : presence=Oui, type_denombrement=Compté
      var formValues = formState.getFormValues();
      expect(formValues['presence'], equals('Oui'));
      expect(formValues['type_denombrement'], equals('Compté'));
      expect(formValues['nombre_compte'], equals(5)); // Visible car type_denombrement=Compté
      expect(formValues.containsKey('nombre_estime_min'), isFalse); // Caché car type_denombrement≠Estimé

      // Changer presence à "Non" - tous les champs liés deviennent cachés
      await tester.tap(find.text('Non'));
      await tester.pumpAndSettle();

      formValues = formState.getFormValues();
      expect(formValues['presence'], equals('Non'));
      expect(formValues.containsKey('type_denombrement'), isFalse);
      expect(formValues.containsKey('nombre_compte'), isFalse);
      expect(formValues.containsKey('nombre_estime_min'), isFalse);
    });
  });
}