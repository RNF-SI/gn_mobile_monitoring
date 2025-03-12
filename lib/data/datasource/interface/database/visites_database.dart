import 'package:gn_mobile_monitoring/data/db/database.dart';

abstract class VisitesDatabase {
  /// Get all visits
  Future<List<TBaseVisit>> getAllVisits();
  
  /// Get all visits for a specific site
  Future<List<TBaseVisit>> getVisitsBySiteId(int siteId);

  /// Get a specific visit by ID
  Future<TBaseVisit> getVisitById(int id);

  /// Insert a new visit
  Future<int> insertVisit(TBaseVisitsCompanion visit);

  /// Update an existing visit
  Future<bool> updateVisit(TBaseVisitsCompanion visit);

  /// Delete a visit by ID
  Future<int> deleteVisit(int id);

  /// Get visit complement by visit ID
  Future<TVisitComplement?> getVisitComplementById(int visitId);

  /// Insert a new visit complement
  Future<int> insertVisitComplement(TVisitComplementsCompanion complement);

  /// Update an existing visit complement
  Future<bool> updateVisitComplement(TVisitComplementsCompanion complement);

  /// Delete a visit complement by visit ID
  Future<int> deleteVisitComplement(int visitId);

  /// Delete both visit and its complement in a single transaction
  Future<void> deleteVisitWithComplement(int visitId);
}
