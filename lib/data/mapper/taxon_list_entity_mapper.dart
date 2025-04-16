import 'package:gn_mobile_monitoring/data/entity/taxon_list_entity.dart';
import 'package:gn_mobile_monitoring/domain/model/taxon_list.dart';

extension TaxonListEntityMapper on TaxonListEntity {
  TaxonList toDomain() {
    return TaxonList(
      idListe: idListe,
      codeListe: codeListe,
      nomListe: nomListe,
      descListe: descListe,
      regne: regne,
      group2Inpn: group2Inpn,
    );
  }
}

extension DomainTaxonListEntityMapper on TaxonList {
  TaxonListEntity toEntity() {
    return TaxonListEntity(
      idListe: idListe,
      codeListe: codeListe,
      nomListe: nomListe,
      descListe: descListe,
      regne: regne,
      group2Inpn: group2Inpn,
    );
  }
}
