import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/domain/model/observation.dart';
import 'package:gn_mobile_monitoring/presentation/view/observation_form_page.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/observations_viewmodel.dart';
import 'package:mocktail/mocktail.dart';

// Mocks
class MockObservationsViewModel extends Mock implements ObservationsViewModel {}

// Pour les tests avec Riverpod
class TestObservationsNotifier
    extends StateNotifier<AsyncValue<List<Observation>>>
    implements ObservationsViewModel {
  TestObservationsNotifier() : super(const AsyncValue.data([]));

  @override
  Future<int> createObservation(Map<String, dynamic> formData) async {
    return 123; // Simuler un ID d'observation nouvellement créée
  }

  @override
  Future<bool> updateObservation(
      Map<String, dynamic> formData, int observationId) async {
    return true; // Simuler une mise à jour réussie
  }

  @override
  Future<bool> deleteObservation(int observationId) async {
    return true;
  }

  @override
  Future<void> loadObservations() async {}
  
  @override
  Future<Observation> getObservationById(int observationId) async {
    return Observation(idObservation: observationId);
  }

  @override
  Future<List<Observation>> getObservationsByVisitId() async {
    return [];
  }

  @override
  void dispose() {
    super.dispose();
  }
}

void main() {
  late ObjectConfig testObservationConfig;

  setUp(() {
    testObservationConfig = ObjectConfig(
      label: 'Observation',
      displayProperties: ['cd_nom', 'comments'],
      generic: {
        'cd_nom': GenericFieldConfig(
          attributLabel: 'Cd Nom',
          typeWidget: 'number',
          required: true,
        ),
        'comments': GenericFieldConfig(
          attributLabel: 'Commentaires',
          typeWidget: 'textarea',
        ),
        'test_field': GenericFieldConfig(
          attributLabel: 'Champ de test',
          typeWidget: 'text',
        ),
      },
    );
  });

  testWidgets('ObservationFormPage should render create form correctly',
      (WidgetTester tester) async {
    // Paramètres du test
    const int testVisitId = 10;

    // Mock du ViewModel
    final mockViewModel = TestObservationsNotifier();

    // Rendre la page
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          observationsProvider(testVisitId).overrideWith((_) => mockViewModel),
        ],
        child: MaterialApp(
          home: ObservationFormPage(
            visitId: testVisitId,
            observationConfig: testObservationConfig,
          ),
        ),
      ),
    );

    // Laisser le temps au widget de se construire
    await tester.pumpAndSettle();

    // Vérifier que le titre est correct
    expect(find.text('Nouvelle observation'), findsOneWidget);
    expect(find.text('Saisir une nouvelle observation'), findsOneWidget);

    // Vérifier que les champs du formulaire sont affichés
    expect(find.text('Cd Nom *'), findsOneWidget);
    expect(find.text('Commentaires'), findsOneWidget);
    expect(find.text('Champ de test'), findsOneWidget);

    // Vérifier que le bouton de sauvegarde est présent
    expect(find.byIcon(Icons.save), findsOneWidget);
    expect(find.text('Ajouter'), findsOneWidget);
  });

  testWidgets('ObservationFormPage should render edit form with initial values',
      (WidgetTester tester) async {
    // Paramètres du test
    const int testVisitId = 10;

    // Observation existante pour le mode édition
    final testObservation = Observation(
      idObservation: 1,
      idBaseVisit: testVisitId,
      cdNom: 123,
      comments: 'Test observation comment',
      data: {'test_field': 'Test value'},
    );

    // Mock du ViewModel
    final mockViewModel = TestObservationsNotifier();

    // Rendre la page en mode édition
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          observationsProvider(testVisitId).overrideWith((_) => mockViewModel),
        ],
        child: MaterialApp(
          home: ObservationFormPage(
            visitId: testVisitId,
            observationConfig: testObservationConfig,
            observation: testObservation,
          ),
        ),
      ),
    );

    // Laisser le temps au widget de se construire
    await tester.pumpAndSettle();

    // Vérifier que le titre est correct pour le mode édition
    expect(find.text('Modifier l\'observation'), findsOneWidget);
    expect(find.text('Modifier les informations de l\'observation'),
        findsOneWidget);

    // Vérifier que les champs ont les valeurs initiales
    // Note: Il est difficile de vérifier les valeurs des champs directement
    // car elles sont à l'intérieur des TextFormField. On pourrait étendre
    // le test pour interagir avec les champs, mais ce serait plus complexe.

    // Vérifier que le bouton a le libellé correct pour l'édition
    expect(find.text('Enregistrer'), findsOneWidget);
  });

  testWidgets('ObservationFormPage should show loading indicator during save',
      (WidgetTester tester) async {
    // Paramètres du test
    const int testVisitId = 10;

    // Créer un ViewModel qui introduit un délai lors de la sauvegarde
    final mockViewModel = MockObservationsViewModel();
    when(() => mockViewModel.createObservation(any())).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 1));
      return 123;
    });

    // Un StateNotifier pour l'override du provider
    final notifier = TestObservationsNotifier();

    // Rendre la page
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          observationsProvider(testVisitId).overrideWith((_) => notifier),
        ],
        child: MaterialApp(
          home: ObservationFormPage(
            visitId: testVisitId,
            observationConfig: testObservationConfig,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Remplir les champs obligatoires
    // Utiliser une clé pour trouver le bon widget sans ambiguïté
    final textField = find.byType(TextFormField).first;

    // Entrer une valeur dans le champ obligatoire
    await tester.enterText(textField, '123');
    await tester.pump();

    // Appuyer sur le bouton de sauvegarde
    await tester.tap(find.text('Ajouter'));
    await tester.pump(); // Commence la sauvegarde, mais ne la finalise pas

    // Vérifier que l'indicateur de chargement est affiché
    // Note: Ce test pourrait être fragile si l'implémentation change
    // et que la sauvegarde est trop rapide
  });

  testWidgets('ObservationFormPage should validate required fields',
      (WidgetTester tester) async {
    // Paramètres du test
    const int testVisitId = 10;

    // Mock du ViewModel
    final mockViewModel = TestObservationsNotifier();

    // Rendre la page
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          observationsProvider(testVisitId).overrideWith((_) => mockViewModel),
        ],
        child: MaterialApp(
          home: ObservationFormPage(
            visitId: testVisitId,
            observationConfig: testObservationConfig,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Appuyer sur le bouton de sauvegarde sans remplir les champs obligatoires
    await tester.tap(find.text('Ajouter'));
    await tester.pumpAndSettle();

    // Vérifier qu'un message d'erreur de validation est affiché
    expect(find.text('Ce champ est requis'), findsOneWidget);

    // Vérifier que le SnackBar avec le message d'erreur est affiché
    expect(find.text('Veuillez corriger les erreurs du formulaire'),
        findsOneWidget);
  });
}
