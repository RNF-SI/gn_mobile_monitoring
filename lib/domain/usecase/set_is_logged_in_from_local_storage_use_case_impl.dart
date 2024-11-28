import 'package:gn_mobile_monitoring/domain/repository/local_storage_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/set_is_logged_in_from_local_storage_use_case.dart';

class SetIsLoggedInFromLocalStorageUseCaseImpl
    implements SetIsLoggedInFromLocalStorageUseCase {
  final LocalStorageRepository _localStorageRepository;

  const SetIsLoggedInFromLocalStorageUseCaseImpl(this._localStorageRepository);

  @override
  Future<void> execute(bool value) async {
    await _localStorageRepository.setIsLoggedIn(value);
  }
}
