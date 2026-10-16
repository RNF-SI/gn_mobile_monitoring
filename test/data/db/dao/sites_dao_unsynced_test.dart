import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';

/// Tests de [SitesDao.getModuleIdsWithUnsyncedSitesOrGroups] (issue #204) :
/// un site ou un groupe créé sur l'appareil et pas encore téléversé doit
/// rendre son module « à téléverser », même sans visite.
void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  Future<void> insertSite(int id, int idModule,
      {required bool isLocal, int? serverSiteId}) async {
    // metaCreateDate/metaUpdateDate forcés à null : le défaut SQL
    // `CURRENT_TIMESTAMP` n'est pas lisible par Drift (cf. migration 029).
    await db.into(db.tBaseSites).insert(TBaseSitesCompanion.insert(
          idBaseSite: Value(id),
          baseSiteName: Value('Site $id'),
          isLocal: Value(isLocal),
          serverSiteId: Value(serverSiteId),
          metaCreateDate: const Value(null),
          metaUpdateDate: const Value(null),
        ));
    await db.into(db.corSiteModuleTable).insert(
        CorSiteModuleTableCompanion.insert(idBaseSite: id, idModule: idModule));
  }

  Future<void> insertGroup(int id, int idModule,
      {required bool isLocal, int? serverSiteGroupId}) async {
    await db.into(db.tSitesGroups).insert(TSitesGroupsCompanion.insert(
          idSitesGroup: Value(id),
          sitesGroupName: Value('Group $id'),
          isLocal: Value(isLocal),
          serverSiteGroupId: Value(serverSiteGroupId),
          metaCreateDate: const Value(null),
          metaUpdateDate: const Value(null),
        ));
    await db.into(db.corSitesGroupModuleTable).insert(
        CorSitesGroupModuleTableCompanion.insert(
            idSitesGroup: id, idModule: idModule));
  }

  group('SitesDao.getModuleIdsWithUnsyncedSitesOrGroups (issue #204)', () {
    test('aucun module quand la base est vide', () async {
      expect(await db.sitesDao.getModuleIdsWithUnsyncedSitesOrGroups(),
          isEmpty);
    });

    test('site créé localement et pas encore envoyé → module retenu',
        () async {
      await insertSite(1, 10, isLocal: true);
      expect(await db.sitesDao.getModuleIdsWithUnsyncedSitesOrGroups(), {10});
    });

    test('groupe créé localement et pas encore envoyé → module retenu',
        () async {
      await insertGroup(1, 20, isLocal: true);
      expect(await db.sitesDao.getModuleIdsWithUnsyncedSitesOrGroups(), {20});
    });

    test('site ou groupe déjà envoyé (ID serveur connu) → ignoré', () async {
      await insertSite(1, 10, isLocal: true, serverSiteId: 501);
      await insertGroup(1, 20, isLocal: true, serverSiteGroupId: 601);
      expect(await db.sitesDao.getModuleIdsWithUnsyncedSitesOrGroups(),
          isEmpty);
    });

    test('site ou groupe téléchargé depuis le serveur → ignoré', () async {
      await insertSite(1, 10, isLocal: false);
      await insertGroup(1, 20, isLocal: false);
      expect(await db.sitesDao.getModuleIdsWithUnsyncedSitesOrGroups(),
          isEmpty);
    });

    test('union des modules concernés par des sites et des groupes', () async {
      await insertSite(1, 10, isLocal: true);
      await insertSite(2, 10, isLocal: true);
      await insertGroup(1, 20, isLocal: true);
      await insertSite(3, 30, isLocal: false);
      expect(
          await db.sitesDao.getModuleIdsWithUnsyncedSitesOrGroups(), {10, 20});
    });
  });
}
