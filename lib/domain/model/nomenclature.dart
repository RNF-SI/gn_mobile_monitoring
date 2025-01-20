import 'package:freezed_annotation/freezed_annotation.dart';

part 'nomenclature.freezed.dart';

@freezed
class Nomenclature with _$Nomenclature {
  const factory Nomenclature({
    required int id,
    required int idType,
    required String cdNomenclature,
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
    int? idBroader,
    String? hierarchy,
    bool? active,
    DateTime? metaCreateDate,
    DateTime? metaUpdateDate,
  }) = _Nomenclature;
}
