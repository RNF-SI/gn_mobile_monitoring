import 'package:freezed_annotation/freezed_annotation.dart';

part 'module_complement.freezed.dart';

@freezed
class ModuleComplement with _$ModuleComplement {
  const factory ModuleComplement({
    required int id,
    String? uuidModuleComplement,
    int? idListObserver,
    int? idListTaxonomy,
    bool? bSynthese,
    String? taxonomyDisplayFieldName,
    bool? bDrawSitesGroup,
    String? data,
  }) = _ModuleComplement;
}
