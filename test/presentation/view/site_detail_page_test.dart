import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/core/helpers/format_datetime.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/base_visit.dart';
import 'package:gn_mobile_monitoring/domain/model/module.dart';
import 'package:gn_mobile_monitoring/domain/model/module_complement.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/domain/usecase/create_visit_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/delete_visit_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_user_id_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_user_name_from_local_storage_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_visit_complement_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_visit_with_details_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_visits_by_site_id_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/save_visit_complement_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/update_visit_use_case.dart';
import 'package:gn_mobile_monitoring/presentation/model/module_info.dart';
import 'package:gn_mobile_monitoring/presentation/state/module_download_status.dart';
import 'package:gn_mobile_monitoring/presentation/view/site_detail_page.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/site_visits_viewmodel.dart';
import 'package:mocktail/mocktail.dart';

class MockGetVisitsBySiteIdUseCase extends Mock
    implements GetVisitsBySiteIdUseCase {}

class MockGetVisitWithDetailsUseCase extends Mock
    implements GetVisitWithDetailsUseCase {}

class MockGetVisitComplementUseCase extends Mock
    implements GetVisitComplementUseCase {}

class MockSaveVisitComplementUseCase extends Mock
    implements SaveVisitComplementUseCase {}

class MockCreateVisitUseCase extends Mock implements CreateVisitUseCase {}

class MockUpdateVisitUseCase extends Mock implements UpdateVisitUseCase {}

class MockDeleteVisitUseCase extends Mock implements DeleteVisitUseCase {}

class MockGetUserIdFromLocalStorageUseCase extends Mock
    implements GetUserIdFromLocalStorageUseCase {}

