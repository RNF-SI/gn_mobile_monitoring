import 'package:gn_mobile_monitoring/domain/model/visit_complement.dart';
import 'package:gn_mobile_monitoring/domain/repository/visit_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_visit_complement_use_case.dart';

/// Implémentation du use case pour récupérer les données complémentaires d'une visite
class GetVisitComplementUseCaseImpl implements GetVisitComplementUseCase {
  final VisitRepository _visitRepository;

  GetVisitComplementUseCaseImpl(this._visitRepository);

  @override
  Future<VisitComplement?> execute(int visitId) async {
    return _visitRepository.getVisitComplementDomain(visitId);
  }
}