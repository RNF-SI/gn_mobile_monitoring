import '../../domain/model/site_complement.dart';
import '../entity/site_complement_entity.dart';

extension SiteComplementEntityMapper on SiteComplementEntity {
  SiteComplement toDomain() {
    return SiteComplement(
      idBaseSite: idBaseSite,
      idSitesGroup: idSitesGroup,
      data: data,
    );
  }
}

extension SiteComplementMapper on SiteComplement {
  SiteComplementEntity toEntity() {
    return SiteComplementEntity(
      idBaseSite: idBaseSite,
      idSitesGroup: idSitesGroup,
      data: data,
    );
  }
}
