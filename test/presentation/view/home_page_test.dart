import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/presentation/state/sync_status.dart';
import 'package:gn_mobile_monitoring/presentation/view/home_page/home_page.dart';
import 'package:gn_mobile_monitoring/presentation/view/home_page/menu_actions.dart';
import 'package:gn_mobile_monitoring/presentation/view/home_page/module_list_widget.dart';
import 'package:gn_mobile_monitoring/presentation/view/home_page/site_group_list_widget.dart';
import 'package:gn_mobile_monitoring/presentation/view/home_page/site_list_widget.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/sync_service.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/sync_status_widget.dart';
import 'package:mocktail/mocktail.dart';

// Mocks
class MockModuleListWidget extends Mock implements ModuleListWidget {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) =>
      super.toString();
}

class MockSiteGroupListWidget extends Mock implements SiteGroupListWidget {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) =>
      super.toString();
}

class MockSiteListWidget extends Mock implements SiteListWidget {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) =>
      super.toString();
}

class MockMenuActions extends Mock implements MenuActions {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) =>
      super.toString();
}

class MockSyncStatusWidget extends Mock implements SyncStatusWidget {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) =>
      super.toString();
}

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer(
      overrides: [
        syncStatusProvider.overrideWith((ref) => SyncStatus.initial),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  Future<void> pumpHomePage(WidgetTester tester,
      [SyncStatus? syncStatus]) async {
    if (syncStatus != null) {
      container = ProviderContainer(
        overrides: [
          syncStatusProvider.overrideWithProvider(
            StateProvider<SyncStatus>((ref) => syncStatus),
          ),
        ],
      );
    }

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: HomePage(),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('HomePage should display TabController with 3 tabs',
      (WidgetTester tester) async {
    await pumpHomePage(tester);

    expect(find.text('Mes Données'), findsOneWidget);
    expect(find.text('Modules'), findsOneWidget);
    expect(find.text('Groupes de Sites'), findsOneWidget);
    expect(find.text('Sites'), findsOneWidget);

    expect(find.byType(Tab), findsNWidgets(3));
    expect(find.byType(TabBar), findsOneWidget);
    expect(find.byType(TabBarView), findsOneWidget);
  });

  testWidgets('HomePage should display ModuleListWidget on first tab',
      (WidgetTester tester) async {
    await pumpHomePage(tester);

    // Le premier onglet (Modules) devrait être actif par défaut
    expect(find.byType(ModuleListWidget), findsOneWidget);
    expect(find.byType(SiteGroupListWidget), findsNothing);
    expect(find.byType(SiteListWidget), findsNothing);
  });

  testWidgets('HomePage should display SiteGroupListWidget on second tab',
      (WidgetTester tester) async {
    await pumpHomePage(tester);

    // Tap sur le deuxième onglet (Groupes de Sites)
    await tester.tap(find.text('Groupes de Sites'));
    await tester.pump();
    await tester
        .pump(const Duration(milliseconds: 300)); // Attendre l'animation

    expect(find.byType(ModuleListWidget), findsNothing);
    expect(find.byType(SiteGroupListWidget), findsOneWidget);
    expect(find.byType(SiteListWidget), findsNothing);
  });

  testWidgets('HomePage should display SiteListWidget on third tab',
      (WidgetTester tester) async {
    await pumpHomePage(tester);

    // Tap sur le troisième onglet (Sites)
    await tester.tap(find.text('Sites'));
    await tester.pump();
    await tester
        .pump(const Duration(milliseconds: 300)); // Attendre l'animation

    expect(find.byType(ModuleListWidget), findsNothing);
    expect(find.byType(SiteGroupListWidget), findsNothing);
    expect(find.byType(SiteListWidget), findsOneWidget);
  });

  testWidgets('HomePage should display SyncStatusWidget',
      (WidgetTester tester) async {
    await pumpHomePage(tester);
    expect(find.byType(SyncStatusWidget), findsOneWidget);
  });

  testWidgets('HomePage should display MenuActions in AppBar',
      (WidgetTester tester) async {
    await pumpHomePage(tester);
    expect(find.byType(MenuActions), findsOneWidget);
  });

  testWidgets('HomePage should show modal barrier when syncing',
      (WidgetTester tester) async {
    final syncingStatus = SyncStatus.syncingModules.copyWith(
      progress: 50,
      message: 'Synchronisation en cours',
    );

    await pumpHomePage(tester, syncingStatus);
    await tester.pump(); // Pour s'assurer que le modal est affiché

    // We expect to find our ModalBarrier with the specific key
    expect(find.byKey(const Key('sync-modal-barrier')), findsOneWidget);
    expect(find.text('Synchronisation en cours'), findsOneWidget);
  });

  testWidgets('HomePage should not allow tab changes when syncing',
      (WidgetTester tester) async {
    final syncingStatus = SyncStatus.syncingModules.copyWith(
      progress: 50,
      message: 'Synchronisation en cours',
    );

    await pumpHomePage(tester, syncingStatus);

    // Find the Tab widget instead of just the text
    final tabFinder = find.ancestor(
      of: find.text('Groupes de Sites'),
      matching: find.byType(Tab),
    );

    // Try to tap on the tab
    if (tabFinder.evaluate().isNotEmpty) {
      await tester.tap(tabFinder, warnIfMissed: false);
      await tester.pump();
    }

    // Verify we're still on the first tab
    expect(find.byType(ModuleListWidget), findsOneWidget);
    expect(find.byType(SiteGroupListWidget), findsNothing);
  });

  testWidgets('HomePage should show modal barrier when deleting database',
      (WidgetTester tester) async {
    final deletingStatus = SyncStatus.deletingDatabase.copyWith(
      message: 'Suppression et rechargement de la base de données...',
    );

    await pumpHomePage(tester, deletingStatus);
    await tester.pump();

    expect(find.byKey(const Key('sync-modal-barrier')), findsOneWidget);
    expect(find.text('Suppression et rechargement de la base de données...'),
        findsOneWidget);
  });

  testWidgets('HomePage should show error state when sync fails',
      (WidgetTester tester) async {
    final errorStatus = SyncStatus.error('Erreur de synchronisation');

    // Debug information
    print(
        'Error Status - isInProgress: ${errorStatus.isInProgress}, step: ${errorStatus.step}');

    // Verify that isInProgress is false and step is error
    expect(errorStatus.isInProgress, false);
    expect(errorStatus.step, SyncStep.error);

    await pumpHomePage(tester, errorStatus);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Get the current sync status from the provider
    final container = ProviderScope.containerOf(
      tester.element(find.byType(HomePage)),
    );
    final currentStatus = container.read(syncStatusProvider);
    print(
        'Current Status - isInProgress: ${currentStatus.isInProgress}, step: ${currentStatus.step}');

    // Debug the widget tree
    print('\nWidget Tree:');
    print(tester.allWidgets
        .where((w) => w is Stack || w is ModalBarrier)
        .map((w) => '${w.runtimeType}')
        .join('\n'));

    // Verify that the error message is shown in the SyncStatusWidget
    expect(
        find.byWidgetPredicate((widget) =>
            widget is Text &&
            widget.data == 'Erreur de synchronisation' &&
            widget.style?.color == const Color(0xffd32f2f)),
        findsOneWidget);

    // Verify that our sync modal barrier is not shown in error state
    expect(find.byKey(const Key('sync-modal-barrier')), findsNothing);
  });

  testWidgets('HomePage should show complete state after successful sync',
      (WidgetTester tester) async {
    final completeStatus = SyncStatus.complete;

    // Debug information
    print(
        'Complete Status - isInProgress: ${completeStatus.isInProgress}, step: ${completeStatus.step}');

    // Verify that isInProgress is false and step is complete
    expect(completeStatus.isInProgress, false);
    expect(completeStatus.step, SyncStep.complete);

    await pumpHomePage(tester, completeStatus);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Get the current sync status from the provider
    final container = ProviderScope.containerOf(
      tester.element(find.byType(HomePage)),
    );
    final currentStatus = container.read(syncStatusProvider);
    print(
        'Current Status - isInProgress: ${currentStatus.isInProgress}, step: ${currentStatus.step}');

    // Debug the widget tree
    print('\nWidget Tree:');
    print(tester.allWidgets
        .where((w) => w is Stack || w is ModalBarrier)
        .map((w) => '${w.runtimeType}')
        .join('\n'));

    // Verify that the complete message is shown
    expect(find.text('Synchronisation terminée'), findsOneWidget);

    // Verify that our sync modal barrier is not shown in complete state
    expect(find.byKey(const Key('sync-modal-barrier')), findsNothing);
  });
}
