import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../e2e_test_app_real.dart';
import 'helpers/real_test_helpers.dart';

/// Module non configuré côté serveur (`configured: false`,
/// gn_module_monitoring#752) : comme le module web, l'app refuse de le
/// télécharger.
///
/// Le module testé est le premier que le serveur signale non configuré (ex.
/// un module sans jeu de données). Sans nouvelle API monitoring (≤ 1.3.x) ou
/// sans module non configuré, le test est ignoré.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late RealE2EConfig config;

  setUpAll(() => config = RealE2EConfig.load());

  testWidgets('Un module non configuré ne peut pas être téléchargé',
      (tester) async {
    final testApp = RealE2ETestApp(config: config);
    await RealTestHelpers.loginAndReachHome(tester, testApp, config);

    final moduleCode =
        await _findNotConfiguredModule(await RealTestHelpers.serverClient(config));
    if (moduleCode == null) {
      markTestSkipped(
          'Aucun module signalé non configuré par le serveur (nouvelle API '
          'absente ou tous les modules configurés)');
      return;
    }
    debugPrint('Module non configuré testé : $moduleCode');

    await RealTestHelpers.scrollToModuleCard(tester, moduleCode);
    final moduleCard = find.byKey(Key('module-card-$moduleCode'));
    await tester.ensureVisible(moduleCard);
    await tester.tap(find
        .descendant(of: moduleCard, matching: find.text('Télécharger'))
        .first);
    await tester.pump();

    await RealTestHelpers.waitForWidget(
      tester,
      find.textContaining("n'est pas encore configuré"),
      timeout: const Duration(minutes: 1),
      description: 'message « module non configuré »',
    );
    expect(find.text('Module non configuré'), findsOneWidget);

    await tester.tap(find.text('Fermer'));
    await RealTestHelpers.pumpFor(tester, const Duration(seconds: 1));

    // Le module reste non téléchargé.
    await RealTestHelpers.scrollToModuleCard(tester, moduleCode);
    expect(
        find.descendant(
            of: find.byKey(Key('module-card-$moduleCode')),
            matching: find.text('Télécharger')),
        findsOneWidget);
  });
}

/// Premier module dont la config (nouvelle API) porte `configured: false`.
Future<String?> _findNotConfiguredModule(Dio dio) async {
  final modules = (await dio.get('/monitorings/modules')).data as List;
  for (final module in modules) {
    final code = (module as Map)['module_code'] as String?;
    if (code == null) continue;
    for (final base in ['/monitorings/refacto', '/monitorings']) {
      try {
        final config = (await dio.get('$base/$code/config')).data;
        if (config is Map && config['configured'] == false) return code;
        break;
      } on DioException catch (e) {
        if (e.response?.statusCode != 404) rethrow;
      }
    }
  }
  return null;
}
