import 'package:gn_mobile_monitoring/domain/repository/local_storage_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_user_id_from_local_storage_use_case.dart';

class GetUserIdFromLocalStorageUseCaseImpl
    implements GetUserIdFromLocalStorageUseCase {
  final LocalStorageRepository _repository;

  const GetUserIdFromLocalStorageUseCaseImpl(this._repository);

  @override
  Future<int> execute() {
    return _repository.getUserId();
  }
}
