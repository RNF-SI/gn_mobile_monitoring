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
    late MockGetVisitsBySiteAndModuleUseCase mockGetVisitsBySiteAndModuleUseCase;
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
      mockGetVisitsBySiteAndModuleUseCase = MockGetVisitsBySiteAndModuleUseCase();
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
      when(() => mockGetVisitsBySiteAndModuleUseCase.execute(testSite.idBaseSite, 1))
          .thenAnswer((_) async => []);
          
      // Create a SiteVisitsViewModel provider
      final viewModelProvider = StateNotifierProvider.autoDispose<SiteVisitsViewModel, AsyncValue<List<BaseVisit>>>((ref) {
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
          1, // Default moduleId
        );
      });
  
      await tester.pumpWidget(ProviderScope(
        overrides: [
          // Override the original provider with our test-specific provider
          siteVisitsViewModelProvider.overrideWith(
            (ref, params) => ref.watch(viewModelProvider.notifier),
          ),
        ],
        child: MaterialApp(
          home: SiteDetailPage(
            site: testSite,
            moduleInfo: testModuleInfo,
          ),
        ),
      ));
  
      // Wait for the widget to build
      await tester.pumpAndSettle();
  
      // Verify site properties are displayed
      expect(find.text('Test Site'), findsAtLeastNWidgets(1));
      expect(find.text('TST1'), findsOneWidget);
      expect(find.text('Test site description'), findsOneWidget);
      expect(find.text('100-200 m'),
          findsOneWidget); // Notez l'espace entre 200 et m
  
      // Verify visits section is displayed
      expect(find.text('Visites'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.text('Ajouter une visite'), findsOneWidget);
  
      // Verify empty visits message is displayed (since mock returns empty list)
      expect(find.text('Aucune visite pour ce site'), findsOneWidget);
    });

    testWidgets('displays visits correctly when available',
        (WidgetTester tester) async {
      // Configure mock to return test visits
      when(() => mockGetVisitsBySiteAndModuleUseCase.execute(testSite.idBaseSite, 1))
          .thenAnswer((_) async => testVisits);
          
      // Create a SiteVisitsViewModel provider
      final viewModelProvider = StateNotifierProvider.autoDispose<SiteVisitsViewModel, AsyncValue<List<BaseVisit>>>((ref) {
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
          1, // Default moduleId
        );
      });
  
      await tester.pumpWidget(ProviderScope(
        overrides: [
          siteVisitsViewModelProvider.overrideWith(
            (ref, params) => ref.watch(viewModelProvider.notifier),
          ),
        ],
        child: MaterialApp(
          home: SiteDetailPage(
            site: testSite,
            moduleInfo: testModuleInfo,
          ),
        ),
      ));
  
      // Wait for the widget to build completely
      await tester.pumpAndSettle();
  
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

    testWidgets('shows error message when loading visits fails',
        (WidgetTester tester) async {
      // Configure mock to throw an error
      final errorMsg = 'Erreur de chargement';
      when(() => mockGetVisitsBySiteAndModuleUseCase.execute(testSite.idBaseSite, 1))
          .thenThrow(errorMsg);
          
      // Create a SiteVisitsViewModel provider
      final viewModelProvider = StateNotifierProvider.autoDispose<SiteVisitsViewModel, AsyncValue<List<BaseVisit>>>((ref) {
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
          1, // Default moduleId
        );
      });
  
      await tester.pumpWidget(ProviderScope(
        overrides: [
          siteVisitsViewModelProvider.overrideWith(
            (ref, params) => ref.watch(viewModelProvider.notifier),
          ),
        ],
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
      // Configure mock to delay response - this keeps the loading state visible
      final completer = Completer<List<BaseVisit>>();
      when(() => mockGetVisitsBySiteAndModuleUseCase.execute(testSite.idBaseSite, 1))
          .thenAnswer((_) => completer.future);
      
      // Create a SiteVisitsViewModel provider
      final viewModelProvider = StateNotifierProvider.autoDispose<SiteVisitsViewModel, AsyncValue<List<BaseVisit>>>((ref) {
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
          1, // Default moduleId
        );
      });
  
      await tester.pumpWidget(ProviderScope(
        overrides: [
          siteVisitsViewModelProvider.overrideWith(
            (ref, params) => ref.watch(viewModelProvider.notifier),
          ),
        ],
        child: MaterialApp(
          home: SiteDetailPage(
            site: testSite,
            moduleInfo: testModuleInfo,
          ),
        ),
      ));
  
      // Just pump once without settling to keep the loading state
      await tester.pump();
  
      // Verify loading indicator is displayed
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      
      // Complete the future to clean up
      completer.complete([]);
    });

    testWidgets('allows navigating to create visit page with module config',
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
  
      final customModuleInfo = ModuleInfo(
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
  
      // Configure mock to return empty list
      when(() => mockGetVisitsBySiteAndModuleUseCase.execute(testSite.idBaseSite, 1))
          .thenAnswer((_) async => []);
          
      // Create a SiteVisitsViewModel provider
      final viewModelProvider = StateNotifierProvider.autoDispose<SiteVisitsViewModel, AsyncValue<List<BaseVisit>>>((ref) {
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
          1, // Default moduleId
        );
      });
  
      await tester.pumpWidget(ProviderScope(
        overrides: [
          siteVisitsViewModelProvider.overrideWith(
            (ref, params) => ref.watch(viewModelProvider.notifier),
          ),
        ],
        child: MaterialApp(
          navigatorObservers: [mockNavigatorObserver],
          home: SiteDetailPage(
            site: testSite,
            moduleInfo: customModuleInfo,
          ),
        ),
      ));
  
      await tester.pumpAndSettle();
  
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

    testWidgets('shows error when adding visit without config',
        (WidgetTester tester) async {
      // Configure mock to return empty list
      when(() => mockGetVisitsBySiteAndModuleUseCase.execute(testSite.idBaseSite, 1))
          .thenAnswer((_) async => []);
          
      // Create a SiteVisitsViewModel provider
      final viewModelProvider = StateNotifierProvider.autoDispose<SiteVisitsViewModel, AsyncValue<List<BaseVisit>>>((ref) {
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
          1, // Default moduleId
        );
      });
  
      await tester.pumpWidget(ProviderScope(
        overrides: [
          siteVisitsViewModelProvider.overrideWith(
            (ref, params) => ref.watch(viewModelProvider.notifier),
          ),
        ],
        child: MaterialApp(
          scaffoldMessengerKey: GlobalKey<ScaffoldMessengerState>(),
          home: SiteDetailPage(site: testSite), // No moduleInfo passed
        ),
      ));
  
      await tester.pumpAndSettle();
  
      // Verify the error message is displayed
      expect(find.text('Module non disponible'), findsOneWidget);
    });
  }); // Close the group
}
