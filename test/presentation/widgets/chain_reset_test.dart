import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/dynamic_form_builder.dart';

/// Mode enchaînement : la saisie suivante reprend les champs `keep` et les
/// présélections de l'ouverture, comme `resetObjForm` du module web.
/// Avant, `resetForm` vidait tout, valeurs fixes des champs cachés comprises.
void main() {
  ObjectConfig config({List<String>? keep}) => ObjectConfig(
        label: 'Observation',
        keep: keep,
        specific: {
          'cd_nom': {
            'type_widget': 'text',
            'attribut_label': 'Espèce',
            'hidden': true,
            'value': 888501,
          },
          'methode': {'type_widget': 'text', 'attribut_label': 'Méthode'},
          'comments': {'type_widget': 'text', 'attribut_label': 'Remarques'},
        },
      );

  Future<DynamicFormBuilderState> pumpForm(
      WidgetTester tester, ObjectConfig config) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: DynamicFormBuilder(objectConfig: config),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return tester.state(find.byType(DynamicFormBuilder));
  }

  Future<void> fill(WidgetTester tester) async {
    await tester.enterText(
        find.byKey(const ValueKey('methode_false')), 'Capture');
    await tester.enterText(
        find.byKey(const ValueKey('comments_false')), 'RAS');
    await tester.pumpAndSettle();
  }

  testWidgets('les champs keep sont repris, les autres vidés', (tester) async {
    final form = await pumpForm(tester, config(keep: ['methode']));
    await fill(tester);

    form.resetForm();
    await tester.pumpAndSettle();

    final values = form.getFormValues();
    expect(values['methode'], 'Capture');
    expect(values['comments'], anyOf(isNull, ''));
    expect(find.text('Capture'), findsOneWidget,
        reason: 'La valeur reprise est affichée dans le champ');
    expect(find.text('RAS'), findsNothing);
  });

  testWidgets('la valeur fixe d\'un champ caché est reposée', (tester) async {
    final form = await pumpForm(tester, config());
    await fill(tester);

    form.resetForm();
    await tester.pumpAndSettle();

    expect(form.getFormValues()['cd_nom'], 888501);
    expect(form.getFormValues()['methode'], anyOf(isNull, ''));
  });
}
