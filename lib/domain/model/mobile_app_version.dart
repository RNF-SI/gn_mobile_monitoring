import 'package:freezed_annotation/freezed_annotation.dart';

part 'mobile_app_version.freezed.dart';

@freezed
class MobileAppVersion with _$MobileAppVersion {
  const factory MobileAppVersion({
    required int idMobileApp,
    required String appCode,
    String? package,
    required String versionCode,
    String? urlApk,
  }) = _MobileAppVersion;
}
