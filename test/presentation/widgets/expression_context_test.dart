import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/dynamic_form_builder.dart';

/// Contexte des expressions aligné sur le web (audit 09/2026) : un champ
/// taxonomique est exposé en objet `{cd_nom}` (suivi_loutre_*_gmb,
/// suivi_Camphi_gmb : `value.cd_nom.cd_nom == 60630`).
void main() {
  ObjectConfig loutre() => ObjectConfig(
        label: 'Observation',
        specific: {
          'cd_nom': {
            'type_widget': 'taxonomy',
            'attribut_label': 'Taxon',
            'type_util': 'taxonomy',
          },
          'nb_epreinte_tot': {
            'type_widget': 'number',
            'attribut_label': "Nombre total d'épreintes",
            'hidden':
                '({value}) => !(value.cd_nom && value.cd_nom.cd_nom == 60630)',
            'required': '({value}) => value.cd_nom && value.cd_nom.cd_nom == 60630',
          },
        },
      );

  Future<void> pumpForm(WidgetTester tester, Map<String, dynamic> values) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: DynamicFormBuilder(
                objectConfig: loutre(),
                initialValues: values,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('loutre (60630) : champ affiché et requis', (tester) async {
    await pumpForm(tester, {'cd_nom': 60630});

    expect(find.text("Nombre total d'épreintes *"), findsOneWidget);
  });

  testWidgets('autre taxon : champ masqué', (tester) async {
    await pumpForm(tester, {'cd_nom': 1234});

    expect(find.textContaining("Nombre total d'épreintes"), findsNothing);
  });

  testWidgets('sans taxon : champ masqué', (tester) async {
    await pumpForm(tester, {});

    expect(find.textContaining("Nombre total d'épreintes"), findsNothing);
  });
}
