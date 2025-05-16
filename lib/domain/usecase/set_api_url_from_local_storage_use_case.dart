import 'package:gn_mobile_monitoring/domain/repository/local_storage_repository.dart';

abstract class SetApiUrlFromLocalStorageUseCase {
  Future<void> execute(String apiUrl);
}

class SetApiUrlFromLocalStorageUseCaseImpl
    implements SetApiUrlFromLocalStorageUseCase {
  final LocalStorageRepository _localStorageRepository;

  SetApiUrlFromLocalStorageUseCaseImpl(this._localStorageRepository);

  @override
  Future<void> execute(String apiUrl) async {
    await _localStorageRepository.setApiUrl(apiUrl);
  }
}