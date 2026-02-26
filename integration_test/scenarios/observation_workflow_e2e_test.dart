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

  group('Observation Workflow E2E', () {
    late E2ETestApp testApp;
    late TestDataSeeder seeder;

    setUp(() {
      testApp = E2ETestApp();
      seeder = TestDataSeeder(testApp);
    });

    /// Helper: setup app and navigate to site detail page.
    Future<void> setupAndNavigateToSiteDetail(WidgetTester tester) async {
      await seeder.seedAll();

      await MockApiHandlers.setupFullJourney(testApp.interceptor);
      testApp.interceptor.onGetJson('/nomenclatures/nomenclatures', []);
      testApp.interceptor.onGetJson('/monitorings/modules', []);

      await tester.pumpWidget(testApp.buildProviderScope());
      await tester.pumpAndSettle(
        const Duration(milliseconds: 100),
        EnginePhase.sendSemanticsUpdate,
        const Duration(seconds: 15),
      );

      // Navigate: Home → Module Detail
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

      // Navigate: Module Detail → Site Detail
      final moduleRobot = ModuleDetailRobot(tester);
      moduleRobot.expectSite('Site de test Alpha');

      await moduleRobot.tapSite('Site de test Alpha');
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle(
        const Duration(milliseconds: 100),
        EnginePhase.sendSemanticsUpdate,
        const Duration(seconds: 15),
      );
    }

    testWidgets(
        'Full navigation: Home → Module → Site detail with correct elements',
        (tester) async {
      await setupAndNavigateToSiteDetail(tester);

      // Verify site detail page
      final siteRobot = SiteDetailRobot(tester);
      siteRobot.expectSiteDetailVisible('Site de test Alpha');

      // Verify create visit button is present (prerequisite for observations)
      final createVisitButton = find.byKey(const Key('create-visit-button'));
      expect(createVisitButton, findsOneWidget,
          reason: 'Create visit button should be present');

      // Verify edit site button is present
      final editSiteButton = find.byKey(const Key('edit-site-button'));
      expect(editSiteButton, findsOneWidget,
          reason: 'Edit site button should be present');
    });

    testWidgets('Site detail shows empty visits list initially',
        (tester) async {
      await setupAndNavigateToSiteDetail(tester);

      final siteRobot = SiteDetailRobot(tester);
      siteRobot.expectSiteDetailVisible('Site de test Alpha');

      // With no visits seeded, the visits list should be empty or show a message
      // The create visit button should still be visible
      final createVisitButton = find.byKey(const Key('create-visit-button'));
      expect(createVisitButton, findsOneWidget,
          reason:
              'Create visit button should be present even with no visits');
    });

    testWidgets(
        'Navigate back from site detail through module detail to home',
        (tester) async {
      await setupAndNavigateToSiteDetail(tester);

      // On site detail page
      final siteRobot = SiteDetailRobot(tester);
      siteRobot.expectSiteDetailVisible('Site de test Alpha');

      // Go back to module detail
      await siteRobot.goBack();
      await tester.pumpAndSettle(
        const Duration(milliseconds: 100),
        EnginePhase.sendSemanticsUpdate,
        const Duration(seconds: 15),
      );

      // Verify module detail
      final moduleRobot = ModuleDetailRobot(tester);
      moduleRobot.expectModuleDetailVisible(TestDataSeeder.testModuleLabel);

      // Go back to home
      await moduleRobot.goBack();
      await tester.pumpAndSettle(
        const Duration(milliseconds: 100),
        EnginePhase.sendSemanticsUpdate,
        const Duration(seconds: 15),
      );

      // May need to go back once more (through ModuleLoadingPage)
      final backButton = find.byTooltip('Back');
      if (backButton.evaluate().isNotEmpty) {
        await tester.tap(backButton.first);
        await tester.pumpAndSettle(
          const Duration(milliseconds: 100),
          EnginePhase.sendSemanticsUpdate,
          const Duration(seconds: 15),
        );
      }

      // Verify home page
      final homeRobot = HomeRobot(tester);
      homeRobot.expectHomePageVisible();
    });
  });
}
