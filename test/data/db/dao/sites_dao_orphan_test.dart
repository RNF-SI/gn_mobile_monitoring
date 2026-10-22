import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';

/// Une association module ↔ groupe (ou site) dont l'objet a disparu ne doit
/// pas faire planter la lecture des groupes et sites du module : c'était le
/// cas après la suppression d'un groupe, et la connexion suivante échouait
/// (« Invalid table passed to readTable: t_sites_groups »).
void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  Future<void> insertGroup(int id, int idModule) async {
    await db.into(db.tSitesGroups).insert(TSitesGroupsCompanion.insert(
          idSitesGroup: Value(id),
          sitesGroupName: Value('Group $id'),
          metaCreateDate: const Value(null),
          metaUpdateDate: const Value(null),
        ));
    await db.into(db.corSitesGroupModuleTable).insert(
        CorSitesGroupModuleTableCompanion.insert(
            idSitesGroup: id, idModule: idModule));
  }

  test('supprimer un groupe retire aussi ses associations aux modules',
      () async {
    await insertGroup(1, 10);
    await insertGroup(2, 10);

    await db.sitesDao.deleteSiteGroup(1);

    final groups = await db.sitesDao.getGroupsByModuleId(10);
    expect(groups.map((g) => g.idSitesGroup), [2]);
    expect(await db.sitesDao.getSiteGroupModulesBySiteGroupId(1), isEmpty);
  });

  test('association vers un groupe absent : ignorée à la lecture', () async {
    await insertGroup(2, 10);
    await db.into(db.corSitesGroupModuleTable).insert(
        CorSitesGroupModuleTableCompanion.insert(idSitesGroup: 99, idModule: 10));

    final groups = await db.sitesDao.getGroupsByModuleId(10);
    expect(groups.map((g) => g.idSitesGroup), [2]);
  });

  test('association vers un site absent : ignorée à la lecture', () async {
    await db.into(db.tBaseSites).insert(TBaseSitesCompanion.insert(
          idBaseSite: const Value(1),
          baseSiteName: const Value('Site 1'),
          metaCreateDate: const Value(null),
          metaUpdateDate: const Value(null),
        ));
    for (final id in [1, 99]) {
      await db.into(db.corSiteModuleTable).insert(
          CorSiteModuleTableCompanion.insert(idBaseSite: id, idModule: 10));
    }

    final sites = await db.sitesDao.getSitesByModuleId(10);
    expect(sites.map((s) => s.idBaseSite), [1]);
  });
}
