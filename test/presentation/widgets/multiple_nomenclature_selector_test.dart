import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/nomenclature.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/multiple_nomenclature_selector_widget.dart';

void main() {
  group('MultipleNomenclatureSelectorWidget', () {
    late List<Nomenclature> mockNomenclatures;

    setUp(() {
      mockNomenclatures = [
        Nomenclature(
          id: 657,
          idType: 100,
          cdNomenclature: '1',
          mnemonique: 'METHODE_PROSPECTION',
          labelFr: 'Capture au filet troubleau',
          labelDefault: 'Capture au filet troubleau',
        ),
        Nomenclature(
          id: 658,
          idType: 100,
          cdNomenclature: '2',
          mnemonique: 'METHODE_PROSPECTION',
          labelFr: 'Observation à vue',
          labelDefault: 'Observation à vue',
        ),
        Nomenclature(
          id: 659,
          idType: 100,
          cdNomenclature: '3',
          mnemonique: 'METHODE_PROSPECTION',
          labelFr: 'Écoute',
          labelDefault: 'Écoute',
        ),
      ];
    });

    Widget createTestWidget({
      required Map<String, dynamic> fieldConfig,
      List<int>? initialValue,
      required ValueChanged<List<int>?> onChanged,
      bool isRequired = false,
    }) {
      return ProviderScope(
        overrides: [
          nomenclaturesByTypeProvider('METHODE_PROSPECTION').overrideWith(
            (ref) => Future.value(mockNomenclatures),
          ),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: MultipleNomenclatureSelectorWidget(
              label: 'Méthode(s) de prospection',
              fieldConfig: fieldConfig,
              value: initialValue,
              onChanged: onChanged,
              isRequired: isRequired,
              description: 'Sélectionnez une ou plusieurs méthodes',
            ),
          ),
        ),
      );
    }

    testWidgets('should display nomenclature list with checkboxes',
        (WidgetTester tester) async {
      final fieldConfig = {
        'api': 'nomenclatures/nomenclature/METHODE_PROSPECTION',
        'multiple': true,
      };

      await tester.pumpWidget(
        createTestWidget(
          fieldConfig: fieldConfig,
          onChanged: (_) {},
        ),
      );

      // Attendre que les nomenclatures se chargent
      await tester.pumpAndSettle();

      // Vérifier que le label est affiché
      expect(find.text('Méthode(s) de prospection'), findsOneWidget);

      // Vérifier que la description est affichée
      expect(
          find.text('Sélectionnez une ou plusieurs méthodes'), findsOneWidget);

      // Vérifier que les 3 nomenclatures sont affichées
      expect(find.text('Capture au filet troubleau'), findsOneWidget);
      expect(find.text('Observation à vue'), findsOneWidget);
      expect(find.text('Écoute'), findsOneWidget);

      // Vérifier que le compteur affiche 0
      expect(find.text('0 sélectionné(s)'), findsOneWidget);
    });

    testWidgets('should allow selecting multiple items',
        (WidgetTester tester) async {
      final fieldConfig = {
        'api': 'nomenclatures/nomenclature/METHODE_PROSPECTION',
        'multiple': true,
      };

      List<int>? selectedValues;

      await tester.pumpWidget(
        createTestWidget(
          fieldConfig: fieldConfig,
          onChanged: (value) {
            selectedValues = value;
          },
        ),
      );

      await tester.pumpAndSettle();

      // Sélectionner la première nomenclature
      await tester.tap(find.text('Capture au filet troubleau'));
      await tester.pumpAndSettle();

      expect(selectedValues, equals([657]));
      expect(find.text('1 sélectionné(s)'), findsOneWidget);

      // Sélectionner la deuxième nomenclature
      await tester.tap(find.text('Observation à vue'));
      await tester.pumpAndSettle();

      expect(selectedValues, equals([657, 658]));
      expect(find.text('2 sélectionné(s)'), findsOneWidget);

      // Sélectionner la troisième nomenclature
      await tester.tap(find.text('Écoute'));
      await tester.pumpAndSettle();

      expect(selectedValues, equals([657, 658, 659]));
      expect(find.text('3 sélectionné(s)'), findsOneWidget);
    });

    testWidgets('should allow deselecting items', (WidgetTester tester) async {
      final fieldConfig = {
        'api': 'nomenclatures/nomenclature/METHODE_PROSPECTION',
        'multiple': true,
      };

      List<int>? selectedValues;

      await tester.pumpWidget(
        createTestWidget(
          fieldConfig: fieldConfig,
          initialValue: [657, 658],
          onChanged: (value) {
            selectedValues = value;
          },
        ),
      );

      await tester.pumpAndSettle();

      // Vérifier que 2 items sont sélectionnés
      expect(find.text('2 sélectionné(s)'), findsOneWidget);

      // Désélectionner le premier
      await tester.tap(find.text('Capture au filet troubleau'));
      await tester.pumpAndSettle();

      expect(selectedValues, equals([658]));
      expect(find.text('1 sélectionné(s)'), findsOneWidget);

      // Désélectionner le deuxième (liste vide)
      await tester.tap(find.text('Observation à vue'));
      await tester.pumpAndSettle();

      expect(selectedValues, isNull);
      expect(find.text('0 sélectionné(s)'), findsOneWidget);
    });

    testWidgets('should display "Tout désélectionner" button when items selected',
        (WidgetTester tester) async {
      final fieldConfig = {
        'api': 'nomenclatures/nomenclature/METHODE_PROSPECTION',
        'multiple': true,
      };

      List<int>? selectedValues;

      await tester.pumpWidget(
        createTestWidget(
          fieldConfig: fieldConfig,
          initialValue: [657, 658, 659],
          onChanged: (value) {
            selectedValues = value;
          },
        ),
      );

      await tester.pumpAndSettle();

      // Vérifier que le bouton "Tout désélectionner" est affiché
      expect(find.text('Tout désélectionner'), findsOneWidget);

      // Cliquer sur "Tout désélectionner"
      await tester.tap(find.text('Tout désélectionner'));
      await tester.pumpAndSettle();

      // Vérifier que tout est désélectionné
      expect(selectedValues, isNull);
      expect(find.text('0 sélectionné(s)'), findsOneWidget);
      expect(find.text('Tout désélectionner'), findsNothing);
    });

    testWidgets('should show required validation message when required and empty',
        (WidgetTester tester) async {
      final fieldConfig = {
        'api': 'nomenclatures/nomenclature/METHODE_PROSPECTION',
        'multiple': true,
      };

      await tester.pumpWidget(
        createTestWidget(
          fieldConfig: fieldConfig,
          onChanged: (_) {},
          isRequired: true,
        ),
      );

      await tester.pumpAndSettle();

      // Vérifier que l'astérisque de champ requis est affiché
      expect(find.text('Méthode(s) de prospection *'), findsOneWidget);

      // Vérifier que le message de validation est affiché
      expect(
          find.text('Au moins une sélection est requise'), findsOneWidget);
    });

    testWidgets('should not show validation message when required but has selection',
        (WidgetTester tester) async {
      final fieldConfig = {
        'api': 'nomenclatures/nomenclature/METHODE_PROSPECTION',
        'multiple': true,
      };

      await tester.pumpWidget(
        createTestWidget(
          fieldConfig: fieldConfig,
          initialValue: [657],
          onChanged: (_) {},
          isRequired: true,
        ),
      );

      await tester.pumpAndSettle();

      // Le message de validation ne devrait pas être affiché
      expect(find.text('Au moins une sélection est requise'), findsNothing);
    });

    testWidgets('should display loading indicator while fetching nomenclatures',
        (WidgetTester tester) async {
      final fieldConfig = {
        'api': 'nomenclatures/nomenclature/METHODE_PROSPECTION',
        'multiple': true,
      };

      await tester.pumpWidget(
        createTestWidget(
          fieldConfig: fieldConfig,
          onChanged: (_) {},
        ),
      );

      // Avant pumpAndSettle, l'indicateur de chargement devrait être visible
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();

      // Après pumpAndSettle, l'indicateur ne devrait plus être visible
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('should handle empty nomenclature list',
        (WidgetTester tester) async {
      final fieldConfig = {
        'api': 'nomenclatures/nomenclature/METHODE_PROSPECTION',
        'multiple': true,
      };

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            nomenclaturesByTypeProvider('METHODE_PROSPECTION').overrideWith(
              (ref) => Future.value(<Nomenclature>[]),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: MultipleNomenclatureSelectorWidget(
                label: 'Méthode(s) de prospection',
                fieldConfig: fieldConfig,
                value: null,
                onChanged: (_) {},
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Vérifier le message "Aucune nomenclature disponible"
      expect(find.text('Aucune nomenclature disponible'), findsOneWidget);
    });
  });
}
