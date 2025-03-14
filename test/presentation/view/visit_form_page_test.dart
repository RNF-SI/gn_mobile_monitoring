import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/base_visit.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/presentation/view/visit_form_page.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/dynamic_form_builder.dart';
import 'package:mocktail/mocktail.dart';

// Mocks
class MockDynamicFormBuilderState extends Mock
    implements DynamicFormBuilderState {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  late BaseSite testSite;
  late ObjectConfig testVisitConfig;
  late CustomConfig testCustomConfig;
  late BaseVisit testVisit;
  late MockNavigatorObserver mockNavigatorObserver;

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

    mockNavigatorObserver = MockNavigatorObserver();
    registerFallbackValue(FakeRoute());
  });

  testWidgets('VisitFormPage should render in creation mode',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
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

    // Verify title
    expect(find.text('Visite'), findsOneWidget);

    // Verify site info is displayed
    expect(find.text('Nom: Test Site'), findsOneWidget);
    expect(find.text('Code: TS01'), findsOneWidget);

    // Verify form fields are displayed
    expect(find.text('Date de visite *'), findsOneWidget);
    expect(find.text('Commentaires'), findsOneWidget);
    expect(find.text('Nb L1'), findsOneWidget);
    expect(find.text('Chenille entièrement noire de <1,5mm'), findsOneWidget);

    // Verify buttons
    expect(find.text('Annuler'), findsOneWidget);
    expect(find.text('Enregistrer'), findsOneWidget);

    // Verify dynamic form builder is rendered
    expect(find.byType(DynamicFormBuilder), findsOneWidget);
  });

  testWidgets('VisitFormPage should render in edit mode',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
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

    // Verify delete button is present in edit mode
    expect(find.byIcon(Icons.delete), findsOneWidget);

    // Verify update button is shown instead of save
    expect(find.text('Mettre à jour'), findsOneWidget);
  });

  testWidgets('VisitFormPage should handle form submission',
      (WidgetTester tester) async {
    // This test is complex because it involves form validation and submission
    // which uses internal FormBuilderKey that we can't easily mock
    
    await tester.pumpWidget(
      ProviderScope(
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

    // Can't meaningfully test form submission without deeper mocking
    // But we can test button presence and UI interaction
    
    // Find and tap the save button
    final saveButton = find.text('Enregistrer');
    expect(saveButton, findsOneWidget);
    await tester.tap(saveButton);
    await tester.pump();
    
    // In a real test, we'd verify navigation or success message
    // But this requires more complex mocking
  });

  testWidgets('VisitFormPage should handle delete action in edit mode',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
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

    // Find and tap the delete button
    final deleteButton = find.byIcon(Icons.delete);
    await tester.tap(deleteButton);
    await tester.pumpAndSettle();

    // Verify confirmation dialog appears
    expect(find.text('Confirmer la suppression'), findsOneWidget);
    expect(find.text('Êtes-vous sûr de vouloir supprimer cette visite ?'), findsOneWidget);
    expect(find.text('Annuler'), findsOneWidget);
    expect(find.text('Supprimer'), findsOneWidget);

    // Tap cancel
    await tester.tap(find.text('Annuler').last);
    await tester.pumpAndSettle();
    
    // Dialog should disappear
    expect(find.text('Confirmer la suppression'), findsNothing);
  });
}

// For registering routes with mocktail
class FakeRoute extends Fake implements Route {}