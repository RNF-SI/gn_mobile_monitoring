import 'package:gn_mobile_monitoring/domain/repository/local_storage_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/clear_token_from_local_storage_use_case.dart';

class ClearTokenFromLocalStorageUseCaseImpl
    implements ClearTokenFromLocalStorageUseCase {
  final LocalStorageRepository _localStorageRepository;

  ClearTokenFromLocalStorageUseCaseImpl(this._localStorageRepository);

  @override
  Future<void> execute() async {
    await _localStorageRepository.clearToken();
  }
}
