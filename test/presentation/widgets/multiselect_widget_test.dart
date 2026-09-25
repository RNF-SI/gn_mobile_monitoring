import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/core/helpers/form_config_parser.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/dynamic_form_builder.dart';

/// Widget `multiselect` du web (pnx-multiselect) : ecrevisses_pattes_blanches,
/// nidif_gypa, stom. Il était rendu en simple champ texte (audit 09/2026).
void main() {
  test('multiselect est reconnu comme datalist', () {
    expect(
        FormConfigParser.determineWidgetType({'type_widget': 'multiselect'}),
        'DatalistField');
  });

  // stom/visit.json (extrait)
  ObjectConfig stomVisit() => ObjectConfig(
        label: 'Visite',
        specific: {
          'elem_paysager': {
            'type_widget': 'multiselect',
            'attribut_label': 'Éléments paysagers',
            'values': [
              {'value': 'Bâti', 'label': 'Bâti'},
              {'value': 'Câblage', 'label': 'Câblage'},
              {'value': 'Clôture', 'label': 'Clôture'},
            ],
          },
        },
      );

  Future<DynamicFormBuilderState> pumpForm(WidgetTester tester,
      {Map<String, dynamic>? initialValues}) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: DynamicFormBuilder(
                objectConfig: stomVisit(),
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

  testWidgets('stom : cases à cocher et liste des valeurs cochées',
      (tester) async {
    final form = await pumpForm(tester);

    expect(find.byType(TextFormField), findsNothing,
        reason: 'Plus de champ texte libre');
    await tester.tap(find.text('Bâti'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Clôture'));
    await tester.pumpAndSettle();

    expect(form.getFormValues()['elem_paysager'],
        unorderedEquals(['Bâti', 'Clôture']));
  });

  testWidgets('édition : valeurs enregistrées cochées', (tester) async {
    final form = await pumpForm(tester, initialValues: {
      'elem_paysager': ['Câblage'],
    });

    final tile = tester.widget<CheckboxListTile>(
        find.widgetWithText(CheckboxListTile, 'Câblage'));
    expect(tile.value, isTrue);
    expect(form.getFormValues()['elem_paysager'], ['Câblage']);
  });
}
