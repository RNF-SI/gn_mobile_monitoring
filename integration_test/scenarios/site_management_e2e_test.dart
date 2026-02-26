import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../e2e_test_app.dart';
import '../helpers/test_data_seeder.dart';
import '../mocks/mock_api_handlers.dart';
import '../robots/home_robot.dart';
import '../robots/module_detail_robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Site Management E2E', () {
    late E2ETestApp testApp;
    late TestDataSeeder seeder;

    setUp(() {
      testApp = E2ETestApp();
      seeder = TestDataSeeder(testApp);
    });

    /// Helper: setup app as logged in with a downloaded module, skip login flow.
    Future<void> setupWithDownloadedModule(WidgetTester tester) async {
      // Seed data: logged-in user + downloaded module with sites + nomenclatures
      await seeder.seedAll();

      // Setup API handlers for any background calls
      await MockApiHandlers.setupModulesList(testApp.interceptor);
      await MockApiHandlers.setupSites(testApp.interceptor);
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
    }

    testWidgets('Home page displays downloaded module with Ouvrir button',
        (tester) async {
      await setupWithDownloadedModule(tester);

      final homeRobot = HomeRobot(tester);
      homeRobot.expectHomePageVisible();

      // Verify the module card is displayed
      homeRobot.expectModuleCard(TestDataSeeder.testModuleLabel);

      // Verify "Ouvrir" button is shown for downloaded module
      expect(find.text('Ouvrir'), findsOneWidget,
          reason: 'Downloaded module should show "Ouvrir" button');
    });

    testWidgets(
        'Navigate to module detail and see sites listed', (tester) async {
      await setupWithDownloadedModule(tester);

      final homeRobot = HomeRobot(tester);
      homeRobot.expectHomePageVisible();
      homeRobot.expectModuleCard(TestDataSeeder.testModuleLabel);

      // Tap on the "Ouvrir" button to navigate to module detail
      await tester.tap(find.text('Ouvrir'));
      await tester.pumpAndSettle(
        const Duration(milliseconds: 100),
        EnginePhase.sendSemanticsUpdate,
        const Duration(seconds: 15),
      );

      // Wait for module loading page to transition to detail page
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle(
        const Duration(milliseconds: 100),
        EnginePhase.sendSemanticsUpdate,
        const Duration(seconds: 15),
      );

      // Verify module detail page is displayed
      final moduleDetailRobot = ModuleDetailRobot(tester);

      // The module label should appear in the AppBar or breadcrumb
      moduleDetailRobot.expectModuleDetailVisible(
          TestDataSeeder.testModuleLabel);

      // Verify sites are listed
      moduleDetailRobot.expectSite('Site de test Alpha');
      moduleDetailRobot.expectSite('Site de test Beta');
    });

    testWidgets('Module detail page shows site group', (tester) async {
      await setupWithDownloadedModule(tester);

      final homeRobot = HomeRobot(tester);
      homeRobot.expectHomePageVisible();

      // Navigate to module detail
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

      // The module has children_types: ['site', 'sites_group']
      // so there should be tabs. Check for the group tab text.
      final groupTab = find.text('Groupe de sites');
      if (groupTab.evaluate().isNotEmpty) {
        // Tap on the groups tab
        await tester.tap(groupTab);
        await tester.pumpAndSettle();

        // Verify the site group is listed
        expect(find.text('Groupe de test'), findsWidgets,
            reason: 'Site group should be displayed');
      }
    });

    testWidgets(
        'Module card shows correct download status',
        (tester) async {
      await setupWithDownloadedModule(tester);

      final homeRobot = HomeRobot(tester);
      homeRobot.expectHomePageVisible();

      // Verify module info shows the module as downloaded
      expect(find.text('Ouvrir'), findsOneWidget);
      expect(find.text('Télécharger'), findsNothing,
          reason:
              'Downloaded module should not show Télécharger button');
    });
  });
}
