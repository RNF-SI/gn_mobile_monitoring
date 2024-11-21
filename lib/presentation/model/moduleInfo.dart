// import 'package:dendro3/domain/model/placette_list.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gn_mobile_monitoring/domain/model/module.dart';
import 'package:gn_mobile_monitoring/presentation/state/module_download_status.dart';

part 'moduleInfo.freezed.dart';

@freezed
class ModuleInfo with _$ModuleInfo {
  const factory ModuleInfo({
    required Module module,
    required ModuleDownloadStatus downloadStatus,
    @Default(0.0)
    double downloadProgress, // Default to 0.0, indicating no progress
  }) = _ModuleInfo;

  const ModuleInfo._();
}
