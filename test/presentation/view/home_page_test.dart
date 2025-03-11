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
  testWidgets('HomePage should display TabController with 3 tabs',
      (WidgetTester tester) async {
    // Arrange
    final container = ProviderContainer(
      overrides: [
        syncStatusProvider.overrideWith(
          (ref) => SyncStatus.initial,
        )
      ],
    );

    // Act
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: HomePage(),
        ),
      ),
    );

    // Assert
    expect(find.text('Mes Données'), findsOneWidget);
    expect(find.text('Modules'), findsOneWidget);
    expect(find.text('Groupes de Sites'), findsOneWidget);
    expect(find.text('Sites'), findsOneWidget);

    // Vérifier que les tabs sont correctement configurés
    expect(find.byType(Tab), findsNWidgets(3));
    expect(find.byType(TabBar), findsOneWidget);
    expect(find.byType(TabBarView), findsOneWidget);
  });

  testWidgets('HomePage should display ModuleListWidget on first tab',
      (WidgetTester tester) async {
    // Arrange
    final container = ProviderContainer(
      overrides: [
        syncStatusProvider.overrideWith(
          (ref) => SyncStatus.initial,
        )
      ],
    );

    // Act
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: HomePage(),
        ),
      ),
    );

    // Assert - Le premier onglet (Modules) devrait être actif par défaut
    expect(find.byType(ModuleListWidget), findsOneWidget);
    expect(find.byType(SiteGroupListWidget), findsNothing);
    expect(find.byType(SiteListWidget), findsNothing);
  });

  testWidgets('HomePage should display SiteGroupListWidget on second tab',
      (WidgetTester tester) async {
    // Arrange
    final container = ProviderContainer(
      overrides: [
        syncStatusProvider.overrideWith(
          (ref) => SyncStatus.initial,
        )
      ],
    );

    // Act
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: HomePage(),
        ),
      ),
    );

    // Tap sur le deuxième onglet (Groupes de Sites)
    await tester.tap(find.text('Groupes de Sites'));
    await tester.pumpAndSettle();

    // Assert
    expect(find.byType(ModuleListWidget), findsNothing);
    expect(find.byType(SiteGroupListWidget), findsOneWidget);
    expect(find.byType(SiteListWidget), findsNothing);
  });

  testWidgets('HomePage should display SiteListWidget on third tab',
      (WidgetTester tester) async {
    // Arrange
    final container = ProviderContainer(
      overrides: [
        syncStatusProvider.overrideWith(
          (ref) => SyncStatus.initial,
        )
      ],
    );

    // Act
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: HomePage(),
        ),
      ),
    );

    // Tap sur le troisième onglet (Sites)
    await tester.tap(find.text('Sites'));
    await tester.pumpAndSettle();

    // Assert
    expect(find.byType(ModuleListWidget), findsNothing);
    expect(find.byType(SiteGroupListWidget), findsNothing);
    expect(find.byType(SiteListWidget), findsOneWidget);
  });

  testWidgets('HomePage should display SyncStatusWidget',
      (WidgetTester tester) async {
    // Arrange
    final container = ProviderContainer(
      overrides: [
        syncStatusProvider.overrideWith(
          (ref) => SyncStatus.initial,
        )
      ],
    );

    // Act
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: HomePage(),
        ),
      ),
    );

    // Assert
    expect(find.byType(SyncStatusWidget), findsOneWidget);
  });

  testWidgets('HomePage should display MenuActions in AppBar',
      (WidgetTester tester) async {
    // Arrange
    final container = ProviderContainer(
      overrides: [
        syncStatusProvider.overrideWith(
          (ref) => SyncStatus.initial,
        )
      ],
    );

    // Act
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: HomePage(),
        ),
      ),
    );

    // Assert
    expect(find.byType(MenuActions), findsOneWidget);
  });

  testWidgets('HomePage should show modal barrier when syncing',
      (WidgetTester tester) async {
    // Arrange
    final container = ProviderContainer(
      overrides: [
        syncStatusProvider.overrideWith(
          (ref) => SyncStatus.syncingModules
              .copyWith(progress: 50, message: 'Synchronisation en cours'),
        )
      ],
    );

    // Act
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: HomePage(),
        ),
      ),
    );

    // Assert
    expect(find.byType(ModalBarrier), findsOneWidget);
  });

  testWidgets('HomePage should not allow tab changes when syncing',
      (WidgetTester tester) async {
    // Arrange
    final container = ProviderContainer(
      overrides: [
        syncStatusProvider.overrideWith(
          (ref) => SyncStatus.syncingModules
              .copyWith(progress: 50, message: 'Synchronisation en cours'),
        )
      ],
    );

    // Act
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: HomePage(),
        ),
      ),
    );

    // Nombre initial de ModuleListWidget
    final initialWidgetCount =
        tester.widgetList(find.byType(ModuleListWidget)).length;

    // Tap sur le deuxième onglet (Groupes de Sites) pendant la synchronisation
    await tester.tap(find.text('Groupes de Sites'));
    await tester.pumpAndSettle();

    // Assert - Le widget ne devrait pas changer car les tabs sont désactivés
    expect(tester.widgetList(find.byType(ModuleListWidget)).length,
        equals(initialWidgetCount));
    expect(find.byType(SiteGroupListWidget), findsNothing);
  });
}
