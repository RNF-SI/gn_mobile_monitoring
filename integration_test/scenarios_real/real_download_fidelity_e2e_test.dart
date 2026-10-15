import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:integration_test/integration_test.dart';

import '../e2e_test_app_real.dart';
import 'helpers/real_test_helpers.dart';

/// Test E2E de fidélité du téléchargement : après le téléchargement d'un
/// module, les groupes de sites et les sites enregistrés dans la base locale
/// doivent correspondre à ce que renvoie l'API (mêmes objets, mêmes champs).
///
/// `real_sync_download_e2e_test` vérifie seulement que la synchronisation se
/// termine sans erreur ; ce scénario vérifie le contenu, donc la lecture du
/// JSON serveur (code généré) et l'écriture en base (Drift).
///
/// Lectures via `/monitorings/refacto/<module>/sites(_groups)`, disponibles en
/// monitoring 1.3.x comme après la refonte (#513).
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late RealE2ETestApp testApp;
  late RealE2EConfig config;

  setUpAll(() {
    config = RealE2EConfig.load();
    debugPrint('=== Test E2E fidélité du téléchargement ===');
    debugPrint('Serveur: ${config.serverUrl} / module: ${config.moduleCode}');
  });

  setUp(() {
    testApp = RealE2ETestApp(config: config);
  });

  testWidgets('Sites et groupes téléchargés identiques à ceux du serveur',
      (tester) async {
    final moduleCode = config.moduleCode;

    await RealTestHelpers.loginAndReachHome(tester, testApp, config);
    await RealTestHelpers.downloadAndOpenModule(tester, moduleCode);

    final dio = await RealTestHelpers.serverClient(config);
    final db = await AppDatabase.getInstance();
    final module = await db.modulesDao.getModuleByCode(moduleCode);
    expect(module, isNotNull, reason: 'module $moduleCode absent en local');

    // ----- Groupes de sites -----
    final serverGroups = {
      for (final g in await _all(dio, moduleCode, 'sites_groups'))
        g['id_sites_group'] as int: g
    };
    final localGroups = {
      for (final g in await db.sitesDao.getGroupsByModuleId(module!.id))
        g.serverSiteGroupId ?? g.idSitesGroup: g
    };
    debugPrint('Groupes : serveur ${serverGroups.length}, '
        'local ${localGroups.length}');
    expect(localGroups.keys.toSet(), serverGroups.keys.toSet(),
        reason: 'les groupes locaux doivent être ceux du serveur');
    for (final id in serverGroups.keys) {
      final s = serverGroups[id]!;
      final l = localGroups[id]!;
      final where = 'groupe $id';
      expect(l.sitesGroupName, s['sites_group_name'], reason: '$where : nom');
      expect(l.sitesGroupCode, s['sites_group_code'], reason: '$where : code');
      expect(l.uuidSitesGroup, s['uuid_sites_group'], reason: '$where : uuid');
      _expectSameGeometry(l.geom, s['geometry'], where);
    }

    // ----- Sites -----
    final serverSites = {
      for (final site in await _all(dio, moduleCode, 'sites'))
        site['id_base_site'] as int: site
    };
    final localSites = {
      for (final site in await db.sitesDao.getSitesByModuleId(module.id))
        site.serverSiteId ?? site.idBaseSite: site
    };
    debugPrint('Sites : serveur ${serverSites.length}, '
        'local ${localSites.length}');
    expect(localSites.keys.toSet(), serverSites.keys.toSet(),
        reason: 'les sites locaux doivent être ceux du serveur');
    for (final id in serverSites.keys) {
      final s = serverSites[id]!;
      final l = localSites[id]!;
      final where = 'site $id';
      expect(l.baseSiteName, s['base_site_name'], reason: '$where : nom');
      expect(l.baseSiteCode, s['base_site_code'], reason: '$where : code');
      expect(l.uuidBaseSite, s['uuid_base_site'], reason: '$where : uuid');
      expect(_day(l.firstUseDate), s['first_use_date'],
          reason: '$where : date de première utilisation');
      _expectSameGeometry(l.geom, s['geometry'], where);

      final complement =
          await db.sitesDao.getSiteComplementById(l.idBaseSite);
      expect(complement?.idSitesGroup, s['id_sites_group'],
          reason: '$where : groupe de rattachement');
    }
    debugPrint('Fidélité vérifiée : ${serverGroups.length} groupes, '
        '${serverSites.length} sites');
  });
}

/// Toutes les pages d'une liste d'objets d'un module.
Future<List<Map<String, dynamic>>> _all(
    Dio dio, String moduleCode, String objects) async {
  final items = <Map<String, dynamic>>[];
  for (var page = 1;; page++) {
    final resp = await dio.get('/monitorings/refacto/$moduleCode/$objects',
        queryParameters: {'limit': 100, 'page': page});
    final batch = (resp.data['items'] as List)
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
    items.addAll(batch);
    if (items.length >= (resp.data['count'] as int) || batch.isEmpty) break;
  }
  return items;
}

String? _day(DateTime? date) =>
    date?.toIso8601String().substring(0, 10);

/// Compare deux géométries GeoJSON (chaînes ou objets) à 1e-6 près.
void _expectSameGeometry(String? local, Object? server, String where) {
  Map? parse(Object? g) => g == null
      ? null
      : g is String
          ? jsonDecode(g) as Map
          : g as Map;
  final l = parse(local);
  final s = parse(server);
  if (s == null) {
    expect(l, isNull, reason: '$where : géométrie absente du serveur');
    return;
  }
  expect(l, isNotNull, reason: '$where : géométrie absente en local');
  expect(l!['type'], s['type'], reason: '$where : type de géométrie');
  final lc = _flatten(l['coordinates']);
  final sc = _flatten(s['coordinates']);
  expect(lc.length, sc.length, reason: '$where : nombre de coordonnées');
  for (var i = 0; i < sc.length; i++) {
    expect(lc[i], closeTo(sc[i], 1e-6), reason: '$where : coordonnée $i');
  }
}

List<double> _flatten(Object? coords) => coords is List
    ? [for (final c in coords) ..._flatten(c)]
    : [(coords as num).toDouble()];
