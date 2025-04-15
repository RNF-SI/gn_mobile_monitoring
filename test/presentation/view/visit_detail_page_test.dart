import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/base_visit.dart';
import 'package:gn_mobile_monitoring/domain/model/module.dart';
import 'package:gn_mobile_monitoring/domain/model/module_complement.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/domain/model/observation.dart';
import 'package:gn_mobile_monitoring/presentation/model/module_info.dart';
import 'package:gn_mobile_monitoring/presentation/state/module_download_status.dart';
import 'package:gn_mobile_monitoring/presentation/view/visit/visit_detail_page.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/observations_viewmodel.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/site_visits_viewmodel.dart';
import 'package:mocktail/mocktail.dart';

// Mocks nécessaires
class MockSiteVisitsViewModel extends Mock implements SiteVisitsViewModel {}

class MockObservationsViewModel extends Mock implements ObservationsViewModel {}

// Provider pour les tests
class TestNotifier extends StateNotifier<AsyncValue<List<Observation>>>
    implements ObservationsViewModel {
  TestNotifier(super.state);

  @override
  Future<int> createObservation(Map<String, dynamic> formData) {
    return Future.value(123); // Retourne immédiatement, sans délai
  }

  @override
  Future<bool> updateObservation(
      Map<String, dynamic> formData, int observationId) {
    return Future.value(true); // Retourne immédiatement, sans délai
  }

  @override
  Future<bool> deleteObservation(int observationId) {
    return Future.value(true); // Retourne immédiatement, sans délai
  }

  @override
  Future<void> loadObservations() async {
    // Ne rien faire pour éviter les chargements supplémentaires qui causent des timeouts
  }

  @override
  Future<Observation> getObservationById(int observationId) {
    return Future.value(Observation(idObservation: observationId));
  }

  @override
  Future<List<Observation>> getObservationsByVisitId() {
    // Retourner directement l'état actuel sans Future.delayed
    if (state is AsyncData<List<Observation>>) {
      return Future.value((state as AsyncData<List<Observation>>).value);
    }
    return Future.value([]);
  }
}

// On utilise des riverpod overrides pour fournir les données de test
class TestProviders {
  final testVisit = BaseVisit(
    idBaseVisit: 1,
    idBaseSite: 10,
    idModule: 1,
    idDataset: 1,
    visitDateMin: '2024-03-20',
    visitDateMax: '2024-03-20',
    comments: 'Test visit',
    metaCreateDate: '2024-03-20',
    metaUpdateDate: '2024-03-20',
    observers: [1, 2],
    data: {'field1': 'value1', 'field2': 'value2'},
  );

  final testObservations = [
    Observation(
      idObservation: 1,
      idBaseVisit: 1,
      cdNom: 123,
      comments: 'Test observation 1',
      data: {'field1': 'value1', 'field2': 42},
    ),
    Observation(
      idObservation: 2,
      idBaseVisit: 1,
      cdNom: 456,
      comments: 'Test observation 2',
      data: {'fieldA': 'valueA'},
    ),
  ];

  late final AutoDisposeFutureProvider<BaseVisit> visitDetailsProvider;
  late final AutoDisposeStateNotifierProvider<TestNotifier,
      AsyncValue<List<Observation>>> testObservationsProvider;

  TestProviders() {
    // Utiliser Future.value pour éviter tout délai
    visitDetailsProvider = FutureProvider.autoDispose<BaseVisit>((ref) {
      return Future.value(testVisit);
    });

    testObservationsProvider = StateNotifierProvider.autoDispose<TestNotifier,
        AsyncValue<List<Observation>>>((ref) {
      return TestNotifier(AsyncValue.data(testObservations));
    });
  }

