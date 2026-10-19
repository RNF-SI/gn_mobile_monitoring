import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:integration_test/integration_test.dart';
import 'package:latlong2/latlong.dart';

import '../e2e_test_app_real.dart';
import 'helpers/real_test_helpers.dart';

/// Test E2E aller-retour des groupes de sites et des sites : création dans
/// l'app, sans visite → téléversement → vérification sur le serveur.
///
/// Vérifie côté serveur ce que les autres scénarios ne contrôlent pas :
/// rattachement du groupe au module, du site au groupe, géométrie (position
/// GPS fixée par le test), types de site et champs propres au protocole.
/// Vérifie aussi côté app que les identifiants serveur ont été enregistrés.
/// Sans visite, le module doit quand même être proposé au téléversement
/// (#204).
///
/// Lectures via `/monitorings/refacto/<module>/sites(_groups)`, disponibles en
/// monitoring 1.3.x comme après la refonte (#513). Les objets créés sont
/// supprimés du serveur en fin de test.
///
/// Formulaires remplis pour POPAmphibien / POPReptile.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Position arbitraire et reconnaissable, reprise telle quelle dans la
  // géométrie du site.
  const position = LatLng(45.123456, 5.654321);

  late RealE2ETestApp testApp;
  late RealE2EConfig config;

  setUpAll(() {
    config = RealE2EConfig.load();
    debugPrint('=== Test E2E aller-retour groupe + site ===');
    debugPrint('Serveur: ${config.serverUrl} / module: ${config.moduleCode}');
  });

  setUp(() {
    testApp = RealE2ETestApp(config: config, fakeLocation: position);
  });

  testWidgets(
      'Créer groupe + site sans visite → téléverser → vérifier sur le serveur',
      (tester) async {
    final moduleCode = config.moduleCode;
    final groupName = RealTestHelpers.uniqueName('E2E_RT_Group');
    final siteName = RealTestHelpers.uniqueName('E2E_RT_Site');

    // ----- 1. Login + module -----
    await RealTestHelpers.loginAndReachHome(tester, testApp, config);
    await RealTestHelpers.downloadAndOpenModule(tester, moduleCode);

    // ----- 2. Groupe de sites -----
    final createGroup = find.byKey(const Key('create-site-group-button'));
    await RealTestHelpers.waitForWidget(tester, createGroup,
        timeout: const Duration(seconds: 10),
        description: 'bouton create-site-group-button');
    await tester.tap(createGroup);
    await RealTestHelpers.pumpFor(tester, const Duration(seconds: 4));
    await RealTestHelpers.enterFormField(tester, 'sites_group_name', groupName,
        isRequired: true);
    await RealTestHelpers.fillSiteGroupSpecificFields(tester, moduleCode);
    await RealTestHelpers.tapFormSave(tester);
    await RealTestHelpers.pumpFor(tester, const Duration(seconds: 5));
    RealTestHelpers.expectFormClosed(tester);
    await RealTestHelpers.waitForWidget(tester, find.textContaining(groupName),
        timeout: const Duration(seconds: 10),
        description: 'page du groupe créé');
    debugPrint('Groupe local créé : $groupName');

    // ----- 3. Site dans ce groupe -----
    final createSite = find.byKey(const Key('create-site-button'));
    await RealTestHelpers.waitForWidget(tester, createSite,
        timeout: const Duration(seconds: 10),
        description: 'bouton create-site-button dans le groupe');
    await tester.tap(createSite);
    await RealTestHelpers.pumpFor(tester, const Duration(seconds: 4));
    await RealTestHelpers.enterFormField(tester, 'base_site_name', siteName,
        isRequired: true);
    await RealTestHelpers.pickFormDate(tester, 'first_use_date',
        isRequired: true);
    await RealTestHelpers.fillSiteSpecificFields(tester, moduleCode);
    await RealTestHelpers.tapFormSave(tester);
    await RealTestHelpers.pumpFor(tester, const Duration(seconds: 5));
    RealTestHelpers.expectFormClosed(tester);
    await RealTestHelpers.waitForWidget(
        tester, find.byKey(const Key('edit-site-button')),
        timeout: const Duration(seconds: 60), description: 'page du site créé');
    debugPrint('Site local créé : $siteName');

    // ----- 4. Téléversement -----
    await RealTestHelpers.navigateBackToHome(tester);
    await RealTestHelpers.triggerSyncUploadFromHome(tester,
        skipIfDownloadRequired: false);

    // ----- 5. Vérification côté serveur -----
    final dio = await RealTestHelpers.serverClient(config);
    final serverGroup = await _findOne(
        dio, moduleCode, 'sites_groups', 'sites_group_name', groupName);
    final idGroup = serverGroup['id_sites_group'] as int;
    final idModule = await _moduleId(dio, moduleCode);
    expect((serverGroup['modules'] as List?)?.contains(idModule), isTrue,
        reason: 'le groupe doit être rattaché au module $moduleCode');

    final serverSite =
        await _findOne(dio, moduleCode, 'sites', 'base_site_name', siteName);
    final idSite = serverSite['id_base_site'] as int;
    expect(serverSite['id_sites_group'], idGroup,
        reason: 'le site doit être rattaché au groupe créé');
    expect(serverSite['first_use_date'], isNotNull);
    expect((serverSite['types_site'] as List?)?.isNotEmpty, isTrue,
        reason: 'le site doit avoir au moins un type de site');

    final geometry =
        _geometry(serverSite['geometry'] ?? serverSite['geom']);
    expect(geometry['type'], 'Point');
    final coords = (geometry['coordinates'] as List).cast<num>();
    expect(coords[0], closeTo(position.longitude, 1e-5),
        reason: 'longitude du site');
    expect(coords[1], closeTo(position.latitude, 1e-5),
        reason: 'latitude du site');

    final specificKey =
        moduleCode == 'POPReptile' ? 'milieu_bordier' : 'milieu_aquatique';
    debugPrint('Champ propre au protocole ($specificKey) : '
        '${_field(serverSite, specificKey)}');
    debugPrint('Serveur : groupe $idGroup, site $idSite');

    // ----- 6. Identifiants serveur enregistrés côté app -----
    final db = await AppDatabase.getInstance();
    final localGroup = (await db.sitesDao.getAllGroups())
        .singleWhere((g) => g.sitesGroupName == groupName);
    expect(localGroup.serverSiteGroupId ?? localGroup.idSitesGroup, idGroup,
        reason: 'le groupe local doit connaître son identifiant serveur');
    final localSite = (await db.sitesDao.getAllSites())
        .singleWhere((s) => s.baseSiteName == siteName);
    expect(localSite.serverSiteId ?? localSite.idBaseSite, idSite,
        reason: 'le site local doit connaître son identifiant serveur');

    // ----- 7. Plus modifiables une fois envoyés -----
    // Choix assumé (#205) : un site ou un groupe envoyé n'est plus modifiable
    // sur le téléphone, et n'est donc jamais renvoyé (#211).
    expect(localSite.serverSiteId, isNotNull);
    expect(localGroup.serverSiteGroupId, isNotNull);

    // ----- 8. Nettoyage du serveur -----
    // Route de la nouvelle API, puis route d'avant la refonte (1.3.x).
    await _deleteQuietly(dio, [
      '/monitorings/refacto/$moduleCode/sites/$idSite',
      '/monitorings/sites/$idSite',
    ]);
    await _deleteQuietly(dio, [
      '/monitorings/refacto/$moduleCode/sites_groups/$idGroup',
      '/monitorings/sites_groups/$idGroup',
    ]);
  });
}

