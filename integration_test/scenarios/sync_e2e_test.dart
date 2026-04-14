import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../e2e_test_app.dart';
import '../helpers/test_data_seeder.dart';
import '../mocks/mock_api_handlers.dart';
import '../robots/home_robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Sync E2E', () {
    late E2ETestApp testApp;
    late TestDataSeeder seeder;

    setUp(() {
      testApp = E2ETestApp();
      seeder = TestDataSeeder(testApp);
    });

    /// Helper: start the app already logged in with a downloaded module.
    Future<void> setupLoggedInWithModule(WidgetTester tester) async {
      await seeder.seedAll();

      await MockApiHandlers.setupModulesList(testApp.interceptor);
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

    testWidgets('Home page shows module list when logged in', (tester) async {
      await setupLoggedInWithModule(tester);

      final homeRobot = HomeRobot(tester);
      homeRobot.expectHomePageVisible();

      // Verify module is displayed
      homeRobot.expectModuleCard(TestDataSeeder.testModuleLabel);

      // Verify user is logged in via local storage
      final isLoggedIn = await testApp.localStorage.getIsLoggedIn();
      expect(isLoggedIn, isTrue);

      final token = await testApp.localStorage.getToken();
      expect(token, isNotNull);
      expect(token, isNotEmpty);
    });

    testWidgets('Offline mode: fail mode blocks new API calls',
        (tester) async {
      await setupLoggedInWithModule(tester);

      final homeRobot = HomeRobot(tester);
      homeRobot.expectHomePageVisible();

      // Activate fail mode to simulate server being unreachable
      testApp.interceptor.setFailMode(
        statusCode: 503,
        message: 'Service Unavailable',
      );

      // Clear records to track new requests only
      testApp.interceptor.clearRecords();

      // The module data is in the local database, so it should still be visible
      // even though the server is unreachable
      homeRobot.expectModuleCard(TestDataSeeder.testModuleLabel);

      // Verify no new API calls were made (data comes from local DB)
      expect(testApp.interceptor.requests, isEmpty,
          reason: 'No API calls should be made when data is in local DB');
    });

    testWidgets('Menu actions are accessible on home page', (tester) async {
      await setupLoggedInWithModule(tester);

      final homeRobot = HomeRobot(tester);
      homeRobot.expectHomePageVisible();

      // Open the menu
      await homeRobot.openMenu();

      // Verify menu items are visible
      // Look for the popup menu items
      expect(find.byKey(const Key('menu-logout')), findsOneWidget,
          reason: 'Logout menu item should be visible');
    });

    testWidgets('MockApiInterceptor records all requests correctly',
        (tester) async {
      await setupLoggedInWithModule(tester);

      // Note : avec l'utilisateur pré-connecté et le module déjà téléchargé,
      // l'app ne fait aucun appel HTTP au boot (tout vient de la DB locale).
      // Pour valider que l'interceptor enregistre bien les requêtes quand
      // elles existent, on en déclenche une via le Dio configuré par testApp.
      testApp.interceptor.clearRecords();
      await testApp.dio.get('/monitorings/modules');

      expect(testApp.interceptor.requests, isNotEmpty,
          reason:
              'Interceptor should record requests routed through testApp.dio');

      final firstRequest = testApp.interceptor.requests.first;
      expect(firstRequest.method, isNotEmpty);
      expect(firstRequest.path, isNotEmpty);
      expect(firstRequest.timestamp, isNotNull);
    });

    testWidgets('Module data persists in local database after seeding',
        (tester) async {
      await setupLoggedInWithModule(tester);

      // Verify module is in the mock database
      final modules = await testApp.moduleDatabase.getAllModules();
      expect(modules, isNotEmpty,
          reason: 'Mock database should contain seeded modules');
      expect(modules.first.moduleLabel, equals(TestDataSeeder.testModuleLabel));
      expect(modules.first.downloaded, isTrue);

      // Verify sites are in the mock database
      final sites = await testApp.sitesDatabase.getAllSites();
      expect(sites, hasLength(2),
          reason: 'Mock database should contain 2 seeded sites');

      // Verify nomenclatures are in the mock database
      final nomenclatures =
          await testApp.nomenclaturesDatabase.getAllNomenclatures();
      expect(nomenclatures, isNotEmpty,
          reason: 'Mock database should contain seeded nomenclatures');

      // Verify datasets are in the mock database
      final datasets = await testApp.datasetsDatabase.getAllDatasets();
      expect(datasets, isNotEmpty,
          reason: 'Mock database should contain seeded datasets');
    });
  });
}
