import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../e2e_test_app_real.dart';
import 'helpers/real_test_helpers.dart';

/// Tests E2E du menu "Mettre à jour les données" (sync download).
///
/// Couvre :
/// 1. Login + atteinte de la HomePage
/// 2. Ouverture du menu burger
/// 3. Tap sur "Mettre à jour les données"
/// 4. Confirmation du dialog de mise à jour
/// 5. Attente de la fin de la sync (ModalBarrier disparait)
/// 6. Verification que la HomePage est a nouveau fonctionnelle
///
/// Pre-requis :
/// - Serveur GeoNature accessible avec au moins un module (POPAmphibien)
/// - Le compte admin peut acceder aux donnees
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late RealE2ETestApp testApp;
  late RealE2EConfig config;

  setUpAll(() {
    config = RealE2EConfig.load();
    debugPrint('=== Tests E2E Sync Download ===');
    debugPrint('Serveur: ${config.serverUrl}');
  });

  setUp(() {
    testApp = RealE2ETestApp(config: config);
  });

  group('Sync Download (Mettre à jour les données) (API reelle)', () {
    testWidgets(
        'Menu "Mettre à jour les données" → confirmer → sync termine sans erreur',
        (tester) async {
      // ----- 1. Login + HomePage -----
      await RealTestHelpers.loginAndReachHome(tester, testApp, config);

      // ----- 2. Ouvrir le menu burger et tap sur "Mettre à jour les données" -----
      debugPrint('===== REGARDE l\'ecran : ouverture du menu burger =====');
      final menuButton = find.byIcon(Icons.menu);
      await RealTestHelpers.waitForWidget(
        tester,
        menuButton,
        timeout: const Duration(seconds: 10),
        description: 'menu burger',
      );
      await tester.tap(menuButton);
      await RealTestHelpers.pumpFor(
          tester, const Duration(seconds: 2));

      debugPrint('===== REGARDE l\'ecran : tap sur "Mettre à jour les données" =====');
      final downloadMenuItem = find.byKey(const Key('menu-sync_download'));
      await RealTestHelpers.waitForWidget(
        tester,
        downloadMenuItem,
        timeout: const Duration(seconds: 5),
        description: 'item menu-sync_download',
      );
      await tester.tap(downloadMenuItem);
      await RealTestHelpers.pumpFor(
          tester, const Duration(seconds: 2));

      // ----- 3. Dialog de confirmation → tap "Mettre à jour" -----
      debugPrint('===== REGARDE l\'ecran : dialog confirmation download =====');
      final confirmButton = find.widgetWithText(ElevatedButton, 'Mettre à jour');
      await RealTestHelpers.waitForWidget(
        tester,
        confirmButton,
        timeout: const Duration(seconds: 10),
        description: 'bouton "Mettre à jour" du dialog',
      );
      await tester.tap(confirmButton);
      await RealTestHelpers.pumpFor(
          tester, const Duration(seconds: 2));

      // ----- 4. Attente de la fin de la sync -----
      // Le ModalBarrier (key: sync-modal-barrier) s'affiche pendant la sync
      // et disparait quand c'est termine. On poll jusqu'a disparition.
      debugPrint(
          '===== Sync en cours, attente de la fin (ModalBarrier) =====');
      await RealTestHelpers.waitForSyncToFinish(
        tester,
        timeout: const Duration(minutes: 5),
      );

      // ----- 5. Verifier qu'on est toujours sur la HomePage -----
      // La presence du titre "Mes Modules" + du menu burger confirme qu'on
      // est bien de retour sur la HomePage sans erreur bloquante.
      expect(find.text('Mes Modules'), findsOneWidget,
          reason: 'HomePage devrait etre visible apres la sync');
      expect(find.byIcon(Icons.menu), findsOneWidget,
          reason: 'Menu burger devrait etre a nouveau disponible');

      // Si un dialog d'erreur est present, on echoue proprement
      final errorDialogs = find.byType(AlertDialog);
      if (errorDialogs.evaluate().isNotEmpty) {
        final visibleTexts = find
            .byType(Text)
            .evaluate()
            .map((e) => (e.widget as Text).data ?? '')
            .where((s) => s.isNotEmpty)
            .toList();
        // Dismisser au cas ou
        await RealTestHelpers.dismissBlockingDialogs(tester);
        fail(
            'Un dialog est present apres la sync : $visibleTexts');
      }

      debugPrint('Sync download terminee avec succes');
    });
  });
}
