import 'package:gn_mobile_monitoring/data/datasource/implementation/database/db.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/sites_database.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/data/mapper/base_site_entity_mapper.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/data/entity/base_site_entity.dart';
import 'package:gn_mobile_monitoring/data/db/mapper/t_site_complement_mapper.dart';
import 'package:gn_mobile_monitoring/domain/model/site_complement.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';
import 'package:gn_mobile_monitoring/domain/model/site_module.dart';
import 'package:gn_mobile_monitoring/domain/model/sites_group_module.dart';


class SitesDatabaseImpl implements SitesDatabase {
  Future<AppDatabase> get _database async => await DB.instance.database;

  /// TBaseSites
  @override
  Future<void> clearSites() async {
    final db = await _database;
    await db.sitesDao.clearSites();
  }

  @override
  Future<void> insertSites(List<BaseSite> sites) async {
    final db = await _database;
    await db.sitesDao.insertSites(sites);
  }
  
  @override
  Future<void> updateSite(BaseSite site) async {
    final db = await _database;
    await db.sitesDao.updateSite(site);
  }
  
  @override
  Future<void> deleteSite(int siteId) async {
    final db = await _database;
    await db.sitesDao.deleteSite(siteId);
  }

  @override
  Future<List<BaseSite>> getAllSites() async {
    final db = await _database;
    return await db.sitesDao.getAllSites();
  }

  /// TSiteComplements
  @override
  Future<void> clearSiteComplements() async {
    final db = await _database;
    await db.sitesDao.clearComplements();
  }

  @override
  Future<void> insertSiteComplements(List<SiteComplement> complements) async {
    final db = await _database;
    await db.sitesDao.insertComplements(complements);
  }

  @override
  Future<void> deleteSiteComplement(int siteId) async {
    final db = await _database;
    await db.sitesDao.deleteSiteComplement(siteId);
  }

  @override
  Future<List<SiteComplement>> getAllSiteComplements() async {
    final db = await _database;
    return await db.sitesDao.getAllComplements();
  }

  @override
  Future<List<SiteComplement>> getSiteComplementsByModuleId(int moduleId) async {
    final db = await _database;
    return await db.sitesDao.getSiteComplementsByModuleId(moduleId);
  }

  @override
  Future<bool> siteHasOtherModuleReferences(int siteId, int excludeModuleId) async {
    final db = await _database;
    return await db.sitesDao.siteHasOtherModuleReferences(siteId, excludeModuleId);
  }

  @override
  Future<bool> siteGroupHasOtherModuleReferences(int siteGroupId, int excludeModuleId) async {
    final db = await _database;
    return await db.sitesDao.siteGroupHasOtherModuleReferences(siteGroupId, excludeModuleId);
  }

  @override
  Future<void> deleteSiteCompletely(int siteId) async {
    final db = await _database;
    await db.sitesDao.deleteSiteCompletely(siteId);
  }

  /// TSitesGroups
  @override
  Future<void> clearSiteGroups() async {
    final db = await _database;
    await db.sitesDao.clearGroups();
  }

  @override
  Future<void> insertSiteGroups(List<SiteGroup> siteGroups) async {
    final db = await _database;
    await db.sitesDao.insertGroups(siteGroups);
  }
  
  @override
  Future<void> updateSiteGroup(SiteGroup siteGroup) async {
    final db = await _database;
    await db.sitesDao.updateSiteGroup(siteGroup);
  }
  
  @override
  Future<void> deleteSiteGroup(int siteGroupId) async {
    final db = await _database;
    await db.sitesDao.deleteSiteGroup(siteGroupId);
  }

  @override
  Future<List<SiteGroup>> getAllSiteGroups() async {
    final db = await _database;
    return await db.sitesDao.getAllGroups();
  }

  @override
  Future<List<BaseSite>> getSitesForModule(int moduleId) async {
    final db = await _database;
    return await db.sitesDao.getSitesForModule(moduleId);
  }

  @override
  Future<List<SiteGroup>> getSiteGroupsForModule(int moduleId) async {
    final db = await _database;
    return await db.sitesDao.getGroupsForModule(moduleId);
  }

  @override
  Future<void> clearAllSiteGroupModules() async {
    final db = await _database;
    await db.sitesDao.clearSitesGroupModules();
  }

@override
  Future<void> insertSiteGroupModule(SitesGroupModule siteGroupModule) async {
    final db = await _database;
    await db.sitesDao.insertSiteGroupModule(siteGroupModule);
  }

  @override
  Future<void> insertSiteGroupModules(List<SitesGroupModule> modules) async {
    final db = await _database;
    await db.sitesDao.insertSitesGroupModules(modules);
  }
  
  @override
  Future<void> deleteSiteGroupModule(int siteGroupId, int moduleId) async {
    final db = await _database;
    await db.sitesDao.deleteSiteGroupModule(siteGroupId, moduleId);
  }
  
  @override
  Future<List<SitesGroupModule>> getAllSiteGroupModules() async {
    final db = await _database;
    return await db.sitesDao.getAllSiteGroupModules();
  }

  @override
  Future<List<SiteGroup>> getSiteGroupsByModuleId(int moduleId) async {
    final db = await _database;
    return await db.sitesDao.getGroupsByModuleId(moduleId);
  }
  
