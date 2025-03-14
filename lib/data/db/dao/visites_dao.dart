import 'package:drift/drift.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/data/db/tables/cor_visit_observer.dart';
import 'package:gn_mobile_monitoring/data/db/tables/t_base_visits.dart';
import 'package:gn_mobile_monitoring/data/db/tables/t_visit_complements.dart';

part 'visites_dao.g.dart';

@DriftAccessor(tables: [TBaseVisits, TVisitComplements, CorVisitObserver])
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
        await deleteVisitObservers(visitId);
        await deleteVisit(visitId);
      });
      
  // Méthodes pour gérer les observateurs de visite
  Future<List<CorVisitObserverData>> getVisitObservers(int visitId) =>
      (select(corVisitObserver)..where((t) => t.idBaseVisit.equals(visitId))).get();
      
  Future<int> insertVisitObserver(CorVisitObserverCompanion observer) =>
      into(corVisitObserver).insert(observer);
      
  Future<int> deleteVisitObservers(int visitId) =>
      (delete(corVisitObserver)..where((t) => t.idBaseVisit.equals(visitId))).go();
      
  Future<int> deleteVisitObserver(int visitId, int idRole) =>
      (delete(corVisitObserver)
        ..where((t) => t.idBaseVisit.equals(visitId) & t.idRole.equals(idRole)))
        .go();
        
  Future<void> replaceVisitObservers(int visitId, List<CorVisitObserverCompanion> observers) => 
      transaction(() async {
        await deleteVisitObservers(visitId);
        for (final observer in observers) {
          await insertVisitObserver(observer);
        }
      });
}
