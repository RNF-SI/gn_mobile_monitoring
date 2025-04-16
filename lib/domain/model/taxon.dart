import 'package:freezed_annotation/freezed_annotation.dart';

part 'taxon.freezed.dart';

@freezed
class Taxon with _$Taxon {
  const factory Taxon({
    required int cdNom,
    int? cdRef,
    String? idStatut,
    int? idHabitat,
    String? idRang,
    String? regne,
    String? phylum,
    String? classe,
    String? ordre,
    String? famille,
    String? sousFamille,
    String? tribu,
    int? cdTaxsup,
    int? cdSup,
    String? lbNom,
    String? lbAuteur,
    required String nomComplet,
    String? nomCompletHtml,
    String? nomVern,
    String? nomValide,
    String? nomVernEng,
    String? group1Inpn,
    String? group2Inpn,
    String? group3Inpn,
    String? url,
  }) = _Taxon;
}