  // Pour créer une version vide (aucune observation)
  TestProviders.empty() {
    visitDetailsProvider = FutureProvider.autoDispose<BaseVisit>((ref) {
      return Future.value(testVisit);
    });

    testObservationsProvider = StateNotifierProvider.autoDispose<TestNotifier,
        AsyncValue<List<Observation>>>((ref) {
      return TestNotifier(const AsyncValue.data([]));
    });
  }

  // Pour créer une version avec erreur
  TestProviders.error() {
    visitDetailsProvider = FutureProvider.autoDispose<BaseVisit>((ref) {
      throw Exception('Test error loading visit');
    });

    testObservationsProvider = StateNotifierProvider.autoDispose<TestNotifier,
        AsyncValue<List<Observation>>>((ref) {
      return TestNotifier(AsyncValue.error(
          Exception('Test error loading observations'), StackTrace.current));
    });
  }

  // Pour créer une version loading
  TestProviders.loading() {
    visitDetailsProvider = FutureProvider.autoDispose<BaseVisit>((ref) {
      return Future.sync(() => const AsyncValue.loading())
          .then((_) => testVisit);
    });

    testObservationsProvider = StateNotifierProvider.autoDispose<TestNotifier,
        AsyncValue<List<Observation>>>((ref) {
      return TestNotifier(const AsyncValue.loading());
    });
  }
}

// Simplifier l'approche en utilisant simplement des mocks directs
class MockSiteVisitsViewModelNotifier extends Mock
    implements SiteVisitsViewModel {}

