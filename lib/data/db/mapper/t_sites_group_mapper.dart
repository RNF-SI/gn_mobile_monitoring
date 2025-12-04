import 'package:drift/drift.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';

/// Enlève le SRID d'une géométrie pour retourner du GeoJSON pur au domaine
String? _removeSridFromGeometry(String? geomWithSrid) {
  if (geomWithSrid == null || geomWithSrid.isEmpty) {
    return geomWithSrid;
  }
  
  // Si la géométrie commence par SRID=xxxx;, l'enlever
  final sridPattern = RegExp(r'^SRID=\d+;\s*');
  return geomWithSrid.replaceFirst(sridPattern, '');
}

extension TSitesGroupMapper on TSitesGroup {
  SiteGroup toDomain() {
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
      geom: _removeSridFromGeometry(geom),
      altitudeMin: altitudeMin,
      altitudeMax: altitudeMax,
    );
  }
}

extension SiteGroupMapper on SiteGroup {
  TSitesGroupsCompanion toDatabaseEntity() {
    return TSitesGroupsCompanion(
      // Pour les nouveaux groupes de sites (ID=0), utiliser Value.absent() pour laisser SQLite générer un ID
      idSitesGroup: idSitesGroup == 0 ? const Value.absent() : Value(idSitesGroup),
      sitesGroupName: Value(sitesGroupName),
      sitesGroupCode: Value(sitesGroupCode),
      sitesGroupDescription: Value(sitesGroupDescription),
      uuidSitesGroup: Value(uuidSitesGroup),
      comments: Value(comments),
      data: Value(data),
      metaCreateDate: Value(metaCreateDate),
      metaUpdateDate: Value(metaUpdateDate),
      idDigitiser: Value(idDigitiser),
      geom: Value(geom),
      altitudeMin: Value(altitudeMin),
      altitudeMax: Value(altitudeMax),
    );
  }
}
