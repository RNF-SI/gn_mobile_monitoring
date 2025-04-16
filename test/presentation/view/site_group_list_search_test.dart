import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';
import 'package:gn_mobile_monitoring/presentation/state/state.dart' as custom_async_state;
import 'package:gn_mobile_monitoring/presentation/view/home_page/site_group_list_widget.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/site_groups_utilisateur_viewmodel.dart';
import 'package:mocktail/mocktail.dart';

class MockSiteGroupsViewModel extends Mock implements SiteGroupsViewModel {}

void main() {
  group('SiteGroupListWidget search functionality', () {
    testWidgets('should have a search field', (WidgetTester tester) async {
      // Arrange
      final siteGroups = <SiteGroup>[];
      final customState = custom_async_state.State<List<SiteGroup>>.success(siteGroups);

      final container = ProviderContainer(
        overrides: [
          siteGroupListProvider.overrideWithValue(customState),
          filteredSiteGroupsProvider.overrideWith((_) => siteGroups),
        ],
      );

      // Act
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(
              body: SiteGroupListWidget(),
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('should filter site groups based on search query', (WidgetTester tester) async {
      // Arrange
      final siteGroups = [
        SiteGroup(
          idSitesGroup: 1,
          sitesGroupName: 'Groupe de Montagne',
          sitesGroupDescription: 'Sites en montagne',
          uuidSitesGroup: 'SG1',
        ),
        SiteGroup(
          idSitesGroup: 2,
          sitesGroupName: 'Groupe de Rivières',
          sitesGroupDescription: 'Sites de rivières',
          uuidSitesGroup: 'SG2',
        ),
        SiteGroup(
          idSitesGroup: 3,
          sitesGroupName: 'Groupe des Cascades',
          sitesGroupDescription: 'Sites de cascades en montagne',
          uuidSitesGroup: 'SG3',
        ),
      ];

      final customState = custom_async_state.State<List<SiteGroup>>.success(siteGroups);

      final container = ProviderContainer(
        overrides: [
          siteGroupListProvider.overrideWithValue(customState),
          filteredSiteGroupsProvider.overrideWith((ref) => 
            ref.watch(siteGroupSearchQueryProvider).isEmpty
              ? siteGroups
              : siteGroups.where((group) => 
                  group.sitesGroupName!.toLowerCase().contains(
                    ref.watch(siteGroupSearchQueryProvider).toLowerCase()
                  ) ||
                  (group.sitesGroupDescription != null && 
                   group.sitesGroupDescription!.toLowerCase().contains(
                    ref.watch(siteGroupSearchQueryProvider).toLowerCase()
                  ))
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
              body: SiteGroupListWidget(),
            ),
          ),
        ),
      );

      // Initial state shows all site groups
      expect(find.text('Groupe de Montagne'), findsOneWidget);
      expect(find.text('Groupe de Rivières'), findsOneWidget);
      expect(find.text('Groupe des Cascades'), findsOneWidget);

      // Enter a search query
      await tester.enterText(find.byType(TextField), 'mont');
      await tester.pump();

      // Only site groups with "mont" in their name or description should be visible
      expect(find.text('Groupe de Montagne'), findsOneWidget);
      expect(find.text('Groupe de Rivières'), findsNothing);
      expect(find.text('Groupe des Cascades'), findsOneWidget); // Contains "montagne" in description
    });

    testWidgets('should show a "no results" message when search returns no results', 
        (WidgetTester tester) async {
      // Arrange
      final siteGroups = [
        SiteGroup(
          idSitesGroup: 1,
          sitesGroupName: 'Groupe de Montagne',
          sitesGroupDescription: 'Sites en montagne',
          uuidSitesGroup: 'SG1',
        ),
        SiteGroup(
          idSitesGroup: 2,
          sitesGroupName: 'Groupe de Rivières',
          sitesGroupDescription: 'Sites de rivières',
          uuidSitesGroup: 'SG2',
        ),
      ];

      final customState = custom_async_state.State<List<SiteGroup>>.success(siteGroups);

      final container = ProviderContainer(
        overrides: [
          siteGroupListProvider.overrideWithValue(customState),
          filteredSiteGroupsProvider.overrideWith((ref) => 
            ref.watch(siteGroupSearchQueryProvider).isEmpty
              ? siteGroups
              : siteGroups.where((group) => 
                  group.sitesGroupName!.toLowerCase().contains(
                    ref.watch(siteGroupSearchQueryProvider).toLowerCase()
                  ) ||
                  (group.sitesGroupDescription != null && 
                   group.sitesGroupDescription!.toLowerCase().contains(
                    ref.watch(siteGroupSearchQueryProvider).toLowerCase()
                  ))
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
              body: SiteGroupListWidget(),
            ),
          ),
        ),
      );

      // Enter a search query that won't match any site groups
      await tester.enterText(find.byType(TextField), 'xyz');
      await tester.pump();

      // Should show no results message
      expect(find.text('Aucun résultat trouvé pour "xyz"'), findsOneWidget);
      expect(find.text('Groupe de Montagne'), findsNothing);
      expect(find.text('Groupe de Rivières'), findsNothing);
    });

    testWidgets('should clear search query when clear button is pressed', 
        (WidgetTester tester) async {
      // Arrange
      final siteGroups = [
        SiteGroup(
          idSitesGroup: 1,
          sitesGroupName: 'Groupe de Montagne',
          sitesGroupDescription: 'Sites en montagne',
          uuidSitesGroup: 'SG1',
        ),
        SiteGroup(
          idSitesGroup: 2,
          sitesGroupName: 'Groupe de Rivières',
          sitesGroupDescription: 'Sites de rivières',
          uuidSitesGroup: 'SG2',
        ),
      ];

      final customState = custom_async_state.State<List<SiteGroup>>.success(siteGroups);

      final container = ProviderContainer(
        overrides: [
          siteGroupListProvider.overrideWithValue(customState),
          filteredSiteGroupsProvider.overrideWith((ref) => 
            ref.watch(siteGroupSearchQueryProvider).isEmpty
              ? siteGroups
              : siteGroups.where((group) => 
                  group.sitesGroupName!.toLowerCase().contains(
                    ref.watch(siteGroupSearchQueryProvider).toLowerCase()
                  ) ||
                  (group.sitesGroupDescription != null && 
                   group.sitesGroupDescription!.toLowerCase().contains(
                    ref.watch(siteGroupSearchQueryProvider).toLowerCase()
                  ))
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
              body: SiteGroupListWidget(),
            ),
          ),
        ),
      );

      // Enter a search query
      await tester.enterText(find.byType(TextField), 'mont');
      await tester.pump();

      // Only site groups with "mont" in their name should be visible
      expect(find.text('Groupe de Montagne'), findsOneWidget);
      expect(find.text('Groupe de Rivières'), findsNothing);

      // Clear the search query
      await tester.tap(find.byIcon(Icons.clear));
      await tester.pump();

      // All site groups should be visible again
      expect(find.text('Groupe de Montagne'), findsOneWidget);
      expect(find.text('Groupe de Rivières'), findsOneWidget);
    });
  });
}