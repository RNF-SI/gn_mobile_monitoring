import 'package:freezed_annotation/freezed_annotation.dart';

part 'module_complement.freezed.dart';

@freezed
class ModuleComplement with _$ModuleComplement {
  const factory ModuleComplement({
    required int idModule,
    String? uuidModuleComplement,
    int? idListObserver,
    int? idListTaxonomy,
    @Default(true) bool bSynthese,
    @Default('nom_vern,lb_nom') String taxonomyDisplayFieldName,
    bool? bDrawSitesGroup,
    String? data,
  }) = _ModuleComplement;
}
