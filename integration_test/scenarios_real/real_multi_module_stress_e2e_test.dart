import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../e2e_test_app_real.dart';
import 'helpers/real_test_helpers.dart';

/// Stress-test cross-module : login unique → saisies sur plusieurs modules
/// en une seule session → upload final.
///
/// Objectif : verifier que l'application gere correctement la coexistence
/// de donnees locales sur plusieurs modules (visites + observations), et
/// que la sync upload envoie correctement tout le backlog en une passe.
///
/// Pre-requis :
///   - TEST_MODULE_CODES=A,B,C dans .env.test (liste des modules a exercer).
///   - Chaque module doit etre disponible sur le GeoNature cible et
///     contenir au moins un groupe/site.
///
/// Lancement :
///   ./run_real_e2e_tests.sh cross-module                 # sans upload
///   ./run_real_e2e_tests.sh cross-module --with-upload   # avec upload final
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late RealE2ETestApp testApp;
  late RealE2EConfig config;

  // Nombre d'observations a creer par module.
  const observationsPerModule = 2;

  setUpAll(() {
    config = RealE2EConfig.load();
    debugPrint('=== Tests E2E Cross-Module ===');
    debugPrint('Serveur:       ${config.serverUrl}');
    debugPrint('Modules:       ${config.moduleCodes.join(", ")}');
    debugPrint('Obs / module:  $observationsPerModule');
    debugPrint('Upload final:  ${config.withUpload}');
  });

  setUp(() {
    testApp = RealE2ETestApp(config: config);
  });

  group('Cross-module stress (API reelle)', () {
    testWidgets(
      'Session unique → saisies sur ${RealE2EConfig.load().moduleCodes.length} modules'
      '${RealE2EConfig.load().withUpload ? ' → upload' : ''}',
      (tester) async {
        final modules = config.moduleCodes;
        if (modules.length < 2) {
          markTestSkipped(
              'Ce test necessite au moins 2 modules dans TEST_MODULE_CODES '
              '(actuellement : ${modules.join(", ")})');
          return;
        }

        // ----- 1. Login (une seule fois) -----
        await RealTestHelpers.loginAndReachHome(tester, testApp, config);

        final perModuleStats = <String, _ModuleResult>{};

        // ----- 2. Pour chaque module : download + open + saisies -----
        for (var i = 0; i < modules.length; i++) {
          final moduleCode = modules[i];
          debugPrint('');
          debugPrint(
              '===== Module ${i + 1}/${modules.length} : $moduleCode =====');

          final stopwatch = Stopwatch()..start();
          try {
            await _exerciseModule(
              tester,
              moduleCode: moduleCode,
              observationsCount: observationsPerModule,
            );
            stopwatch.stop();
            perModuleStats[moduleCode] = _ModuleResult(
              duration: stopwatch.elapsed,
              success: true,
            );
          } catch (e, stack) {
            stopwatch.stop();
            perModuleStats[moduleCode] = _ModuleResult(
              duration: stopwatch.elapsed,
              success: false,
              error: '$e',
            );
            debugPrint('ECHEC sur $moduleCode : $e');
            debugPrint('$stack');
            // On tente de retourner a la HomePage pour continuer avec le
            // module suivant. En cas d'echec de navigation, on sort.
            try {
              await RealTestHelpers.navigateBackToHome(tester);
            } catch (_) {
              rethrow;
            }
          }

          // Retourner a la HomePage pour le module suivant
          if (i < modules.length - 1) {
            await RealTestHelpers.navigateBackToHome(tester);
            await RealTestHelpers.pumpFor(
                tester, const Duration(seconds: 2));
          }
        }

        // ----- 3. Bilan par module -----
        debugPrint('');
        debugPrint('===== Bilan cross-module =====');
        for (final entry in perModuleStats.entries) {
          final r = entry.value;
          final status = r.success ? 'OK' : 'KO';
          debugPrint(
              '  [$status] ${entry.key} : ${r.duration.inSeconds}s'
              '${r.error != null ? " (${r.error})" : ""}');
        }

        final failures =
            perModuleStats.entries.where((e) => !e.value.success).toList();
        expect(failures, isEmpty,
            reason:
                'Echec sur les modules : ${failures.map((e) => e.key).toList()}');

        // ----- 4. Upload final (optionnel) -----
        if (config.withUpload) {
          debugPrint('');
          debugPrint('===== Upload final =====');
          await RealTestHelpers.navigateBackToHome(tester);
          await RealTestHelpers.triggerSyncUploadFromHome(tester);
        }

        debugPrint('===== Test cross-module termine =====');
      },
    );
  });
}

