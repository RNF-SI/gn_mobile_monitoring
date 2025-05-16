import 'package:gn_mobile_monitoring/domain/repository/local_storage_repository.dart';

abstract class GetApiUrlFromLocalStorageUseCase {
  Future<String?> execute();
}

class GetApiUrlFromLocalStorageUseCaseImpl
    implements GetApiUrlFromLocalStorageUseCase {
  final LocalStorageRepository _localStorageRepository;

  GetApiUrlFromLocalStorageUseCaseImpl(this._localStorageRepository);

  @override
  Future<String?> execute() async {
    return await _localStorageRepository.getApiUrl();
  }
}