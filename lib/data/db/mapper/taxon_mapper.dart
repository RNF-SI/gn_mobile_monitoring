import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/domain/model/taxon.dart';

// Taxref mapper
extension TaxrefMapper on TTaxref {
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

extension DomainTaxrefMapper on Taxon {
  TTaxref toDatabaseEntity() {
    return TTaxref(
      cdNom: cdNom,
      cdRef: cdRef,
      idStatut: idStatut,
      idHabitat: idHabitat,
      idRang: idRang,
      nomComplet: nomComplet,
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
