import 'package:drift/drift.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/domain/model/individual.dart';

extension TIndividualMapper on TIndividual {
  Individual toDomain() {
    DateTime? parseDate(String? date) {
      if (date == null) return null;
      try {
        return DateTime.parse(date); // ISO8601 format
      } catch (e) {
        return null;
      }
    }

    return Individual(
      idIndividual: idIndividual,
      idDigitiser: idDigitiser,
      cdNom: cdNom,
      comment: comment,
      individualName: individualName,
      idNomenclatureSex: idNomenclatureSex,
      activeIndividual: activeIndividual ?? true,
      uuidIndividual: uuidIndividual,
      metaCreateDate: parseDate(metaCreateDate?.toIso8601String()),
      metaUpdateDate: parseDate(metaUpdateDate?.toIso8601String()),
      serverIndividualId: serverIndividualId, // 🔧 FIX: Ajouter le mapping du serverIndividualId
    );
  }
}

extension IndividualMapper on Individual {
  TIndividualsCompanion toDatabaseEntity() {
    return TIndividualsCompanion(
      idIndividual: Value(idIndividual),
      idDigitiser: 
          idDigitiser == null ? const Value.absent() : Value(idDigitiser),
      cdNom: Value(cdNom),
      comment: comment == null ? const Value.absent() : Value(comment),
      individualName: Value(individualName),
      idNomenclatureSex == null
          ? const Value.absent()
          : Value(idNomenclatureSex),
      activeIndividual: Value(activeIndividual ?? true),
      uuidIndividual: 
          uuidIndividual == null ? const Value.absent() : Value(uuidIndividual),
      serverIndividualId: serverIndividualId == null ? const Value.absent() : Value(serverIndividualId), // 🔧 FIX: Ajouter le mapping du serverIndividualId
      metaCreateDate: const Value.absent(),
      metaUpdateDate: const Value.absent(),
    );
  }
}