void main() {
  // Setup global provider overrides to prevent real async calls
  late TestProviders providers;

  setUp(() {
    providers = TestProviders();
  });

  // Helper to create a testable widget with all the provider overrides
  Widget createTestableWidget({
    required BaseVisit visit,
    required BaseSite site,
    ModuleInfo? moduleInfo,
    List<Override> additionalOverrides = const [],
  }) {
    // Create the mock view model
    final mockViewModel = MockSiteVisitsViewModelNotifier();
    when(() => mockViewModel.getVisitWithFullDetails(any()))
        .thenAnswer((_) => Future.value(visit));

    return ProviderScope(
      overrides: [
        // Override siteVisitsViewModelProvider to use our mock
        siteVisitsViewModelProvider((site.idBaseSite, 1))
            .overrideWith((_) => mockViewModel),

        // Override the observations provider to prevent actual DB calls
        observationsProvider(visit.idBaseVisit).overrideWith(
            (_) => TestNotifier(AsyncValue.data(providers.testObservations))),

        // Any additional overrides specified by the test
        ...additionalOverrides,
      ],
      child: MaterialApp(
        home: VisitDetailPage(
          visit: visit,
          site: site,
          moduleInfo: moduleInfo,
        ),
      ),
    );
  }

  // Function to create standard test objects
  BaseSite createTestSite() {
    return BaseSite(
      idBaseSite: 10,
      baseSiteName: 'Test Site',
      baseSiteCode: 'TEST001',
    );
  }

  ModuleInfo createTestModuleInfo() {
    final moduleConfig = ModuleConfiguration(
      visit: ObjectConfig(
        label: 'Visite',
        generic: {
          'visit_date_min': GenericFieldConfig(
            attributLabel: 'Date de début',
            typeWidget: 'date',
            required: true,
          ),
          'comments': GenericFieldConfig(
            attributLabel: 'Commentaires',
            typeWidget: 'textarea',
          ),
        },
      ),
      observation: ObjectConfig(
        label: 'Observations',
        displayList: ['cd_nom', 'comments'],
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
        },
      ),
    );

    return ModuleInfo(
      module: Module(
        id: 1,
        moduleCode: 'TEST',
        moduleLabel: 'Test Module',
        complement: ModuleComplement(
          idModule: 1,
          configuration: moduleConfig,
        ),
      ),
      downloadStatus: ModuleDownloadStatus.moduleDownloaded,
    );
  }

  testWidgets('VisitDetailPage should display visit info when data is loaded',
      (WidgetTester tester) async {
    // Create test objects
    final testSite = createTestSite();
    final moduleInfo = createTestModuleInfo();

    // Create a mock that returns a controlled future
    final mockViewModel = MockSiteVisitsViewModelNotifier();
    final completer = Completer<BaseVisit>();
    when(() => mockViewModel.getVisitWithFullDetails(any()))
        .thenAnswer((_) => completer.future);

    // Build widget with overrides inside the test
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          // Override with our controlled mock
          siteVisitsViewModelProvider((testSite.idBaseSite, 1))
              .overrideWith((_) => mockViewModel),

          // Override observations provider to avoid loading real data
          observationsProvider(providers.testVisit.idBaseVisit).overrideWith(
              (_) => TestNotifier(AsyncValue.data(providers.testObservations))),
        ],
        child: MaterialApp(
          home: VisitDetailPage(
            visit: providers.testVisit,
            site: testSite,
            moduleInfo: moduleInfo,
          ),
        ),
      ),
    );

    // Complete the future to avoid pending timers
    completer.complete(providers.testVisit);

    // Process first frame showing loading
    await tester.pump();

    // Process frame after future completes
    await tester.pump();

    // Check for basic UI elements that should be present
    expect(find.text('Détails de la visite'), findsOneWidget);
    expect(find.text('Informations générales'), findsOneWidget);
    expect(find.text('Test Site'), findsOneWidget);
    expect(find.text('Test visit'), findsOneWidget);

    // Check for the Add button for observations
    expect(find.text('Ajouter'), findsOneWidget);

    // Check for action buttons
    expect(find.byIcon(Icons.edit), findsWidgets);
  });

  testWidgets(
      'VisitDetailPage should display loading indicator when data is loading',
      (WidgetTester tester) async {
    // Create test objects for each test to avoid shared state
    final testSite = createTestSite();
    final testProviders = TestProviders.loading();  // Use loading state specifically

    // Create a fresh mock for this test
    final mockViewModel = MockSiteVisitsViewModelNotifier();
    final completer = Completer<BaseVisit>();
    when(() => mockViewModel.getVisitWithFullDetails(any()))
        .thenAnswer((_) => completer.future);

    // Build widget with loading state
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          // Override with our mock that has an uncompleted future
          siteVisitsViewModelProvider((testSite.idBaseSite, 1))
              .overrideWith((_) => mockViewModel),

          // Also make sure observations are in loading state
          observationsProvider(1)
              .overrideWith((_) => TestNotifier(const AsyncValue.loading())),
        ],
        child: MaterialApp(
          home: VisitDetailPage(
            visit: providers.testVisit,
            site: testSite,
          ),
        ),
      ),
    );

    // Wait for first frame, which should show loading
    await tester.pump();

    // Verify loading indicator is shown
    expect(find.byType(CircularProgressIndicator), findsWidgets);

    // Complete the future to avoid pending timers
    completer.complete(providers.testVisit);

    // Process the completion
    await tester.pump();
  });

  testWidgets('VisitDetailPage should display empty state when no observations',
      (WidgetTester tester) async {
    // Create test objects specifically for this test
    final testSite = createTestSite();
    final moduleInfo = createTestModuleInfo();
    final testProvidersEmpty = TestProviders.empty();  // Use empty state provider

    // Create a fresh mock for this test
    final mockViewModel = MockSiteVisitsViewModelNotifier();
    final completer = Completer<BaseVisit>();
    when(() => mockViewModel.getVisitWithFullDetails(any()))
        .thenAnswer((_) => completer.future);

    // Create a dedicated observations test notifier with empty data
    final observationsNotifier = TestNotifier(const AsyncValue.data([]));

    // Build widget with specific overrides for this test
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          // Override for visit details
          siteVisitsViewModelProvider((testSite.idBaseSite, 1))
              .overrideWith((_) => mockViewModel),

          // Override for empty observations list
          observationsProvider(providers.testVisit.idBaseVisit)
              .overrideWith((_) => observationsNotifier),
        ],
        child: MaterialApp(
          home: VisitDetailPage(
            visit: providers.testVisit,
            site: testSite,
            moduleInfo: moduleInfo,
          ),
        ),
      ),
    );

    // Complete the future to avoid pending timers
    completer.complete(providers.testVisit);

    // Process first frame
    await tester.pump();

    // Process frame after future completes
    await tester.pump();

    // Verify empty state message is displayed
    expect(find.text('Aucune observation enregistrée pour cette visite'),
        findsOneWidget);
    expect(
        find.text('Cliquez sur "Ajouter" pour créer une nouvelle observation'),
        findsOneWidget);
  });

  testWidgets('VisitDetailPage should display loading indicator on initial render',
      (WidgetTester tester) async {
    // Create test objects specific to this test
    final testSite = createTestSite();
    
    // Create a fresh mock with a never-completing future (to keep it in loading state)
    final mockViewModel = MockSiteVisitsViewModelNotifier();
    final completer = Completer<BaseVisit>();
    when(() => mockViewModel.getVisitWithFullDetails(any()))
        .thenAnswer((_) => completer.future);
    
    // Build widget with loading future
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          // Override with our controlled mock
          siteVisitsViewModelProvider((testSite.idBaseSite, 1))
              .overrideWith((_) => mockViewModel),
        ],
        child: MaterialApp(
          home: VisitDetailPage(
            visit: providers.testVisit,
            site: testSite,
          ),
        ),
      ),
    );

    // Wait for first frame
    await tester.pump();

    // Verify loading indicator is displayed (this is a more reliable test)
    expect(find.byType(CircularProgressIndicator), findsWidgets);
    
    // Complete the future to avoid pending timers
    completer.complete(providers.testVisit);
    await tester.pump();
  });

  testWidgets('should display Add button when observation config exists',
      (WidgetTester tester) async {
    // Arrange with fresh objects for this test
    final mockSiteVisitsViewModel = MockSiteVisitsViewModelNotifier();
    final testSite = createTestSite();
    final testNotifier = TestNotifier(AsyncValue.data(providers.testObservations));
    
    // Reset and configure mocks specifically for this test
    reset(mockSiteVisitsViewModel);
    
    // Create BaseVisit with completed future to avoid timing issues
    final completer = Completer<BaseVisit>();
    when(() => mockSiteVisitsViewModel.getVisitWithFullDetails(any()))
        .thenAnswer((_) => completer.future);

    // ModuleInfo with observation configuration
    final moduleInfoWithObsConfig = ModuleInfo(
      module: Module(
        id: 1,
        moduleLabel: 'Test Module',
        complement: ModuleComplement(
          idModule: 1,
          configuration: ModuleConfiguration(
            observation: ObjectConfig(
              label: 'Observations',
              displayList: ['cd_nom', 'comments'],
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
              },
            ),
          ),
        ),
      ),
      downloadStatus: ModuleDownloadStatus.moduleDownloaded,
    );

    // Build widget with overrides
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          // Override with our controlled mock
          siteVisitsViewModelProvider((testSite.idBaseSite, 1))
              .overrideWith((_) => mockSiteVisitsViewModel),

          // Override observations provider with test data
          observationsProvider(providers.testVisit.idBaseVisit)
              .overrideWith((_) => testNotifier),
        ],
        child: MaterialApp(
          home: VisitDetailPage(
            visit: providers.testVisit,
            site: testSite,
            moduleInfo: moduleInfoWithObsConfig,
          ),
        ),
      ),
    );

    // Complete the future
    completer.complete(providers.testVisit);
    
    // Wait for first frame
    await tester.pump();
    
    // Wait for future to complete and UI to update
    await tester.pump();
    
    // Allow more time for UI to fully render
    await tester.pumpAndSettle();

    // Check for the Add button which is present when observation config exists
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}
