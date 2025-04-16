import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/base_visit.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/domain/model/observation.dart';
import 'package:gn_mobile_monitoring/presentation/model/module_info.dart';
import 'package:gn_mobile_monitoring/presentation/view/observation/observation_form_page.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/observations_viewmodel.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/dynamic_form_builder.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/mocks.dart';

// Mocks nécessaires pour les tests
class MockObservationsViewModel extends Mock implements ObservationsViewModel {}
class MockNavigatorObserver extends Mock implements NavigatorObserver {}

// Widget de test pour envelopper ObservationFormPage
class TestApp extends StatelessWidget {
  final ObjectConfig observationConfig;
  final CustomConfig? customConfig;
  final int visitId;
  final Observation? observation;
  
  const TestApp({
    Key? key,
    required this.observationConfig,
    required this.visitId,
    this.customConfig,
    this.observation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        // Override des providers nécessaires
        observationsProvider(visitId).overrideWith((ref) => MockObservationsViewModel()),
      ],
      child: MaterialApp(
        home: ObservationFormPage(
          visitId: visitId,
          observationConfig: observationConfig,
          customConfig: customConfig,
          observation: observation,
        ),
      ),
    );
  }
}

void main() {
  late MockNavigatorObserver mockNavigatorObserver;
  
  setUp(() {
    mockNavigatorObserver = MockNavigatorObserver();
  });

  testWidgets('chainInput provider should be initialized correctly', (WidgetTester tester) async {
    // Arrange
    final objectConfig = ObjectConfig(
      label: 'Observation',
      chained: true, // Chaînage activé dans la config
    );
    
    // Act - Build l'application avec le formulaire
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: ObservationFormPage(
            visitId: 1,
            observationConfig: objectConfig,
          ),
        ),
      ),
    );
    
    // Attendre que tout soit rendu
    await tester.pumpAndSettle();
    
    // Trouver le DynamicFormBuilder
    final formBuilderFinder = find.byType(DynamicFormBuilder);
    expect(formBuilderFinder, findsOneWidget);
    
    // Vérifier que le bouton de sauvegarde existe
    final saveButtonFinder = find.widgetWithText(ElevatedButton, 'Ajouter');
    expect(saveButtonFinder, findsOneWidget);
  });
    
  testWidgets('Form should show success message when saving', (WidgetTester tester) async {
    // Arrange
    final objectConfig = ObjectConfig(
      label: 'Observation',
      chained: true, // Chaînage activé dans la config
    );
    final mockObservationsViewModel = MockObservationsViewModel();
    
    when(() => mockObservationsViewModel.createObservation(any()))
        .thenAnswer((_) async => 123); // ID de la nouvelle observation
    
    when(() => mockObservationsViewModel.getObservationById(123))
        .thenAnswer((_) async => Observation(idObservation: 123, idBaseVisit: 1));
    
    // Act - Build l'application avec le formulaire
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          // Override pour le mock du viewmodel
          observationsProvider(1).overrideWith((_) => mockObservationsViewModel),
        ],
        child: MaterialApp(
          home: ObservationFormPage(
            visitId: 1,
            observationConfig: objectConfig,
            customConfig: CustomConfig(),
            // Ajouter les infos nécessaires pour la navigation
            visit: BaseVisit(
              idBaseVisit: 1,
              idDataset: 1,
              idModule: 1,
              visitDateMin: '2025-04-15',
            ),
            site: BaseSite(idBaseSite: 1),
          ),
        ),
      ),
    );
    
    // Attendre que tout soit rendu
    await tester.pumpAndSettle();
    
    // Trouver et appuyer sur le bouton de sauvegarde
    final saveButton = find.widgetWithText(ElevatedButton, 'Ajouter');
    await tester.tap(saveButton);
    await tester.pumpAndSettle();
    
    // Vérifier que createObservation a été appelé
    verify(() => mockObservationsViewModel.createObservation(any())).called(1);
    
    // Vérifier qu'un snackbar s'affiche avec le message de succès
    expect(find.text('Observation créée avec succès'), findsOneWidget);
  });
}