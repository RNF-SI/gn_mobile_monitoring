import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/module.dart';
import 'package:gn_mobile_monitoring/domain/model/module_complement.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/presentation/model/module_info.dart';
import 'package:gn_mobile_monitoring/presentation/state/module_download_status.dart';
import 'package:gn_mobile_monitoring/presentation/view/module_detail_page.dart';
import 'package:gn_mobile_monitoring/presentation/view/site_detail_page.dart';

void main() {
  late ModuleInfo mockModuleInfo;
  late MockNavigatorObserver mockNavigatorObserver;

  setUp(() {
    mockNavigatorObserver = MockNavigatorObserver();
    mockModuleInfo = ModuleInfo(
      downloadStatus: ModuleDownloadStatus.moduleDownloaded,
      module: Module(
        id: 1,
        moduleLabel: 'Test Module',
        moduleDesc: 'Test Description',
        sites: List.generate(
          100,
          (index) => BaseSite(
            idBaseSite: index,
            baseSiteName: 'Site $index',
            baseSiteCode: 'CODE$index',
            altitudeMin: 100,
            altitudeMax: 200,
            baseSiteDescription: 'Description du site $index',
          ),
        ),
        complement: ModuleComplement(
          idModule: 1,
          configuration: ModuleConfiguration(
            module: ModuleConfig(
              childrenTypes: ['site'],
            ),
            site: ObjectConfig(
              labelList: 'Sites',
              generic: {
                'base_site_name': GenericFieldConfig(
                  attributLabel: 'Nom du site',
                ),
              },
            ),
          ),
        ),
      ),
    );
  });

  testWidgets('ModuleDetailPage shows module properties and tabs',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        navigatorObservers: [mockNavigatorObserver],
        home: ModuleDetailPage(moduleInfo: mockModuleInfo),
      ),
    );

    // Wait for initial loading
    await tester.pumpAndSettle();

    // Verify module properties
    expect(find.text('Test Module'), findsOneWidget);
    expect(find.text('Test Description'), findsOneWidget);
    expect(find.text('Jeu de données'), findsOneWidget);

    // Verify tabs with counts
    expect(find.text('Secteurs (0)'), findsOneWidget);
    expect(find.text('Dalles (100)'), findsOneWidget);

    // Verify initial sites list
    expect(find.text('Site 0'), findsOneWidget);
    expect(find.text('Description du site 0'), findsOneWidget);
  });

  testWidgets('ModuleDetailPage shows sites list with navigation',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        navigatorObservers: [mockNavigatorObserver],
        home: ModuleDetailPage(moduleInfo: mockModuleInfo),
      ),
    );

    // Wait for initial loading
    await tester.pumpAndSettle();

    // Verify that sites are displayed in cards
    expect(find.byType(Card), findsNWidgets(20)); // First page of sites

    // Verify site content
    expect(find.text('Site 0'), findsOneWidget);
    expect(find.text('Description du site 0'), findsOneWidget);

    // Verify visibility icons
    expect(find.byIcon(Icons.visibility), findsNWidgets(20));

    // Tap on the visibility icon of the first site
    await tester.tap(find.byIcon(Icons.visibility).first);
    await tester.pumpAndSettle();

    // Verify navigation to SiteDetailPage
    verify(() => mockNavigatorObserver.didPush(any(), any())).called(1);
  });

  testWidgets('ModuleDetailPage shows properties card with correct information',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ModuleDetailPage(moduleInfo: mockModuleInfo),
      ),
    );

    // Wait for initial loading
    await tester.pumpAndSettle();

    // Verify that the properties card shows the correct information
    expect(find.text('Test Module'), findsOneWidget);
    expect(find.text('Test Description'), findsOneWidget);
    expect(find.text('Jeu de données'), findsOneWidget);
  });

  testWidgets('ModuleDetailPage loads more sites on scroll',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 600));

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ModuleDetailPage(moduleInfo: mockModuleInfo),
        ),
      ),
    );

    // Wait for initial loading
    await tester.pumpAndSettle();

    // Verify initial content
    expect(find.text('Site 0'), findsOneWidget);
    expect(find.text('Site 19'), findsOneWidget);
    expect(find.text('Site 20'), findsNothing);

    // Find the scrollable
    final scrollable = find.byType(ListView);
    final scrollableWidget = tester.widget<ListView>(scrollable);
    final controller = scrollableWidget.controller;

    // Simulate scroll to near the bottom
    if (controller != null) {
      controller.jumpTo(controller.position.maxScrollExtent - 100);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      // Verify that we can now see more sites
      expect(find.text('Site 20'), findsOneWidget);
      expect(find.text('Site 21'), findsOneWidget);
    } else {
      fail('ScrollController not found');
    }
  });
}

class MockNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    // Verify that we're navigating to SiteDetailPage
    expect(route, isA<MaterialPageRoute>());
    final materialRoute = route as MaterialPageRoute;
    expect(materialRoute.builder, isA<Function>());
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {}

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {}

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {}

  @override
  void didStartUserGesture(
      Route<dynamic> route, Route<dynamic>? previousRoute) {}

  @override
  void didStopUserGesture() {}
}
