import 'package:gn_mobile_monitoring/data/mapper/visite_entity_mapper.dart';
import 'package:gn_mobile_monitoring/domain/model/base_visit.dart';
import 'package:gn_mobile_monitoring/domain/repository/visit_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_visits_by_site_id_use_case.dart';

class GetVisitsBySiteIdUseCaseImpl implements GetVisitsBySiteIdUseCase {
  final VisitRepository _visitRepository;

  GetVisitsBySiteIdUseCaseImpl(this._visitRepository);

  @override
  Future<List<BaseVisit>> execute(int siteId) async {
    final visitEntities = await _visitRepository.getVisitsBySiteId(siteId);
    return visitEntities.map((entity) => entity.toDomain()).toList();
  }
}
