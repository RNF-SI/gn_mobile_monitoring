import '../../domain/model/individual.dart';
import '../entity/individual_entity.dart';

/// Extension pour mapper une entité IndividualEntity vers un objet de domaine Individual
extension IndividualEntityMapper on IndividualEntity {
  Individual toDomain() {
    return Individual(
      idIndividual: idIndividual,
      idDigitiser: idDigitiser,
      cdNom: cdNom,
      comment: comment,
      individualName: individualName,
      idNomenclatureSex: idNomenclatureSex,
      activeIndividual: activeIndividual,
      uuidIndividual: uuidIndividual,
      metaCreateDate: metaCreateDate,
      metaUpdateDate: metaUpdateDate,
    );
  }
}

/// Extension pour mapper un objet de domaine Individual vers une entité IndividualEntity
extension IndividualMapper on Individual {
  IndividualEntity toEntity() {
    return IndividualEntity(
      idIndividual: idIndividual,
      idDigitiser: idDigitiser,
      cdNom: cdNom,
      comment: comment,
      individualName: individualName,
      idNomenclatureSex: idNomenclatureSex,
      activeIndividual: activeIndividual,
      uuidIndividual: uuidIndividual,
      metaCreateDate: metaCreateDate,
      metaUpdateDate: metaUpdateDate,
    );
  }
}

/// Extension pour créer un TIndividualsCompanion à partir d'une entité IndividualEntity
extension IndividualToCompanion on IndividualEntity {
  TIndividualsCompanion toCompanion() {
    return TIndividualsCompanion(
      idIndividual:
          idIndividual == 0 ? const Value.absent() : Value(idIndividual),
      idDigitiser:
          idDigitiser == null ? const Value.absent() : Value(idDigitiser),
      cdNom: cdNom == null ? const Value.absent() : Value(cdNom),
      comment: comment == null ? const Value.absent() : Value(comment),
      individualName:
          individualName == null ? const Value.absent() : Value(individualName),
      idNomenclatureSex: idNomenclatureSex == null
          ? const Value.absent()
          : Value(idNomenclatureSex),
      activeIndividual: Value(activeIndividual ?? true),
      uuidIndividual: uuidIndividual == null
          ? const Value.absent()
          : Value(uuidIndividual),
      serverIndividualId: serverIndividualId == null
          ? const Value.absent()
          : Value(serverIndividualId),
      metaCreateDate: const Value.absent(),
      metaUpdateDate: const Value.absent(),
    );
  }
}