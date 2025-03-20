import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/base_visit.dart';
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
import 'package:gn_mobile_monitoring/presentation/view/visit_form_page.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/site_visits_viewmodel.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/dynamic_form_builder.dart';
import 'package:mocktail/mocktail.dart';

// Mocks
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

// Create a proper mock for DynamicFormBuilderState that handles Diagnosticable
class MockDynamicFormBuilderState extends Mock
    implements DynamicFormBuilderState {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return super.toString();
  }
}

// Fake classes for mocktail
class FakeRoute extends Fake implements Route {}

class FakeBuildContext extends Fake implements BuildContext {}

void main() {
  late BaseSite testSite;
  late ObjectConfig testVisitConfig;
  late CustomConfig testCustomConfig;
  late BaseVisit testVisit;
  late MockNavigatorObserver mockNavigatorObserver;
  late MockGetVisitsBySiteIdUseCase mockGetVisitsBySiteIdUseCase;
  late MockGetVisitWithDetailsUseCase mockGetVisitWithDetailsUseCase;
  late MockGetVisitComplementUseCase mockGetVisitComplementUseCase;
  late MockSaveVisitComplementUseCase mockSaveVisitComplementUseCase;
  late MockCreateVisitUseCase mockCreateVisitUseCase;
  late MockUpdateVisitUseCase mockUpdateVisitUseCase;
  late MockDeleteVisitUseCase mockDeleteVisitUseCase;
  late MockGetUserIdFromLocalStorageUseCase mockGetUserIdUseCase;
  late MockGetUserNameFromLocalStorageUseCase mockGetUserNameUseCase;

  setUpAll(() {
    registerFallbackValue(FakeRoute());
    registerFallbackValue(BaseSite(idBaseSite: 1));
    registerFallbackValue(BaseVisit(
      idBaseVisit: 1,
      idBaseSite: 1,
      idDataset: 1,
      idModule: 1,
      visitDateMin: '2024-01-01',
    ));
    registerFallbackValue(FakeBuildContext());
  });

  setUp(() {
    testSite = BaseSite(
      idBaseSite: 1,
      baseSiteName: 'Test Site',
      baseSiteCode: 'TS01',
      altitudeMin: 100,
      altitudeMax: 200,
    );

    testVisitConfig = ObjectConfig(
      label: 'Visite',
      chained: true,
      displayList: ['visit_date_min', 'comments', 'observers'],
      generic: {
        'visit_date_min': GenericFieldConfig(
          attributLabel: 'Date de visite',
          typeWidget: 'date',
          required: true,
        ),
        'comments': GenericFieldConfig(
          attributLabel: 'Commentaires',
          typeWidget: 'textarea',
        ),
        'observers': GenericFieldConfig(
          attributLabel: 'Observateurs',
          typeWidget: 'select',
          multiSelect: true,
        ),
      },
      specific: {
        'count_stade_l1': {
          'attribut_label': 'Nb L1',
          'type_widget': 'number',
          'default': 0,
          'description': 'Chenille entièrement noire de <1,5mm',
        },
        'time_start': {
          'attribut_label': 'Heure début',
          'type_widget': 'time',
        },
      },
    );

    testCustomConfig = CustomConfig(
      moduleCode: 'APOLTEST',
      idModule: 1,
    );

    testVisit = BaseVisit(
      idBaseVisit: 1,
      idBaseSite: 1,
      idDataset: 1,
      idModule: 1,
      visitDateMin: '2024-03-20',
      observers: [1, 2],
      comments: 'Test visit',
      data: {
        'count_stade_l1': 3,
        'time_start': '08:30',
      },
    );

    // Initialiser les mocks pour le ViewModel
    mockNavigatorObserver = MockNavigatorObserver();
    mockGetVisitsBySiteIdUseCase = MockGetVisitsBySiteIdUseCase();
    mockGetVisitWithDetailsUseCase = MockGetVisitWithDetailsUseCase();
    mockGetVisitComplementUseCase = MockGetVisitComplementUseCase();
    mockSaveVisitComplementUseCase = MockSaveVisitComplementUseCase();
    mockCreateVisitUseCase = MockCreateVisitUseCase();
    mockUpdateVisitUseCase = MockUpdateVisitUseCase();
    mockDeleteVisitUseCase = MockDeleteVisitUseCase();
    mockGetUserIdUseCase = MockGetUserIdFromLocalStorageUseCase();
    mockGetUserNameUseCase = MockGetUserNameFromLocalStorageUseCase();

    // Configure default behavior for mocks
    when(() => mockGetVisitsBySiteIdUseCase.execute(any()))
        .thenAnswer((_) async => []);
    when(() => mockGetVisitWithDetailsUseCase.execute(any()))
        .thenAnswer((_) async => testVisit);
    when(() => mockGetVisitComplementUseCase.execute(any()))
        .thenAnswer((_) async => null);
    when(() => mockGetUserIdUseCase.execute()).thenAnswer((_) async => 42);
    when(() => mockGetUserNameUseCase.execute())
        .thenAnswer((_) async => 'Test User');
    when(() => mockCreateVisitUseCase.execute(any()))
        .thenAnswer((_) async => 3);
    when(() => mockUpdateVisitUseCase.execute(any()))
        .thenAnswer((_) async => true);
    when(() => mockDeleteVisitUseCase.execute(any()))
        .thenAnswer((_) async => true);
  });

  ProviderScope buildTestProviderScope({required Widget child}) {
    return ProviderScope(
      overrides: [
        // Override the viewModel provider
        siteVisitsViewModelProvider
            .overrideWith((ref, siteId) => SiteVisitsViewModel(
                  mockGetVisitsBySiteIdUseCase,
                  mockGetVisitWithDetailsUseCase,
                  mockGetVisitComplementUseCase,
                  mockSaveVisitComplementUseCase,
                  mockCreateVisitUseCase,
                  mockUpdateVisitUseCase,
                  mockDeleteVisitUseCase,
                  mockGetUserIdUseCase,
                  mockGetUserNameUseCase,
                  siteId,
                )),
      ],
      child: child,
    );
  }

  group('VisitFormPage UI Tests', () {
    testWidgets('VisitFormPage should render in creation mode with site info',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestProviderScope(
          child: MaterialApp(
            navigatorObservers: [mockNavigatorObserver],
            home: VisitFormPage(
              site: testSite,
              visitConfig: testVisitConfig,
              customConfig: testCustomConfig,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify title and site info
      expect(find.text('Visite'), findsOneWidget);
      expect(find.text('Site: Test Site (TS01)'), findsOneWidget);

      // Verify form buttons exist
      expect(find.text('Annuler'), findsOneWidget);
      expect(find.text('Enregistrer'), findsOneWidget);

      // Verify chain input option exists (from the visitConfig)
      expect(find.byType(Switch), findsOneWidget);
    });

    testWidgets('VisitFormPage should show edit mode title and delete button',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestProviderScope(
          child: MaterialApp(
            navigatorObservers: [mockNavigatorObserver],
            home: VisitFormPage(
              site: testSite,
              visitConfig: testVisitConfig,
              customConfig: testCustomConfig,
              visit: testVisit,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify title shows edit mode
      expect(find.text('Modifier la visite'), findsOneWidget);

      // Verify delete button exists in edit mode
      expect(find.byIcon(Icons.delete), findsOneWidget);

      // Verify update button exists
      expect(find.text('Mettre à jour'), findsOneWidget);
    });

    testWidgets('VisitFormPage should switch between actions based on mode',
        (WidgetTester tester) async {
      // Test creation mode button text
      await tester.pumpWidget(
        buildTestProviderScope(
          child: MaterialApp(
            home: VisitFormPage(
              site: testSite,
              visitConfig: testVisitConfig,
              customConfig: testCustomConfig,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Enregistrer'), findsOneWidget);
      expect(find.text('Mettre à jour'), findsNothing);

      // Test edit mode button text
      await tester.pumpWidget(
        buildTestProviderScope(
          child: MaterialApp(
            home: Scaffold(body: Container()), // First clear the widget tree
          ),
        ),
      );
      await tester.pumpAndSettle();
      
      // Now rebuild with the edit mode version
      await tester.pumpWidget(
        buildTestProviderScope(
          child: MaterialApp(
            home: VisitFormPage(
              site: testSite,
              visitConfig: testVisitConfig,
              customConfig: testCustomConfig,
              visit: testVisit,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      
      // Verify the button text is correct for edit mode
      expect(find.widgetWithText(ElevatedButton, 'Mettre à jour'), findsOneWidget);
    });
  });

  group('VisitFormPage Interaction Tests', () {
    testWidgets('Cancel button should close the page',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestProviderScope(
          child: MaterialApp(
            navigatorObservers: [mockNavigatorObserver],
            home: VisitFormPage(
              site: testSite,
              visitConfig: testVisitConfig,
              customConfig: testCustomConfig,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap cancel button
      await tester.tap(find.text('Annuler'));
      await tester.pumpAndSettle();

      // Verify navigation popped
      verify(() => mockNavigatorObserver.didPop(any(), any())).called(1);
    });

    testWidgets(
        'Delete confirmation dialog should appear when delete icon is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestProviderScope(
          child: MaterialApp(
            navigatorObservers: [mockNavigatorObserver],
            home: VisitFormPage(
              site: testSite,
              visitConfig: testVisitConfig,
              customConfig: testCustomConfig,
              visit: testVisit,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap delete button
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();

      // Verify dialog appears
      expect(find.text('Confirmer la suppression'), findsOneWidget);
      expect(find.text('Êtes-vous sûr de vouloir supprimer cette visite ?'),
          findsOneWidget);
      
      // Find buttons within the dialog
      final dialog = find.byType(AlertDialog);
      expect(dialog, findsOneWidget);
      
      // More specific finder for the Cancel button within the dialog context
      expect(find.descendant(
        of: dialog,
        matching: find.text('Annuler'),
      ), findsOneWidget);
      
      expect(find.descendant(
        of: dialog,
        matching: find.text('Supprimer'),
      ), findsOneWidget);
    });
  });

  group('VisitFormPage ViewModel Interaction Tests', () {
    // Note: For these tests, we'll use spy-like behavior to verify calls to the ViewModel

    testWidgets('VisitFormPage should load connected user in creation mode',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestProviderScope(
          child: MaterialApp(
            home: VisitFormPage(
              site: testSite,
              visitConfig: testVisitConfig,
              customConfig: testCustomConfig,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify user data was requested from the ViewModel
      verify(() => mockGetUserIdUseCase.execute()).called(1);
    });

    // Comment out the tests that access private fields
    /* 
    testWidgets('Loading state should show progress indicator',
        (WidgetTester tester) async {
      // Create a key to access the state later
      final visitFormPageKey = GlobalKey<VisitFormPageState>();
      
      await tester.pumpWidget(
        buildTestProviderScope(
          child: MaterialApp(
            home: VisitFormPage(
              key: visitFormPageKey,
              site: testSite,
              visitConfig: testVisitConfig,
              customConfig: testCustomConfig,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      
      // Manually set loading state to true
      visitFormPageKey.currentState?.setState(() {
        visitFormPageKey.currentState?._isLoading = true;
      });
      await tester.pump();
      
      // Verify progress indicator is shown when loading
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      
      // Reset loading state
      visitFormPageKey.currentState?.setState(() {
        visitFormPageKey.currentState?._isLoading = false;
      });
      await tester.pump();
      
      // Verify progress indicator is gone when not loading
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
    */
  });
}
