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
  late MockUserSitesViewModel mockViewModel;

  setUp(() {
    mockViewModel = MockUserSitesViewModel();
  });

  testWidgets('SiteListWidget should display loading state correctly',
      (WidgetTester tester) async {
    // Arrange
    final customState = const custom_async_state.State<List<BaseSite>>.loading();

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
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('SiteListWidget should display error state correctly',
      (WidgetTester tester) async {
    // Arrange
    final customState = custom_async_state.State<List<BaseSite>>.error(
      Exception('Failed to load sites'),
    );

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
    expect(find.text('Erreur: Exception: Failed to load sites'), findsOneWidget);
  });

  testWidgets('SiteListWidget should display initialization state correctly',
      (WidgetTester tester) async {
    // Arrange
    final customState = const custom_async_state.State<List<BaseSite>>.init();

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
    expect(find.text('Initialisation...'), findsOneWidget);
  });

  testWidgets('SiteListWidget should display sites correctly when loaded',
      (WidgetTester tester) async {
    // Arrange
    final sites = [
      BaseSite(
        idBaseSite: 1,
        baseSiteName: 'Site 1',
        baseSiteDescription: 'Description du site 1',
        baseSiteCode: 'S1',
        metaCreateDate: DateTime.now(),
        metaUpdateDate: DateTime.now(),
      ),
      BaseSite(
        idBaseSite: 2,
        baseSiteName: 'Site 2',
        baseSiteDescription: 'Description du site 2',
        baseSiteCode: 'S2',
        metaCreateDate: DateTime.now(),
        metaUpdateDate: DateTime.now(),
      ),
    ];

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
    expect(find.text('Site 1'), findsOneWidget);
    expect(find.text('Description du site 1'), findsOneWidget);
    expect(find.text('Site 2'), findsOneWidget);
    expect(find.text('Description du site 2'), findsOneWidget);
  });

  testWidgets('SiteListWidget should display empty message when no sites are available',
      (WidgetTester tester) async {
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
    expect(find.text('Aucun site disponible.'), findsOneWidget);
  });

  testWidgets('SiteListWidget should trigger refresh when pull-to-refresh is used',
      (WidgetTester tester) async {
    // Arrange
    // Mock the StateNotifierProvider to test the refresh action
    final mockNotifier = MockUserSitesViewModel();
    when(() => mockNotifier.loadSites()).thenAnswer((_) async {});
    
    final sites = <BaseSite>[];
    final customState = custom_async_state.State<List<BaseSite>>.success(sites);

    final container = ProviderContainer(
      overrides: [
        userSitesProvider.overrideWithValue(customState),
        userSitesViewModelStateNotifierProvider.overrideWith((_) => mockNotifier),
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

    // Simulate pull-to-refresh gesture
    await tester.drag(find.byType(ListView), const Offset(0, 300));
    await tester.pump(); // Start animation
    await tester.pump(const Duration(seconds: 1)); // Complete animation

    // Assert
    verify(() => mockNotifier.loadSites()).called(1);
  });
}