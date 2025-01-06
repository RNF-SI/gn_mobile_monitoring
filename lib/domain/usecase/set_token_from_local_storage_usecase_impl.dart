import 'package:gn_mobile_monitoring/domain/repository/local_storage_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/set_token_from_local_storage_usecase.dart';

class SetTokenFromLocalStorageUseCaseImpl
    implements SetTokenFromLocalStorageUseCase {
  final LocalStorageRepository _repository;

  const SetTokenFromLocalStorageUseCaseImpl(this._repository);

  @override
  Future<void> execute(final String token) {
    return _repository.setToken(token);
  }
}
