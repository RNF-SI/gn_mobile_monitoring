import 'package:gn_mobile_monitoring/domain/repository/local_storage_repository.dart';

abstract class ClearApiUrlFromLocalStorageUseCase {
  Future<void> execute();
}

class ClearApiUrlFromLocalStorageUseCaseImpl
    implements ClearApiUrlFromLocalStorageUseCase {
  final LocalStorageRepository _localStorageRepository;

  ClearApiUrlFromLocalStorageUseCaseImpl(this._localStorageRepository);

  @override
  Future<void> execute() async {
    await _localStorageRepository.clearApiUrl();
  }
}