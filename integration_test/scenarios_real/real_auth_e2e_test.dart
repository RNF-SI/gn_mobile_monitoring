import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../e2e_test_app_real.dart';
import '../robots/home_robot.dart';
import '../robots/login_robot.dart';
import 'helpers/real_test_helpers.dart';

/// Tests E2E d'authentification contre un vrai serveur GeoNature.
///
/// Pre-requis :
/// - Un serveur GeoNature local accessible
/// - .env.test configure avec les bons credentials
/// - Emulateur ou appareil connecte au reseau
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late RealE2ETestApp testApp;
  late RealE2EConfig config;

  setUpAll(() {
    config = RealE2EConfig.load();
    debugPrint('=== Tests E2E reels ===');
    debugPrint('Serveur: ${config.serverUrl}');
    debugPrint('Utilisateur: ${config.username}');
    debugPrint('Module: ${config.moduleCode}');
  });

  setUp(() {
    testApp = RealE2ETestApp(config: config);
  });

  group('Authentification E2E (API reelle)', () {
    testWidgets('Login avec credentials valides navigue vers la HomePage',
        (tester) async {
      await tester.pumpWidget(testApp.buildProviderScope());
      await tester.pumpAndSettle();

      // Verifier qu'on est sur la page de login
      final loginRobot = LoginRobot(tester);
      loginRobot.expectLoginPageVisible();

      // Saisir les credentials reels
      await loginRobot.login(
        apiUrl: config.serverUrl,
        identifiant: config.username,
        password: config.password,
      );

      // Attendre la reponse du serveur (plus long qu'avec des mocks)
      await RealTestHelpers.waitForNavigation(tester,
          timeout: const Duration(seconds: 30));

      // Verifier qu'on est arrive sur la home page
      final homeRobot = HomeRobot(tester);
      homeRobot.expectHomePageVisible();

      debugPrint('Login reussi - HomePage atteinte');
    });

    testWidgets('Login avec mauvais mot de passe reste sur LoginPage',
        (tester) async {
      await tester.pumpWidget(testApp.buildProviderScope());
      await tester.pumpAndSettle();

      final loginRobot = LoginRobot(tester);
      loginRobot.expectLoginPageVisible();

      // Saisir un mauvais mot de passe
      await loginRobot.enterApiUrl(config.serverUrl);
      await loginRobot.enterIdentifiant(config.username);
      await loginRobot.enterPassword('mauvais_mot_de_passe_xyz');

      // Tapper le bouton login sans pumpAndSettle (l'erreur peut bloquer settle)
      await tester.tap(find.byKey(const Key('login-button')));

      // Pomper des frames pour laisser l'appel API et le traitement d'erreur
      await RealTestHelpers.pumpFor(
          tester, const Duration(seconds: 30));

      // On doit toujours etre sur la page de login
      loginRobot.expectLoginPageVisible();

      debugPrint('Login echoue correctement - toujours sur LoginPage');
    });

    testWidgets('Logout depuis la HomePage retourne au LoginPage',
        (tester) async {
      // Login + sync + dismiss dialogs
      await RealTestHelpers.loginAndReachHome(tester, testApp, config);

      final homeRobot = HomeRobot(tester);
      homeRobot.expectHomePageVisible();

      // Ouvrir le menu et tapper logout (avec retries tolerants)
      await RealTestHelpers.openMenuAndTapLogout(tester);

      // Confirmer la deconnexion
      await homeRobot.confirmLogout();

      // Verifier qu'on est revenu sur la page de login
      final loginRobot = LoginRobot(tester);
      loginRobot.expectLoginPageVisible();

      debugPrint('Logout reussi - retour au LoginPage');
    });
  });
}
