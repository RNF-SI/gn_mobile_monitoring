import 'dart:io';

import 'package:dio/dio.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/mobile_app_api.dart';
import 'package:gn_mobile_monitoring/domain/model/mobile_app_version.dart';
import 'package:gn_mobile_monitoring/domain/repository/app_update_repository.dart';
import 'package:path_provider/path_provider.dart';

class AppUpdateRepositoryImpl implements AppUpdateRepository {
  static const String _appCode = 'MONITORING';

  final MobileAppApi _mobileAppApi;
  final Dio? _downloadDio;

  AppUpdateRepositoryImpl(this._mobileAppApi, {Dio? downloadDio})
      : _downloadDio = downloadDio;

  Dio get _dio => _downloadDio ?? Dio();

  @override
  Future<MobileAppVersion?> fetchRemoteAppVersion(String token) async {
    final apps = await _mobileAppApi.fetchMobileApps(token, _appCode);
    if (apps == null || apps.isEmpty) return null;

    // Chercher l'app MONITORING dans la liste
    for (final app in apps) {
      final code = app['app_code']?.toString() ?? '';
      if (code.toUpperCase() == _appCode) {
        final idMobileApp = app['id_mobile_app'];
        final versionCode = app['version_code']?.toString();
        if (idMobileApp == null || versionCode == null) continue;

        return MobileAppVersion(
          idMobileApp: idMobileApp is int ? idMobileApp : int.parse(idMobileApp.toString()),
          appCode: code,
          package: app['package']?.toString(),
          versionCode: versionCode,
          urlApk: app['url_apk']?.toString(),
        );
      }
    }

    return null;
  }

  @override
  Future<String> downloadApk(String url,
      {String? token, Function(double)? onProgress}) async {
    final tempDir = await getTemporaryDirectory();
    final filePath = '${tempDir.path}/monitoring_update.apk';

    await _dio.download(
      url,
      filePath,
      options: token != null
          ? Options(headers: {'Authorization': 'Bearer $token'})
          : null,
      onReceiveProgress: (received, total) {
        if (total > 0) {
          onProgress?.call(received / total);
        }
      },
    );

    return filePath;
  }
}
