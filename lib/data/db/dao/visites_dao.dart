import 'package:drift/drift.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/data/db/tables/t_base_visits.dart';
import 'package:gn_mobile_monitoring/data/db/tables/t_visit_complements.dart';

part 'visites_dao.g.dart';

@DriftAccessor(tables: [TBaseVisits, TVisitComplements])
class VisitesDao extends DatabaseAccessor<AppDatabase> with _$VisitesDaoMixin {
  VisitesDao(AppDatabase db) : super(db);

  Future<List<TBaseVisit>> getAllVisits() => select(tBaseVisits).get();

  Future<List<TBaseVisit>> getVisitsBySiteId(int siteId) =>
      (select(tBaseVisits)..where((t) => t.idBaseSite.equals(siteId))).get();

  Future<TBaseVisit> getVisitById(int id) =>
      (select(tBaseVisits)..where((t) => t.idBaseVisit.equals(id))).getSingle();

  Future<int> insertVisit(TBaseVisitsCompanion visit) =>
      into(tBaseVisits).insert(visit);

  Future<bool> updateVisit(TBaseVisitsCompanion visit) =>
      update(tBaseVisits).replace(visit);

  Future<int> deleteVisit(int id) =>
      (delete(tBaseVisits)..where((t) => t.idBaseVisit.equals(id))).go();

  Future<TVisitComplement?> getVisitComplementById(int visitId) =>
      (select(tVisitComplements)..where((t) => t.idBaseVisit.equals(visitId)))
          .getSingleOrNull();

  Future<int> insertVisitComplement(TVisitComplementsCompanion complement) =>
      into(tVisitComplements).insert(complement);

  Future<bool> updateVisitComplement(TVisitComplementsCompanion complement) =>
      update(tVisitComplements).replace(complement);

  Future<int> deleteVisitComplement(int visitId) =>
      (delete(tVisitComplements)..where((t) => t.idBaseVisit.equals(visitId)))
          .go();

  Future<void> deleteVisitWithComplement(int visitId) => transaction(() async {
        await deleteVisitComplement(visitId);
        await deleteVisit(visitId);
      });
}
