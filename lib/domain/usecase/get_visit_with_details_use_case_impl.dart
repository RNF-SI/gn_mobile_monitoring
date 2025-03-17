import 'package:gn_mobile_monitoring/data/mapper/visite_entity_mapper.dart';
import 'package:gn_mobile_monitoring/domain/model/base_visit.dart';
import 'package:gn_mobile_monitoring/domain/repository/visit_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_visit_with_details_use_case.dart';

/// Implementation of the use case for retrieving a visit with full details
class GetVisitWithDetailsUseCaseImpl implements GetVisitWithDetailsUseCase {
  final VisitRepository _visitRepository;

  GetVisitWithDetailsUseCaseImpl(this._visitRepository);

  @override
  Future<BaseVisit> execute(int visitId) async {
    final visitEntity = await _visitRepository.getVisitWithFullDetails(visitId);
    return visitEntity.toDomain();
  }
}