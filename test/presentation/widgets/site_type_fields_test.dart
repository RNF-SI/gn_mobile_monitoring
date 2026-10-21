import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/core/helpers/form_config_parser.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/dynamic_form_builder.dart';

/// #215 : un type de site peut définir ses propres champs (config des types,
/// réglée depuis le module web). Le serveur les ajoute aux champs du site
/// avec `id_types_site` ; comme sur le web, un tel champ n'est affiché (et
/// envoyé) que si l'un de ses types est sélectionné sur le site.
void main() {
  // Config telle que renvoyée par le serveur pour POPAmphibien avec deux
  // types : 941 (Site POPAmphibien) et 975 (Transect POPReptile).
  ObjectConfig siteConfig() => ObjectConfig(
        label: 'Site',
        specific: {
          'base_site_name': {'type_widget': 'text', 'attribut_label': 'Nom'},
          'e2e_eau_permanente': {
            'type_widget': 'radio',
            'attribut_label': 'Eau permanente',
            'values': ['Oui', 'Non'],
            'required': true,
            'id_types_site': [941],
          },
          'e2e_longueur_transect': {
            'type_widget': 'number',
            'attribut_label': 'Longueur du transect (m)',
            'required': true,
            'id_types_site': [975],
          },
        },
      );

  Future<DynamicFormBuilderState> pumpForm(
    WidgetTester tester, {
    Map<String, dynamic>? initialValues,
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: DynamicFormBuilder(
                objectConfig: siteConfig(),
                objectType: 'site',
                initialValues: initialValues,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return tester.state(find.byType(DynamicFormBuilder));
  }

  test('le schéma unifié conserve id_types_site', () {
    final schema = FormConfigParser.generateUnifiedSchema(siteConfig(), null,
        objectType: 'site');
    expect(schema['e2e_eau_permanente']['id_types_site'], [941]);
    expect(schema['base_site_name'].containsKey('id_types_site'), isFalse);
  });

  test(
      'le choix des types est dans le formulaire de site même hors '
      'display_properties, comme sur le web', () {
    final schema = FormConfigParser.generateUnifiedSchema(
        ObjectConfig(
          label: 'Site',
          displayProperties: const ['base_site_name'],
          generic: {
            'base_site_name': GenericFieldConfig(
                attributLabel: 'Nom', typeWidget: 'text'),
            'types_site': GenericFieldConfig(
                attributLabel: 'Type(s) de site',
                typeWidget: 'datalist',
                multiple: true,
                required: true),
            'base_site_code': GenericFieldConfig(
                attributLabel: 'Code', typeWidget: 'text'),
          },
        ),
        null,
        objectType: 'site');
    expect(schema.containsKey('types_site'), isTrue);
    expect(schema.containsKey('base_site_code'), isFalse,
        reason: 'les autres champs suivent toujours display_properties');
  });

  testWidgets('seuls les champs des types sélectionnés sont affichés',
      (tester) async {
    await pumpForm(tester, initialValues: {
      'types_site': ['941'],
    });

    expect(find.textContaining('Nom'), findsOneWidget,
        reason: 'un champ sans id_types_site est toujours affiché');
    expect(find.textContaining('Eau permanente'), findsOneWidget);
    expect(find.textContaining('Longueur du transect'), findsNothing);
  });

  testWidgets('cocher un type affiche ses champs, le décocher les masque',
      (tester) async {
    final form = await pumpForm(tester, initialValues: {
      'types_site': ['941'],
    });

    form.updateFormValue('types_site', ['941', '975']);
    await tester.pumpAndSettle();
    expect(find.textContaining('Eau permanente'), findsOneWidget);
    expect(find.textContaining('Longueur du transect'), findsOneWidget);

    form.updateFormValue('types_site', ['975']);
    await tester.pumpAndSettle();
    expect(find.textContaining('Eau permanente'), findsNothing);
    expect(find.textContaining('Longueur du transect'), findsOneWidget);
  });

  testWidgets('sans type sélectionné, aucun champ propre à un type',
      (tester) async {
    await pumpForm(tester);

    expect(find.textContaining('Eau permanente'), findsNothing);
    expect(find.textContaining('Longueur du transect'), findsNothing);
  });

  testWidgets(
      "les valeurs d'un type non sélectionné ne sont pas envoyées, "
      'même obligatoires', (tester) async {
    final form = await pumpForm(tester, initialValues: {
      'types_site': ['941'],
      'e2e_eau_permanente': 'Oui',
      'e2e_longueur_transect': 120,
    });

    final values = form.getFormValues();
    expect(values['e2e_eau_permanente'], 'Oui');
    expect(values.containsKey('e2e_longueur_transect'), isFalse);
  });

  testWidgets('un type de site obligatoire non choisi bloque l\'enregistrement',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: DynamicFormBuilder(
                objectConfig: ObjectConfig(
                  label: 'Site',
                  specific: {
                    'types_site': {
                      'type_widget': 'datalist',
                      'attribut_label': 'Type(s) de site',
                      'multiple': true,
                      'required': true,
                      'values': [
                        {'value': '941', 'label': 'Site POPAmphibien'},
                        {'value': '975', 'label': 'Transect POPReptile'},
                      ],
                    },
                  },
                ),
                objectType: 'site',
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final form =
        tester.state<DynamicFormBuilderState>(find.byType(DynamicFormBuilder));

    expect(form.validate(), isFalse);
    await tester.tap(find.text('Transect POPReptile'));
    await tester.pumpAndSettle();
    expect(form.validate(), isTrue);
  });
}
