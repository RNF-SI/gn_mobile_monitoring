import 'package:gn_mobile_monitoring/data/entity/taxon_entity.dart';
import 'package:gn_mobile_monitoring/domain/model/taxon.dart';

extension TaxonEntityMapper on TaxonEntity {
  Taxon toDomain() {
    return Taxon(
      cdNom: cdNom,
      cdRef: cdRef,
      idStatut: idStatut,
      idHabitat: idHabitat,
      idRang: idRang,
      regne: regne,
      phylum: phylum,
      classe: classe,
      ordre: ordre,
      famille: famille,
      sousFamille: sousFamille,
      tribu: tribu,
      cdTaxsup: cdTaxsup,
      cdSup: cdSup,
      lbNom: lbNom,
      lbAuteur: lbAuteur,
      nomComplet: nomComplet,
      nomCompletHtml: nomCompletHtml,
      nomVern: nomVern,
      nomValide: nomValide,
      nomVernEng: nomVernEng,
      group1Inpn: group1Inpn,
      group2Inpn: group2Inpn,
      group3Inpn: group3Inpn,
      url: url,
    );
  }
}

extension DomainTaxonEntityMapper on Taxon {
  TaxonEntity toEntity() {
    return TaxonEntity(
      cdNom: cdNom,
      cdRef: cdRef,
      idStatut: idStatut,
      idHabitat: idHabitat,
      idRang: idRang,
      regne: regne,
      phylum: phylum,
      classe: classe,
      ordre: ordre,
      famille: famille,
      sousFamille: sousFamille,
      tribu: tribu,
      cdTaxsup: cdTaxsup,
      cdSup: cdSup,
      lbNom: lbNom,
      lbAuteur: lbAuteur,
      nomComplet: nomComplet,
      nomCompletHtml: nomCompletHtml,
      nomVern: nomVern,
      nomValide: nomValide,
      nomVernEng: nomVernEng,
      group1Inpn: group1Inpn,
      group2Inpn: group2Inpn,
      group3Inpn: group3Inpn,
      url: url,
    );
  }
}
