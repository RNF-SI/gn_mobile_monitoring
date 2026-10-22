import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:latlong2/latlong.dart';

import '../e2e_test_app_real.dart';
import 'helpers/generic_form_filler.dart';
import 'helpers/real_test_helpers.dart';

/// Test E2E aller-retour valable pour n'importe quel protocole : (groupe de
/// sites si le module en a) → site → visite → observation, saisis dans l'app
/// avec les champs obligatoires du protocole → téléversement → vérification
/// sur le serveur.
///
/// Les formulaires sont remplis par [GenericFormFiller] d'après la
/// configuration du module : aucun cas particulier par protocole. Le
/// marqueur unique est porté par le nom du site (et du groupe) et par les
/// commentaires de la visite et de l'observation quand le protocole a ce
/// champ.
///
/// Lectures via `/monitorings/refacto/<module>/...`, disponibles en
/// monitoring 1.3.x comme après la refonte (#513), sauf la liste des
/// observations, absente en 1.3.x : elles sont alors lues dans la visite.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late RealE2ETestApp testApp;
  late RealE2EConfig config;

  setUpAll(() {
    config = RealE2EConfig.load();
    debugPrint('=== Test E2E aller-retour générique ===');
    debugPrint('Serveur: ${config.serverUrl} / module: ${config.moduleCode}');
  });

  setUp(() {
    testApp = RealE2ETestApp(
        config: config, fakeLocation: const LatLng(45.2, 5.7));
  });

  testWidgets('Saisir site, visite, observation → téléverser → vérifier',
      (tester) async {
    final moduleCode = config.moduleCode;
    final marker = RealTestHelpers.uniqueName('E2E_GEN');
    final groupName = '${marker}_groupe';
    final siteName = '${marker}_site';

    await RealTestHelpers.loginAndReachHome(tester, testApp, config);
    await RealTestHelpers.downloadAndOpenModule(tester, moduleCode);

    // ----- 1. Groupe de sites, si le module en gère -----
    final createGroup = find.byKey(const Key('create-site-group-button'));
    final withGroup = createGroup.evaluate().isNotEmpty;
    if (withGroup) {
      await tester.tap(createGroup);
      await RealTestHelpers.pumpFor(tester, const Duration(seconds: 4));
      await RealTestHelpers.enterFormField(
          tester, 'sites_group_name', groupName,
          isRequired: true);
      await GenericFormFiller.fillRequiredFields(tester,
          moduleCode: moduleCode, text: marker);
      await _save(tester);
      await RealTestHelpers.waitForWidget(
          tester, find.textContaining(groupName),
          timeout: const Duration(seconds: 10),
          description: 'page du groupe créé');
    }
    debugPrint('Module ${withGroup ? 'avec' : 'sans'} groupes de sites');

    // ----- 2. Site -----
    final createSite = find.byKey(const Key('create-site-button'));
    await RealTestHelpers.waitForWidget(tester, createSite,
        timeout: const Duration(seconds: 10),
        description: 'bouton create-site-button');
    await tester.tap(createSite);
    await RealTestHelpers.pumpFor(tester, const Duration(seconds: 4));
    await RealTestHelpers.enterFormField(tester, 'base_site_name', siteName,
        isRequired: true);
    await GenericFormFiller.fillRequiredFields(tester,
        moduleCode: moduleCode, text: marker);
    await _save(tester);
    await RealTestHelpers.waitForWidget(
        tester, find.byKey(const Key('edit-site-button')),
        timeout: const Duration(seconds: 60), description: 'page du site créé');

    // ----- 3. Visite -----
    await RealTestHelpers.tapTab(tester, 'Visites');
    final createVisit = find.byKey(const Key('create-visit-button'));
    await RealTestHelpers.waitForWidget(tester, createVisit,
        timeout: const Duration(seconds: 10),
        description: 'bouton create-visit-button');
    await tester.tap(createVisit);
    await RealTestHelpers.pumpFor(tester, const Duration(seconds: 4));
    await _enterCommentIfAny(tester, marker);
    await GenericFormFiller.fillRequiredFields(tester,
        moduleCode: moduleCode, text: marker);
    await _save(tester);

    // ----- 4. Observation -----
    await RealTestHelpers.tapTab(tester, 'Observations');
    final addObs = find.byKey(const Key('add-observation-button'));
    await RealTestHelpers.waitForWidget(tester, addObs,
        timeout: const Duration(seconds: 10),
        description: 'bouton add-observation-button');
    await tester.tap(addObs);
    await RealTestHelpers.pumpFor(tester, const Duration(seconds: 4));
    await _enterCommentIfAny(tester, '$marker obs');
    await GenericFormFiller.fillRequiredFields(tester,
        moduleCode: moduleCode, text: marker);
    await _save(tester);

    // ----- 5. Téléversement -----
    await RealTestHelpers.navigateBackToHome(tester);
    await RealTestHelpers.triggerSyncUploadFromHome(tester,
        skipIfDownloadRequired: false);

    // ----- 6. Vérification sur le serveur -----
    final dio = await RealTestHelpers.serverClient(config);
    int? idGroup;
    if (withGroup) {
      final groups = await _list(
          dio, moduleCode, 'sites_groups', {'sites_group_name': groupName});
      expect(groups, hasLength(1), reason: 'groupe absent du serveur');
      idGroup = groups.single['id_sites_group'] as int;
    }
    final sites =
        await _list(dio, moduleCode, 'sites', {'base_site_name': siteName});
    expect(sites, hasLength(1), reason: 'site absent du serveur');
    final idSite = sites.single['id_base_site'] as int;
    if (withGroup) {
      expect(sites.single['id_sites_group'], idGroup,
          reason: 'site rattaché au groupe créé');
    }

    final visits =
        await _list(dio, moduleCode, 'visits', {'id_base_site': idSite});
    expect(visits, hasLength(1), reason: 'visite absente du serveur');
    final idVisit = visits.single['id_base_visit'] as int;
    final observations = await _observations(dio, moduleCode, idVisit);
    expect(observations, hasLength(1),
        reason: 'observation absente du serveur');
    debugPrint('Aller-retour vérifié ($moduleCode) : site $idSite, '
        'visite $idVisit, observation '
        '${observations.single['id_observation']}'
        '${withGroup ? ', groupe $idGroup' : ''}');
  });
}

