import 'package:gn_mobile_monitoring/domain/repository/local_storage_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_token_from_local_storage_usecase.dart';

class GetTokenFromLocalStorageUseCaseImpl
    implements GetTokenFromLocalStorageUseCase {
  final LocalStorageRepository _repository;

  const GetTokenFromLocalStorageUseCaseImpl(this._repository);

  @override
  Future<String?> execute() {
    return _repository.getToken();
  }
}
