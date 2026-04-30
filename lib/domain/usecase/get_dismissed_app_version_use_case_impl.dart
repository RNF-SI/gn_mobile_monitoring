import 'package:gn_mobile_monitoring/domain/repository/local_storage_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_dismissed_app_version_use_case.dart';

class GetDismissedAppVersionUseCaseImpl
    implements GetDismissedAppVersionUseCase {
  final LocalStorageRepository _repository;

  const GetDismissedAppVersionUseCaseImpl(this._repository);

  @override
  Future<String?> execute() {
    return _repository.getDismissedAppVersionCode();
  }
}
