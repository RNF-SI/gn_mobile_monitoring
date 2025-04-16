import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gn_mobile_monitoring/presentation/model/module_info.dart';

part 'module_info_list.freezed.dart';

@freezed
class ModuleInfoList with _$ModuleInfoList {
  const factory ModuleInfoList({required List<ModuleInfo> values}) =
      _ModuleInfoList;

  const ModuleInfoList._();

  operator [](final int index) => values[index];

  int get length => values.length;

  ModuleInfoList addModuleInfo(final ModuleInfo moduleInfo) =>
      copyWith(values: [...values, moduleInfo]);

  ModuleInfoList updateModuleInfo(final ModuleInfo newModuleInfo) {
    return copyWith(
        values: values
            .map((moduleInfo) => newModuleInfo.module == moduleInfo.module
                ? newModuleInfo
                : moduleInfo)
            .toList());
  }

  bool isEmpty() => values.isEmpty;
}
