import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../e2e_test_app.dart';
import '../helpers/test_data_seeder.dart';
import '../mocks/mock_api_handlers.dart';
import '../robots/home_robot.dart';
import '../robots/login_robot.dart';
import '../robots/module_detail_robot.dart';
import '../robots/site_detail_robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Full User Journey E2E', () {
    late E2ETestApp testApp;
    late TestDataSeeder seeder;

    setUp(() {
      testApp = E2ETestApp();
      seeder = TestDataSeeder(testApp);
    });

    testWidgets(
        'Complete journey: login → view modules → verify infrastructure',
        (tester) async {
      // Setup all mock handlers for the full journey
      await MockApiHandlers.setupFullJourney(testApp.interceptor);
      testApp.interceptor.onGetJson('/nomenclatures/nomenclatures', []);

      // 1. Launch the app
      await tester.pumpWidget(testApp.buildProviderScope());
      await tester.pumpAndSettle();

      // 2. Login
      final loginRobot = LoginRobot(tester);
      loginRobot.expectLoginPageVisible();

      await loginRobot.login(
        identifiant: 'testuser',
        password: 'testpass',
      );

      // Wait for login flow to complete (API call + data save + navigation)
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle(
        const Duration(milliseconds: 100),
        EnginePhase.sendSemanticsUpdate,
        const Duration(seconds: 15),
      );

      // 3. Verify home page with modules
      final homeRobot = HomeRobot(tester);
      homeRobot.expectHomePageVisible();

      // Verify module cards are displayed
      homeRobot.expectModuleCard('Module de test 1');
      homeRobot.expectModuleCard('Module de test 2');

      // 4. Verify API interactions
      expect(testApp.interceptor.hasRequest('POST', '/auth/login'), isTrue,
          reason: 'Login API should have been called');

      // Verify the login request contained correct credentials
      final loginRequests =
          testApp.interceptor.findRequests('POST', '/auth/login');
      expect(loginRequests, hasLength(1));

      // 5. Verify in-memory storage was updated
      final isLoggedIn = await testApp.localStorage.getIsLoggedIn();
      expect(isLoggedIn, isTrue,
          reason: 'User should be marked as logged in');

      final token = await testApp.localStorage.getToken();
      expect(token, isNotNull, reason: 'Token should be stored');
      expect(token, isNotEmpty, reason: 'Token should not be empty');

      final userId = await testApp.localStorage.getUserId();
      expect(userId, greaterThan(0), reason: 'User ID should be stored');
    });

    testWidgets('Login → view modules → logout → back to login',
        (tester) async {
      // Setup handlers
      await MockApiHandlers.setupFullJourney(testApp.interceptor);
      testApp.interceptor.onGetJson('/nomenclatures/nomenclatures', []);

      // Launch and login
      await tester.pumpWidget(testApp.buildProviderScope());
      await tester.pumpAndSettle();

      final loginRobot = LoginRobot(tester);
      await loginRobot.login(
        identifiant: 'testuser',
        password: 'testpass',
      );

      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle(
        const Duration(milliseconds: 100),
        EnginePhase.sendSemanticsUpdate,
        const Duration(seconds: 15),
      );

      // Verify home page
      final homeRobot = HomeRobot(tester);
      homeRobot.expectHomePageVisible();

      // Logout
      await homeRobot.tapLogout();
      await homeRobot.confirmLogout();

      await tester.pumpAndSettle(
        const Duration(milliseconds: 100),
        EnginePhase.sendSemanticsUpdate,
        const Duration(seconds: 10),
      );

      // Verify back on login page
      loginRobot.expectLoginPageVisible();

      // Verify storage was cleared
      final isLoggedIn = await testApp.localStorage.getIsLoggedIn();
      expect(isLoggedIn, isFalse, reason: 'User should be logged out');
    });

    testWidgets(
        'Pre-seeded journey: module → site detail navigation',
        (tester) async {
      // Pré-seed : user connecté + module téléchargé + nomenclatures + datasets.
      // On skip la phase login pour éviter que le sync post-login n'efface
      // le module seedé (le mock /monitorings/modules retourne un set de
      // fixtures différentes et le sync purge les modules absents du payload).
      // Le parcours testé reste : home (pré-connecté) → module → site detail.
      await seeder.seedAll();

      await MockApiHandlers.setupFullJourney(testApp.interceptor);
      testApp.interceptor.onGetJson('/nomenclatures/nomenclatures', []);
      testApp.interceptor.onGetJson('/monitorings/modules', []);

      // Launch the app (user is already logged in → lands on HomePage directly)
      await tester.pumpWidget(testApp.buildProviderScope());
      await tester.pumpAndSettle(
        const Duration(milliseconds: 100),
        EnginePhase.sendSemanticsUpdate,
        const Duration(seconds: 15),
      );

      // Verify home page
      final homeRobot = HomeRobot(tester);
      homeRobot.expectHomePageVisible();

      // The seeded module should appear as downloaded with "Ouvrir"
      expect(find.text('Ouvrir'), findsWidgets);

      // Navigate to module detail
      await tester.tap(find.text('Ouvrir').first);
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

      // Verify module detail page with sites
      final moduleRobot = ModuleDetailRobot(tester);
      moduleRobot.expectModuleDetailVisible(TestDataSeeder.testModuleLabel);
      moduleRobot.expectSite('Site de test Alpha');
      moduleRobot.expectSite('Site de test Beta');

      // Navigate to site detail
      await moduleRobot.tapSite('Site de test Alpha');
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle(
        const Duration(milliseconds: 100),
        EnginePhase.sendSemanticsUpdate,
        const Duration(seconds: 15),
      );

      // Verify site detail page
      final siteRobot = SiteDetailRobot(tester);
      siteRobot.expectSiteDetailVisible('Site de test Alpha');

      // Verify storage state throughout the journey
      final isLoggedIn = await testApp.localStorage.getIsLoggedIn();
      expect(isLoggedIn, isTrue);
      final token = await testApp.localStorage.getToken();
      expect(token, isNotEmpty);
    });
  });
}
