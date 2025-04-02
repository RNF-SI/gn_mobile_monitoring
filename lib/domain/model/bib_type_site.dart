import 'package:freezed_annotation/freezed_annotation.dart';

part 'bib_type_site.freezed.dart';

@freezed
class BibTypeSite with _$BibTypeSite {
  const factory BibTypeSite({
    required int idNomenclatureTypeSite,
    Map<String, dynamic>? config,
  }) = _BibTypeSite;
}