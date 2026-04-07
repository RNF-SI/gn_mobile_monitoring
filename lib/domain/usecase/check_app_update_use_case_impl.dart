import 'package:gn_mobile_monitoring/domain/model/mobile_app_version.dart';
import 'package:gn_mobile_monitoring/domain/repository/app_update_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/check_app_update_use_case.dart';
import 'package:package_info_plus/package_info_plus.dart';

class CheckAppUpdateUseCaseImpl implements CheckAppUpdateUseCase {
  final AppUpdateRepository _repository;

  /// Permet d'injecter le buildNumber local pour les tests
  final Future<String> Function()? _localBuildNumberProvider;

  CheckAppUpdateUseCaseImpl(this._repository,
      {Future<String> Function()? localBuildNumberProvider})
      : _localBuildNumberProvider = localBuildNumberProvider;

  @override
  Future<MobileAppVersion?> execute(String token) async {
    final remoteApp = await _repository.fetchRemoteAppVersion(token);
    if (remoteApp == null) return null;

    // Pas d'APK disponible au téléchargement
    if (remoteApp.urlApk == null || remoteApp.urlApk!.isEmpty) return null;

    // Récupérer le buildNumber local
    final localBuildNumber = _localBuildNumberProvider != null
        ? await _localBuildNumberProvider!()
        : (await PackageInfo.fromPlatform()).buildNumber;

    final localCode = int.tryParse(localBuildNumber) ?? 0;
    final remoteCode = int.tryParse(remoteApp.versionCode) ?? 0;

    if (remoteCode > localCode) {
      return remoteApp;
    }

    return null;
  }
}