/// Liste filtrée d'objets d'un module (`sites` ou `sites_groups`).
Future<List<Map<String, dynamic>>> _list(Dio dio, String moduleCode,
    String objects, Map<String, dynamic> filters) async {
  final resp = await dio.get('/monitorings/refacto/$moduleCode/$objects',
      queryParameters: {'limit': 100, ...filters});
  return (resp.data['items'] as List)
      .map((e) => Map<String, dynamic>.from(e as Map))
      .toList();
}

/// Objet unique portant [value] dans [nameField] ; échoue s'il est absent ou
/// en double.
Future<Map<String, dynamic>> _findOne(Dio dio, String moduleCode,
    String objects, String nameField, String value) async {
  final items = await _list(dio, moduleCode, objects, {nameField: value});
  final matches = items.where((i) => i[nameField] == value).toList();
  expect(matches, hasLength(1),
      reason: '"$value" doit exister une seule fois dans $objects');
  return matches.single;
}

Future<int> _moduleId(Dio dio, String moduleCode) async {
  final modules = (await dio.get('/monitorings/modules')).data as List;
  final module = modules.firstWhere((m) => m['module_code'] == moduleCode);
  return module['id_module'] as int;
}

/// La géométrie est renvoyée en chaîne GeoJSON (1.3.x) ou en objet, sous
/// `geometry` ou `geom` (monitoring develop) selon la version.
Map<String, dynamic> _geometry(Object? raw) {
  if (raw is String) return Map<String, dynamic>.from(jsonDecode(raw) as Map);
  if (raw is Map) return Map<String, dynamic>.from(raw);
  fail('Géométrie absente ou illisible : $raw');
}

/// Champ propre au protocole : à plat ou dans `data` selon la version.
Object? _field(Map<String, dynamic> obj, String key) =>
    obj[key] ?? (obj['data'] as Map?)?[key];

/// Supprime via la première route de [paths] qui existe sur le serveur.
Future<void> _deleteQuietly(Dio dio, List<String> paths) async {
  for (final path in paths) {
    try {
      await dio.delete(path);
      return;
    } on DioException catch (e) {
      debugPrint('Nettoyage $path : ${e.response?.statusCode}');
    }
  }
}
