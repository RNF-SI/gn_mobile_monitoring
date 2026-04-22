import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../e2e_test_app_real.dart';
import 'helpers/real_test_helpers.dart';

/// Test E2E du filtrage par module pour les sites d'un groupe (issue #169).
///
/// Jeu de données serveur (GeoNature de recette) :
///   - Modules : `plaquesreptiles` (m70) et `POPReptile` (m12).
///   - 55 groupes `TEST_Plaque_Groupe_01..55` :
///       * 01..20 : mono-module (plaquesreptiles uniquement), 4 sites chacun.
///       * 21..55 : partagés (m70 + m12), 4 sites dont _1/_2 → m70, _3/_4 → m12.
///
/// Ce test vérifie :
///   - Cas a : groupe partagé (25) ouvert depuis plaquesreptiles → 2 sites (_1, _2).
///   - Cas b : même groupe depuis POPReptile → 2 sites (_3, _4).
///   - Cas c : groupe mono-module (05) depuis plaquesreptiles → 4 sites (_1..4).
///
/// Avant le fix : (a) et (b) affichent les 4 sites → échec.
/// Après le fix : partition exacte sur chaque module.
///
/// Lancement :
///   ./run_real_e2e_tests.sh site-group-module-filtering
/// ou directement :
///   flutter test integration_test/scenarios_real/real_site_group_module_filtering_e2e_test.dart \
///     --dart-define=TEST_SERVER_URL=http://10.0.2.2:8001 \
///     --dart-define=TEST_USERNAME=admin \
///     --dart-define=TEST_PASSWORD=admin \
///     --dart-define=TEST_MODULE_CODES=plaquesreptiles,POPReptile
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late RealE2ETestApp testApp;
  late RealE2EConfig config;

  const moduleReptilePlaques = 'plaquesreptiles';
  const modulePopReptile = 'POPReptile';

  const sharedGroup = 'TEST_Plaque_Groupe_25';
  const controlGroup = 'TEST_Plaque_Groupe_05';

  setUpAll(() {
    config = RealE2EConfig.load();
    debugPrint('=== Tests E2E filtrage sites par module (issue #169) ===');
    debugPrint('Serveur: ${config.serverUrl}');
    debugPrint('Modules requis: $moduleReptilePlaques + $modulePopReptile');
  });

  setUp(() {
    testApp = RealE2ETestApp(config: config);
  });

  group('Filtrage sites par module (API réelle)', () {
    testWidgets(
      'Groupe 25 partagé : plaquesreptiles → {_1,_2} | POPReptile → {_3,_4} ; '
      'Groupe 05 mono-module plaquesreptiles → {_1,_2,_3,_4}',
      (tester) async {
        // ---------------------------------------------------------------
        // Préconditions sur la config
        // ---------------------------------------------------------------
        final moduleCodes = config.moduleCodes;
        if (!moduleCodes.contains(moduleReptilePlaques) ||
            !moduleCodes.contains(modulePopReptile)) {
          markTestSkipped(
              'Ce test nécessite TEST_MODULE_CODES=$moduleReptilePlaques,$modulePopReptile '
              '(actuel : ${moduleCodes.join(", ")})');
          return;
        }

        // ---------------------------------------------------------------
        // 1. Login + sync initiale
        // ---------------------------------------------------------------
        await RealTestHelpers.loginAndReachHome(tester, testApp, config);

        // Dump les keys de modules visibles sur la home pour faciliter
        // le diagnostic si la card du module cible est absente.
        _dumpVisibleModuleCards(prefix: 'Avant cas (a)');

        // ---------------------------------------------------------------
        // 2. Cas (a) : plaquesreptiles / Groupe 25 → attend {_1, _2}
        // ---------------------------------------------------------------
        debugPrint('');
        debugPrint('===== Cas (a) : $moduleReptilePlaques / $sharedGroup =====');
        await _scrollToModuleCard(tester, moduleReptilePlaques);
        await RealTestHelpers.downloadAndOpenModule(
            tester, moduleReptilePlaques);
        await _openSiteGroupByName(tester, sharedGroup);

        _assertSitesPresent(
          group: sharedGroup,
          expectedSuffixes: const ['_1', '_2'],
          forbiddenSuffixes: const ['_3', '_4'],
        );

        // ---------------------------------------------------------------
        // 3. Cas (c) non-régression : retour sur la page module (pas home)
        //    pour ouvrir le groupe 05 depuis le même module.
        // ---------------------------------------------------------------
        debugPrint('');
        debugPrint('===== Cas (c) non-reg : $moduleReptilePlaques / $controlGroup =====');
        await _popBackOneLevel(tester);
        await _openSiteGroupByName(tester, controlGroup);

        _assertSitesPresent(
          group: controlGroup,
          expectedSuffixes: const ['_1', '_2', '_3', '_4'],
          forbiddenSuffixes: const [],
        );

        // Retour HomePage pour basculer de module
        await RealTestHelpers.navigateBackToHome(tester);
        await RealTestHelpers.dismissBlockingDialogs(tester);
        await RealTestHelpers.pumpFor(tester, const Duration(seconds: 2));

        // ---------------------------------------------------------------
        // 4. Cas (b) : POPReptile / même Groupe 25 → attend {_3, _4}
        // ---------------------------------------------------------------
        debugPrint('');
        debugPrint('===== Cas (b) : $modulePopReptile / $sharedGroup =====');
        _dumpVisibleModuleCards(prefix: 'Avant cas (b)');
        await _scrollToModuleCard(tester, modulePopReptile);
        await RealTestHelpers.downloadAndOpenModule(
            tester, modulePopReptile);
        await _openSiteGroupByName(tester, sharedGroup);

        _assertSitesPresent(
          group: sharedGroup,
          expectedSuffixes: const ['_3', '_4'],
          forbiddenSuffixes: const ['_1', '_2'],
        );

        debugPrint('');
        debugPrint('===== Tous les cas ont passe =====');
      },
      timeout: const Timeout(Duration(minutes: 15)),
    );
  });
}

