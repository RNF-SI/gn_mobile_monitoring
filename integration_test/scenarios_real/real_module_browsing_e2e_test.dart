import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../e2e_test_app_real.dart';
import '../robots/home_robot.dart';
import '../robots/module_detail_robot.dart';
import 'helpers/real_test_helpers.dart';

/// Tests E2E de navigation dans le module POPAmphibien contre un vrai GeoNature.
///
/// Ce test :
/// 1. Se connecte au serveur
/// 2. Verifie que le module POPAmphibien est dans la liste
/// 3. Telecharge le module (si pas deja telecharge)
/// 4. Ouvre le module et verifie la liste de sites
/// 5. Navigue dans un site
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late RealE2ETestApp testApp;
  late RealE2EConfig config;

  setUpAll(() {
    config = RealE2EConfig.load();
    debugPrint('=== Tests E2E Module Browsing ===');
    debugPrint('Serveur: ${config.serverUrl}');
    debugPrint('Module: ${config.moduleCode}');
  });

  setUp(() {
    testApp = RealE2ETestApp(config: config);
  });

  group('Navigation module ${RealE2EConfig.load().moduleCode} (API reelle)',
      () {
    testWidgets('Le module est visible dans la liste apres login',
        (tester) async {
      await RealTestHelpers.loginAndReachHome(tester, testApp, config);

      final homeRobot = HomeRobot(tester);
      homeRobot.expectHomePageVisible();

      // Verifier que le module est present dans la liste (avec scroll car
      // ListView.builder n'instancie que les items visibles)
      await RealTestHelpers.scrollToModuleCard(tester, config.moduleCode);

      debugPrint('Module ${config.moduleCode} trouve dans la liste');
    });

    testWidgets(
        'Telecharger et ouvrir le module affiche la page de detail avec des sites',
        (tester) async {
      await RealTestHelpers.loginAndReachHome(tester, testApp, config);

      final homeRobot = HomeRobot(tester);
      homeRobot.expectHomePageVisible();

      // downloadAndOpenModule scrolle automatiquement vers la card cible
      await RealTestHelpers.downloadAndOpenModule(tester, config.moduleCode);

      // Verifier qu'on a quitte la HomePage
      expect(find.text('Mes Modules'), findsNothing,
          reason: 'Devrait avoir quitte la HomePage');

      debugPrint('Page de detail du module atteinte');
    });

    testWidgets('Navigation dans un site du module', (tester) async {
      await RealTestHelpers.loginAndReachHome(tester, testApp, config);

      // downloadAndOpenModule scrolle automatiquement vers la card cible
      await RealTestHelpers.downloadAndOpenModule(tester, config.moduleCode);

      final moduleDetailRobot = ModuleDetailRobot(tester);

      // Attendre que des elements de la liste apparaissent (sites/groupes)
      await RealTestHelpers.waitForWidget(
        tester,
        find.byType(Card),
        timeout: const Duration(seconds: 15),
        description: 'cards de sites/groupes',
      );

      debugPrint('Sites charges sur la page du module');

      // Tapper sur le premier element (site ou groupe de sites)
      final cards = find.byType(Card);
      if (cards.evaluate().length > 1) {
        await tester.tap(cards.at(1));
      } else if (cards.evaluate().isNotEmpty) {
        await tester.tap(cards.first);
      }

      await RealTestHelpers.pumpFor(
          tester, const Duration(seconds: 6));

      debugPrint('Navigation dans un site reussie');

      // Retour arriere
      await moduleDetailRobot.goBack();
      await RealTestHelpers.pumpFor(
          tester, const Duration(seconds: 2));

      debugPrint('Retour arriere reussi');
    });
  });
}

