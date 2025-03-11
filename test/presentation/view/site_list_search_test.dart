import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/presentation/state/state.dart' as custom_async_state;
import 'package:gn_mobile_monitoring/presentation/view/home_page/site_list_widget.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/sites_utilisateur_viewmodel.dart';
import 'package:mocktail/mocktail.dart';

class MockUserSitesViewModel extends Mock implements UserSitesViewModel {}

void main() {
  group('SiteListWidget search functionality', () {
    testWidgets('should have a search field', (WidgetTester tester) async {
      // Arrange
      final sites = <BaseSite>[];
      final customState = custom_async_state.State<List<BaseSite>>.success(sites);

      final container = ProviderContainer(
        overrides: [
          userSitesProvider.overrideWithValue(customState),
        ],
      );

      // Act
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(
              body: SiteListWidget(),
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('should filter sites based on search query', (WidgetTester tester) async {
      // Arrange
      final sites = [
        BaseSite(
          idBaseSite: 1,
          baseSiteName: 'Lac de Montagne',
          baseSiteDescription: 'Un beau lac de montagne',
          baseSiteCode: 'S1',
          metaCreateDate: DateTime.now(),
          metaUpdateDate: DateTime.now(),
        ),
        BaseSite(
          idBaseSite: 2,
          baseSiteName: 'Rivière des Galets',
          baseSiteDescription: 'Une rivière rocheuse',
          baseSiteCode: 'S2',
          metaCreateDate: DateTime.now(),
          metaUpdateDate: DateTime.now(),
        ),
        BaseSite(
          idBaseSite: 3,
          baseSiteName: 'Cascade du Mont',
          baseSiteDescription: 'Cascade en montagne',
          baseSiteCode: 'S3',
          metaCreateDate: DateTime.now(),
          metaUpdateDate: DateTime.now(),
        ),
      ];

      final customState = custom_async_state.State<List<BaseSite>>.success(sites);

      final container = ProviderContainer(
        overrides: [
          userSitesProvider.overrideWithValue(customState),
          filteredSitesProvider.overrideWith((ref) => 
            ref.watch(searchQueryProvider).isEmpty
              ? sites
              : sites.where((site) => 
                  site.baseSiteName!.toLowerCase().contains(
                    ref.watch(searchQueryProvider).toLowerCase()
                  )
                ).toList()
          ),
        ],
      );

      // Act
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(
              body: SiteListWidget(),
            ),
          ),
        ),
      );

      // Initial state shows all sites
      expect(find.text('Lac de Montagne'), findsOneWidget);
      expect(find.text('Rivière des Galets'), findsOneWidget);
      expect(find.text('Cascade du Mont'), findsOneWidget);

      // Enter a search query
      await tester.enterText(find.byType(TextField), 'mont');
      await tester.pump();

      // Only sites with "mont" in their name should be visible
      expect(find.text('Lac de Montagne'), findsOneWidget);
      expect(find.text('Rivière des Galets'), findsNothing);
      expect(find.text('Cascade du Mont'), findsOneWidget);
    });

    testWidgets('should show a "no results" message when search returns no results', 
        (WidgetTester tester) async {
      // Arrange
      final sites = [
        BaseSite(
          idBaseSite: 1,
          baseSiteName: 'Lac de Montagne',
          baseSiteDescription: 'Un beau lac de montagne',
          baseSiteCode: 'S1',
          metaCreateDate: DateTime.now(),
          metaUpdateDate: DateTime.now(),
        ),
        BaseSite(
          idBaseSite: 2,
          baseSiteName: 'Rivière des Galets',
          baseSiteDescription: 'Une rivière rocheuse',
          baseSiteCode: 'S2',
          metaCreateDate: DateTime.now(),
          metaUpdateDate: DateTime.now(),
        ),
      ];

      final customState = custom_async_state.State<List<BaseSite>>.success(sites);

      final container = ProviderContainer(
        overrides: [
          userSitesProvider.overrideWithValue(customState),
          filteredSitesProvider.overrideWith((ref) => 
            ref.watch(searchQueryProvider).isEmpty
              ? sites
              : sites.where((site) => 
                  site.baseSiteName!.toLowerCase().contains(
                    ref.watch(searchQueryProvider).toLowerCase()
                  )
                ).toList()
          ),
        ],
      );

      // Act
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(
              body: SiteListWidget(),
            ),
          ),
        ),
      );

      // Enter a search query that won't match any sites
      await tester.enterText(find.byType(TextField), 'xyz');
      await tester.pump();

      // Should show no results message
      expect(find.text('Aucun résultat trouvé pour "xyz"'), findsOneWidget);
      expect(find.text('Lac de Montagne'), findsNothing);
      expect(find.text('Rivière des Galets'), findsNothing);
    });

    testWidgets('should clear search query when clear button is pressed', 
        (WidgetTester tester) async {
      // Arrange
      final sites = [
        BaseSite(
          idBaseSite: 1,
          baseSiteName: 'Lac de Montagne',
          baseSiteDescription: 'Un beau lac de montagne',
          baseSiteCode: 'S1',
          metaCreateDate: DateTime.now(),
          metaUpdateDate: DateTime.now(),
        ),
        BaseSite(
          idBaseSite: 2,
          baseSiteName: 'Rivière des Galets',
          baseSiteDescription: 'Une rivière rocheuse',
          baseSiteCode: 'S2',
          metaCreateDate: DateTime.now(),
          metaUpdateDate: DateTime.now(),
        ),
      ];

      final customState = custom_async_state.State<List<BaseSite>>.success(sites);

      final container = ProviderContainer(
        overrides: [
          userSitesProvider.overrideWithValue(customState),
          filteredSitesProvider.overrideWith((ref) => 
            ref.watch(searchQueryProvider).isEmpty
              ? sites
              : sites.where((site) => 
                  site.baseSiteName!.toLowerCase().contains(
                    ref.watch(searchQueryProvider).toLowerCase()
                  )
                ).toList()
          ),
        ],
      );

      // Act
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(
              body: SiteListWidget(),
            ),
          ),
        ),
      );

      // Enter a search query
      await tester.enterText(find.byType(TextField), 'mont');
      await tester.pump();

      // Only sites with "mont" in their name should be visible
      expect(find.text('Lac de Montagne'), findsOneWidget);
      expect(find.text('Rivière des Galets'), findsNothing);

      // Clear the search query
      await tester.tap(find.byIcon(Icons.clear));
      await tester.pump();

      // All sites should be visible again
      expect(find.text('Lac de Montagne'), findsOneWidget);
      expect(find.text('Rivière des Galets'), findsOneWidget);
    });
  });
}