import 'package:gn_mobile_monitoring/data/entity/base_visit_entity.dart';

abstract class VisitRepository {
  /// Get all visits
  Future<List<BaseVisitEntity>> getAllVisits();

  /// Get a specific visit by ID
  Future<BaseVisitEntity> getVisitById(int id);

  /// Create a new visit
  /// Returns the ID of the created visit
  Future<int> createVisit(BaseVisitEntity visit);

  /// Update an existing visit
  /// Returns true if the update was successful
  Future<bool> updateVisit(BaseVisitEntity visit);

  /// Delete a visit and its complement if it exists
  /// Returns true if the deletion was successful
  Future<bool> deleteVisit(int id);

  /// Get visit complement data
  /// Returns null if no complement exists
  Future<String?> getVisitComplementData(int visitId);

  /// Save visit complement data
  /// Creates new or updates existing complement
  Future<void> saveVisitComplementData(int visitId, String data);

  /// Delete visit complement data
  Future<void> deleteVisitComplementData(int visitId);
}
