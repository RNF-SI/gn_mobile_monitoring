import 'package:drift/drift.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';

extension TSitesGroupMapper on TSitesGroup {
  SiteGroup toDomain() {
    // Retirer le préfixe SRID=4326; si présent lors de la lecture
    String? cleanedGeom = geom;
    if (cleanedGeom != null && cleanedGeom.startsWith('SRID=4326;')) {
      cleanedGeom = cleanedGeom.substring(10); // Retirer "SRID=4326;"
    }

    return SiteGroup(
      idSitesGroup: idSitesGroup,
      sitesGroupName: sitesGroupName,
      sitesGroupCode: sitesGroupCode,
      sitesGroupDescription: sitesGroupDescription,
      uuidSitesGroup: uuidSitesGroup,
      comments: comments,
      data: data,
      metaCreateDate: metaCreateDate,
      metaUpdateDate: metaUpdateDate,
      idDigitiser: idDigitiser,
      geom: cleanedGeom,
      altitudeMin: altitudeMin,
      altitudeMax: altitudeMax,
      isLocal: isLocal,
      serverSiteGroupId: serverSiteGroupId,
    );
  }
}

extension SiteGroupMapper on SiteGroup {
  TSitesGroupsCompanion toDatabaseEntity() {
    // Ajouter le préfixe SRID=4326; si absent lors de l'insertion
    String? geomWithSrid = geom;
    if (geomWithSrid != null && !geomWithSrid.startsWith('SRID=4326;')) {
      geomWithSrid = 'SRID=4326;$geomWithSrid';
    }

    return TSitesGroupsCompanion(
      // Pour les nouveaux groupes de sites (ID=0), utiliser Value.absent() pour laisser SQLite générer un ID
      idSitesGroup:
          idSitesGroup == 0 ? const Value.absent() : Value(idSitesGroup),
      sitesGroupName: Value(sitesGroupName),
      sitesGroupCode: Value(sitesGroupCode),
      sitesGroupDescription: Value(sitesGroupDescription),
      uuidSitesGroup: Value(uuidSitesGroup),
      comments: Value(comments),
      data: Value(data),
      metaCreateDate: Value(metaCreateDate),
      metaUpdateDate: Value(metaUpdateDate),
      idDigitiser: Value(idDigitiser),
      geom: Value(geomWithSrid),
      altitudeMin: Value(altitudeMin),
      altitudeMax: Value(altitudeMax),
      isLocal: Value(isLocal),
      serverSiteGroupId: Value(serverSiteGroupId),
    );
  }
}
