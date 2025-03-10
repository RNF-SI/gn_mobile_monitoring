import 'package:gn_mobile_monitoring/domain/repository/modules_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/incremental_sync_modules_usecase.dart';

class IncrementalSyncModulesUseCaseImpl implements IncrementalSyncModulesUseCase {
  final ModulesRepository _modulesRepository;

  const IncrementalSyncModulesUseCaseImpl(this._modulesRepository);

  @override
  Future<void> execute(String token) async {
    try {
      await _modulesRepository.incrementalSyncModulesFromApi(token);
    } catch (e) {
      print('Error in IncrementalSyncModulesUseCase: $e');
      rethrow;
    }
  }
}