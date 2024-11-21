import 'package:freezed_annotation/freezed_annotation.dart';

part 'module.freezed.dart';

@freezed
class Module with _$Module {
  const factory Module(
      {required int idModule,
      required String moduleCode,
      required String moduleLabel,
      required String data}) = _Module;

  const Module._();
}
