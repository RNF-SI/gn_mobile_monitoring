import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../e2e_test_app_real.dart';
import 'helpers/real_test_helpers.dart';

/// Tests E2E du menu "Téléversement" (sync upload).
///
/// Flow :
/// 1. Login + sync initial
/// 2. Download (pour que la verif "< 7 jours" passe et debloquer le téléversement)
/// 3. Tap menu → "Téléversement"
/// 4. Confirmer le dialog "Envoyer"
/// 5. Attendre la fin de la sync upload
/// 6. Verifier le retour HomePage sans erreur
///
/// Note : le test n'est pas oblige de creer des donnees locales a uploader.
/// S'il n'y en a pas, l'upload reussit sans rien envoyer. Le but ici est de
/// tester que le FLUX marche, pas forcement qu'une donnee specifique est envoyee.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late RealE2ETestApp testApp;
  late RealE2EConfig config;

  setUpAll(() {
    config = RealE2EConfig.load();
    debugPrint('=== Tests E2E Sync Upload ===');
    debugPrint('Serveur: ${config.serverUrl}');
  });

  setUp(() {
    testApp = RealE2ETestApp(config: config);
  });

  group('Sync Upload (Téléversement) (API reelle)', () {
    testWidgets(
        'Menu "Téléversement" → confirmer → upload termine sans erreur',
        (tester) async {
      // ----- 1. Login + HomePage -----
      await RealTestHelpers.loginAndReachHome(tester, testApp, config);

      // ----- 2. Faire un download d'abord -----
      // Si la derniere mise a jour date de > 7 jours (ou n'a jamais ete faite),
      // le bouton "Téléversement" affiche un dialog "Synchronisation requise"
      // au lieu de lancer l'upload. Pour eviter ce cas, on force un download.
      debugPrint('===== Pre-requisite : download sync pour passer la verif 7j =====');
      await _triggerDownloadAndWait(tester);

      // ----- 3. Tap menu burger → "Téléversement" -----
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

      debugPrint(
          '===== REGARDE l\'ecran : tap sur "Téléversement" =====');
      final uploadMenuItem = find.byKey(const Key('menu-sync_upload'));
      await RealTestHelpers.waitForWidget(
        tester,
        uploadMenuItem,
        timeout: const Duration(seconds: 5),
        description: 'item menu-sync_upload',
      );
      await tester.tap(uploadMenuItem);
      await RealTestHelpers.pumpFor(
          tester, const Duration(seconds: 2));

      // ----- 4. Detecter le dialog : "Envoi vers serveur" OU "Synchronisation requise" -----
      // Si "Synchronisation requise" apparait (verif 7j echouee malgre le download),
      // on dismiss et on relance le download. C'est un cas defensif.
      if (find.text('Synchronisation requise').evaluate().isNotEmpty) {
        debugPrint(
            'Dialog "Synchronisation requise" detecte → relancer un download');
        // Fermer le dialog (bouton "Fermer" ou "Annuler" ou autre)
        for (final btnText in ['Fermer', 'Annuler', 'OK']) {
          final btn = find.text(btnText);
          if (btn.evaluate().isNotEmpty) {
            await tester.tap(btn.first);
            break;
          }
        }
        await RealTestHelpers.pumpFor(
            tester, const Duration(seconds: 2));
        await _triggerDownloadAndWait(tester);

        // Re-tap "Téléversement"
        await tester.tap(find.byIcon(Icons.menu));
        await RealTestHelpers.pumpFor(
            tester, const Duration(seconds: 2));
        await tester.tap(find.byKey(const Key('menu-sync_upload')));
        await RealTestHelpers.pumpFor(
            tester, const Duration(seconds: 2));
      }

      // ----- 5. Dialog "Envoi vers serveur" → tap "Envoyer" -----
      debugPrint(
          '===== REGARDE l\'ecran : dialog confirmation upload =====');
      final sendButton = find.widgetWithText(ElevatedButton, 'Envoyer');
      await RealTestHelpers.waitForWidget(
        tester,
        sendButton,
        timeout: const Duration(seconds: 10),
        description: 'bouton "Envoyer" du dialog upload',
      );
      await tester.tap(sendButton);
      await RealTestHelpers.pumpFor(
          tester, const Duration(seconds: 2));

      // ----- 6. Si un module selector apparait (plusieurs modules telecharges),
      //          choisir le premier. -----
      final moduleSelectorDialog = find.text('Sélectionner un module');
      if (moduleSelectorDialog.evaluate().isNotEmpty) {
        debugPrint(
            'Dialog de selection de module detecte → choix du premier');
        // Chercher la liste des modules proposés (en general une liste)
        final listTiles = find.byType(ListTile);
        if (listTiles.evaluate().isNotEmpty) {
          await tester.tap(listTiles.first);
          await RealTestHelpers.pumpFor(
              tester, const Duration(seconds: 2));
        }
      }

      // ----- 7. Attente de la fin de la sync upload -----
      debugPrint(
          '===== Upload en cours, attente de la fin (ModalBarrier) =====');
      await RealTestHelpers.waitForSyncToFinish(
        tester,
        timeout: const Duration(minutes: 5),
      );

      // ----- 8. Verifier retour HomePage -----
      expect(find.text('Mes Modules'), findsOneWidget,
          reason: 'HomePage devrait etre visible apres l\'upload');

      // Dismisser tout snackbar/dialog residuel (succes ou info)
      await RealTestHelpers.dismissBlockingDialogs(tester);

      debugPrint('Sync upload terminee avec succes');
    });
  });
}

/// Lance un download sync depuis la HomePage et attend la fin.
/// Utilise pour debloquer le téléversement qui requiert une sync recente.
Future<void> _triggerDownloadAndWait(WidgetTester tester) async {
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

  final downloadItem = find.byKey(const Key('menu-sync_download'));
  await RealTestHelpers.waitForWidget(
    tester,
    downloadItem,
    timeout: const Duration(seconds: 5),
    description: 'item menu-sync_download',
  );
  await tester.tap(downloadItem);
  await RealTestHelpers.pumpFor(
      tester, const Duration(seconds: 2));

  // Dialog confirmation → "Mettre à jour"
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

  // Attendre la fin de la sync
  await RealTestHelpers.waitForSyncToFinish(
    tester,
    timeout: const Duration(minutes: 5),
  );
  debugPrint('Download sync (pre-requis) termine');
}
