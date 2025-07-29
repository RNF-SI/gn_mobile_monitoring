import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/dynamic_form_builder.dart';

void main() {
  group('Test d\'Intégration - Persistance des Champs Cachés', () {
    
    testWidgets('Formulaire PopReptile - Conservation de cd_nom quand caché', (WidgetTester tester) async {
      // Configuration du formulaire PopReptile simplifiée
      final formSchema = {
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
          'validations': {'required': false}
        }
      };

      // Wrapper pour le test
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: DynamicFormBuilder(
                formSchema: formSchema,
                onSubmit: (data) async {
                  // Vérifier que cd_nom est présent même quand caché
                  expect(data.containsKey('cd_nom'), true,
                      reason: 'cd_nom doit être présent dans les données soumises même quand caché');
                  expect(data['cd_nom'], equals(186278),
                      reason: 'La valeur par défaut de cd_nom doit être conservée');
                },
                displayProperties: ['presence', 'cd_nom'],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Initialisation: cd_nom devrait être visible car presence = 'Oui'
      expect(find.text('Taxon'), findsOneWidget,
          reason: 'Le champ cd_nom devrait être visible initialement');

      // Changer presence pour 'Non' - cela devrait cacher cd_nom
      final presenceRadio = find.text('Non');
      await tester.tap(presenceRadio);
      await tester.pumpAndSettle();

      // cd_nom ne devrait plus être visible
      expect(find.text('Taxon'), findsNothing,
          reason: 'Le champ cd_nom devrait être caché quand presence = Non');

      // Simuler la soumission du formulaire
      // Note: Dans un test réel, nous aurions un bouton de soumission
      // Ici nous testons la logique de récupération des données
      final formBuilderState = tester.state<DynamicFormBuilderState>(
        find.byType(DynamicFormBuilder)
      );
      
      final formData = formBuilderState.getFormValues();

      // VÉRIFICATION PRINCIPALE: cd_nom doit être présent avec sa valeur par défaut
      expect(formData.containsKey('cd_nom'), true,
          reason: 'cd_nom doit être présent dans les données même quand caché');
      expect(formData['cd_nom'], equals(186278),
          reason: 'La valeur par défaut de cd_nom doit être conservée');
      expect(formData['presence'], equals('Non'),
          reason: 'La valeur de presence doit refléter le changement');
    });

    testWidgets('Cascade de masquage avec conservation des valeurs', (WidgetTester tester) async {
      final formSchema = {
        'trigger': {
          'widget_type': 'RadioButton',
          'attribut_label': 'Déclencheur',
          'value': 'show',
          'validations': {'required': false},
          'values': ['show', 'hide']
        },
        'dependent1': {
          'widget_type': 'TextInput',
          'attribut_label': 'Champ Dépendant 1',
          'value': 'valeur_par_defaut_1',
          'hidden': "({value}) => value.trigger === 'hide'",
          'validations': {'required': false}
        },
        'dependent2': {
          'widget_type': 'TextInput',
          'attribut_label': 'Champ Dépendant 2',
          'value': 'valeur_par_defaut_2',
          'hidden': "({value}) => value.dependent1 === undefined",
          'validations': {'required': false}
        }
      };

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: DynamicFormBuilder(
                formSchema: formSchema,
                onSubmit: (data) async {},
                displayProperties: ['trigger', 'dependent1', 'dependent2'],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tous les champs devraient être visibles initialement
      expect(find.text('Champ Dépendant 1'), findsOneWidget);
      expect(find.text('Champ Dépendant 2'), findsOneWidget);

      // Changer le déclencheur pour cacher les champs dépendants
      await tester.tap(find.text('hide'));
      await tester.pumpAndSettle();

      // Les champs dépendants ne devraient plus être visibles
      expect(find.text('Champ Dépendant 1'), findsNothing);
      expect(find.text('Champ Dépendant 2'), findsNothing);

      // Vérifier que les valeurs sont conservées
      final formBuilderState = tester.state<DynamicFormBuilderState>(
        find.byType(DynamicFormBuilder)
      );
      final formData = formBuilderState.getFormValues();

      expect(formData['dependent1'], equals('valeur_par_defaut_1'),
          reason: 'dependent1 doit conserver sa valeur par défaut même caché');
      expect(formData['dependent2'], equals('valeur_par_defaut_2'),
          reason: 'dependent2 doit conserver sa valeur par défaut même caché');
    });

    testWidgets('Réaffichage des champs précédemment cachés', (WidgetTester tester) async {
      final formSchema = {
        'visibility_switch': {
          'widget_type': 'Checkbox',
          'attribut_label': 'Afficher le champ spécial',
          'value': true,
          'validations': {'required': false}
        },
        'special_field': {
          'widget_type': 'TextInput',
          'attribut_label': 'Champ Spécial',
          'value': 'valeur_importante',
          'hidden': "({value}) => !value.visibility_switch",
          'validations': {'required': false}
        }
      };

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: DynamicFormBuilder(
                formSchema: formSchema,
                onSubmit: (data) async {},
                displayProperties: ['visibility_switch', 'special_field'],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Le champ spécial devrait être visible initialement
      expect(find.text('Champ Spécial'), findsOneWidget);

      // Décocher la case pour cacher le champ
      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      // Le champ ne devrait plus être visible
      expect(find.text('Champ Spécial'), findsNothing);

      // Recocher pour réafficher le champ
      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      // Le champ devrait réapparaître avec sa valeur intacte
      expect(find.text('Champ Spécial'), findsOneWidget);

      final formBuilderState = tester.state<DynamicFormBuilderState>(
        find.byType(DynamicFormBuilder)
      );
      final formData = formBuilderState.getFormValues();

      expect(formData['special_field'], equals('valeur_importante'),
          reason: 'La valeur doit être restaurée intacte lors du réaffichage');
    });
  });
}