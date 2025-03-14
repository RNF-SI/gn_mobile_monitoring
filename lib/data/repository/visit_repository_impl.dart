import 'package:drift/drift.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/visites_database.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/data/db/mapper/base_visit_mapper.dart';
import 'package:gn_mobile_monitoring/data/db/mapper/cor_visit_observer_mapper.dart';
import 'package:gn_mobile_monitoring/data/entity/base_visit_entity.dart';
import 'package:gn_mobile_monitoring/data/entity/cor_visit_observer_entity.dart';
import 'package:gn_mobile_monitoring/domain/repository/visit_repository.dart';

class VisitRepositoryImpl implements VisitRepository {
  final VisitesDatabase _visitesDatabase;

  VisitRepositoryImpl(this._visitesDatabase);

  @override
  Future<List<BaseVisitEntity>> getAllVisits() async {
    final visits = await _visitesDatabase.getAllVisits();
    return visits.map((visit) => visit.toEntity()).toList();
  }
  
  @override
  Future<List<BaseVisitEntity>> getVisitsBySiteId(int siteId) async {
    final visits = await _visitesDatabase.getVisitsBySiteId(siteId);
    return visits.map((visit) => visit.toEntity()).toList();
  }

  @override
  Future<BaseVisitEntity> getVisitById(int id) async {
    final visit = await _visitesDatabase.getVisitById(id);
    return visit.toEntity();
  }

  @override
  Future<int> createVisit(BaseVisitEntity visit) async {
    return _visitesDatabase.insertVisit(visit.toCompanion());
  }

  @override
  Future<bool> updateVisit(BaseVisitEntity visit) async {
    return _visitesDatabase.updateVisit(visit.toCompanion());
  }

  @override
  Future<bool> deleteVisit(int id) async {
    try {
      await _visitesDatabase.deleteVisitWithComplement(id);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<String?> getVisitComplementData(int visitId) async {
    final complement = await _visitesDatabase.getVisitComplementById(visitId);
    return complement?.data;
  }

  @override
  Future<void> saveVisitComplementData(int visitId, String data) async {
    final complement = TVisitComplementsCompanion(
      idBaseVisit: Value(visitId),
      data: Value(data),
    );

    try {
      await _visitesDatabase.insertVisitComplement(complement);
    } catch (_) {
      // If insert fails (due to unique constraint), try update
      await _visitesDatabase.updateVisitComplement(complement);
    }
  }

  @override
  Future<void> deleteVisitComplementData(int visitId) async {
    await _visitesDatabase.deleteVisitComplement(visitId);
  }
  
  @override
  Future<List<CorVisitObserverEntity>> getVisitObservers(int visitId) async {
    final observers = await _visitesDatabase.getVisitObservers(visitId);
    return observers.map((observer) => CorVisitObserverMapper.toEntity(observer)).toList();
  }
  
  @override
  Future<void> saveVisitObservers(int visitId, List<CorVisitObserverEntity> observers) async {
    final observerCompanions = observers.map((entity) => CorVisitObserverMapper.toCompanion(entity)).toList();
    await _visitesDatabase.replaceVisitObservers(visitId, observerCompanions);
  }
  
  @override
  Future<int> addVisitObserver(int visitId, int observerId) async {
    final entity = CorVisitObserverEntity(
      idBaseVisit: visitId,
      idRole: observerId,
      uniqueIdCoreVisitObserver: '', // L'ID sera généré automatiquement par la base de données
    );
    return _visitesDatabase.insertVisitObserver(CorVisitObserverMapper.toCompanion(entity));
  }
  
  @override
  Future<void> clearVisitObservers(int visitId) async {
    await _visitesDatabase.deleteVisitObservers(visitId);
  }
}
