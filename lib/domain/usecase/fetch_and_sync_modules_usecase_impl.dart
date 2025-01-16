import 'package:gn_mobile_monitoring/domain/repository/modules_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/fetch_and_sync_modules_usecase.dart';

class FetchAndSyncModulesUseCaseImpl implements FetchAndSyncModulesUseCase {
  final ModulesRepository _repository;

  const FetchAndSyncModulesUseCaseImpl(this._repository);

  @override
  Future<void> execute(String token) async {
    await _repository.fetchAndSyncModulesFromApi(token);
  }
}
