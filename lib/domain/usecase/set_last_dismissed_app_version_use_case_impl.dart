import 'package:gn_mobile_monitoring/domain/repository/local_storage_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/set_last_dismissed_app_version_use_case.dart';

class SetLastDismissedAppVersionUseCaseImpl
    implements SetLastDismissedAppVersionUseCase {
  final LocalStorageRepository _localStorageRepository;

  SetLastDismissedAppVersionUseCaseImpl(this._localStorageRepository);

  @override
  Future<void> execute(String versionCode) async {
    await _localStorageRepository.setLastDismissedAppVersionCode(versionCode);
  }
}
