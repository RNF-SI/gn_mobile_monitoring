import 'package:gn_mobile_monitoring/domain/repository/modules_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/sync_modules_usecase.dart';

class SyncModulesUseCaseImpl implements SyncModulesUseCase {
  final ModulesRepository _repository;

  const SyncModulesUseCaseImpl(this._repository);

  @override
  Future<void> execute() async {
    await _repository.fetchAndSyncModulesFromApi();
  }
}
