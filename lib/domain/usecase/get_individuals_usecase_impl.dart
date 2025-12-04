import 'package:gn_mobile_monitoring/domain/model/individual.dart';
import 'package:gn_mobile_monitoring/domain/repository/individuals_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_individuals_usecase.dart';

class GetIndividualsUseCaseImpl implements GetIndividualsUseCase {
  final IndividualsRepository _individualsRepository;

  GetIndividualsUseCaseImpl(this._individualsRepository);

  @override
  Future<List<Individual>> execute() {
    return _individualsRepository.getIndividuals();
  }
}
