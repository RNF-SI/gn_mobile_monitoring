class TaxonListEntity {
  final int idListe;
  final String? codeListe;
  final String nomListe;
  final String? descListe;
  final String? regne;
  final String? group2Inpn;

  TaxonListEntity({
    required this.idListe,
    this.codeListe,
    required this.nomListe,
    this.descListe,
    this.regne,
    this.group2Inpn,
  });
}