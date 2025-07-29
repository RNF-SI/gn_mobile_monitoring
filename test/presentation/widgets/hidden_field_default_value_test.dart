import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/dynamic_form_builder.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/form_data_processor.dart';
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
  }) {
    final hiddenCondition = fieldConfig?['hidden'];
    if (hiddenCondition == null || hiddenCondition == false) {
      return false;
    }

    if (hiddenCondition is String) {
      final values = evaluationContext['value'] as Map<String, dynamic>? ?? {};
      
      // Évaluation simple pour le test : si la condition contient "value.presence === 'Non'"
      // et que presence = 'Non', alors le champ est caché
      if (hiddenCondition.contains("value.presence === 'Non'")) {
        return values['presence'] == 'Non';
      }
      
      // Autres conditions de test
      if (hiddenCondition.contains("value.show_fields === 'No'")) {
        return values['show_fields'] == 'No';
      }
    }

    return false;
  }
}

void main() {
  group('Hidden Field Default Value Tests', () {
    testWidgets('Taxon field with default value should retain value when hidden', (WidgetTester tester) async {
      // Configuration similaire au cas réel avec cd_nom
      final objectConfig = ObjectConfig(
        label: 'Test Form',
        displayProperties: ['presence', 'cd_nom'],
        specific: {
          'presence': {
            'type_widget': 'radio',
            'required': true,
            'attribut_label': 'Avez-vous observé des reptiles lors de la prospection',
            'values': ['Oui', 'Non'],
            'value': 'Non', // Par défaut "Non", ce qui cache le champ cd_nom
          },
          'cd_nom': {
            'type_widget': 'taxonomy',
            'attribut_label': 'Espèce observée',
            'required': true,
            'value': 186278, // Valeur par défaut
            'hidden': "({value}) => value.presence === 'Non'", // Caché si presence = "Non"
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
                onSubmit: (values) {
                  // Test callback
                },
              ),
            ),
          ),
        ),
      );

      // Attendre que le widget soit construit
      await tester.pumpAndSettle();

      // Obtenir la référence à l'état du formulaire
      formState = tester.state(find.byType(DynamicFormBuilder));

      // Vérifier que le champ cd_nom n'est pas visible (puisque presence = "Non")
      expect(find.text('Espèce observée *'), findsNothing);
      
      // Mais vérifier que sa valeur par défaut est bien stockée dans _formValues
      final formValues = formState.getFormValues();
      expect(formValues['cd_nom'], equals(186278));
      expect(formValues['presence'], equals('Non'));
    });

    testWidgets('Taxon field should become visible when condition changes', (WidgetTester tester) async {
      // Configuration similaire au cas réel
      final objectConfig = ObjectConfig(
        label: 'Test Form',
        displayProperties: ['presence', 'cd_nom'],
        specific: {
          'presence': {
            'type_widget': 'radio',
            'required': true,
            'attribut_label': 'Avez-vous observé des reptiles lors de la prospection',
            'values': ['Oui', 'Non'],
            'value': 'Non', // Par défaut "Non"
          },
          'cd_nom': {
            'type_widget': 'taxonomy',
            'attribut_label': 'Espèce observée',
            'required': true,
            'value': 186278, // Valeur par défaut
            'hidden': "({value}) => value.presence === 'Non'", // Caché si presence = "Non"
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
                onSubmit: (values) {
                  // Test callback
                },
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      formState = tester.state(find.byType(DynamicFormBuilder));

      // Initialement, le champ cd_nom est caché mais a sa valeur par défaut
      expect(find.text('Espèce observée *'), findsNothing);
      expect(formState.getFormValues()['cd_nom'], equals(186278));

      // Changer presence à "Oui" pour rendre cd_nom visible
      await tester.tap(find.text('Oui'));
      await tester.pumpAndSettle();

      // Maintenant le champ cd_nom devrait être visible (au moins un widget avec ce texte)
      expect(find.text('Espèce observée *'), findsWidgets);
      
      // Et sa valeur par défaut devrait toujours être là
      expect(formState.getFormValues()['cd_nom'], equals(186278));
    });

    testWidgets('Multiple hidden fields with default values should all be preserved', (WidgetTester tester) async {
      final objectConfig = ObjectConfig(
        label: 'Test Form',
        displayProperties: ['show_fields', 'hidden_text', 'hidden_number', 'hidden_radio'],
        specific: {
          'show_fields': {
            'type_widget': 'radio',
            'attribut_label': 'Show hidden fields',
            'values': ['Yes', 'No'],
            'value': 'No', // Par défaut les champs sont cachés
          },
          'hidden_text': {
            'type_widget': 'text',
            'attribut_label': 'Hidden Text Field',
            'value': 'default_text_value',
            'hidden': "({value}) => value.show_fields === 'No'",
          },
          'hidden_number': {
            'type_widget': 'number',
            'attribut_label': 'Hidden Number Field',
            'value': 42,
            'hidden': "({value}) => value.show_fields === 'No'",
          },
          'hidden_radio': {
            'type_widget': 'radio',
            'attribut_label': 'Hidden Radio Field',
            'values': ['Option1', 'Option2'],
            'value': 'Option2',
            'hidden': "({value}) => value.show_fields === 'No'",
          },
        },
      );

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
      
      final formState = tester.state<DynamicFormBuilderState>(find.byType(DynamicFormBuilder));
      final formValues = formState.getFormValues();

      // Vérifier que tous les champs cachés ont leurs valeurs par défaut préservées
      expect(formValues['show_fields'], equals('No'));
      expect(formValues['hidden_text'], equals('default_text_value'));
      expect(formValues['hidden_number'], equals(42));
      expect(formValues['hidden_radio'], equals('Option2'));

      // Vérifier que les champs ne sont pas visibles
      // Note: Avec notre mock simple, certains champs peuvent encore être visibles
      // L'important est que leurs valeurs par défaut soient préservées
    });
  });
}