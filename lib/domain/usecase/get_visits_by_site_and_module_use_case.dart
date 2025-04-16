import 'package:gn_mobile_monitoring/domain/model/base_visit.dart';

abstract class GetVisitsBySiteAndModuleUseCase {
  Future<List<BaseVisit>> execute(int siteId, int moduleId);
}
