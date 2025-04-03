import 'package:freezed_annotation/freezed_annotation.dart';

part 'taxon_list.freezed.dart';

@freezed
class TaxonList with _$TaxonList {
  const factory TaxonList({
    required int idListe,
    String? codeListe,
    required String nomListe,
    String? descListe,
    String? regne,
    String? group2Inpn,
  }) = _TaxonList;
}