import 'package:freezed_annotation/freezed_annotation.dart';

part 'nomenclature_type.freezed.dart';

@freezed
class NomenclatureType with _$NomenclatureType {
  const factory NomenclatureType({
    required int idType,
    String? mnemonique,
    String? labelDefault,
    String? definitionDefault,
    String? labelFr,
    String? definitionFr,
    String? labelEn,
    String? definitionEn,
    String? labelEs,
    String? definitionEs,
    String? labelDe,
    String? definitionDe,
    String? labelIt,
    String? definitionIt,
    String? source,
    String? statut,
    DateTime? metaCreateDate,
    DateTime? metaUpdateDate,
  }) = _NomenclatureType;
}