/// Deroule le parcours de saisie sur UN module :
///   download+open → premier groupe → premier site → Visites tab →
///   creer 1 visite → Observations tab → creer [observationsCount] observations.
///
/// Utilise presence=Non pour maximiser la vitesse (les champs requis sont
/// masques par la config du module dans ce cas).
Future<void> _exerciseModule(
  WidgetTester tester, {
  required String moduleCode,
  required int observationsCount,
}) async {
  await RealTestHelpers.downloadAndOpenModule(tester, moduleCode);

  // Groupe → Site
  final groupIcons = find.byIcon(Icons.visibility);
  await RealTestHelpers.waitForWidget(
    tester,
    groupIcons,
    timeout: const Duration(seconds: 15),
    description: 'icones visibility sur la page module $moduleCode',
  );
  await tester.tap(groupIcons.first);
  await RealTestHelpers.pumpFor(
      tester, const Duration(seconds: 3));

  final siteIcons = find.byIcon(Icons.visibility);
  await RealTestHelpers.waitForWidget(
    tester,
    siteIcons,
    timeout: const Duration(seconds: 15),
    description: 'icones visibility sur la page groupe de $moduleCode',
  );
  await tester.tap(siteIcons.first);
  await RealTestHelpers.pumpFor(
      tester, const Duration(seconds: 3));

  // Visites tab → creer une visite
  await RealTestHelpers.tapTab(tester, 'Visites');
  await RealTestHelpers.pumpFor(
      tester, const Duration(seconds: 2));

  final createVisit = find.byKey(const Key('create-visit-button'));
  await RealTestHelpers.waitForWidget(
    tester,
    createVisit,
    timeout: const Duration(seconds: 10),
    description: 'bouton create-visit-button sur $moduleCode',
  );
  await tester.tap(createVisit);
  await RealTestHelpers.pumpFor(
      tester, const Duration(seconds: 4));

  // Minimise les champs requis : presence=Non si le champ existe
  if (find.text('Non').evaluate().isNotEmpty) {
    await RealTestHelpers.tapRadioOption(tester, 'Non');
  }
  // Champs heritage POPAmphibien : expertise + num_passage + date.
  // num_passage est requis depuis #180 (commit 4d8ab29) qui a aligne le mobile
  // sur le web : seul `value` pre-remplit (plus `default`). Sur le serveur
  // reel, num_passage est un NumberField.
  try {
    await RealTestHelpers.selectFirstSelectOption(tester, 'expertise');
  } catch (_) {}
  try {
    await RealTestHelpers.enterFormField(tester, 'num_passage', '1',
        isRequired: true);
  } catch (_) {}
  try {
    await RealTestHelpers.pickFormDate(tester, 'visit_date_min',
        isRequired: true);
  } catch (_) {}
  await RealTestHelpers.tapFormSave(tester);
  await RealTestHelpers.pumpFor(
      tester, const Duration(seconds: 3));
  debugPrint('Visite creee sur $moduleCode');

  // Observations tab → creer N observations
  await RealTestHelpers.tapTab(tester, 'Observations');
  await RealTestHelpers.pumpFor(
      tester, const Duration(seconds: 2));

  for (var i = 0; i < observationsCount; i++) {
    debugPrint(
        'Observation ${i + 1}/$observationsCount sur $moduleCode');
    final addObs = find.byKey(const Key('add-observation-button'));
    await RealTestHelpers.waitForWidget(
      tester,
      addObs,
      timeout: const Duration(seconds: 10),
      description: 'bouton add-observation-button sur $moduleCode',
    );
    await tester.tap(addObs);
    await RealTestHelpers.pumpFor(
        tester, const Duration(seconds: 3));

    // presence=Non pour zapper les champs requis (taxon, stade, etc.)
    if (find.text('Non').evaluate().isNotEmpty) {
      await RealTestHelpers.tapRadioOption(tester, 'Non');
    }
    await RealTestHelpers.tapFormSave(tester);
    await RealTestHelpers.pumpFor(
        tester, const Duration(seconds: 2));
  }

  debugPrint(
      '$observationsCount observations creees sur $moduleCode');
}

class _ModuleResult {
  final Duration duration;
  final bool success;
  final String? error;

  _ModuleResult({
    required this.duration,
    required this.success,
    this.error,
  });
}
