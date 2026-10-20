import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/config/config.dart';
import 'package:integration_test/integration_test.dart';

import '../e2e_test_app_real.dart';
import 'helpers/generic_form_filler.dart';
import 'helpers/real_test_helpers.dart';

/// Test E2E aller-retour : saisie dans l'app → téléversement → vérification
/// sur le serveur.
///
/// Contrairement à `real_sync_upload_e2e_test` (qui peut téléverser à vide),
/// ce scénario crée une visite et une observation marquées d'un identifiant
/// unique, les envoie, puis interroge le serveur pour vérifier qu'elles y sont
/// avec leurs champs (jeu de données, observateurs, champs spécifiques).
///
/// La vérification n'utilise que des lectures disponibles en monitoring 1.3.x
/// comme après la refonte (#513), pour valider les deux familles de routes
/// d'écriture.
///
/// Formulaires remplis pour POPAmphibien / POPReptile (présence/accessibilité
/// « Non » rend la plupart des champs facultatifs).
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late RealE2ETestApp testApp;
  late RealE2EConfig config;

  setUpAll(() {
    config = RealE2EConfig.load();
    debugPrint('=== Test E2E aller-retour téléversement ===');
    debugPrint('Serveur: ${config.serverUrl} / module: ${config.moduleCode}');
  });

  setUp(() {
    testApp = RealE2ETestApp(config: config);
  });

  testWidgets(
      'Saisir visite + observation → téléverser → retrouver sur le serveur',
      (tester) async {
    final marker = RealTestHelpers.uniqueName('E2E_UPLOAD');
    final moduleCode = config.moduleCode;

    // ----- 1. Login + module -----
    await RealTestHelpers.loginAndReachHome(tester, testApp, config);
    await RealTestHelpers.downloadAndOpenModule(tester, moduleCode);

    // ----- 2. (Groupe →) site → nouvelle visite -----
    await RealTestHelpers.openFirstSite(tester);

    await RealTestHelpers.tapTab(tester, 'Visites');
    await RealTestHelpers.pumpFor(tester, const Duration(seconds: 2));
    final createVisit = find.byKey(const Key('create-visit-button'));
    await RealTestHelpers.waitForWidget(tester, createVisit,
        timeout: const Duration(seconds: 10),
        description: 'bouton create-visit-button');
    await tester.tap(createVisit);
    await RealTestHelpers.pumpFor(tester, const Duration(seconds: 4));

    await GenericFormFiller.fillRequiredFields(tester,
        moduleCode: moduleCode);
    await RealTestHelpers.enterFormField(tester, 'comments', marker,
        isRequired: false);
    await RealTestHelpers.tapFormSave(tester);
    await RealTestHelpers.pumpFor(tester, const Duration(seconds: 5));
    RealTestHelpers.expectFormClosed(tester);
    debugPrint('Visite locale créée ($marker)');

    // ----- 3. Observation sur cette visite -----
    await RealTestHelpers.tapTab(tester, 'Observations');
    await RealTestHelpers.pumpFor(tester, const Duration(seconds: 2));
    final addObs = find.byKey(const Key('add-observation-button'));
    await RealTestHelpers.waitForWidget(tester, addObs,
        timeout: const Duration(seconds: 10),
        description: 'bouton add-observation-button');
    await tester.tap(addObs);
    await RealTestHelpers.pumpFor(tester, const Duration(seconds: 4));

    await GenericFormFiller.fillRequiredFields(tester,
        moduleCode: moduleCode);
    await RealTestHelpers.enterFormField(tester, 'comments', '$marker obs',
        isRequired: false);
    await RealTestHelpers.tapFormSave(tester);
    await RealTestHelpers.pumpFor(tester, const Duration(seconds: 5));
    RealTestHelpers.expectFormClosed(tester);
    debugPrint('Observation locale créée');

    // ----- 4. Téléversement -----
    await RealTestHelpers.navigateBackToHome(tester);
    await RealTestHelpers.triggerSyncUploadFromHome(tester,
        skipIfDownloadRequired: false);

    // ----- 5. Vérification côté serveur -----
    final dio = Dio(BaseOptions(baseUrl: Config.apiBase));
    final login = await dio.post('/auth/login',
        data: {'login': config.username, 'password': config.password});
    dio.options.headers['Authorization'] = 'Bearer ${login.data['token']}';

    // `/refacto/<module>/visits` existe en 1.3.x et après la refonte ;
    // tri par défaut : id décroissant.
    final visitsResp = await dio.get('/monitorings/refacto/$moduleCode/visits',
        queryParameters: {'limit': 100});
    final items = (visitsResp.data['items'] as List).cast<Map>();
    final visit = items.firstWhere(
      (v) => v['comments'] == marker,
      orElse: () => fail('Visite "$marker" absente du serveur après upload'),
    );
    final idVisit = visit['id_base_visit'] as int;
    debugPrint('Visite retrouvée sur le serveur : $idVisit');

    // Lecture détaillée : route legacy (1.3.x) ou nouvelle route.
    Map<String, dynamic> props;
    List observations;
    try {
      final r = await dio.get('/monitorings/visits/$moduleCode/$idVisit');
      props = Map<String, dynamic>.from(r.data as Map);
      final obsResp = await dio.get(
          '/monitorings/refacto/$moduleCode/observations',
          queryParameters: {'id_base_visit': idVisit});
      observations = obsResp.data['items'] as List;
    } on DioException catch (e) {
      if (e.response?.statusCode != 404) rethrow;
      final r = await dio.get('/monitorings/object/$moduleCode/visit/$idVisit',
          queryParameters: {'depth': 1});
      props = Map<String, dynamic>.from(r.data['properties'] as Map);
      // Les enfants sont abrégés (sans commentaires) : relire chaque
      // observation en entier.
      final children =
          ((r.data['children'] ?? {})['observation'] ?? []) as List;
      observations = [
        for (final child in children)
          (await dio.get(
                  '/monitorings/object/$moduleCode/observation/${child['id']}'))
              .data
      ];
    }

    Object? field(Map m, String key) => m[key] ?? (m['data'] as Map?)?[key];

    expect(props['id_dataset'], isNotNull,
        reason: 'la visite doit être rattachée à un jeu de données');
    expect((props['observers'] as List?)?.isNotEmpty, isTrue,
        reason: 'la visite doit avoir au moins un observateur');

    final obs = observations
        .map((o) => Map<String, dynamic>.from(
            (o is Map && o['properties'] is Map) ? o['properties'] : o as Map))
        .where((o) => o['comments'] == '$marker obs')
        .toList();
    expect(obs, hasLength(1),
        reason: 'l\'observation doit être sur le serveur, rattachée à la visite');
    debugPrint('Aller-retour vérifié : visite $idVisit + observation '
        '${obs.single['id_observation']}');
  });
}
