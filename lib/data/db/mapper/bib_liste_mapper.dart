// BibListes mapper
import 'package:drift/drift.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/domain/model/taxon_list.dart';

extension BibListesMapper on TBibListe {
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

extension DomainBibListesMapper on TaxonList {
  BibListesTableCompanion toDatabaseEntity() {
    return BibListesTableCompanion.insert(
      idListe: Value(idListe),
      codeListe: Value(codeListe),
      nomListe: nomListe,
      descListe: Value(descListe),
      regne: Value(regne),
      group2Inpn: Value(group2Inpn),
    );
  }
}
