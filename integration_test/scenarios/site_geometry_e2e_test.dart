@Tags(['map'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/presentation/view/map/location_picker_page.dart';
import 'package:gn_mobile_monitoring/presentation/view/site/site_form_page.dart';
import 'package:integration_test/integration_test.dart';

import '../e2e_test_app.dart';
import '../helpers/test_data_seeder.dart';

/// Scénarios E2E ciblant le picker de géométrie introduit pour l'issue #154.
///
/// On pompe `SiteFormPage` directement dans le ProviderScope E2E (avec les
/// mocks DB/API/GPS du harness complet) : cela couvre tout le chemin
/// `SiteFormWrapper` → `LocationPreviewHeader` → `LocationPickerPage` sans
/// dépendre de la navigation Home → Module → Site qui est déjà testée par
/// ailleurs. La stabilité prime sur la répétition de la chaîne complète.
///
/// **Tagué `map`** : ces tests rendent `flutter_map` avec un `TileLayer` qui
/// fetch les tuiles OSM en réseau. En CI (GitHub Actions emulator), le
/// réseau vers `tile.openstreetmap.org` est inaccessible et les `fetch` en
/// cours après la fin du test émettent des `SocketException` qui font
/// remonter un échec post-completion. Sur un device physique avec réseau
/// ces tests passent ; la CI les exclut via `--exclude-tags=map`.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Site geometry picker E2E', () {
    late E2ETestApp testApp;
    late TestDataSeeder seeder;

    setUp(() {
      testApp = E2ETestApp();
      seeder = TestDataSeeder(testApp);
    });

    Future<void> pumpSiteForm(
      WidgetTester tester, {
      BaseSite? site,
      List<String>? siteGeometryTypes,
    }) async {
      await seeder.seedAll(siteGeometryTypes: siteGeometryTypes);

      final config = TestDataSeeder.createModuleConfig(
        siteGeometryTypes: siteGeometryTypes,
      );
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
        'Édition d\'un site LineString → header montre le nombre de sommets',
        (tester) async {
      const site = BaseSite(
        idBaseSite: TestDataSeeder.testSiteIdLine,
        baseSiteName: 'Transect test',
        baseSiteCode: 'TRANSECT_01',
        geom: TestDataSeeder.lineStringGeom,
        isLocal: true, // sinon le form est en lecture seule
      );

      await pumpSiteForm(
        tester,
        site: site,
        siteGeometryTypes: ['LineString'],
      );

      // Le header affiche "Ligne tracée" + "3 sommet(s)" (voir
      // LocationPreviewHeader._statusLabel / _detailLabel).
      expect(find.text('Ligne tracée'), findsOneWidget);
      expect(find.text('3 sommet(s)'), findsOneWidget);
      // Le bouton d'ajustement porte le libellé spécifique à la ligne.
      expect(
        find.widgetWithText(OutlinedButton, 'Tracer / modifier la ligne'),
        findsOneWidget,
      );
    });

    testWidgets(
        'Édition d\'un site Polygon → header montre 4 sommets + libellé polygone',
        (tester) async {
      const site = BaseSite(
        idBaseSite: TestDataSeeder.testSiteIdPolygon,
        baseSiteName: 'Zone test',
        baseSiteCode: 'ZONE_01',
        geom: TestDataSeeder.polygonGeom,
        isLocal: true,
      );

      await pumpSiteForm(
        tester,
        site: site,
        siteGeometryTypes: ['Polygon'],
      );

      expect(find.text('Polygone tracé'), findsOneWidget);
      // Le polygone de fixture a 4 sommets uniques (le 5e dupliqué est
      // filtré par le parser côté wrapper).
      expect(find.text('4 sommet(s)'), findsOneWidget);
      expect(
        find.widgetWithText(OutlinedButton, 'Tracer / modifier le polygone'),
        findsOneWidget,
      );
    });

    testWidgets(
        'Création avec geometry_type = [Point, LineString, Polygon] → '
        'bottom sheet offre les 3 choix',
        (tester) async {
      await pumpSiteForm(
        tester,
        siteGeometryTypes: ['Point', 'LineString', 'Polygon'],
      );

      // En création multi-types avec Point autorisé et GPS stubbé, le header
      // affiche d'abord un aperçu en mode Point.
      expect(find.text('Position GPS actuelle'), findsOneWidget);

      // Bouton "Ajuster sur la carte" → ouvre le bottom sheet de choix de type
      await tester.tap(
        find.widgetWithText(OutlinedButton, 'Ajuster sur la carte'),
      );
      await tester.pumpAndSettle();

      expect(find.text('Type de géométrie'), findsOneWidget);
      expect(find.text('Point'), findsWidgets);
      expect(find.text('Ligne (transect)'), findsOneWidget);
      expect(find.text('Polygone (zone)'), findsOneWidget);
    });

    testWidgets(
        'Création avec geometry_type = "LineString" → ouvre directement le '
        'picker en mode ligne sans passer par le sélecteur',
        (tester) async {
      await pumpSiteForm(
        tester,
        siteGeometryTypes: ['LineString'],
      );

      // En ligne-only sans vertices initiaux, le header montre le placeholder
      // "Aucune ligne tracée" et le bouton porte son libellé.
      expect(find.text('Aucune ligne tracée'), findsOneWidget);
      final drawButton = find.widgetWithText(
        OutlinedButton,
        'Tracer / modifier la ligne',
      );
      expect(drawButton, findsOneWidget);

      await tester.tap(drawButton);
      await tester.pumpAndSettle();

      // Pas de bottom sheet, on est directement sur LocationPickerPage
      // en mode ligne (AppBar "Tracer une ligne").
      expect(find.text('Type de géométrie'), findsNothing);
      expect(find.byType(LocationPickerPage), findsOneWidget);
      expect(find.text('Tracer une ligne'), findsOneWidget);
    });
  });
}