// ---------------------------------------------------------------------------
// Helpers locaux au scénario
// ---------------------------------------------------------------------------

/// Scroll la liste des modules jusqu'à faire apparaître la card visée dans
/// le tree. Nécessaire car la `ListView` des modules est virtualisée : une
/// card hors du viewport n'est pas montée. Sans ça,
/// `RealTestHelpers.downloadAndOpenModule` ne la trouverait pas.
Future<void> _scrollToModuleCard(
  WidgetTester tester,
  String moduleCode,
) async {
  final targetKey = Key('module-card-$moduleCode');
  final targetFinder = find.byKey(targetKey);

  if (targetFinder.evaluate().isNotEmpty) {
    await tester.ensureVisible(targetFinder);
    await RealTestHelpers.pumpFor(tester, const Duration(milliseconds: 500));
    return;
  }

  try {
    await tester.dragUntilVisible(
      targetFinder,
      find.byType(Scrollable).first,
      const Offset(0, -300),
      maxIteration: 60,
    );
    await RealTestHelpers.pumpFor(tester, const Duration(milliseconds: 500));
  } catch (e) {
    debugPrint('Échec dragUntilVisible pour $moduleCode: $e');
    _dumpVisibleModuleCards(prefix: 'Après dragUntilVisible échec');
    rethrow;
  }
}

/// Dump les keys `module-card-*` visibles pour faciliter le diagnostic
/// quand un module attendu est absent de la home.
void _dumpVisibleModuleCards({required String prefix}) {
  final keys = <String>{};
  for (final element in find
      .byWidgetPredicate((w) => w.key is ValueKey)
      .evaluate()) {
    final keyValue = (element.widget.key as ValueKey).value;
    if (keyValue is String && keyValue.startsWith('module-card-')) {
      keys.add(keyValue);
    }
  }
  debugPrint('[$prefix] module-card-* visibles: $keys');
}

/// Pop un seul niveau de navigation (de SiteGroupDetailPage vers
/// ModuleDetailPage). Différent de [navigateBackToHome] qui remonte jusqu'à
/// la HomePage.
Future<void> _popBackOneLevel(WidgetTester tester) async {
  final back = find.byTooltip('Back');
  if (back.evaluate().isNotEmpty) {
    await tester.tap(back.first);
  } else {
    final backBtn = find.byType(BackButton);
    if (backBtn.evaluate().isNotEmpty) {
      await tester.tap(backBtn.first);
    } else {
      fail('_popBackOneLevel: aucun bouton back trouvé');
    }
  }
  await RealTestHelpers.pumpFor(tester, const Duration(seconds: 3));
}