  @override
  Future<List<SitesGroupModule>> getSiteGroupModulesBySiteGroupId(int siteGroupId) async {
    final db = await _database;
    return await db.sitesDao.getSiteGroupModulesBySiteGroupId(siteGroupId);
  }

  /// CorSitesModules
  @override
  Future<void> clearAllSiteModules() async {
    final db = await _database;
    await db.sitesDao.clearSitesModules();
  }

  @override
  Future<void> insertSiteModules(List<SiteModule> modules) async {
    final db = await _database;
    await db.sitesDao.insertSitesModules(modules);
  }
  
  @override
  Future<void> deleteSiteModule(int siteId, int moduleId) async {
    final db = await _database;
    await db.sitesDao.deleteSiteModule(siteId, moduleId);
  }

  @override
  Future<List<SiteModule>> getAllSiteModules() async {
    final db = await _database;
    return await db.sitesDao.getAllSiteModules();
  }
  
  @override
  Future<List<BaseSite>> getSitesByModuleId(int moduleId) async {
    final db = await _database;
    return await db.sitesDao.getSitesByModuleId(moduleId);
  }
  
  @override
  Future<List<SiteModule>> getSiteModulesBySiteId(int siteId) async {
    final db = await _database;
    return await db.sitesDao.getSiteModulesBySiteId(siteId);
  }
  
  @override
  Future<List<BaseSite>> getSitesBySiteGroup(int siteGroupId) async {
    final db = await _database;
    return await db.sitesDao.getSitesBySiteGroup(siteGroupId);
  }
  
  @override
  Future<int> insertSite(BaseSite site) async {
    final db = await _database;
    return await db.sitesDao.insertSite(site);
  }
  
  @override
  Future<int> insertSiteGroup(SiteGroup siteGroup) async {
    final db = await _database;
    return await db.sitesDao.insertSiteGroup(siteGroup);
  }
  
  @override
  Future<List<SiteModule>> getSiteModulesByModuleId(int moduleId) async {
    final db = await _database;
    return await db.sitesDao.getSiteModulesByModuleId(moduleId);
  }
  
  @override
  Future<void> insertSiteModule(SiteModule siteModule) async {
    final db = await _database;
    await db.sitesDao.insertSiteModule(siteModule);
  }

   @override
  Future<BaseSite?> getSiteById(int siteId) async {
    final db = await _database;
    return await db.sitesDao.getSitesById(siteId);
  }
  
  @override
  Future<BaseSiteEntity?> getSiteEntityById(int siteId) async {
    final db = await _database;
    final site = await db.sitesDao.getSiteEntityById(siteId);
    if (site == null) {
      return null;
    }

    final complement = await db.sitesDao
        .getSiteComplementById(site.idBaseSite);

    return site.toEntity(complement: complement);
  }

  @override
  Future<SiteGroup?> getSiteGroupById(int siteGroupId) async {
    final db = await _database;
    return await db.sitesDao.getSiteGroupById(siteGroupId);
  }

  @override
  Future<void> updateSiteServerId(int localSiteId, int serverSiteId) async {
    final db = await _database;
    await db.sitesDao.updateSiteServerId(localSiteId, serverSiteId);
  }

  @override
  Future<void> updateSiteGroupServerId(int localSiteGroupId, int serverSiteGroupId) async {
    final db = await _database;
    await db.sitesDao.updateSiteGroupServerId(localSiteGroupId, serverSiteGroupId);
  }

  @override
  Future<void> updateSiteComplementsGroupId(int oldGroupId, int newGroupId) async {
    final db = await _database;
    await db.sitesDao.updateSiteComplementsGroupId(oldGroupId, newGroupId);
  }

  @override
  Future<SiteComplement?> getSiteComplementBySiteId(int siteId) async {
    final db = await _database;
    final complement = await db.sitesDao.getSiteComplementById(siteId);
    return complement?.toDomain();
  }
}

/// Extension pour ajouter la méthode copyWith à BaseSiteEntity
extension BaseSiteEntityExtension on BaseSiteEntity {
  BaseSiteEntity copyWith({
  int? idBaseSite,
  String? baseSiteName,
  String? baseSiteDescription,
  String? baseSiteCode,
  DateTime? firstUseDate,
  String? geom, // GeoJSON representation
  String? uuidBaseSite,
  int? altitudeMin,
  int? altitudeMax,
  DateTime? metaCreateDate,
  DateTime? metaUpdateDate,
  Map<String, dynamic>? data, // Données complémentaires
  }) {
    return BaseSiteEntity(
      idBaseSite: idBaseSite ?? this.idBaseSite,
      baseSiteName: baseSiteName ?? this.baseSiteName,
      baseSiteDescription: baseSiteDescription ?? this.baseSiteDescription,
      baseSiteCode: baseSiteCode ?? this.baseSiteCode,
      firstUseDate: firstUseDate ?? this.firstUseDate,
      geom: geom ?? this.geom,
      uuidBaseSite: uuidBaseSite ?? this.uuidBaseSite,
      altitudeMin: altitudeMin ?? this.altitudeMin,
      altitudeMax: altitudeMax ?? this.altitudeMax,
      metaCreateDate: metaCreateDate ?? this.metaCreateDate,
      metaUpdateDate: metaUpdateDate ?? this.metaUpdateDate,
      data: data ?? this.data,
    );
  }
}
