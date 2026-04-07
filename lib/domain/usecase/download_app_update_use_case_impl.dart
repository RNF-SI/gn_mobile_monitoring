import 'package:gn_mobile_monitoring/domain/repository/app_update_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/download_app_update_use_case.dart';

class DownloadAppUpdateUseCaseImpl implements DownloadAppUpdateUseCase {
  final AppUpdateRepository _repository;

  DownloadAppUpdateUseCaseImpl(this._repository);

  @override
  Future<String> execute(String url,
      {String? token, Function(double)? onProgress}) {
    return _repository.downloadApk(url, token: token, onProgress: onProgress);
  }
}
