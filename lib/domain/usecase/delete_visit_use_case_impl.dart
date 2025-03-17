import 'package:gn_mobile_monitoring/domain/repository/visit_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/delete_visit_use_case.dart';

class DeleteVisitUseCaseImpl implements DeleteVisitUseCase {
  final VisitRepository _visitRepository;

  const DeleteVisitUseCaseImpl(this._visitRepository);

  @override
  Future<bool> execute(int visitId) async {
    return await _visitRepository.deleteVisit(visitId);
  }
}