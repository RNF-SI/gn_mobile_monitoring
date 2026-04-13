import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gn_mobile_monitoring/domain/model/module.dart';
import 'package:gn_mobile_monitoring/presentation/state/module_download_status.dart';

part 'module_info.freezed.dart';

@freezed
class ModuleInfo with _$ModuleInfo {
  const factory ModuleInfo({
    required Module module,
    required ModuleDownloadStatus downloadStatus,
    @Default(0.0)
    double downloadProgress, // Default to 0.0, indicating no progress
    @Default("")
    String currentStep, // Description of the current download step
  }) = _ModuleInfo;

  const ModuleInfo._();
}
