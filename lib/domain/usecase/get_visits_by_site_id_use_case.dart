import 'package:gn_mobile_monitoring/domain/model/base_visit.dart';

abstract class GetVisitsBySiteIdUseCase {
  Future<List<BaseVisit>> execute(int siteId);
}
