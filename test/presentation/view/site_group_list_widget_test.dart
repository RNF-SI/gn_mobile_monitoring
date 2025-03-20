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
  late MockSiteGroupsViewModel mockViewModel;

  setUp(() {
    mockViewModel = MockSiteGroupsViewModel();
  });

  testWidgets('SiteGroupListWidget should display loading state correctly',
      (WidgetTester tester) async {
    // Arrange
    final customState = const custom_async_state.State<List<SiteGroup>>.loading();
    final emptyList = <SiteGroup>[];

    final container = ProviderContainer(
      overrides: [
        siteGroupListProvider.overrideWithValue(customState),
        filteredSiteGroupsProvider.overrideWith((_) => emptyList),
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
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('SiteGroupListWidget should display error state correctly',
      (WidgetTester tester) async {
    // Arrange
    final customState = custom_async_state.State<List<SiteGroup>>.error(
      Exception('Failed to load site groups'),
    );
    final emptyList = <SiteGroup>[];

    final container = ProviderContainer(
      overrides: [
        siteGroupListProvider.overrideWithValue(customState),
        filteredSiteGroupsProvider.overrideWith((_) => emptyList),
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
    expect(find.text('Erreur: Exception: Failed to load site groups'), findsOneWidget);
  });

  testWidgets('SiteGroupListWidget should display initialization state correctly',
      (WidgetTester tester) async {
    // Arrange
    final customState = const custom_async_state.State<List<SiteGroup>>.init();
    final emptyList = <SiteGroup>[];

    final container = ProviderContainer(
      overrides: [
        siteGroupListProvider.overrideWithValue(customState),
        filteredSiteGroupsProvider.overrideWith((_) => emptyList),
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
    expect(find.text('Initialisation...'), findsOneWidget);
  });

  testWidgets('SiteGroupListWidget should display site groups correctly when loaded',
      (WidgetTester tester) async {
    // Arrange
    final siteGroups = [
      const SiteGroup(
        idSitesGroup: 1,
        sitesGroupName: 'Groupe de sites 1',
        sitesGroupDescription: 'Description du groupe 1',
        uuidSitesGroup: 'UUID-1',
      ),
      const SiteGroup(
        idSitesGroup: 2,
        sitesGroupName: 'Groupe de sites 2',
        sitesGroupDescription: 'Description du groupe 2',
        uuidSitesGroup: 'UUID-2',
      ),
    ];

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
    expect(find.text('Groupe de sites 1'), findsOneWidget);
    expect(find.text('Description du groupe 1'), findsOneWidget);
    expect(find.text('UUID-1'), findsOneWidget);
    expect(find.text('Groupe de sites 2'), findsOneWidget);
    expect(find.text('Description du groupe 2'), findsOneWidget);
    expect(find.text('UUID-2'), findsOneWidget);
  });

  testWidgets('SiteGroupListWidget should display empty message when no site groups are available',
      (WidgetTester tester) async {
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
    expect(find.text('Aucun groupe de sites disponible.'), findsOneWidget);
  });

  testWidgets('SiteGroupListWidget should trigger refresh when pull-to-refresh is used',
      (WidgetTester tester) async {
    // Arrange
    // Mock the StateNotifierProvider to test the refresh action
    final mockNotifier = MockSiteGroupsViewModel();
    when(() => mockNotifier.refreshSiteGroups()).thenAnswer((_) async {});
    
    final siteGroups = <SiteGroup>[];
    final customState = custom_async_state.State<List<SiteGroup>>.success(siteGroups);

    final container = ProviderContainer(
      overrides: [
        siteGroupListProvider.overrideWithValue(customState),
        siteGroupViewModelStateNotifierProvider.overrideWith((_) => mockNotifier),
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

    // Simulate pull-to-refresh gesture
    await tester.drag(find.byType(ListView), const Offset(0, 300));
    await tester.pump(); // Start animation
    await tester.pump(const Duration(seconds: 1)); // Complete animation

    // Assert
    verify(() => mockNotifier.refreshSiteGroups()).called(1);
  });
}