class MockGetUserNameFromLocalStorageUseCase extends Mock
    implements GetUserNameFromLocalStorageUseCase {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

// Class for registering Mocktail routes
class FakeRoute extends Fake implements Route {}

void main() {
  final testSite = BaseSite(
    idBaseSite: 1,
    baseSiteName: 'Test Site',
    baseSiteCode: 'TST1',
    baseSiteDescription: 'Test site description',
    altitudeMin: 100,
    altitudeMax: 200,
    metaCreateDate: DateTime.parse('2024-03-21'),
    metaUpdateDate: DateTime.parse('2024-03-21'),
  );

  final testVisits = [
    BaseVisit(
      idBaseVisit: 1,
      idBaseSite: 1,
      idDataset: 1,
      idModule: 1,
      visitDateMin: '2024-03-20',
      visitDateMax: '2024-03-20',
      comments: 'Test visit 1',
      observers: [42],
      idDigitiser: 42,
    ),
    BaseVisit(
      idBaseVisit: 2,
      idBaseSite: 1,
      idDataset: 1,
      idModule: 1,
      visitDateMin: '2024-03-21',
      comments: 'Test visit 2',
      observers: [42, 43],
      idDigitiser: 42,
    ),
  ];

  late MockGetVisitsBySiteIdUseCase mockGetVisitsBySiteIdUseCase;
  late MockGetVisitWithDetailsUseCase mockGetVisitWithDetailsUseCase;
  late MockGetVisitComplementUseCase mockGetVisitComplementUseCase;
  late MockSaveVisitComplementUseCase mockSaveVisitComplementUseCase;
  late MockCreateVisitUseCase mockCreateVisitUseCase;
  late MockUpdateVisitUseCase mockUpdateVisitUseCase;
  late MockDeleteVisitUseCase mockDeleteVisitUseCase;
  late MockGetUserIdFromLocalStorageUseCase mockGetUserIdUseCase;
  late MockGetUserNameFromLocalStorageUseCase mockGetUserNameUseCase;
  late SiteVisitsViewModel preloadedViewModel;
  late MockNavigatorObserver mockNavigatorObserver;

  setUp(() {
    mockGetVisitsBySiteIdUseCase = MockGetVisitsBySiteIdUseCase();
    mockGetVisitWithDetailsUseCase = MockGetVisitWithDetailsUseCase();
    mockGetVisitComplementUseCase = MockGetVisitComplementUseCase();
    mockSaveVisitComplementUseCase = MockSaveVisitComplementUseCase();
    mockCreateVisitUseCase = MockCreateVisitUseCase();
    mockUpdateVisitUseCase = MockUpdateVisitUseCase();
    mockDeleteVisitUseCase = MockDeleteVisitUseCase();
    mockGetUserIdUseCase = MockGetUserIdFromLocalStorageUseCase();
    mockGetUserNameUseCase = MockGetUserNameFromLocalStorageUseCase();
    mockNavigatorObserver = MockNavigatorObserver();

    registerFallbackValue(FakeRoute());

    // Configuration des mocks
    when(() => mockGetUserIdUseCase.execute()).thenAnswer((_) async => 42);
    when(() => mockGetUserNameUseCase.execute())
        .thenAnswer((_) async => 'Test User');

    // Pre-create a ViewModel with data already loaded
    preloadedViewModel = SiteVisitsViewModel(
      mockGetVisitsBySiteIdUseCase,
      mockGetVisitWithDetailsUseCase,
      mockGetVisitComplementUseCase,
      mockSaveVisitComplementUseCase,
      mockCreateVisitUseCase,
      mockUpdateVisitUseCase,
      mockDeleteVisitUseCase,
      mockGetUserIdUseCase,
      mockGetUserNameUseCase,
      testSite.idBaseSite,
    );
  });

  testWidgets('SiteDetailPage displays site properties correctly',
      (WidgetTester tester) async {
    // Configure le viewModel pour retourner une liste vide
    preloadedViewModel.state = const AsyncValue.data([]);

    await tester.pumpWidget(ProviderScope(
      overrides: [
        // Override the provider to return our pre-loaded ViewModel
        siteVisitsViewModelProvider.overrideWith(
          (ref, siteId) => preloadedViewModel,
        ),
      ],
      child: MaterialApp(
        home: SiteDetailPage(site: testSite),
      ),
    ));

    // Just pump once more for the widget to build
    await tester.pump();

    // Verify site properties are displayed
    expect(find.text('Test Site'), findsAtLeastNWidgets(1));
    expect(find.text('TST1'), findsOneWidget);
    expect(find.text('Test site description'), findsOneWidget);
    expect(find.text('100-200m'), findsOneWidget);

    // Verify property labels are displayed
    expect(find.text('Nom'), findsOneWidget);
    expect(find.text('Code'), findsOneWidget);
    expect(find.text('Description'), findsOneWidget);
    expect(find.text('Altitude'), findsOneWidget);
    expect(find.text('Propriétés'), findsOneWidget);

    // Verify visits section is displayed
    expect(find.text('Visites'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
    expect(find.text('Ajouter une visite'), findsOneWidget);

    // Verify empty visits message is displayed (since mock returns empty list)
    expect(find.text('Aucune visite pour ce site'), findsOneWidget);
  });

  testWidgets('SiteDetailPage displays visits correctly when available',
      (WidgetTester tester) async {
    // Configure le viewModel pour retourner une liste avec des visites
    preloadedViewModel.state = AsyncValue.data(testVisits);

    await tester.pumpWidget(ProviderScope(
      overrides: [
        siteVisitsViewModelProvider.overrideWith(
          (ref, siteId) => preloadedViewModel,
        ),
      ],
      child: MaterialApp(
        home: SiteDetailPage(site: testSite),
      ),
    ));

    await tester.pump();

    // Verify visits table headers
    expect(find.text('Actions'), findsOneWidget);
    expect(find.text('Visit Date Min'), findsOneWidget);
    expect(find.text('Observers'), findsOneWidget);
    expect(find.text('Comments'), findsOneWidget);

    // Verify visits data
    expect(find.text(formatDateString('2024-03-20')), findsOneWidget);
    expect(find.text(formatDateString('2024-03-21')), findsOneWidget);
    expect(find.text('Test visit 1'), findsOneWidget);
    expect(find.text('Test visit 2'), findsOneWidget);
    expect(find.text('1'), findsOneWidget); // For visit with 1 observer
    expect(find.text('2'), findsOneWidget); // For visit with 2 observers

    // Verify edit buttons
    expect(find.byIcon(Icons.edit), findsNWidgets(2));
  });

  testWidgets('SiteDetailPage shows error message when loading visits fails',
      (WidgetTester tester) async {
    // Configure le viewModel pour simuler une erreur
    final errorMsg = 'Erreur de chargement';
    preloadedViewModel.state = AsyncValue.error(errorMsg, StackTrace.empty);

    await tester.pumpWidget(ProviderScope(
      overrides: [
        siteVisitsViewModelProvider.overrideWith(
          (ref, siteId) => preloadedViewModel,
        ),
      ],
      child: MaterialApp(
        home: SiteDetailPage(site: testSite),
      ),
    ));

    await tester.pump();

    // Verify error message is displayed
    expect(find.text('Erreur lors du chargement des visites: $errorMsg'),
        findsOneWidget);
  });

  testWidgets('SiteDetailPage shows loading indicator when loading visits',
      (WidgetTester tester) async {
    // Configure le viewModel pour être en état de chargement
    preloadedViewModel.state = const AsyncValue.loading();

    await tester.pumpWidget(ProviderScope(
      overrides: [
        siteVisitsViewModelProvider.overrideWith(
          (ref, siteId) => preloadedViewModel,
        ),
      ],
      child: MaterialApp(
        home: SiteDetailPage(site: testSite),
      ),
    ));

    await tester.pump();

    // Verify loading indicator is displayed
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets(
      'SiteDetailPage allows navigating to create visit page with module config',
      (WidgetTester tester) async {
    // Create a module configuration to enable the add visit button
    final moduleConfig = ModuleConfiguration(
      visit: ObjectConfig(
        label: 'Test Visit',
        chained: true,
        displayList: ['visit_date_min', 'comments'],
        generic: {
          'visit_date_min': GenericFieldConfig(
            attributLabel: 'Date',
            typeWidget: 'date',
            required: true,
          ),
        },
      ),
    );

    final testModuleInfo = ModuleInfo(
      module: Module(
        id: 1,
        moduleCode: 'TEST',
        moduleLabel: 'Test Module',
        activeFrontend: true,
        activeBackend: true,
        complement: ModuleComplement(
          idModule: 1,
          configuration: moduleConfig,
        ),
      ),
      downloadStatus: ModuleDownloadStatus.moduleDownloaded,
    );

    // Configure le viewModel pour retourner une liste vide
    preloadedViewModel.state = const AsyncValue.data([]);

    await tester.pumpWidget(ProviderScope(
      overrides: [
        siteVisitsViewModelProvider.overrideWith(
          (ref, siteId) => preloadedViewModel,
        ),
      ],
      child: MaterialApp(
        navigatorObservers: [mockNavigatorObserver],
        home: SiteDetailPage(
          site: testSite,
          moduleInfo: testModuleInfo,
        ),
      ),
    ));

    await tester.pump();

    // Verify the visit config label is used
    expect(find.text('Test Visit'), findsOneWidget);

    // Verify the add visit button
    expect(find.text('Ajouter une visite'), findsOneWidget);

    // Tap the button to navigate to the visit form
    await tester.tap(find.text('Ajouter une visite'));
    await tester.pumpAndSettle();

    // Verify navigation occurred
    verify(() => mockNavigatorObserver.didPush(any(), any()))
        .called(greaterThanOrEqualTo(1));
  });

  testWidgets('SiteDetailPage shows error when adding visit without config',
      (WidgetTester tester) async {
    // Configure le viewModel pour retourner une liste vide
    preloadedViewModel.state = const AsyncValue.data([]);

    await tester.pumpWidget(ProviderScope(
      overrides: [
        siteVisitsViewModelProvider.overrideWith(
          (ref, siteId) => preloadedViewModel,
        ),
      ],
      child: MaterialApp(
        scaffoldMessengerKey: GlobalKey<ScaffoldMessengerState>(),
        home: SiteDetailPage(site: testSite),
      ),
    ));

    await tester.pump();

    // Tap the button to try to navigate to the visit form
    await tester.tap(find.text('Ajouter une visite'));
    await tester.pumpAndSettle();

    // Verify the snackbar with the error message is shown
    expect(find.text('Configuration de visite non disponible'), findsOneWidget);
  });
}
