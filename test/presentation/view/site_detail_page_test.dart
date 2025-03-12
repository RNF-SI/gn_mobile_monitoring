import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/base_visit.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_visits_by_site_id_use_case.dart';
import 'package:gn_mobile_monitoring/presentation/view/site_detail_page.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/site_visits_viewmodel.dart';

class MockGetVisitsBySiteIdUseCase implements GetVisitsBySiteIdUseCase {
  @override
  Future<List<BaseVisit>> execute(int siteId) async {
    // Return empty list for testing
    return [];
  }
}

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

  testWidgets('SiteDetailPage displays site properties correctly',
      (WidgetTester tester) async {
    final mockUseCase = MockGetVisitsBySiteIdUseCase();
    
    // Pre-create a ViewModel with data already loaded
    final preloadedViewModel = SiteVisitsViewModel(mockUseCase, testSite.idBaseSite);
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
}
