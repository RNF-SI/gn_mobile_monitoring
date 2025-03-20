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
import 'package:gn_mobile_monitoring/presentation/view/visit_detail_page.dart';
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
  Future<int> createObservation(Map<String, dynamic> formData) async {
    return 123;
  }

  @override
  Future<bool> updateObservation(
      Map<String, dynamic> formData, int observationId) async {
    return true;
  }

  @override
  Future<bool> deleteObservation(int observationId) async {
    return true;
  }

  @override
  Future<void> loadObservations() async {}

  @override
  Future<List<Observation>> getObservationsByVisitId() async {
    return [];
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
    visitDetailsProvider = FutureProvider.autoDispose<BaseVisit>((ref) async {
      return testVisit;
    });

    testObservationsProvider = StateNotifierProvider.autoDispose<TestNotifier,
        AsyncValue<List<Observation>>>((ref) {
      return TestNotifier(AsyncValue.data(testObservations));
    });
  }

  // Pour créer une version vide (aucune observation)
  TestProviders.empty() {
    visitDetailsProvider = FutureProvider.autoDispose<BaseVisit>((ref) async {
      return testVisit;
    });

    testObservationsProvider = StateNotifierProvider.autoDispose<TestNotifier,
        AsyncValue<List<Observation>>>((ref) {
      return TestNotifier(const AsyncValue.data([]));
    });
  }

  // Pour créer une version avec erreur
  TestProviders.error() {
    visitDetailsProvider = FutureProvider.autoDispose<BaseVisit>((ref) async {
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
    visitDetailsProvider = FutureProvider.autoDispose<BaseVisit>((ref) async {
      await Future.delayed(const Duration(seconds: 1));
      return testVisit;
    });

    testObservationsProvider = StateNotifierProvider.autoDispose<TestNotifier,
        AsyncValue<List<Observation>>>((ref) {
      return TestNotifier(const AsyncValue.loading());
    });
  }
}

void main() {
  testWidgets('VisitDetailPage should display visit info when data is loaded',
      (WidgetTester tester) async {
    final providers = TestProviders();
    final testSite = BaseSite(
      idBaseSite: 10,
      baseSiteName: 'Test Site',
      baseSiteCode: 'TEST001',
    );

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
        label: 'Observation',
        displayList: ['cd_nom', 'comments'],
        generic: {
          'cd_nom': GenericFieldConfig(
            attributLabel: 'Cd Nom',
            typeWidget: 'number',
          ),
          'comments': GenericFieldConfig(
            attributLabel: 'Commentaires',
            typeWidget: 'textarea',
          ),
        },
      ),
    );

    final moduleInfo = ModuleInfo(
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

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          // Remplacer le provider de détails de visite par notre mock
          FutureProvider.autoDispose<BaseVisit>(
                  (ref) async => providers.testVisit)
              .overrideWithProvider(providers.visitDetailsProvider),

          // Remplacer le provider d'observations par notre mock
          observationsProvider(1).overrideWith(
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

    // Attendre que le chargement initial soit terminé
    await tester.pumpAndSettle();

    // Vérifier que les informations de base sont affichées
    expect(find.text('Détails de la visite'), findsOneWidget);
    expect(find.text('Informations générales'), findsOneWidget);
    expect(find.text('Test Site'), findsOneWidget);
    expect(find.text('Test visit'), findsOneWidget);
    expect(find.text('2 observateur(s)'), findsOneWidget);

    // Vérifier que la section des données spécifiques est affichée
    expect(find.text('Données spécifiques'), findsOneWidget);
    expect(find.text('Field1'), findsOneWidget);
    expect(find.text('value1'), findsAtLeastNWidgets(1));
    expect(find.text('Field2'), findsOneWidget);
    expect(find.text('value2'), findsOneWidget);

    // Vérifier que la section des observations est affichée
    expect(find.text('Observation'), findsOneWidget);
    expect(find.text('Ajouter'), findsOneWidget);

    // Vérifier les colonnes du tableau
    expect(find.text('Actions'), findsOneWidget);
    expect(find.text('Cd Nom'), findsOneWidget);
    expect(find.text('Commentaires'), findsOneWidget);

    // Vérifier que les observations sont listées
    expect(find.text('123'), findsOneWidget);
    expect(find.text('456'), findsOneWidget);
    expect(find.text('Test observation 1'), findsOneWidget);
    expect(find.text('Test observation 2'), findsOneWidget);

    // Vérifier que les boutons d'action sont présents
    expect(find.byIcon(Icons.edit), findsWidgets);
    expect(find.byIcon(Icons.delete), findsWidgets);
  });

  testWidgets(
      'VisitDetailPage should display loading indicator when data is loading',
      (WidgetTester tester) async {
    final providers = TestProviders.loading();
    final testSite = BaseSite(
      idBaseSite: 10,
      baseSiteName: 'Test Site',
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          FutureProvider.autoDispose<BaseVisit>(
                  (ref) async => providers.testVisit)
              .overrideWithProvider(providers.visitDetailsProvider),
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

    // Vérifier que le chargement est affiché
    expect(find.byType(CircularProgressIndicator), findsWidgets);
  });

  testWidgets('VisitDetailPage should display empty state when no observations',
      (WidgetTester tester) async {
    final providers = TestProviders.empty();
    final testSite = BaseSite(
      idBaseSite: 10,
      baseSiteName: 'Test Site',
    );

    final moduleConfig = ModuleConfiguration(
      observation: ObjectConfig(
        label: 'Observation',
        displayList: ['cd_nom', 'comments'],
      ),
    );

    final moduleInfo = ModuleInfo(
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

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          FutureProvider.autoDispose<BaseVisit>(
                  (ref) async => providers.testVisit)
              .overrideWithProvider(providers.visitDetailsProvider),
          observationsProvider(1)
              .overrideWith((_) => TestNotifier(const AsyncValue.data([]))),
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

    await tester.pumpAndSettle();

    // Vérifier que le message d'aucune observation est affiché
    expect(find.text('Aucune observation enregistrée pour cette visite'),
        findsOneWidget);
    expect(
        find.text('Cliquez sur "Ajouter" pour créer une nouvelle observation'),
        findsOneWidget);
  });

  testWidgets('VisitDetailPage should display error when loading fails',
      (WidgetTester tester) async {
    final providers = TestProviders.error();
    final testSite = BaseSite(
      idBaseSite: 10,
      baseSiteName: 'Test Site',
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          FutureProvider.autoDispose<BaseVisit>(
                  (ref) async => providers.testVisit)
              .overrideWithProvider(providers.visitDetailsProvider),
          observationsProvider(1).overrideWith((_) => TestNotifier(
              AsyncValue.error(Exception('Test error loading observations'),
                  StackTrace.current))),
        ],
        child: MaterialApp(
          home: VisitDetailPage(
            visit: providers.testVisit,
            site: testSite,
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Vérifier que le message d'erreur est affiché
    expect(
        find.text(
            'Erreur lors du chargement des détails: Exception: Test error loading visit'),
        findsOneWidget);
  });
}
