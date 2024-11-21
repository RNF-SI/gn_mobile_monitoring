// import 'package:clean_architecture_todo_app/domain/model/todo_id.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gn_mobile_monitoring/domain/model/module.dart';

part 'module_liste.freezed.dart';

@freezed
class ModuleListe with _$ModuleListe {
  const factory ModuleListe({required List<Module> values}) = _ModuleListe;

  const ModuleListe._();

  operator [](final int index) => values[index];

  int get length => values.length;

  ModuleListe addModule(final Module module) =>
      copyWith(values: [...values, module]);

  ModuleListe updateModule(final Module newModule) {
    return copyWith(
        values: values
            .map((module) =>
                newModule.idModule == module.idModule ? newModule : module)
            .toList());
  }

  ModuleListe removeModuleById(final int id) => copyWith(
      values: values.where((module) => module.idModule != id).toList());

// TODO: Change searching disp in phone db
  // ModuleList filterByDownloaded() => copyWith(
  //     values: values.where((module) => module.isCompleted).toList());

  // ModuleList filterByIncomplete() => copyWith(
  //     values: values.where((module) => !module.isCompleted).toList());
}
