import 'package:freezed_annotation/freezed_annotation.dart';

part 'individual.freezed.dart';

@freezed
class Individual with _$Individual {
  const factory Individual({
    required int idIndividual,
    int? idDigitiser,
    int? cdNom,
    String? comment,
    String? individualName,
    int? idNomenclatureSex,
    bool? activeIndividual,
    String? uuidIndividual,
    int? serverIndividualId,
    String? metaCreateDate,
    String? metaUpdateDate,
  }) = _Individual;
}
