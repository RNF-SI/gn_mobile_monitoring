import 'package:gn_mobile_monitoring/data/entity/base_visit_entity.dart';
import 'package:gn_mobile_monitoring/data/entity/cor_visit_observer_entity.dart';
import 'package:gn_mobile_monitoring/data/entity/visit_complement_entity.dart';
import 'package:gn_mobile_monitoring/domain/model/visit_complement.dart';

abstract class VisitRepository {
  /// Get all visits
  Future<List<BaseVisitEntity>> getAllVisits();
  
  /// Get all visits for a specific site
  Future<List<BaseVisitEntity>> getVisitsBySiteId(int siteId);

  /// Get a specific visit by ID
  Future<BaseVisitEntity> getVisitById(int id);
  
  /// Get a visit with complete details (including observers and complement data)
  Future<BaseVisitEntity> getVisitWithFullDetails(int id);

  /// Create a new visit
  /// Returns the ID of the created visit
  Future<int> createVisit(BaseVisitEntity visit);

  /// Update an existing visit
  /// Returns true if the update was successful
  Future<bool> updateVisit(BaseVisitEntity visit);

  /// Delete a visit and its complement if it exists
  /// Returns true if the deletion was successful
  Future<bool> deleteVisit(int id);

  /// Get visit complement data as raw string
  /// Returns null if no complement exists
  Future<String?> getVisitComplementData(int visitId);
  
  /// Get visit complement entity
  /// Returns null if no complement exists
  Future<VisitComplementEntity?> getVisitComplement(int visitId);
  
  /// Get visit complement as domain model
  /// Returns null if no complement exists
  Future<VisitComplement?> getVisitComplementDomain(int visitId);

  /// Save visit complement data as raw JSON string
  /// Creates new or updates existing complement
  Future<void> saveVisitComplementData(int visitId, String data);
  
  /// Save visit complement entity
  /// Creates new or updates existing complement
  Future<void> saveVisitComplement(VisitComplementEntity complement);
  
  /// Save visit complement domain model
  /// Creates new or updates existing complement
  Future<void> saveVisitComplementDomain(VisitComplement complement);

  /// Delete visit complement data
  Future<void> deleteVisitComplementData(int visitId);
  
  /// Get observers for a visit
  Future<List<CorVisitObserverEntity>> getVisitObservers(int visitId);
  
  /// Save observers for a visit (replaces all existing observers)
  Future<void> saveVisitObservers(int visitId, List<CorVisitObserverEntity> observers);
  
  /// Add a single observer to a visit
  Future<int> addVisitObserver(int visitId, int observerId);
  
  /// Remove all observers from a visit
  Future<void> clearVisitObservers(int visitId);
}
