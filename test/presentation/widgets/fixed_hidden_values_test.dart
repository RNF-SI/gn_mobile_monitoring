import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/dynamic_form_builder.dart';

/// Régression audit 09/2026 : un champ `hidden: true` avec une `value` dans
/// la config n'était pas enregistré (observations sans espèce pour
/// nidif_gypa, popanomaloglossus ; visites sans taxon pour apollons,
/// cheveches, craves). Le web envoie tout champ du schéma, masqué ou non.
void main() {
  Future<DynamicFormBuilderState> pumpForm(
    WidgetTester tester,
    ObjectConfig config, {
    Map<String, dynamic>? initialValues,
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: DynamicFormBuilder(
                objectConfig: config,
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

  // popanomaloglossus/observation.json (fork Geomaticien-shf)
  ObjectConfig popanomaloglossus() => ObjectConfig(
        label: 'Observation',
        specific: {
          'cd_nom': {
            'type_widget': 'text',
            'attribut_label': 'Nom espèce (latin)',
            'type_util': 'taxonomy',
            'value': 888501,
            'hidden': true,
          },
          'count': {
            'type_widget': 'number',
            'attribut_label': "Nombre d'Anomaloglossus blanci",
            'required': true,
            'hidden': false,
            'min': 0,
          },
        },
      );

  testWidgets('popanomaloglossus : taxon fixe enregistré en création',
      (tester) async {
    final form = await pumpForm(tester, popanomaloglossus());

    expect(find.text('Nom espèce (latin)'), findsNothing,
        reason: 'Le champ reste masqué');
    expect(form.getFormValues()['cd_nom'], 888501);
  });

  testWidgets('édition : la valeur déjà enregistrée est conservée',
      (tester) async {
    final form = await pumpForm(tester, popanomaloglossus(),
        initialValues: {'cd_nom': 123, 'count': 2});

    expect(form.getFormValues()['cd_nom'], 123);
  });

  testWidgets('nidif_gypa : hidden/value hérités du generic', (tester) async {
    final form = await pumpForm(
      tester,
      ObjectConfig(
        label: 'Observation',
        generic: {
          'cd_nom': GenericFieldConfig(
            attributLabel: 'Espèce',
            typeWidget: 'taxonomy',
          ),
        },
        specific: {
          'cd_nom': {'hidden': true, 'value': 2852},
        },
      ),
    );

    expect(form.getFormValues()['cd_nom'], 2852);
  });

  testWidgets('type de site non injecté (géré par types_site)',
      (tester) async {
    final form = await pumpForm(
      tester,
      ObjectConfig(
        label: 'Site',
        specific: {
          'id_nomenclature_type_site': {
            'type_widget': 'text',
            'type_util': 'nomenclature',
            'hidden': true,
            'value': {
              'code_nomenclature_type': 'TYPE_SITE',
              'cd_nomenclature': 'POPA',
            },
          },
          'base_site_name': {'type_widget': 'text', 'attribut_label': 'Nom'},
        },
      ),
    );

    expect(form.getFormValues().containsKey('id_nomenclature_type_site'),
        isFalse);
  });
}
