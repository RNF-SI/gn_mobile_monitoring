import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/site_complement.dart';
import 'package:gn_mobile_monitoring/domain/model/site_module.dart';

/// Tests unitaires du DAO pour le filtrage des sites d'un groupe par module
/// (issue #169).
///
/// Scénario reproduit en base in-memory :
///   - 1 groupe "G1" (id=10) partagé entre 2 modules (m70, m12).
///   - 4 sites dans G1 :
///       * S1 (id=101), S2 (id=102) → liés à m70
///       * S3 (id=103), S4 (id=104) → liés à m12
///   - 1 groupe "G2" (id=20) mono-module m70 avec 2 sites (pour vérifier
///     qu'on ne filtre pas accidentellement trop large via le moduleId).
void main() {
  late AppDatabase db;

  const moduleM70 = 70;
  const moduleM12 = 12;
  const groupShared = 10;
  const groupControl = 20;

  final shared1 = BaseSite(idBaseSite: 101, baseSiteName: 'S1');
  final shared2 = BaseSite(idBaseSite: 102, baseSiteName: 'S2');
  final shared3 = BaseSite(idBaseSite: 103, baseSiteName: 'S3');
  final shared4 = BaseSite(idBaseSite: 104, baseSiteName: 'S4');
  final control1 = BaseSite(idBaseSite: 201, baseSiteName: 'C1');
  final control2 = BaseSite(idBaseSite: 202, baseSiteName: 'C2');

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());

    await db.sitesDao.insertSites(
        [shared1, shared2, shared3, shared4, control1, control2]);

    await db.sitesDao.insertComplements([
      const SiteComplement(idBaseSite: 101, idSitesGroup: groupShared),
      const SiteComplement(idBaseSite: 102, idSitesGroup: groupShared),
      const SiteComplement(idBaseSite: 103, idSitesGroup: groupShared),
      const SiteComplement(idBaseSite: 104, idSitesGroup: groupShared),
      const SiteComplement(idBaseSite: 201, idSitesGroup: groupControl),
      const SiteComplement(idBaseSite: 202, idSitesGroup: groupControl),
    ]);

    await db.sitesDao.insertSitesModules(const [
      SiteModule(idSite: 101, idModule: moduleM70),
      SiteModule(idSite: 102, idModule: moduleM70),
      SiteModule(idSite: 103, idModule: moduleM12),
      SiteModule(idSite: 104, idModule: moduleM12),
      SiteModule(idSite: 201, idModule: moduleM70),
      SiteModule(idSite: 202, idModule: moduleM70),
    ]);
  });

  tearDown(() async {
    await db.close();
  });

  group('SitesDao.getSitesBySiteGroupAndModule (issue #169)', () {
    test(
        'groupe partagé, module m70 → ne renvoie que les sites liés à m70 (S1, S2)',
        () async {
      final result =
          await db.sitesDao.getSitesBySiteGroupAndModule(groupShared, moduleM70);

      final ids = result.map((s) => s.idBaseSite).toSet();
      expect(ids, equals({101, 102}),
          reason: 'Seuls S1 et S2 sont sur m70 dans le groupe partagé');
      expect(result.length, 2);
    });

    test(
        'groupe partagé, module m12 → ne renvoie que les sites liés à m12 (S3, S4)',
        () async {
      final result =
          await db.sitesDao.getSitesBySiteGroupAndModule(groupShared, moduleM12);

      final ids = result.map((s) => s.idBaseSite).toSet();
      expect(ids, equals({103, 104}),
          reason: 'Seuls S3 et S4 sont sur m12 dans le groupe partagé');
      expect(result.length, 2);
    });

    test(
        'groupe mono-module → les 2 sites ressortent bien (pas de sur-filtrage)',
        () async {
      final result = await db.sitesDao
          .getSitesBySiteGroupAndModule(groupControl, moduleM70);

      final ids = result.map((s) => s.idBaseSite).toSet();
      expect(ids, equals({201, 202}));
      expect(result.length, 2);
    });

    test(
        'groupe mono-module interrogé sur un module sans lien → liste vide',
        () async {
      final result = await db.sitesDao
          .getSitesBySiteGroupAndModule(groupControl, moduleM12);

      expect(result, isEmpty);
    });

    test('l\'ancienne méthode sans filtre renvoie toujours tous les sites',
        () async {
      // Test de non-régression : getSitesBySiteGroup (sans moduleId) est
      // toujours utilisée hors contexte module (formulaires, carte).
      final result = await db.sitesDao.getSitesBySiteGroup(groupShared);
      expect(result.length, 4,
          reason: 'La méthode sans filtre doit rester inchangée');
    });
  });

  group('SitesDao.getOrphanSitesByModuleId (issue #157)', () {
    setUp(() async {
      // Ajouter sur moduleM70 :
      //   OrphanA (500) : aucune ligne t_sites_complements → orphelin
      //   OrphanB (501) : t_sites_complements avec idSitesGroup null → orphelin
      //   GroupedSite (502) : t_sites_complements avec idSitesGroup = groupShared
      await db.sitesDao.insertSites([
        BaseSite(idBaseSite: 500, baseSiteName: 'OrphanA'),
        BaseSite(idBaseSite: 501, baseSiteName: 'OrphanB'),
        BaseSite(idBaseSite: 502, baseSiteName: 'GroupedSite'),
      ]);

      await db.sitesDao.insertComplements(const [
        SiteComplement(idBaseSite: 501, idSitesGroup: null),
        SiteComplement(idBaseSite: 502, idSitesGroup: groupShared),
      ]);

      await db.sitesDao.insertSitesModules(const [
        SiteModule(idSite: 500, idModule: moduleM70),
        SiteModule(idSite: 501, idModule: moduleM70),
        SiteModule(idSite: 502, idModule: moduleM70),
      ]);
    });

    test('ne renvoie que les sites sans idSitesGroup (ou sans complement)',
        () async {
      final result =
          await db.sitesDao.getOrphanSitesByModuleId(moduleM70);
      final ids = result.map((s) => s.idBaseSite).toSet();

      expect(ids, containsAll({500, 501}),
          reason:
              'OrphanA (pas de complement) et OrphanB (idSitesGroup null) attendus');
      expect(ids.contains(502), isFalse,
          reason: 'GroupedSite ne doit pas apparaître');
      // Les sites du groupe shared (101..104) ont tous idSitesGroup non null
      expect(ids.any((id) => id >= 100 && id < 200), isFalse);
    });

    test('liste vide si le module n\'a aucun site orphelin', () async {
      final result =
          await db.sitesDao.getOrphanSitesByModuleId(moduleM12);
      // Sur moduleM12 : seuls les sites 103, 104 (tous deux dans groupShared)
      expect(result, isEmpty);
    });
  });
}
