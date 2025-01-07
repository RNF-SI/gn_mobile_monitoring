import 'package:gn_mobile_monitoring/domain/repository/local_storage_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/clear_user_id_from_local_storage_use_case.dart';

class ClearUserIdFromLocalStorageUseCaseImpl
    implements ClearUserIdFromLocalStorageUseCase {
  final LocalStorageRepository _repository;

  const ClearUserIdFromLocalStorageUseCaseImpl(this._repository);

  @override
  Future<void> execute() async {
    await _repository.clearUserId();
  }
}
