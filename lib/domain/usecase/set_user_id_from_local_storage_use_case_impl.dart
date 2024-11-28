import 'package:gn_mobile_monitoring/domain/repository/local_storage_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/set_user_id_from_local_storage_use_case.dart';

class SetUserIdFromLocalStorageUseCaseImpl
    implements SetUserIdFromLocalStorageUseCase {
  final LocalStorageRepository _repository;

  const SetUserIdFromLocalStorageUseCaseImpl(this._repository);

  @override
  Future<void> execute(final int userId) {
    return _repository.setUserId(userId);
  }
}
