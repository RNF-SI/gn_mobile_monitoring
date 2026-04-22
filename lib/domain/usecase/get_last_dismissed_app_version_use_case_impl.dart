import 'package:gn_mobile_monitoring/domain/repository/local_storage_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_last_dismissed_app_version_use_case.dart';

class GetLastDismissedAppVersionUseCaseImpl
    implements GetLastDismissedAppVersionUseCase {
  final LocalStorageRepository _localStorageRepository;

  GetLastDismissedAppVersionUseCaseImpl(this._localStorageRepository);

  @override
  Future<String?> execute() async {
    return await _localStorageRepository.getLastDismissedAppVersionCode();
  }
}
