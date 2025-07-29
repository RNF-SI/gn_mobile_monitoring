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
  group('Nuanced Initialization Tests', () {
    testWidgets('Should NOT initialize hidden field without special annotation', (WidgetTester tester) async {
      // Configuration où cd_nom est initialement caché
      final objectConfig = ObjectConfig(
        label: 'Test Form',
        displayProperties: ['presence', 'cd_nom'],
        specific: {
          'presence': {
            'type_widget': 'radio',
            'attribut_label': 'Avez-vous observé',
            'values': ['Oui', 'Non'],
            'value': 'Non', // Valeur par défaut = Non (donc cd_nom caché)
          },
          'cd_nom': {
            'type_widget': 'taxonomy',
            'attribut_label': 'Espèce',
            'value': 186278, // Valeur par défaut présente
            'hidden': "({value}) => value.presence === 'Non'", // Caché quand presence = Non
            // PAS d'annotation initialize_when_hidden
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

      // Vérifier les valeurs initiales
      final initialValues = formState.getFormValues();
      
      // presence devrait être initialisé (champ visible)
      expect(initialValues['presence'], equals('Non'));
      
      // cd_nom ne devrait PAS être initialisé car initialement caché sans annotation spéciale
      expect(initialValues.containsKey('cd_nom'), isFalse, 
        reason: 'cd_nom should NOT be initialized when initially hidden without special annotation');
    });

    testWidgets('Should initialize hidden field with initialize_when_hidden annotation', (WidgetTester tester) async {
      // Configuration avec annotation initialize_when_hidden
      final objectConfig = ObjectConfig(
        label: 'Test Form',
        displayProperties: ['presence', 'facteur_correction'],
        specific: {
          'presence': {
            'type_widget': 'radio',
            'attribut_label': 'Avez-vous observé',
            'values': ['Oui', 'Non'],
            'value': 'Non', // Valeur par défaut = Non
          },
          'facteur_correction': {
            'type_widget': 'number',
            'attribut_label': 'Facteur de correction',
            'value': 1.5, // Valeur par défaut
            'hidden': "({value}) => value.presence === 'Non'", // Caché quand presence = Non
            'initialize_when_hidden': true, // ANNOTATION SPÉCIALE
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

      // Vérifier les valeurs internes (avant filtrage)
      final allFormValues = formState.getAllFormValues();
      
      // facteur_correction devrait être initialisé même si caché grâce à l'annotation
      expect(allFormValues['facteur_correction'], equals(1.5), 
        reason: 'facteur_correction should be initialized even when hidden due to initialize_when_hidden annotation');
      
      // Mais ne devrait pas apparaître dans les valeurs soumises (car caché)
      final submittedValues = formState.getFormValues();
      expect(submittedValues.containsKey('facteur_correction'), isFalse,
        reason: 'Hidden fields should still be filtered from submission');
    });

    testWidgets('Should initialize metadata fields even when hidden', (WidgetTester tester) async {
      // Configuration avec champ métadonnées
      final objectConfig = ObjectConfig(
        label: 'Test Form',
        displayProperties: ['mode', 'facteur_correction_special'],
        specific: {
          'mode': {
            'type_widget': 'radio',
            'attribut_label': 'Mode',
            'values': ['Simple', 'Avancé'],
            'value': 'Simple', // Mode simple par défaut
          },
          'facteur_correction_special': {
            'type_widget': 'number',
            'attribut_label': 'Facteur spécial',
            'value': 2.0, // Valeur par défaut
            'hidden': "({value}) => value.mode === 'Simple'", // Caché en mode simple
            // PAS d'annotation explicite, mais le nom correspond aux patterns métadonnées
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

      // Vérifier les valeurs internes
      final allFormValues = formState.getAllFormValues();
      
      // Le champ devrait être initialisé car reconnu comme métadonnées
      expect(allFormValues['facteur_correction_special'], equals(2.0), 
        reason: 'Metadata fields should be initialized even when hidden');
    });

    testWidgets('Should initialize visible field normally', (WidgetTester tester) async {
      // Configuration avec champ visible
      final objectConfig = ObjectConfig(
        label: 'Test Form',
        displayProperties: ['presence', 'cd_nom'],
        specific: {
          'presence': {
            'type_widget': 'radio',
            'attribut_label': 'Avez-vous observé',
            'values': ['Oui', 'Non'],
            'value': 'Oui', // Valeur par défaut = Oui (donc cd_nom visible)
          },
          'cd_nom': {
            'type_widget': 'taxonomy',
            'attribut_label': 'Espèce',
            'value': 186278, // Valeur par défaut
            'hidden': "({value}) => value.presence === 'Non'", // Caché quand presence = Non
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

      // Vérifier les valeurs soumises
      final submittedValues = formState.getFormValues();
      
      // Les deux champs devraient être présents car cd_nom est visible
      expect(submittedValues['presence'], equals('Oui'));
      expect(submittedValues['cd_nom'], equals(186278), 
        reason: 'Visible fields should be initialized and included in submission');
    });

    testWidgets('Should handle always_initialize annotation', (WidgetTester tester) async {
      // Configuration avec annotation always_initialize
      final objectConfig = ObjectConfig(
        label: 'Test Form',
        displayProperties: ['status', 'version_info'],
        specific: {
          'status': {
            'type_widget': 'radio',
            'attribut_label': 'Status',
            'values': ['Active', 'Inactive'],
            'value': 'Inactive', // Status inactif par défaut
          },
          'version_info': {
            'type_widget': 'text',
            'attribut_label': 'Version',
            'value': 'v1.0.0', // Valeur par défaut
            'hidden': "({value}) => value.status === 'Inactive'", // Caché quand inactif
            'always_initialize': true, // ANNOTATION SPÉCIALE
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

      // Vérifier les valeurs internes
      final allFormValues = formState.getAllFormValues();
      
      // version_info devrait être initialisé grâce à always_initialize
      expect(allFormValues['version_info'], equals('v1.0.0'), 
        reason: 'Fields with always_initialize should be initialized even when hidden');
    });
  });
}