Future<void> _save(WidgetTester tester) async {
  await RealTestHelpers.tapFormSave(tester);
  await RealTestHelpers.pumpFor(tester, const Duration(seconds: 5));
  RealTestHelpers.expectFormClosed(tester);
}

/// Commentaire marqueur, si le protocole a ce champ (facultatif).
Future<void> _enterCommentIfAny(WidgetTester tester, String text) async {
  if (find.byKey(const ValueKey('comments_false')).evaluate().isEmpty &&
      find.byKey(const ValueKey('comments_true')).evaluate().isEmpty) {
    return;
  }
  await RealTestHelpers.enterFormField(tester, 'comments', text,
      isRequired: false);
}

Future<List<Map<String, dynamic>>> _list(Dio dio, String moduleCode,
    String objects, Map<String, dynamic> filters) async {
  final resp = await dio.get('/monitorings/refacto/$moduleCode/$objects',
      queryParameters: {'limit': 100, ...filters});
  return (resp.data['items'] as List)
      .map((e) => Map<String, dynamic>.from(e as Map))
      .toList();
}

/// Observations de la visite : route `refacto` après la refonte, sinon les
/// enfants de la visite (monitoring 1.3.x).
Future<List<Map<String, dynamic>>> _observations(
    Dio dio, String moduleCode, int idVisit) async {
  try {
    return await _list(
        dio, moduleCode, 'observations', {'id_base_visit': idVisit});
  } on DioException catch (e) {
    if (e.response?.statusCode != 404) rethrow;
  }
  final resp = await dio.get('/monitorings/object/$moduleCode/visit/$idVisit',
      queryParameters: {'depth': 1});
  final children = (resp.data['children'] as Map?)?['observation'] as List?;
  return (children ?? const [])
      .map((e) => Map<String, dynamic>.from((e as Map)['properties'] as Map))
      .toList();
}
