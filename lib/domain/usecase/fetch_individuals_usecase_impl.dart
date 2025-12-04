import 'package:gn_mobile_monitoring/domain/repository/individuals_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/fetch_individuals_usecase.dart';

class FetchIndividualsUseCaseImpl implements FetchIndividualsUseCase {
  final IndividualsRepository _individualsRepository;

  const FetchIndividualsUseCaseImpl(this._individualsRepository);

  @override
  Future<void> execute(String token) async {
    try {
      await _individualsRepository.fetchIndividualsAndIndividualModules(token);
    } catch (e) {
      print('Error in FetchindividualsUseCase: $e');
      rethrow;
    }
  }
}