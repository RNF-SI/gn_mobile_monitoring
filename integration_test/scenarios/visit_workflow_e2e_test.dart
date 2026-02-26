import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../e2e_test_app.dart';
import '../helpers/test_data_seeder.dart';
import '../mocks/mock_api_handlers.dart';
import '../robots/home_robot.dart';
import '../robots/module_detail_robot.dart';
import '../robots/site_detail_robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Visit Workflow E2E', () {
    late E2ETestApp testApp;
    late TestDataSeeder seeder;

    setUp(() {
      testApp = E2ETestApp();
      seeder = TestDataSeeder(testApp);
    });

    /// Helper: setup app with downloaded module and navigate to module detail.
    Future<void> setupAndNavigateToModuleDetail(WidgetTester tester) async {
      await seeder.seedAll();

      await MockApiHandlers.setupModulesList(testApp.interceptor);
      await MockApiHandlers.setupSites(testApp.interceptor);
      await MockApiHandlers.setupVisits(testApp.interceptor);
      await MockApiHandlers.setupNomenclatures(testApp.interceptor);
      await MockApiHandlers.setupDatasets(testApp.interceptor);
      testApp.interceptor.onGetJson('/nomenclatures/nomenclatures', []);
      testApp.interceptor.onGetJson('/monitorings/modules', []);

      await tester.pumpWidget(testApp.buildProviderScope());
      await tester.pumpAndSettle(
        const Duration(milliseconds: 100),
        EnginePhase.sendSemanticsUpdate,
        const Duration(seconds: 15),
      );

      // Navigate to module detail
      final homeRobot = HomeRobot(tester);
      homeRobot.expectHomePageVisible();

      await tester.tap(find.text('Ouvrir'));
      await tester.pumpAndSettle(
        const Duration(milliseconds: 100),
        EnginePhase.sendSemanticsUpdate,
        const Duration(seconds: 15),
      );
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle(
        const Duration(milliseconds: 100),
        EnginePhase.sendSemanticsUpdate,
        const Duration(seconds: 15),
      );
    }

    testWidgets('Navigate from home to module detail showing sites',
        (tester) async {
      await setupAndNavigateToModuleDetail(tester);

      // Verify module detail page with sites
      final moduleRobot = ModuleDetailRobot(tester);
      moduleRobot.expectModuleDetailVisible(TestDataSeeder.testModuleLabel);
      moduleRobot.expectSite('Site de test Alpha');
    });

    testWidgets('Navigate from module detail to site detail', (tester) async {
      await setupAndNavigateToModuleDetail(tester);

      // Verify sites are listed
      final moduleRobot = ModuleDetailRobot(tester);
      moduleRobot.expectSite('Site de test Alpha');

      // Tap on the first site
      await moduleRobot.tapSite('Site de test Alpha');

      // Wait for site detail page to load
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle(
        const Duration(milliseconds: 100),
        EnginePhase.sendSemanticsUpdate,
        const Duration(seconds: 15),
      );

      // Verify site detail page is displayed
      final siteRobot = SiteDetailRobot(tester);
      siteRobot.expectSiteDetailVisible('Site de test Alpha');
    });

    testWidgets('Site detail page shows create visit button', (tester) async {
      await setupAndNavigateToModuleDetail(tester);

      final moduleRobot = ModuleDetailRobot(tester);
      moduleRobot.expectSite('Site de test Alpha');

      // Navigate to site detail
      await moduleRobot.tapSite('Site de test Alpha');
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle(
        const Duration(milliseconds: 100),
        EnginePhase.sendSemanticsUpdate,
        const Duration(seconds: 15),
      );

      // Verify create visit button is present
      final createVisitButton = find.byKey(const Key('create-visit-button'));
      expect(createVisitButton, findsOneWidget,
          reason: 'Create visit button should be present on site detail page');
    });

    testWidgets('Back navigation from site detail returns to module detail',
        (tester) async {
      await setupAndNavigateToModuleDetail(tester);

      final moduleRobot = ModuleDetailRobot(tester);
      moduleRobot.expectSite('Site de test Alpha');

      // Navigate to site detail
      await moduleRobot.tapSite('Site de test Alpha');
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle(
        const Duration(milliseconds: 100),
        EnginePhase.sendSemanticsUpdate,
        const Duration(seconds: 15),
      );

      // Navigate back
      final siteRobot = SiteDetailRobot(tester);
      await siteRobot.goBack();

      await tester.pumpAndSettle(
        const Duration(milliseconds: 100),
        EnginePhase.sendSemanticsUpdate,
        const Duration(seconds: 15),
      );

      // Verify we're back on module detail
      moduleRobot.expectModuleDetailVisible(TestDataSeeder.testModuleLabel);
    });
  });
}
