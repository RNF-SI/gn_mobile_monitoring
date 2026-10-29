import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/dynamic_form_builder.dart';

/// #225 : un champ `number` accepte les décimaux, comme le web ; `step`
/// (PnX-SI/GeoNature#4478) restreint les valeurs à `(valeur - min) % step == 0`.
void main() {
  Future<DynamicFormBuilderState> pumpForm(
      WidgetTester tester, Map<String, dynamic> field) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: DynamicFormBuilder(
                objectConfig: ObjectConfig(
                  label: 'Visite',
                  specific: {
                    'mesure': {
                      'type_widget': 'number',
                      'attribut_label': 'Mesure',
                      ...field,
                    },
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return tester.state(find.byType(DynamicFormBuilder));
  }

  Future<bool> enter(
      WidgetTester tester, DynamicFormBuilderState form, String text) async {
    await tester.enterText(find.byKey(const ValueKey('mesure_false')), text);
    await tester.pumpAndSettle();
    final valid = form.validate();
    await tester.pumpAndSettle();
    return valid;
  }

  testWidgets('décimal accepté et enregistré comme nombre', (tester) async {
    final form = await pumpForm(tester, {});
    expect(await enter(tester, form, '12.5'), isTrue);
    expect(form.getFormValues()['mesure'], 12.5);
  });

  testWidgets('virgule décimale acceptée', (tester) async {
    final form = await pumpForm(tester, {});
    expect(await enter(tester, form, '12,5'), isTrue);
    expect(form.getFormValues()['mesure'], 12.5);
  });

  testWidgets('valeur négative acceptée', (tester) async {
    final form = await pumpForm(tester, {});
    expect(await enter(tester, form, '-3.5'), isTrue);
    expect(form.getFormValues()['mesure'], -3.5);
  });

  testWidgets('valeur entière gardée en entier', (tester) async {
    final form = await pumpForm(tester, {});
    expect(await enter(tester, form, '4'), isTrue);
    expect(form.getFormValues()['mesure'], isA<int>());
  });

  testWidgets('saisie illisible refusée', (tester) async {
    final form = await pumpForm(tester, {});
    expect(await enter(tester, form, '12.5.3'), isFalse);
  });

  testWidgets('bornes appliquées aux décimaux', (tester) async {
    final form = await pumpForm(tester, {'min': 0, 'max': 10});
    expect(await enter(tester, form, '10.5'), isFalse);
    expect(await enter(tester, form, '9.5'), isTrue);
  });

  testWidgets('step 1 : entiers seulement', (tester) async {
    final form = await pumpForm(tester, {'step': 1});
    expect(await enter(tester, form, '2.5'), isFalse);
    expect(await enter(tester, form, '2'), isTrue);
  });

  testWidgets('step 0.5 avec min : multiples depuis min', (tester) async {
    final form = await pumpForm(tester, {'step': 0.5, 'min': 0.2});
    expect(await enter(tester, form, '1.2'), isTrue);
    expect(await enter(tester, form, '1.3'), isFalse);
  });
}
