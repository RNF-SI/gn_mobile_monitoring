import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/presentation/view/site/site_form_page.dart';
import 'package:integration_test/integration_test.dart';

import '../e2e_test_app.dart';
import '../helpers/test_data_seeder.dart';

/// Scénarios E2E ciblant le cycle de vie d'un site (suppression, verrouillage
/// post-sync). Pompe `SiteFormPage` directement dans le ProviderScope E2E
/// pour garder ces tests rapides et isolés de la chaîne de navigation.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Site lifecycle E2E', () {
    late E2ETestApp testApp;
    late TestDataSeeder seeder;

    setUp(() {
      testApp = E2ETestApp();
      seeder = TestDataSeeder(testApp);
    });

    Future<void> pumpSiteForm(
      WidgetTester tester, {
      required BaseSite site,
    }) async {
      await seeder.seedAll(extraSites: [site]);

      final config = TestDataSeeder.createModuleConfig();
      final siteConfig = config.site!;

      await tester.pumpWidget(
        testApp.buildProviderScope(
          child: MaterialApp(
            home: SiteFormPage(
              siteConfig: siteConfig,
              site: site,
              moduleId: TestDataSeeder.testModuleId,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle(
        const Duration(milliseconds: 100),
        EnginePhase.sendSemanticsUpdate,
        const Duration(seconds: 10),
      );
    }

    testWidgets(
        'Suppression d\'un site local : confirmation dialog → site retiré de la DB',
        (tester) async {
      const siteId = 501;
      const site = BaseSite(
        idBaseSite: siteId,
        baseSiteName: 'Site à supprimer',
        baseSiteCode: 'DEL_01',
        isLocal: true,
      );

      await pumpSiteForm(tester, site: site);

      // Sanity : le site est bien dans la mock DB avant suppression.
      final before = await testApp.sitesDatabase.getAllSites();
      expect(
        before.where((s) => s.idBaseSite == siteId),
        hasLength(1),
        reason: 'Le site devrait être présent avant suppression',
      );

      // L'icon delete de l'AppBar (uniquement en mode édition).
      final deleteIcon = find.descendant(
        of: find.byType(AppBar),
        matching: find.byIcon(Icons.delete),
      );
      expect(deleteIcon, findsOneWidget,
          reason: 'L\'icon delete doit être visible en mode édition');
      await tester.tap(deleteIcon);
      await tester.pumpAndSettle();

      // Dialog de confirmation avec boutons "Annuler" / "Supprimer".
      expect(find.text('Confirmer la suppression'), findsOneWidget);
      await tester.tap(find.widgetWithText(ElevatedButton, 'Supprimer'));
      await tester.pumpAndSettle();

      // Vérifier que le site a bien été supprimé de la mock DB.
      final after = await testApp.sitesDatabase.getAllSites();
      expect(
        after.where((s) => s.idBaseSite == siteId),
        isEmpty,
        reason: 'Le site devrait avoir disparu après confirmation',
      );
    });

    testWidgets(
        'Annulation du dialog : site conservé',
        (tester) async {
      const siteId = 502;
      const site = BaseSite(
        idBaseSite: siteId,
        baseSiteName: 'Site à conserver',
        baseSiteCode: 'KEEP_01',
        isLocal: true,
      );

      await pumpSiteForm(tester, site: site);

      await tester.tap(find.descendant(
        of: find.byType(AppBar),
        matching: find.byIcon(Icons.delete),
      ));
      await tester.pumpAndSettle();

      // Clic sur "Annuler" dans l'AlertDialog (éviter d'autres "Annuler"
      // qui peuvent exister ailleurs dans le form).
      await tester.tap(find.descendant(
        of: find.byType(AlertDialog),
        matching: find.widgetWithText(TextButton, 'Annuler'),
      ));
      await tester.pumpAndSettle();

      final after = await testApp.sitesDatabase.getAllSites();
      expect(
        after.where((s) => s.idBaseSite == siteId),
        hasLength(1),
        reason: 'Le site doit rester présent après annulation',
      );
    });

    testWidgets(
        'Site déjà synchronisé (serverSiteId != null) : formulaire verrouillé, pas d\'icon delete',
        (tester) async {
      const siteId = 503;
      const site = BaseSite(
        idBaseSite: siteId,
        baseSiteName: 'Site synchronisé',
        baseSiteCode: 'SYNC_01',
        isLocal: true,
        serverSiteId: 9999, // → synchronisé, non modifiable
      );

      await pumpSiteForm(tester, site: site);

      // Le wrapper affiche un message de verrouillage sans AppBar d'édition.
      expect(find.text('Ce site ne peut pas être modifié'), findsOneWidget);
      expect(
        find.text(
            'Ce site a déjà été synchronisé avec le serveur et ne peut plus être modifié.'),
        findsOneWidget,
      );

      // L'icon delete n'est pas exposé dans le mode verrouillé.
      expect(
        find.descendant(
          of: find.byType(AppBar),
          matching: find.byIcon(Icons.delete),
        ),
        findsNothing,
        reason: 'Pas d\'icon delete sur un site verrouillé',
      );
    });

    testWidgets(
        'Site non local (isLocal=false) : formulaire verrouillé avec message dédié',
        (tester) async {
      const siteId = 504;
      const site = BaseSite(
        idBaseSite: siteId,
        baseSiteName: 'Site serveur',
        baseSiteCode: 'REMOTE_01',
        isLocal: false, // vient du serveur, jamais créé localement
      );

      await pumpSiteForm(tester, site: site);

      expect(find.text('Ce site ne peut pas être modifié'), findsOneWidget);
      expect(
        find.text('Seuls les sites créés localement peuvent être modifiés.'),
        findsOneWidget,
      );
    });
  });
}
