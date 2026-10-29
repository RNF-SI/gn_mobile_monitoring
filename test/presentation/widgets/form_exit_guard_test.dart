import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/generic_form_page.dart';

/// Garde de sortie : quitter un formulaire modifié (retour système, flèche
/// de l'AppBar, « Annuler ») demande confirmation ; un formulaire intact se
/// ferme directement.
void main() {
  final config = ObjectConfig(
    label: 'Visite',
    specific: {
      'cd_nom': {
        'type_widget': 'text',
        'attribut_label': 'Espèce',
        'hidden': true,
        'value': 888501,
      },
      'comments': {'type_widget': 'text', 'attribut_label': 'Remarques'},
    },
  );

  Future<void> openForm(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => GenericFormPage(
                      objectConfig: config,
                      title: 'Nouvelle visite',
                      onSave: (_) async => true,
                    ),
                  ),
                ),
                child: const Text('ouvrir'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('ouvrir'));
    await tester.pumpAndSettle();
    expect(find.text('Nouvelle visite'), findsOneWidget);
  }

  Future<void> systemBack(WidgetTester tester) async {
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
  }

  testWidgets('formulaire intact : le retour ferme sans demander',
      (tester) async {
    await openForm(tester);
    await systemBack(tester);

    expect(find.text('Quitter sans enregistrer ?'), findsNothing);
    expect(find.text('Nouvelle visite'), findsNothing);
  });

  testWidgets('formulaire modifié : le retour demande confirmation',
      (tester) async {
    await openForm(tester);
    await tester.enterText(
        find.byKey(const ValueKey('comments_false')), 'RAS');
    await tester.pumpAndSettle();

    await systemBack(tester);
    expect(find.text('Quitter sans enregistrer ?'), findsOneWidget);

    await tester.tap(find.text('Continuer la saisie'));
    await tester.pumpAndSettle();
    expect(find.text('Nouvelle visite'), findsOneWidget);
    expect(find.text('RAS'), findsOneWidget);

    await tester.tap(find.text('Annuler'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Quitter'));
    await tester.pumpAndSettle();
    expect(find.text('Nouvelle visite'), findsNothing);
  });

  testWidgets('texte effacé : plus rien à confirmer', (tester) async {
    await openForm(tester);
    final field = find.byKey(const ValueKey('comments_false'));
    await tester.enterText(field, 'RAS');
    await tester.enterText(field, '');
    await tester.pumpAndSettle();

    await systemBack(tester);
    expect(find.text('Quitter sans enregistrer ?'), findsNothing);
    expect(find.text('Nouvelle visite'), findsNothing);
  });
}
