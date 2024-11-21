import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gn_mobile_monitoring/presentation/model/moduleInfo.dart';

part 'moduleInfo_liste.freezed.dart';

@freezed
class ModuleInfoListe with _$ModuleInfoListe {
  const factory ModuleInfoListe({required List<ModuleInfo> values}) =
      _ModuleInfoListe;

  const ModuleInfoListe._();

  operator [](final int index) => values[index];

  int get length => values.length;

  ModuleInfoListe addModuleInfo(final ModuleInfo moduleInfo) =>
      copyWith(values: [...values, moduleInfo]);

  ModuleInfoListe updateModuleInfo(final ModuleInfo newModuleInfo) {
    return copyWith(
        values: values
            .map((moduleInfo) => newModuleInfo.module == moduleInfo.module
                ? newModuleInfo
                : moduleInfo)
            .toList());
  }

  bool isEmpty() => values.isEmpty;
}
