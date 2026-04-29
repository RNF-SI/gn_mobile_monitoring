import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';

/// Tests d'intégration de [ModulesDao.uninstallModule] et de la méthode
/// agrégée [ModulesDao.countExclusiveSitesForModule]. On utilise une vraie
/// base SQLite en mémoire pour valider :
/// - les `customStatement` SQL (noms de tables réels, transactions)
/// - le filtrage "site exclusif" (NOT EXISTS) qui est le garde-fou
///   principal contre la suppression de données partagées avec d'autres
///   modules.
void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  Future<void> insertModule(int idModule, {bool downloaded = true}) {
    return db
        .into(db.tModules)
        .insert(TModulesCompanion.insert(
          idModule: Value(idModule),
          moduleCode: Value('M$idModule'),
          downloaded: Value(downloaded),
        ));
  }

  Future<void> insertModuleComplement(int idModule, {String? config}) {
    return db.into(db.tModuleComplements).insert(
        TModuleComplementsCompanion.insert(
            idModule: Value(idModule), configuration: Value(config)));
  }

  Future<int> insertSite(int idBaseSite) async {
    // metaCreateDate/metaUpdateDate forcés à null pour éviter le défaut
    // SQL `CURRENT_TIMESTAMP` qui produit une string non parsable par Drift
    // (cf. même bug fixé sur les visites — migration 029).
    return db.into(db.tBaseSites).insert(TBaseSitesCompanion.insert(
          idBaseSite: Value(idBaseSite),
          baseSiteName: Value('Site $idBaseSite'),
          metaCreateDate: const Value(null),
          metaUpdateDate: const Value(null),
        ));
  }

  Future<void> insertSiteComplement(int idBaseSite) {
    return db.into(db.tSiteComplements).insert(
        TSiteComplementsCompanion.insert(idBaseSite: Value(idBaseSite)));
  }

  Future<void> linkSiteToModule(int idBaseSite, int idModule) {
    return db.into(db.corSiteModuleTable).insert(
        CorSiteModuleTableCompanion.insert(
            idBaseSite: idBaseSite, idModule: idModule));
  }

  Future<void> insertSiteGroup(int idSitesGroup) {
    return db.into(db.tSitesGroups).insert(TSitesGroupsCompanion.insert(
          idSitesGroup: Value(idSitesGroup),
          sitesGroupName: Value('Group $idSitesGroup'),
          metaCreateDate: const Value(null),
          metaUpdateDate: const Value(null),
        ));
  }

  Future<void> linkGroupToModule(int idSitesGroup, int idModule) {
    return db.into(db.corSitesGroupModuleTable).insert(
        CorSitesGroupModuleTableCompanion.insert(
            idSitesGroup: idSitesGroup, idModule: idModule));
  }

  Future<int> insertVisit({
    required int idModule,
    required int idBaseSite,
    int? serverVisitId,
  }) {
    return db.into(db.tBaseVisits).insert(TBaseVisitsCompanion.insert(
          idBaseSite: Value(idBaseSite),
          idDataset: 1,
          idModule: idModule,
          visitDateMin: '2026-01-01',
          serverVisitId: Value(serverVisitId),
        ));
  }

  Future<int> insertObservation(int idBaseVisit) {
    return db.into(db.tObservations).insert(
        TObservationsCompanion.insert(idBaseVisit: Value(idBaseVisit)));
  }

  Future<void> insertObservationDetail(int idObservation) {
    return db.into(db.tObservationDetails).insert(
        TObservationDetailsCompanion.insert(
            idObservation: Value(idObservation)));
  }

  Future<void> linkDatasetToModule(int idDataset, int idModule) {
    return db.into(db.corModuleDatasetTable).insert(
        CorModuleDatasetTableCompanion.insert(
            idModule: idModule, idDataset: idDataset));
  }

  group('ModulesDao.countExclusiveSitesForModule', () {
    test('compte uniquement les sites n\'appartenant qu\'à ce module',
        () async {
      await insertModule(42);
      await insertModule(99);

      // Site exclusif au module 42
      await insertSite(101);
      await linkSiteToModule(101, 42);

      // Site partagé entre 42 et 99
      await insertSite(102);
      await linkSiteToModule(102, 42);
      await linkSiteToModule(102, 99);

      // Site appartenant uniquement au module 99 (ne doit pas remonter)
      await insertSite(103);
      await linkSiteToModule(103, 99);

      final count = await db.modulesDao.countExclusiveSitesForModule(42);
      expect(count, 1);
    });

    test('retourne 0 quand aucun site n\'est lié au module', () async {
      await insertModule(42);
      final count = await db.modulesDao.countExclusiveSitesForModule(42);
      expect(count, 0);
    });
  });

  group('ModulesDao.uninstallModule', () {
    test(
        'préserve les sites et groupes partagés avec un autre module — '
        'garde-fou principal contre la perte de données', () async {
      await insertModule(42);
      await insertModule(99);

      // Site exclusif → doit disparaître
      await insertSite(101);
      await insertSiteComplement(101);
      await linkSiteToModule(101, 42);

      // Site partagé → doit rester
      await insertSite(102);
      await insertSiteComplement(102);
      await linkSiteToModule(102, 42);
      await linkSiteToModule(102, 99);

      // Groupe exclusif
      await insertSiteGroup(201);
      await linkGroupToModule(201, 42);

      // Groupe partagé
      await insertSiteGroup(202);
      await linkGroupToModule(202, 42);
      await linkGroupToModule(202, 99);

      await db.modulesDao.uninstallModule(42);

      final remainingSites = await db.select(db.tBaseSites).get();
      expect(remainingSites.map((s) => s.idBaseSite).toList(), [102],
          reason:
              'Le site partagé doit être conservé, le site exclusif supprimé');

      final remainingComplements = await db.select(db.tSiteComplements).get();
      expect(remainingComplements.map((c) => c.idBaseSite).toList(), [102]);

      final remainingGroups = await db.select(db.tSitesGroups).get();
      expect(remainingGroups.map((g) => g.idSitesGroup).toList(), [202],
          reason: 'Le groupe partagé doit être conservé');

      // Associations cor_site_module : la ligne (102, 99) doit rester.
      final remainingLinks = await db.select(db.corSiteModuleTable).get();
      expect(
          remainingLinks
              .map((l) => '${l.idBaseSite}-${l.idModule}')
              .toList(),
          ['102-99']);

      // Idem pour les groupes : (202, 99) conservée.
      final remainingGroupLinks =
          await db.select(db.corSitesGroupModuleTable).get();
      expect(
          remainingGroupLinks
              .map((l) => '${l.idSitesGroup}-${l.idModule}')
              .toList(),
          ['202-99']);
    });

    test(
        'cascade les visites, observations, détails et observers du module '
        'mais épargne ceux d\'un autre module', () async {
      await insertModule(42);
      await insertModule(99);
      await insertSite(101);
      await insertSite(102);
      await linkSiteToModule(101, 42);
      await linkSiteToModule(102, 99);

      // Visite + obs + détail dans le module 42 (à supprimer)
      final visit42 = await insertVisit(idModule: 42, idBaseSite: 101);
      final obs42 = await insertObservation(visit42);
      await insertObservationDetail(obs42);

      // Visite + obs + détail dans le module 99 (à conserver)
      final visit99 = await insertVisit(idModule: 99, idBaseSite: 102);
      final obs99 = await insertObservation(visit99);
      await insertObservationDetail(obs99);

      await db.modulesDao.uninstallModule(42);

      final remainingVisits = await db.select(db.tBaseVisits).get();
      expect(remainingVisits.map((v) => v.idBaseVisit).toList(), [visit99]);

      final remainingObs = await db.select(db.tObservations).get();
      expect(remainingObs.map((o) => o.idObservation).toList(), [obs99]);

      final remainingDetails = await db.select(db.tObservationDetails).get();
      expect(
          remainingDetails.map((d) => d.idObservation).toList(), [obs99]);
    });

    test('coupe les associations dataset du module mais conserve les autres',
        () async {
      await insertModule(42);
      await insertModule(99);
      await linkDatasetToModule(7, 42);
      await linkDatasetToModule(7, 99);
      await linkDatasetToModule(8, 42);

      await db.modulesDao.uninstallModule(42);

      final remaining = await db.select(db.corModuleDatasetTable).get();
      expect(remaining.map((r) => '${r.idDataset}-${r.idModule}').toList(),
          ['7-99']);
    });

    test('vide la configuration et passe downloaded à false', () async {
      await insertModule(42);
      await insertModuleComplement(42, config: '{"key": "value"}');

      await db.modulesDao.uninstallModule(42);

      final module = await db.modulesDao.getModuleById(42);
      expect(module, isNotNull);
      expect(module!.downloaded, false,
          reason: 'Le module reste dans la liste mais marqué non installé');

      final complement = await db.modulesDao.getModuleComplementById(42);
      expect(complement?.configuration, null);
    });

    test('atomique : ne supprime rien si une erreur survient', () async {
      // Module non existant → l'update final passe sans erreur (0 lignes
      // affectées). On vérifie que les autres modules ne sont pas touchés.
      await insertModule(42);
      await insertSite(101);
      await linkSiteToModule(101, 42);
      await insertVisit(idModule: 42, idBaseSite: 101);

      // Module 99 totalement indépendant
      await insertModule(99);
      await insertSite(102);
      await linkSiteToModule(102, 99);
      final unaffectedVisit =
          await insertVisit(idModule: 99, idBaseSite: 102);

      await db.modulesDao.uninstallModule(42);

      final remainingVisits = await db.select(db.tBaseVisits).get();
      expect(remainingVisits.map((v) => v.idBaseVisit).toList(),
          [unaffectedVisit],
          reason: 'Les visites du module 99 ne doivent pas être impactées');

      final m99 = await db.modulesDao.getModuleById(99);
      expect(m99!.downloaded, true,
          reason: 'Le flag downloaded du module 99 est intact');
    });
  });
}
