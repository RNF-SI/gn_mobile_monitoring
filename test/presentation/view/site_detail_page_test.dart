import 'dart:async';

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
import 'package:gn_mobile_monitoring/domain/usecase/get_visits_by_site_and_module_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/save_visit_complement_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/update_visit_use_case.dart';
import 'package:gn_mobile_monitoring/presentation/model/module_info.dart';
import 'package:gn_mobile_monitoring/presentation/state/module_download_status.dart';
import 'package:gn_mobile_monitoring/presentation/view/site/site_detail_page.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/site_visits_viewmodel.dart';
import 'package:mocktail/mocktail.dart';

class MockGetVisitsBySiteAndModuleUseCase extends Mock
    implements GetVisitsBySiteAndModuleUseCase {}

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
  group('SiteDetailPage Tests', () {
    // Shared variables for all tests
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

    final testModuleInfo = ModuleInfo(
      module: Module(
        id: 1,
        moduleLabel: 'Test Module',
        moduleCode: 'TEST_MODULE',
        moduleDesc: 'Test module description',
        complement: ModuleComplement(
          idModule: 1,
          configuration: ModuleConfiguration(
            visit: ObjectConfig(
              label: 'Visites',
              displayList: ['visit_date_min', 'observers', 'comments'],
            ),
            site: ObjectConfig(
              label: 'Site',
              displayList: [
                'base_site_name',
                'base_site_code',
                'base_site_description'
              ],
            ),
          ),
        ),
      ),
      downloadStatus: ModuleDownloadStatus.moduleDownloaded,
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

    // These instances will be recreated for each test
    late MockGetVisitsBySiteAndModuleUseCase
        mockGetVisitsBySiteAndModuleUseCase;
    late MockGetVisitWithDetailsUseCase mockGetVisitWithDetailsUseCase;
    late MockGetVisitComplementUseCase mockGetVisitComplementUseCase;
    late MockSaveVisitComplementUseCase mockSaveVisitComplementUseCase;
    late MockCreateVisitUseCase mockCreateVisitUseCase;
    late MockUpdateVisitUseCase mockUpdateVisitUseCase;
    late MockDeleteVisitUseCase mockDeleteVisitUseCase;
    late MockGetUserIdFromLocalStorageUseCase mockGetUserIdUseCase;
    late MockGetUserNameFromLocalStorageUseCase mockGetUserNameUseCase;
    late MockNavigatorObserver mockNavigatorObserver;

    // Setup that runs before each test
    setUp(() {
      mockGetVisitsBySiteAndModuleUseCase =
          MockGetVisitsBySiteAndModuleUseCase();
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

      // Common mock configurations
      when(() => mockGetUserIdUseCase.execute()).thenAnswer((_) async => 42);
      when(() => mockGetUserNameUseCase.execute())
          .thenAnswer((_) async => 'Test User');
      when(() => mockGetVisitsBySiteAndModuleUseCase.execute(any(), any()))
          .thenAnswer((_) async => []);
    });

    testWidgets('displays site properties correctly',
        (WidgetTester tester) async {
      // Configure mock to return empty list
      when(() => mockGetVisitsBySiteAndModuleUseCase.execute(
          testSite.idBaseSite, 1)).thenAnswer((_) async => []);

      // Create a provider container that will be disposed properly
      final container = ProviderContainer(
        overrides: [
          siteVisitsViewModelProvider.overrideWith((ref, params) {
            return SiteVisitsViewModel(
              mockGetVisitsBySiteAndModuleUseCase,
              mockGetVisitWithDetailsUseCase,
              mockGetVisitComplementUseCase,
              mockSaveVisitComplementUseCase,
              mockCreateVisitUseCase,
              mockUpdateVisitUseCase,
              mockDeleteVisitUseCase,
              mockGetUserIdUseCase,
              mockGetUserNameUseCase,
              testSite.idBaseSite,
              1,
            );
          }),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: SiteDetailPage(
            site: testSite,
            moduleInfo: testModuleInfo,
          ),
        ),
      ));

      // Wait for the widget to build completely
      await tester.pumpAndSettle();

      // Verify site properties are displayed
      expect(find.text('Test Site'), findsAtLeastNWidgets(1));
      expect(find.text('TST1'), findsOneWidget);
      expect(find.text('Test site description'), findsOneWidget);

      // Verify section titles
      expect(find.text('Informations générales'), findsOneWidget);
      expect(find.text('Visites'), findsOneWidget);

      // Verify empty visits message
      expect(find.text('Aucune visite pour ce site'), findsOneWidget);
      expect(find.text('Nouvelle visite'), findsOneWidget);
    });

    testWidgets('displays visits correctly when available',
        (WidgetTester tester) async {
      // Configure mock to return test visits immediately
      when(() => mockGetVisitsBySiteAndModuleUseCase.execute(
          testSite.idBaseSite, 1)).thenAnswer((_) async => testVisits);

      // Create a provider container that will be disposed properly
      final container = ProviderContainer(
        overrides: [
          siteVisitsViewModelProvider.overrideWith((ref, params) {
            return SiteVisitsViewModel(
              mockGetVisitsBySiteAndModuleUseCase,
              mockGetVisitWithDetailsUseCase,
              mockGetVisitComplementUseCase,
              mockSaveVisitComplementUseCase,
              mockCreateVisitUseCase,
              mockUpdateVisitUseCase,
              mockDeleteVisitUseCase,
              mockGetUserIdUseCase,
              mockGetUserNameUseCase,
              testSite.idBaseSite,
              1,
            );
          }),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: Scaffold(
            body: SiteDetailPage(
              site: testSite,
              moduleInfo: testModuleInfo,
            ),
          ),
        ),
      ));

      // Initial build
      await tester.pump();

      // Wait for post frame callback and TabController initialization
      await tester.pump(const Duration(milliseconds: 50));

      // Wait for async data loading
      await tester.pump(const Duration(milliseconds: 50));

      // Wait for any animations to complete
      await tester.pumpAndSettle();

      // Verify site info is displayed first
      expect(find.text('Test Site'), findsAtLeastNWidgets(1));
      expect(find.text('TST1'), findsOneWidget);
      expect(find.text('Test site description'), findsOneWidget);

      // Find the DataTable widget first
      final dataTableFinder = find.byType(DataTable);
      expect(dataTableFinder, findsOneWidget);

      // Get the DataTable widget
      final DataTable dataTable = tester.widget(dataTableFinder);

      // Verify the columns directly from the DataTable widget
      final columnLabels =
          dataTable.columns.map((c) => (c.label as Text).data).toList();
      expect(columnLabels,
          ['Actions', 'Date De Visite', 'Commentaires', 'Observateurs']);

      // Verify visits data is displayed
      expect(find.text(formatDateString('2024-03-20')), findsOneWidget);
      expect(find.text(formatDateString('2024-03-21')), findsOneWidget);
      expect(find.text('Test visit 1'), findsOneWidget);
      expect(find.text('Test visit 2'), findsOneWidget);
      expect(find.text('1 observateur'), findsOneWidget);
      expect(find.text('2 observateurs'), findsOneWidget);

      // Find all IconButtons in the DataTable
      final iconButtons = find.descendant(
        of: dataTableFinder,
        matching: find.byType(IconButton),
      );

      // Verify the number of action buttons (2 per row: view and edit)
      expect(iconButtons, findsNWidgets(4));

      // Verify the specific icons within the IconButtons in the DataTable
      final visibilityIcons = find.descendant(
        of: dataTableFinder,
        matching: find.byIcon(Icons.visibility),
      );
      final editIcons = find.descendant(
        of: dataTableFinder,
        matching: find.byIcon(Icons.edit),
      );

      expect(visibilityIcons, findsNWidgets(2));
      expect(editIcons, findsNWidgets(2));
    });

    testWidgets('shows error message when loading visits fails',
        (WidgetTester tester) async {
      // Configure mock to throw an error
      final errorMsg = 'Erreur de chargement';
      when(() => mockGetVisitsBySiteAndModuleUseCase.execute(
          testSite.idBaseSite, 1)).thenThrow(errorMsg);

      // Create a provider container that will be disposed properly
      final container = ProviderContainer(
        overrides: [
          siteVisitsViewModelProvider.overrideWith((ref, params) {
            return SiteVisitsViewModel(
              mockGetVisitsBySiteAndModuleUseCase,
              mockGetVisitWithDetailsUseCase,
              mockGetVisitComplementUseCase,
              mockSaveVisitComplementUseCase,
              mockCreateVisitUseCase,
              mockUpdateVisitUseCase,
              mockDeleteVisitUseCase,
              mockGetUserIdUseCase,
              mockGetUserNameUseCase,
              testSite.idBaseSite,
              1,
            );
          }),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: SiteDetailPage(
            site: testSite,
            moduleInfo: testModuleInfo,
          ),
        ),
      ));

      // Wait for the widget to build completely
      await tester.pumpAndSettle();

      // Verify error message is displayed
      expect(find.text('Erreur lors du chargement des visites: $errorMsg'),
          findsOneWidget);
    });

    testWidgets('shows loading indicator when loading visits',
        (WidgetTester tester) async {
      // Configure mock to delay response
      final completer = Completer<List<BaseVisit>>();
      when(() => mockGetVisitsBySiteAndModuleUseCase.execute(
          testSite.idBaseSite, 1)).thenAnswer((_) => completer.future);

      // Create a provider container that will be disposed properly
      final container = ProviderContainer(
        overrides: [
          siteVisitsViewModelProvider.overrideWith((ref, params) {
            return SiteVisitsViewModel(
              mockGetVisitsBySiteAndModuleUseCase,
              mockGetVisitWithDetailsUseCase,
              mockGetVisitComplementUseCase,
              mockSaveVisitComplementUseCase,
              mockCreateVisitUseCase,
              mockUpdateVisitUseCase,
              mockDeleteVisitUseCase,
              mockGetUserIdUseCase,
              mockGetUserNameUseCase,
              testSite.idBaseSite,
              1,
            );
          }),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: SiteDetailPage(
            site: testSite,
            moduleInfo: testModuleInfo,
          ),
        ),
      ));

      // Just pump once to keep the loading state
      await tester.pump();

      // Verify loading indicator is displayed
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Complete the future to clean up
      completer.complete([]);
    });

    testWidgets('shows error when adding visit without config',
        (WidgetTester tester) async {
      // Configure mock to return empty list
      when(() => mockGetVisitsBySiteAndModuleUseCase.execute(
          testSite.idBaseSite, 1)).thenAnswer((_) async => []);

      // Create a provider container that will be disposed properly
      final container = ProviderContainer(
        overrides: [
          siteVisitsViewModelProvider.overrideWith((ref, params) {
            return SiteVisitsViewModel(
              mockGetVisitsBySiteAndModuleUseCase,
              mockGetVisitWithDetailsUseCase,
              mockGetVisitComplementUseCase,
              mockSaveVisitComplementUseCase,
              mockCreateVisitUseCase,
              mockUpdateVisitUseCase,
              mockDeleteVisitUseCase,
              mockGetUserIdUseCase,
              mockGetUserNameUseCase,
              testSite.idBaseSite,
              1,
            );
          }),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: SiteDetailPage(
            site: testSite,
            // Pass null moduleInfo to trigger the error case
            moduleInfo: null,
          ),
        ),
      ));

      await tester.pumpAndSettle();

      // Verify that the add visit button is not present when there's no config
      expect(find.text('Nouvelle visite'), findsNothing);
    });
  }); // Close the group
}
