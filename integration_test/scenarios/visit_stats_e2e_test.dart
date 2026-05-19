import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:integration_test/integration_test.dart';

import '../e2e_test_app.dart';
import '../helpers/test_data_seeder.dart';
import '../mocks/mock_api_handlers.dart';
import '../robots/home_robot.dart';
import '../robots/module_detail_robot.dart';

/// E2E pour la régression #P5 : la colonne "Dernier passage" et "Nb. passages"
/// du tableau Sites d'un module doivent être alimentées par le calcul local
/// à partir de `t_base_visits` (y compris les visites non encore téléversées).
///
/// On configure un module avec un `display_list` qui inclut `last_visit` et
/// `nb_visits`, on seed le mock visites avec un mix de visites synchronisées
/// et non synchronisées, puis on vérifie que les cellules du tableau
/// affichent les bonnes valeurs par site.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Visit Stats (last_visit / nb_visits) E2E', () {
    late E2ETestApp testApp;
    late TestDataSeeder seeder;

    setUp(() {
      testApp = E2ETestApp();
      seeder = TestDataSeeder(testApp);
    });

    testWidgets(
        'la liste Sites affiche Dernier passage et Nb. passages par site, '
        'inclut les visites non téléversées', (tester) async {
      // Config module avec last_visit / nb_visits dans display_list
      await seeder.seedAll(siteDisplayList: [
        'base_site_name',
        'base_site_code',
        'last_visit',
        'nb_visits',
      ]);

      // Site Alpha (101) : 2 visites dans le module test, dont 1 non
      // téléversée (serverVisitId NULL) — la plus récente.
      // Site Beta (102) : 1 visite synchronisée.
      // Une visite d'un autre module est aussi seedée pour vérifier qu'elle
      // n'est pas comptée.
      testApp.visitesDatabase.seedVisits([
        TBaseVisit(
          idBaseVisit: 1,
          idBaseSite: TestDataSeeder.testSiteId1,
          idDataset: TestDataSeeder.testDatasetId,
          idModule: TestDataSeeder.testModuleId,
          visitDateMin: '2026-01-15',
          serverVisitId: 500, // téléversée
          metaCreateDate: '2026-01-15',
          metaUpdateDate: '2026-01-15',
        ),
        TBaseVisit(
          idBaseVisit: 2,
          idBaseSite: TestDataSeeder.testSiteId1,
          idDataset: TestDataSeeder.testDatasetId,
          idModule: TestDataSeeder.testModuleId,
          visitDateMin: '2026-03-20',
          serverVisitId: null, // pas encore téléversée
          metaCreateDate: '2026-03-20',
          metaUpdateDate: '2026-03-20',
        ),
        TBaseVisit(
          idBaseVisit: 3,
          idBaseSite: TestDataSeeder.testSiteId2,
          idDataset: TestDataSeeder.testDatasetId,
          idModule: TestDataSeeder.testModuleId,
          visitDateMin: '2026-02-10',
          serverVisitId: 501,
          metaCreateDate: '2026-02-10',
          metaUpdateDate: '2026-02-10',
        ),
        // Visite d'un autre module : doit être ignorée dans le calcul du
        // module courant (pas de double comptage).
        TBaseVisit(
          idBaseVisit: 4,
          idBaseSite: TestDataSeeder.testSiteId1,
          idDataset: TestDataSeeder.testDatasetId,
          idModule: 999,
          visitDateMin: '2026-04-01',
          serverVisitId: 502,
          metaCreateDate: '2026-04-01',
          metaUpdateDate: '2026-04-01',
        ),
      ]);

      await MockApiHandlers.setupModulesList(testApp.interceptor);
      await MockApiHandlers.setupSites(testApp.interceptor);
      await MockApiHandlers.setupVisits(testApp.interceptor);
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

      final homeRobot = HomeRobot(tester);
      homeRobot.expectHomePageVisible();

      await tester.tap(find.text('Ouvrir'));
      await tester.pumpAndSettle(
        const Duration(milliseconds: 100),
        EnginePhase.sendSemanticsUpdate,
        const Duration(seconds: 15),
      );
      // Laisser le temps à _loadVisitDerivedData (Future.wait sur le mock)
      // de compléter et de déclencher un setState.
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle(
        const Duration(milliseconds: 100),
        EnginePhase.sendSemanticsUpdate,
        const Duration(seconds: 15),
      );

      final moduleRobot = ModuleDetailRobot(tester);
      moduleRobot.expectModuleDetailVisible(TestDataSeeder.testModuleLabel);
      moduleRobot.expectSite('Site de test Alpha');
      moduleRobot.expectSite('Site de test Beta');

      // Depuis le refactor de l'onglet Sites en ListView.builder, il n'y a
      // plus de DataTable avec des entêtes de colonnes — les infos visites
      // sont rendues sous forme de chips dans chaque Card. On vérifie donc
      // le contenu des chips, pas des cellules.

      // Dates de dernière visite (format dd/MM/yyyy identique à l'ancien rendu)
      expect(find.text('20/03/2026'), findsOneWidget,
          reason:
              'Dernière visite de Alpha (inclut la visite non téléversée)');
      expect(find.text('10/02/2026'), findsOneWidget,
          reason: 'Dernière visite de Beta');
      // Nb. passages — désormais affiché avec pluriel ("N passages" / "1 passage")
      // dans la chip Icons.repeat de la Card.
      expect(find.text('2 passages'), findsOneWidget,
          reason: 'Nb visites pour Alpha');
      expect(find.text('1 passage'), findsOneWidget,
          reason: 'Nb visites pour Beta');
    });

    testWidgets('un site sans visite ne montre aucune puce Nb. passages',
        (tester) async {
      await seeder.seedAll(siteDisplayList: [
        'base_site_name',
        'base_site_code',
        'nb_visits',
      ]);
      // Aucune visite seedée.

      await MockApiHandlers.setupModulesList(testApp.interceptor);
      await MockApiHandlers.setupSites(testApp.interceptor);
      await MockApiHandlers.setupVisits(testApp.interceptor);
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

      await tester.tap(find.text('Ouvrir'));
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

      // Depuis le refactor en ListView.builder, la Card de chaque site
      // masque la chip nb_passages si la valeur est 0 (UX mobile : on
      // évite la pollution visuelle). On vérifie donc que :
      // 1. les 2 sites sont bien rendus
      // 2. aucune chip Icons.repeat (compteur visites) n'est affichée
      //    → l'absence implique 0
      final moduleRobot = ModuleDetailRobot(tester);
      moduleRobot.expectSite('Site de test Alpha');
      moduleRobot.expectSite('Site de test Beta');
      expect(find.byIcon(Icons.repeat), findsNothing,
          reason:
              'Aucun site n\'a de visite, donc pas de puce nb passages');
    });
  });
}
