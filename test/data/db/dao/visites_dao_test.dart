import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  /// Construit une visite avec des champs minimums valides pour la table.
  TBaseVisitsCompanion buildVisit({
    required int idModule,
    required int? idBaseSite,
    required String visitDateMin,
    int? serverVisitId,
  }) {
    return TBaseVisitsCompanion.insert(
      idBaseSite: Value(idBaseSite),
      idDataset: 1,
      idModule: idModule,
      visitDateMin: visitDateMin,
      serverVisitId: Value(serverVisitId),
    );
  }

  group('VisitesDao.getVisitStatsForModule', () {
    test(
        'aggrège correctement nb_visits et last_visit par site pour le module '
        'demandé', () async {
      // Site 101 dans le module 42 : 2 visites aux 3 dates distinctes
      await db.visitesDao.insertVisit(buildVisit(
        idModule: 42,
        idBaseSite: 101,
        visitDateMin: '2026-01-15',
      ));
      await db.visitesDao.insertVisit(buildVisit(
        idModule: 42,
        idBaseSite: 101,
        visitDateMin: '2026-03-20',
      ));

      // Site 102 dans le module 42 : 1 visite
      await db.visitesDao.insertVisit(buildVisit(
        idModule: 42,
        idBaseSite: 102,
        visitDateMin: '2026-02-10',
      ));

      // Site 103 mais dans un AUTRE module : ne doit pas apparaître.
      await db.visitesDao.insertVisit(buildVisit(
        idModule: 99,
        idBaseSite: 103,
        visitDateMin: '2026-04-01',
      ));

      final stats = await db.visitesDao.getVisitStatsForModule(42);

      expect(stats.keys.toSet(), {101, 102});
      expect(stats[101]!.nbVisits, 2);
      expect(stats[101]!.lastVisit, DateTime.parse('2026-03-20'));
      expect(stats[102]!.nbVisits, 1);
      expect(stats[102]!.lastVisit, DateTime.parse('2026-02-10'));
    });

    test('ignore les visites dont id_base_site est NULL', () async {
      // Visite orpheline (saisie avant d'avoir un site rattaché, cas rare).
      await db.visitesDao.insertVisit(buildVisit(
        idModule: 42,
        idBaseSite: null,
        visitDateMin: '2026-01-01',
      ));
      await db.visitesDao.insertVisit(buildVisit(
        idModule: 42,
        idBaseSite: 101,
        visitDateMin: '2026-02-01',
      ));

      final stats = await db.visitesDao.getVisitStatsForModule(42);

      expect(stats.keys.toSet(), {101});
      expect(stats[101]!.nbVisits, 1);
    });

    test(
        'inclut les visites non téléversées (serverVisitId NULL) — c\'est '
        "toute la raison d'être du calcul local", () async {
      await db.visitesDao.insertVisit(buildVisit(
        idModule: 42,
        idBaseSite: 101,
        visitDateMin: '2026-04-23',
        serverVisitId: null, // pas encore uploadée
      ));

      final stats = await db.visitesDao.getVisitStatsForModule(42);

      expect(stats[101]!.nbVisits, 1);
      expect(stats[101]!.lastVisit, DateTime.parse('2026-04-23'));
    });

    test('retourne une Map vide si aucune visite pour ce module', () async {
      await db.visitesDao.insertVisit(buildVisit(
        idModule: 99,
        idBaseSite: 101,
        visitDateMin: '2026-01-01',
      ));

      final stats = await db.visitesDao.getVisitStatsForModule(42);

      expect(stats, isEmpty);
    });
  });
}
