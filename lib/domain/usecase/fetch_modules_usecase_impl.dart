import 'package:gn_mobile_monitoring/domain/repository/modules_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/fetch_modules_usecase.dart';

class FetchModulesUseCaseImpl implements FetchModulesUseCase {
  final ModulesRepository _modulesRepository;

  const FetchModulesUseCaseImpl(this._modulesRepository);

  @override
  Future<void> execute(String token) async {
    try {
      await _modulesRepository.fetchAndSyncModulesFromApi(token);
    } catch (e) {
      print('Error in FetchModulesUseCase: $e');
      rethrow;
    }
  }
}