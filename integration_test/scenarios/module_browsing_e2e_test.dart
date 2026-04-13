import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../e2e_test_app.dart';
import '../mocks/mock_api_handlers.dart';
import '../robots/home_robot.dart';
import '../robots/login_robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Module Browsing E2E', () {
    late E2ETestApp testApp;

    setUp(() {
      testApp = E2ETestApp();
    });

    /// Helper to login and reach the home page
    Future<void> loginAndReachHome(WidgetTester tester) async {
      await MockApiHandlers.setupAuthSuccess(testApp.interceptor);
      await MockApiHandlers.setupModulesList(testApp.interceptor);
      testApp.interceptor.onGetJson('/nomenclatures/nomenclatures', []);

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
    }

    testWidgets('Module list displays module cards after login',
        (tester) async {
      await loginAndReachHome(tester);

      final homeRobot = HomeRobot(tester);
      homeRobot.expectHomePageVisible();

      // Verify module cards are displayed
      homeRobot.expectModuleCard('Module de test 1');
      homeRobot.expectModuleCard('Module de test 2');
    });

    testWidgets('Module cards show module descriptions', (tester) async {
      await loginAndReachHome(tester);

      // Verify descriptions are shown
      expect(find.text('Premier module de test pour les E2E'), findsOneWidget);
      expect(find.text('Deuxième module pour les tests E2E'), findsOneWidget);
    });

    testWidgets('Module card is identifiable by code key', (tester) async {
      await loginAndReachHome(tester);

      // Verify cards have correct keys
      expect(find.byKey(const Key('module-card-TEST_MODULE_1')),
          findsOneWidget);
      expect(find.byKey(const Key('module-card-TEST_MODULE_2')),
          findsOneWidget);
    });
  });
}
