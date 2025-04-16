import 'package:gn_mobile_monitoring/domain/model/visit_complement.dart';
import 'package:gn_mobile_monitoring/domain/repository/visit_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/save_visit_complement_use_case.dart';

/// Implémentation du use case pour sauvegarder les données complémentaires d'une visite
class SaveVisitComplementUseCaseImpl implements SaveVisitComplementUseCase {
  final VisitRepository _visitRepository;

  SaveVisitComplementUseCaseImpl(this._visitRepository);

  @override
  Future<void> execute(VisitComplement complement) async {
    await _visitRepository.saveVisitComplementDomain(complement);
  }
}