/// Ouvre un groupe de sites par son nom depuis la page de détail du module.
///
/// Stratégie :
///   1. Attend qu'au moins un `ExpansionTile` de groupe soit rendu.
///   2. Scroll vers [groupName] pour le ramener dans le viewport si besoin.
///   3. Tape sur l'icône `visibility` descendant du tile contenant ce nom.
Future<void> _openSiteGroupByName(
  WidgetTester tester,
  String groupName,
) async {
  debugPrint('===== Ouverture du groupe "$groupName" =====');

  // Attendre qu'au moins un groupe soit rendu (visibility icon présent).
  await RealTestHelpers.waitForWidget(
    tester,
    find.byIcon(Icons.visibility),
    timeout: const Duration(seconds: 15),
    description: 'icônes visibility des groupes de la page module',
  );

  // Scroll jusqu'à trouver le groupe par son nom.
  // La liste peut contenir 50+ groupes → on délègue à dragUntilVisible,
  // qui sait traiter les ListView virtualisées.
  final groupLabel = find.text(groupName);

  if (groupLabel.evaluate().isEmpty) {
    // Choisir le bon Scrollable : on veut celui de la liste des groupes,
    // pas celui d'un TabBar ou d'un AppBar. Heuristique : le plus grand
    // Scrollable de la page (typiquement ListView/CustomScrollView).
    Finder scrollable = find.byType(Scrollable).first;

    // Essayer d'abord un scroll vers le bas
    try {
      await tester.dragUntilVisible(
        groupLabel,
        scrollable,
        const Offset(0, -300),
        maxIteration: 80,
      );
    } catch (_) {
      // Retry en scrollant vers le haut au cas où on est passé trop loin
      try {
        await tester.dragUntilVisible(
          groupLabel,
          scrollable,
          const Offset(0, 300),
          maxIteration: 80,
        );
      } catch (e) {
        fail('Groupe "$groupName" introuvable dans la liste des groupes '
            'du module (dragUntilVisible a épuisé ses itérations dans les '
            'deux directions). Dernière erreur: $e');
      }
    }
  }

  await tester.ensureVisible(groupLabel.first);
  await RealTestHelpers.pumpFor(
      tester, const Duration(milliseconds: 500));

  // Trouver l'ExpansionTile contenant ce texte, puis son icône visibility.
  final tile = find.ancestor(
    of: groupLabel,
    matching: find.byType(ExpansionTile),
  );
  expect(tile, findsAtLeastNWidgets(1),
      reason: 'Aucun ExpansionTile englobant le groupe "$groupName"');

  final visIcon = find.descendant(
    of: tile.first,
    matching: find.byIcon(Icons.visibility),
  );
  expect(visIcon, findsAtLeastNWidgets(1),
      reason:
          'Aucun bouton visibility sur le tile du groupe "$groupName"');

  await tester.tap(visIcon.first);
  await RealTestHelpers.pumpFor(tester, const Duration(seconds: 4));

  // On doit maintenant être sur SiteGroupDetailPage. Sanity-check.
  await RealTestHelpers.waitForWidget(
    tester,
    find.textContaining(groupName),
    timeout: const Duration(seconds: 10),
    description: 'titre de SiteGroupDetailPage pour "$groupName"',
  );
}

/// Vérifie que la SiteGroupDetailPage affiche exactement les sites attendus
/// pour le groupe courant.
///
/// [expectedSuffixes] et [forbiddenSuffixes] s'appliquent au suffixe du code
/// site : "TEST_Plaque_Site_${groupNumber}${suffix}" (ex: `_1`, `_2`).
/// Le nombre de sites extraits du tree doit correspondre exactement à
/// `expectedSuffixes.length`, sinon l'assertion échoue avec le détail.
void _assertSitesPresent({
  required String group,
  required List<String> expectedSuffixes,
  required List<String> forbiddenSuffixes,
}) {
  // Extraire le numéro du groupe (deux derniers chiffres de "..._XX")
  final groupNumMatch = RegExp(r'_(\d{2})$').firstMatch(group);
  expect(groupNumMatch, isNotNull,
      reason: 'Nom de groupe inattendu: $group');
  final groupNum = groupNumMatch!.group(1);

  final sitePrefix = 'TEST_Plaque_Site_$groupNum';
  debugPrint(
      'Assertion sites (préfixe "$sitePrefix") — attendus ${expectedSuffixes.length}: $expectedSuffixes');

  // Collecter tous les Text widgets qui commencent par le préfixe
  final allSiteTexts = find
      .byWidgetPredicate((w) =>
          w is Text &&
          w.data != null &&
          w.data!.startsWith(sitePrefix))
      .evaluate()
      .map((el) => (el.widget as Text).data!)
      .toSet();

  debugPrint('Sites visibles dans la page : $allSiteTexts');

  // Présence des attendus
  for (final suffix in expectedSuffixes) {
    final expected = '$sitePrefix$suffix';
    expect(
      allSiteTexts.contains(expected),
      isTrue,
      reason:
          'Site "$expected" attendu mais absent sur la page du groupe $group. '
          'Sites visibles: $allSiteTexts',
    );
  }

  // Absence des interdits
  for (final suffix in forbiddenSuffixes) {
    final forbidden = '$sitePrefix$suffix';
    expect(
      allSiteTexts.contains(forbidden),
      isFalse,
      reason:
          'Site "$forbidden" NE DEVRAIT PAS apparaître sur la page du groupe $group '
          '(appartient à un autre module). Bug #169 si présent.',
    );
  }

  // Count exact : on compte uniquement les sites de CE groupe (préfixe strict)
  final siteCountForThisGroup = allSiteTexts
      .where((name) =>
          RegExp('^${RegExp.escape(sitePrefix)}_[0-9]+\$').hasMatch(name))
      .length;

  expect(
    siteCountForThisGroup,
    expectedSuffixes.length,
    reason:
        'Nombre exact de sites du groupe $group attendu=${expectedSuffixes.length} '
        'mais trouvé=$siteCountForThisGroup. Sites visibles: $allSiteTexts',
  );
}
