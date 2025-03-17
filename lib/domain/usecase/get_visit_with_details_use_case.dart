import 'package:gn_mobile_monitoring/domain/model/base_visit.dart';

/// Use case for retrieving a visit with full details, including observers and module-specific data
abstract class GetVisitWithDetailsUseCase {
  /// Fetches a visit by its ID, including its complete data and observers
  /// [visitId] - The ID of the visit to retrieve
  Future<BaseVisit> execute(int visitId);
}