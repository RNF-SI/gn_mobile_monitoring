import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/generic_form_page.dart';

/// #229 : un enregistrement refusé fait défiler jusqu'au premier champ en
/// erreur et nomme les champs à corriger.
void main() {
  // 20 champs facultatifs, puis deux champs obligatoires hors écran.
  final config = ObjectConfig(
    label: 'Visite',
    specific: {
      for (var i = 0; i < 20; i++)
        'champ_$i': {'type_widget': 'text', 'attribut_label': 'Champ $i'},
      'temperature': {
        'type_widget': 'number',
        'attribut_label': 'Température',
        'required': true,
      },
      'vent': {
        'type_widget': 'text',
        'attribut_label': 'Vent',
        'required': true,
      },
    },
  );

  testWidgets('défile jusqu\'au premier champ en erreur et le nomme',
      (tester) async {
    var saved = false;
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: GenericFormPage(
            objectConfig: config,
            title: 'Nouvelle visite',
            onSave: (_) async => saved = true,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final temperature = find.byKey(const ValueKey('temperature_true'));
    final screenHeight = tester.view.physicalSize.height /
        tester.view.devicePixelRatio;
    expect(tester.getTopLeft(temperature).dy, greaterThan(screenHeight),
        reason: 'Le champ est hors écran au départ');

    await tester.tap(find.text('Enregistrer'));
    await tester.pumpAndSettle();

    expect(saved, isFalse);
    final top = tester.getTopLeft(temperature).dy;
    expect(top, inInclusiveRange(0, screenHeight),
        reason: 'Le premier champ en erreur est ramené à l\'écran');
    expect(find.textContaining('Température'), findsWidgets);
    expect(find.text('À corriger : Température, Vent'), findsOneWidget);
  });
}
