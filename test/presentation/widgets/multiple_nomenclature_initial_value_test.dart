import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/domain/model/nomenclature.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/dynamic_form_builder.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/multiple_nomenclature_selector_widget.dart';

/// Régression audit 09/2026 : une valeur initiale dont l'ID est une chaîne
/// (`{"id": "657"}`) faisait planter le formulaire (cast `as int`).
void main() {
  final nomenclatures = [
    for (final (id, label) in [(657, 'Vu'), (658, 'Entendu'), (659, 'Trace')])
      Nomenclature(
        id: id,
        idType: 100,
        cdNomenclature: '$id',
        mnemonique: label,
        labelFr: label,
        labelDefault: label,
      ),
  ];

  Future<void> pumpForm(WidgetTester tester, dynamic initialValue,
      {String multipleKey = 'multiple'}) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          nomenclaturesByTypeProvider('METHODE_PROSPECTION')
              .overrideWith((ref) => Future.value(nomenclatures)),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: DynamicFormBuilder(
                objectConfig: ObjectConfig(
                  label: 'Observation',
                  specific: {
                    'id_nomenclature_meth': {
                      'type_widget': 'nomenclature',
                      'attribut_label': 'Méthodes',
                      'code_nomenclature_type': 'METHODE_PROSPECTION',
                      'api': 'nomenclatures/nomenclature/METHODE_PROSPECTION',
                      multipleKey: true,
                    },
                  },
                ),
                initialValues: {'id_nomenclature_meth': initialValue},
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('accepte des IDs en chaîne dans une liste de Maps',
      (tester) async {
    await pumpForm(tester, [
      {'id': '657'},
      '658',
    ]);

    expect(tester.takeException(), isNull);
    expect(find.text('2 sélectionné(s)'), findsOneWidget);
  });

  testWidgets('accepte une valeur unique en Map avec ID en chaîne',
      (tester) async {
    await pumpForm(tester, {'id': '659'});

    expect(tester.takeException(), isNull);
    expect(find.text('1 sélectionné(s)'), findsOneWidget);
  });

  testWidgets('multi_select (clé du widget nomenclature web)', (tester) async {
    await pumpForm(tester, [657, 658, 659], multipleKey: 'multi_select');

    expect(find.text('3 sélectionné(s)'), findsOneWidget);
  });
}
