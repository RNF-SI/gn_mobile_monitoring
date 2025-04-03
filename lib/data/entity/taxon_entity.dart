class TaxonEntity {
  final int cdNom;
  final int? cdRef;
  final String? idStatut;
  final int? idHabitat;
  final String? idRang;
  final String? regne;
  final String? phylum;
  final String? classe;
  final String? ordre;
  final String? famille;
  final String? sousFamille;
  final String? tribu;
  final int? cdTaxsup;
  final int? cdSup;
  final String? lbNom;
  final String? lbAuteur;
  final String nomComplet;
  final String? nomCompletHtml;
  final String? nomVern;
  final String? nomValide;
  final String? nomVernEng;
  final String? group1Inpn;
  final String? group2Inpn;
  final String? group3Inpn;
  final String? url;

  TaxonEntity({
    required this.cdNom,
    this.cdRef,
    this.idStatut,
    this.idHabitat,
    this.idRang,
    this.regne,
    this.phylum,
    this.classe,
    this.ordre,
    this.famille,
    this.sousFamille,
    this.tribu,
    this.cdTaxsup,
    this.cdSup,
    this.lbNom,
    this.lbAuteur,
    required this.nomComplet,
    this.nomCompletHtml,
    this.nomVern,
    this.nomValide,
    this.nomVernEng,
    this.group1Inpn,
    this.group2Inpn,
    this.group3Inpn,
    this.url,
  });
}