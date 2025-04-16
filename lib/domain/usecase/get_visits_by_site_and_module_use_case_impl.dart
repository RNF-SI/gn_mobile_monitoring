import 'package:gn_mobile_monitoring/data/mapper/visite_entity_mapper.dart';
import 'package:gn_mobile_monitoring/domain/model/base_visit.dart';
import 'package:gn_mobile_monitoring/domain/repository/visit_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_visits_by_site_and_module_use_case.dart';

class GetVisitsBySiteAndModuleUseCaseImpl
    implements GetVisitsBySiteAndModuleUseCase {
  final VisitRepository _visitRepository;

  GetVisitsBySiteAndModuleUseCaseImpl(this._visitRepository);

  @override
  Future<List<BaseVisit>> execute(int siteId, int moduleId) async {
    final visits =
        await _visitRepository.getVisitsBySiteIdAndModuleId(siteId, moduleId);
    return visits.map((visit) => visit.toDomain()).toList();
  }
}
