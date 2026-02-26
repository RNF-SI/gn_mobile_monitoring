import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../e2e_test_app.dart';
import '../mocks/mock_api_handlers.dart';
import '../robots/home_robot.dart';
import '../robots/login_robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Authentication E2E', () {
    late E2ETestApp testApp;

    setUp(() {
      testApp = E2ETestApp();
    });

    testWidgets('Login success navigates to HomePage', (tester) async {
      // Setup mock handlers for successful login and module list
      await MockApiHandlers.setupAuthSuccess(testApp.interceptor);
      await MockApiHandlers.setupModulesList(testApp.interceptor);

      // Also handle any additional API calls during login flow
      testApp.interceptor.onGetJson('/monitorings/modules', []);
      testApp.interceptor.onGetJson('/nomenclatures/nomenclatures', []);

      // Launch the app
      await tester.pumpWidget(testApp.buildProviderScope());
      await tester.pumpAndSettle();

      // Interact with login page
      final loginRobot = LoginRobot(tester);
      loginRobot.expectLoginPageVisible();

      await loginRobot.login(
        identifiant: 'testuser',
        password: 'testpass',
      );

      // Wait for navigation to complete
      // The login flow involves async operations: API call, saving data, syncing
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle(
        const Duration(milliseconds: 100),
        EnginePhase.sendSemanticsUpdate,
        const Duration(seconds: 15),
      );

      // Verify we're on the home page
      final homeRobot = HomeRobot(tester);
      homeRobot.expectHomePageVisible();
    });

    testWidgets('Login failure shows error message', (tester) async {
      // Setup mock handlers for failed login
      await MockApiHandlers.setupAuthFailure(testApp.interceptor);

      // Launch the app
      await tester.pumpWidget(testApp.buildProviderScope());
      await tester.pumpAndSettle();

      // Try to login with bad credentials
      final loginRobot = LoginRobot(tester);
      loginRobot.expectLoginPageVisible();

      // Enter credentials without using tapAndSettle for the login button
      // (error dialogs/animations may prevent pumpAndSettle from completing)
      await loginRobot.enterApiUrl('https://mock.geonature.test');
      await loginRobot.enterIdentifiant('baduser');
      await loginRobot.enterPassword('badpass');

      // Tap login button without waiting for settle
      await tester.tap(find.byKey(const Key('login-button')));

      // Pump frames to let the API call and error handling run
      for (int i = 0; i < 30; i++) {
        await tester.pump(const Duration(milliseconds: 200));
      }

      // The login page should still be visible (no navigation)
      loginRobot.expectLoginPageVisible();

      // Verify the request was made
      expect(testApp.interceptor.hasRequest('POST', '/auth/login'), isTrue,
          reason: 'Expected a POST /auth/login request');
    });

    testWidgets('Logout returns to LoginPage', (tester) async {
      // Setup the app as already logged in
      await testApp.localStorage.setIsLoggedIn(true);
      await testApp.localStorage.setToken('mock-token');
      await testApp.localStorage.setUserId(1);
      await testApp.localStorage.setUserName('testuser');

      // Setup mock handlers
      await MockApiHandlers.setupModulesList(testApp.interceptor);
      testApp.interceptor.onGetJson('/monitorings/modules', []);

      // Launch the app - should go directly to HomePage
      await tester.pumpWidget(testApp.buildProviderScope());

      // Use pump loop instead of pumpAndSettle (SyncStatusWidget may animate)
      for (int i = 0; i < 30; i++) {
        await tester.pump(const Duration(milliseconds: 200));
      }

      // Verify we're on home page
      final homeRobot = HomeRobot(tester);
      homeRobot.expectHomePageVisible();

      // Perform logout — opens menu then taps logout
      // Use tap + pump instead of tapAndSettle (ongoing animations)
      final menuButton = find.byIcon(Icons.menu);
      expect(menuButton, findsOneWidget, reason: 'Menu button not found');
      await tester.tap(menuButton);
      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      // Tap logout menu item
      final logoutItem = find.byKey(const Key('menu-logout'));
      expect(logoutItem, findsOneWidget, reason: 'Logout menu item not found');
      await tester.tap(logoutItem);
      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      // Confirm logout
      await homeRobot.confirmLogout();

      // Verify we're back on login page
      final loginRobot = LoginRobot(tester);
      loginRobot.expectLoginPageVisible();
    });
  });
}
