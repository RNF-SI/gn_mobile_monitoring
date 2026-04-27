import 'package:gn_mobile_monitoring/domain/repository/local_storage_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/set_dismissed_app_version_use_case.dart';

class SetDismissedAppVersionUseCaseImpl
    implements SetDismissedAppVersionUseCase {
  final LocalStorageRepository _repository;

  const SetDismissedAppVersionUseCaseImpl(this._repository);

  @override
  Future<void> execute(String? versionCode) {
    return _repository.setDismissedAppVersionCode(versionCode);
  }
}
