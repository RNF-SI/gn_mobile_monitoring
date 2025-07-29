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
    Map<String, dynamic>? allFieldsConfig,
  }) {
    // Utiliser le vrai FormDataProcessor pour tester l'intégration complète
    final realProcessor = FormDataProcessor(MockRef());
    return realProcessor.isFieldHidden(
      fieldName,
      evaluationContext,
      fieldConfig: fieldConfig,
      allFieldsConfig: allFieldsConfig,
    );
  }
}

// Mock pour Ref
class MockRef extends Fake implements Ref {}

void main() {
  group('Cascade Integration Tests', () {
    testWidgets('Should cascade hide fields in real form scenario', (WidgetTester tester) async {
      // Configuration d'un formulaire qui simule le problème réel
      final objectConfig = ObjectConfig(
        label: 'Test Cascade Form',
        displayProperties: ['presence', 'type_denombrement', 'nombre_compte', 'nombre_estime_min'],
        specific: {
          'presence': {
            'type_widget': 'radio',
            'required': true,
            'attribut_label': 'Avez-vous observé des individus',
            'values': ['Oui', 'Non'],
            'value': 'Oui', // Par défaut "Oui"
          },
          'type_denombrement': {
            'type_widget': 'radio',
            'attribut_label': 'Type de dénombrement',
            'values': ['Compté', 'Estimé'],
            'hidden': "({value}) => value.presence === 'Non'", // Caché si presence = Non
          },
          'nombre_compte': {
            'type_widget': 'number',
            'attribut_label': 'Nombre d\'individus comptés',
            'hidden': "({value}) => value.type_denombrement !== 'Compté'", // Caché si type != Compté
          },
          'nombre_estime_min': {
            'type_widget': 'number',
            'attribut_label': 'Nombre minimum estimé',
            'hidden': "({value}) => value.type_denombrement !== 'Estimé'", // Caché si type != Estimé
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

      // SCÉNARIO 1: État initial - presence = 'Oui'
      // Vérifier que type_denombrement est visible
      expect(find.text('Type de dénombrement'), findsOneWidget);
      
      // Sélectionner 'Compté' pour type_denombrement
      await tester.tap(find.text('Compté'));
      await tester.pumpAndSettle();
      
      // Vérifier que nombre_compte est visible et nombre_estime_min est caché
      expect(find.text('Nombre d\'individus comptés'), findsOneWidget);
      expect(find.text('Nombre minimum estimé'), findsNothing);

      // SCÉNARIO 2: Changer pour 'Estimé'
      await tester.tap(find.text('Estimé'));
      await tester.pumpAndSettle();
      
      // Vérifier que nombre_estime_min est visible et nombre_compte est caché
      expect(find.text('Nombre minimum estimé'), findsOneWidget);
      expect(find.text('Nombre d\'individus comptés'), findsNothing);

      // SCÉNARIO 3: CASCADE - Changer presence à 'Non'
      await tester.tap(find.text('Non'));
      await tester.pumpAndSettle();
      
      // Vérifier que TOUS les champs dépendants sont cachés
      expect(find.text('Type de dénombrement'), findsNothing, 
        reason: 'type_denombrement should be hidden when presence is Non');
      expect(find.text('Nombre d\'individus comptés'), findsNothing,
        reason: 'nombre_compte should be hidden in cascade when type_denombrement is hidden');
      expect(find.text('Nombre minimum estimé'), findsNothing,
        reason: 'nombre_estime_min should be hidden in cascade when type_denombrement is hidden');

      // SCÉNARIO 4: Vérifier les valeurs soumises
      final submittedValues = formState.getFormValues();
      
      // Seule la valeur de presence devrait être présente
      expect(submittedValues['presence'], equals('Non'));
      expect(submittedValues.containsKey('type_denombrement'), isFalse,
        reason: 'type_denombrement should not be included when hidden');
      expect(submittedValues.containsKey('nombre_compte'), isFalse,
        reason: 'nombre_compte should not be included when hidden in cascade');
      expect(submittedValues.containsKey('nombre_estime_min'), isFalse,
        reason: 'nombre_estime_min should not be included when hidden in cascade');
        
      print('Final submitted values: $submittedValues');

      // SCÉNARIO 5: Revenir à 'Oui' pour vérifier que tout reapparaît
      await tester.tap(find.text('Oui'));
      await tester.pumpAndSettle();
      
      // Tous les champs devraient réapparaître
      expect(find.text('Type de dénombrement'), findsOneWidget,
        reason: 'type_denombrement should reappear when presence is Oui');
    });
  });
}