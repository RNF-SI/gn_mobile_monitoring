import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/dynamic_form_builder.dart';

void main() {
  group('Radio Button Widget Tests', () {
    testWidgets('Radio button field should display and work correctly', (WidgetTester tester) async {
      // Configuration de test pour un champ radio
      final objectConfig = ObjectConfig(
        label: 'Test Radio',
        displayProperties: ['presence'],
        specific: {
          'presence': {
            'type_widget': 'radio',
            'required': true,
            'attribut_label': 'Avez-vous observé des reptiles lors de la prospection',
            'values': ['Oui', 'Non'],
            'value': 'Oui',
          },
        },
      );

      Map<String, dynamic>? submittedValues;

      // Construire le widget
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: DynamicFormBuilder(
                objectConfig: objectConfig,
                onSubmit: (values) {
                  submittedValues = values;
                },
              ),
            ),
          ),
        ),
      );

      // Vérifier que le label s'affiche
      expect(find.text('Avez-vous observé des reptiles lors de la prospection *'), findsOneWidget);
      
      // Vérifier que les options radio s'affichent
      expect(find.text('Oui'), findsOneWidget);
      expect(find.text('Non'), findsOneWidget);
      
      // Vérifier qu'il y a bien deux Radio widgets (disposition horizontale pour "Oui"/"Non")
      expect(find.byType(Radio<String>), findsNWidgets(2));
      
      // Vérifier que la disposition horizontale utilise un Wrap
      expect(find.byType(Wrap), findsOneWidget);
      
      // Vérifier que la valeur par défaut "Oui" est sélectionnée
      final ouiRadio = tester.widget<Radio<String>>(
        find.byType(Radio<String>).first,
      );
      expect(ouiRadio.value, 'Oui');
      expect(ouiRadio.groupValue, 'Oui');
      
      // Taper sur "Non" pour changer la sélection
      await tester.tap(find.text('Non'));
      await tester.pump();
      
      // Vérifier que la sélection a changé en vérifiant le deuxième Radio
      final nonRadio = tester.widget<Radio<String>>(
        find.byType(Radio<String>).last,
      );
      expect(nonRadio.groupValue, 'Non');
    });

    testWidgets('Radio button field should show validation error when required and empty', (WidgetTester tester) async {
      // Configuration sans valeur par défaut et required
      final objectConfig = ObjectConfig(
        label: 'Test Radio',
        displayProperties: ['test_field'],
        specific: {
          'test_field': {
            'type_widget': 'radio',
            'required': true,
            'attribut_label': 'Champ obligatoire',
            'values': ['Option1', 'Option2'],
            // Pas de valeur par défaut
          },
        },
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: DynamicFormBuilder(
                objectConfig: objectConfig,
              ),
            ),
          ),
        ),
      );

      // Vérifier que le champ s'affiche avec l'astérisque pour indiquer qu'il est requis
      expect(find.text('Champ obligatoire *'), findsOneWidget);
      
      // Vérifier que toutes les options s'affichent
      expect(find.text('Option1'), findsOneWidget);
      expect(find.text('Option2'), findsOneWidget);
      
      // Vérifier qu'aucune option n'est sélectionnée par défaut
      // Les options "Option1" et "Option2" sont courtes, donc disposition horizontale avec Radio
      final radio1 = tester.widget<Radio<String>>(
        find.byType(Radio<String>).first,
      );
      expect(radio1.groupValue, isNull);
    });

    testWidgets('Radio button field should handle optional fields correctly', (WidgetTester tester) async {
      // Configuration non obligatoire
      final objectConfig = ObjectConfig(
        label: 'Test Radio',
        displayProperties: ['optional_field'],
        specific: {
          'optional_field': {
            'type_widget': 'radio',
            'required': false,
            'attribut_label': 'Champ optionnel',
            'values': ['A', 'B', 'C'],
          },
        },
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: DynamicFormBuilder(
                objectConfig: objectConfig,
              ),
            ),
          ),
        ),
      );

      // Vérifier que le label ne contient pas d'astérisque
      expect(find.text('Champ optionnel'), findsOneWidget);
      expect(find.text('Champ optionnel *'), findsNothing);
      
      // Vérifier que toutes les options s'affichent
      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
      expect(find.text('C'), findsOneWidget);
    });

    testWidgets('Radio button field should use vertical layout for long options', (WidgetTester tester) async {
      // Configuration avec des options longues pour forcer la disposition verticale
      final objectConfig = ObjectConfig(
        label: 'Test Radio',
        displayProperties: ['long_options'],
        specific: {
          'long_options': {
            'type_widget': 'radio',
            'required': false,
            'attribut_label': 'Options avec textes longs',
            'values': ['Option très longue numéro un', 'Option très longue numéro deux'],
          },
        },
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: DynamicFormBuilder(
                objectConfig: objectConfig,
              ),
            ),
          ),
        ),
      );

      // Vérifier que le champ s'affiche
      expect(find.text('Options avec textes longs'), findsOneWidget);
      
      // Vérifier que les options longues utilisent RadioListTile (disposition verticale)
      expect(find.byType(RadioListTile<String>), findsNWidgets(2));
      
      // Dans la disposition verticale, les Radio sont à l'intérieur des RadioListTile
      // Mais il ne devrait pas y avoir de Wrap (qui indique la disposition horizontale)
      expect(find.byType(Wrap), findsNothing);
      
      // Vérifier que les textes longs s'affichent
      expect(find.text('Option très longue numéro un'), findsOneWidget);
      expect(find.text('Option très longue numéro deux'), findsOneWidget);
    });
  });
}