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