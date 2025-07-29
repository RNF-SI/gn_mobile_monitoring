import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/dynamic_form_builder.dart';

void main() {
  group('Filtrage des Champs Cachés selon Required', () {
    
    testWidgets('Champs required cachés sont conservés', (WidgetTester tester) async {
      // Configuration de test : cd_nom required mais caché
      final formSchema = {
        'presence': {
          'widget_type': 'RadioButton',
          'attribut_label': 'Présence',
          'value': 'Non',
          'validations': {'required': false},
          'values': ['Oui', 'Non']
        },
        'cd_nom': {
          'widget_type': 'TaxonSelector',
          'attribut_label': 'Taxon',
          'value': 186278,
          'hidden': "({value}) => value.presence === 'Non'",
          'validations': {'required': true} // ← REQUIRED + CACHÉ
        }
      };

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: DynamicFormBuilder(
                formSchema: formSchema,
                onSubmit: (data) async {},
                displayProperties: ['presence', 'cd_nom'],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // cd_nom devrait être caché mais ses données conservées
      expect(find.text('Taxon'), findsNothing,
          reason: 'cd_nom devrait être caché quand presence = Non');

      final formBuilderState = tester.state<DynamicFormBuilderState>(
        find.byType(DynamicFormBuilder)
      );
      
      final formData = formBuilderState.getFormValues();

      // ASSERTION CRITIQUE: cd_nom required doit être conservé même caché
      expect(formData.containsKey('cd_nom'), true,
          reason: 'cd_nom required doit être conservé même caché');
      expect(formData['cd_nom'], equals(186278),
          reason: 'La valeur par défaut doit être préservée');
    });

    testWidgets('Champs non-required cachés sont supprimés', (WidgetTester tester) async {
      // Configuration de test : commentaires non-required et caché
      final formSchema = {
        'presence': {
          'widget_type': 'RadioButton',
          'attribut_label': 'Présence',
          'value': 'Non',
          'validations': {'required': false},
          'values': ['Oui', 'Non']
        },
        'comments': {
          'widget_type': 'TextInput',
          'attribut_label': 'Commentaires',
          'value': 'Commentaires détaillés sur l\'observation',
          'hidden': "({value}) => value.presence === 'Non'",
          'validations': {'required': false} // ← NON-REQUIRED + CACHÉ
        }
      };

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: DynamicFormBuilder(
                formSchema: formSchema,
                onSubmit: (data) async {},
                displayProperties: ['presence', 'comments'],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final formBuilderState = tester.state<DynamicFormBuilderState>(
        find.byType(DynamicFormBuilder)
      );
      
      final formData = formBuilderState.getFormValues();

      // ASSERTION CRITIQUE: comments non-required doit être supprimé si caché
      expect(formData.containsKey('comments'), false,
          reason: 'comments non-required doit être supprimé quand caché');
      expect(formData['presence'], equals('Non'),
          reason: 'Les champs visibles doivent être conservés');
    });

    testWidgets('Logique mixte - required conservé, non-required supprimé', (WidgetTester tester) async {
      final formSchema = {
        'trigger': {
          'widget_type': 'RadioButton',
          'attribut_label': 'Déclencheur',
          'value': 'hide_fields',
          'validations': {'required': false},
          'values': ['show_fields', 'hide_fields']
        },
        'required_hidden': {
          'widget_type': 'TextInput',
          'attribut_label': 'Requis Caché',
          'value': 'valeur_importante',
          'hidden': "({value}) => value.trigger === 'hide_fields'",
          'validations': {'required': true} // Required → doit être conservé
        },
        'optional_hidden': {
          'widget_type': 'TextInput',
          'attribut_label': 'Optionnel Caché',
          'value': 'valeur_optionnelle',
          'hidden': "({value}) => value.trigger === 'hide_fields'",
          'validations': {'required': false} // Non-required → doit être supprimé
        }
      };

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: DynamicFormBuilder(
                formSchema: formSchema,
                onSubmit: (data) async {},
                displayProperties: ['trigger', 'required_hidden', 'optional_hidden'],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final formBuilderState = tester.state<DynamicFormBuilderState>(
        find.byType(DynamicFormBuilder)
      );
      
      final formData = formBuilderState.getFormValues();

      // Vérifications détaillées
      expect(formData['trigger'], equals('hide_fields'),
          reason: 'Le champ déclencheur visible doit être présent');
      
      expect(formData.containsKey('required_hidden'), true,
          reason: 'Le champ required caché doit être conservé');
      expect(formData['required_hidden'], equals('valeur_importante'),
          reason: 'La valeur du champ required doit être préservée');
      
      expect(formData.containsKey('optional_hidden'), false,
          reason: 'Le champ optionnel caché doit être supprimé');
    });

    testWidgets('Cas PopReptile réel - cd_nom required conservé', (WidgetTester tester) async {
      // Configuration exacte du cas PopReptile
      final popReptileSchema = {
        'presence': {
          'widget_type': 'RadioButton',
          'attribut_label': 'Présence',
          'value': 'Oui',
          'validations': {'required': false},
          'values': ['Oui', 'Non']
        },
        'cd_nom': {
          'widget_type': 'TaxonSelector',
          'attribut_label': 'Taxon',
          'value': 186278,
          'hidden': "({value}) => value.presence === 'Non'",
          'validations': {'required': true} // Supposé required pour éviter erreur BDD
        }
      };

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: DynamicFormBuilder(
                formSchema: popReptileSchema,
                onSubmit: (data) async {},
                displayProperties: ['presence', 'cd_nom'],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Simuler le changement vers 'Non'
      await tester.tap(find.text('Non'));
      await tester.pumpAndSettle();

      final formBuilderState = tester.state<DynamicFormBuilderState>(
        find.byType(DynamicFormBuilder)
      );
      
      final formData = formBuilderState.getFormValues();

      // Vérification finale PopReptile
      expect(formData['presence'], equals('Non'));
      expect(formData.containsKey('cd_nom'), true,
          reason: 'cd_nom required doit être conservé pour PopReptile');
      expect(formData['cd_nom'], equals(186278),
          reason: 'La valeur par défaut cd_nom=186278 doit être envoyée au backend');
    });
  });
}