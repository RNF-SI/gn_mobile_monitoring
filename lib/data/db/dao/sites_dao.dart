import 'package:drift/drift.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/data/db/mapper/cor_site_module_mapper.dart';
import 'package:gn_mobile_monitoring/data/db/mapper/cor_sites_group_module_mapper.dart';
import 'package:gn_mobile_monitoring/data/db/mapper/t_base_site_mapper.dart';
import 'package:gn_mobile_monitoring/data/db/mapper/t_site_complement_mapper.dart';
import 'package:gn_mobile_monitoring/data/db/mapper/t_sites_group_mapper.dart';
import 'package:gn_mobile_monitoring/data/db/tables/cor_site_module.dart';
import 'package:gn_mobile_monitoring/data/db/tables/cor_sites_group_module.dart';
import 'package:gn_mobile_monitoring/data/db/tables/t_base_sites.dart';
import 'package:gn_mobile_monitoring/data/db/tables/t_sites_complements.dart';
import 'package:gn_mobile_monitoring/data/db/tables/t_sites_groups.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/site_complement.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';
import 'package:gn_mobile_monitoring/domain/model/site_module.dart';
import 'package:gn_mobile_monitoring/domain/model/sites_group_module.dart';

part 'sites_dao.g.dart';

@DriftAccessor(tables: [
  TBaseSites,
  TSiteComplements,
  TSitesGroups,
  CorSitesGroupModuleTable,
  CorSiteModuleTable
])
class SitesDao extends DatabaseAccessor<AppDatabase> with _$SitesDaoMixin {
  SitesDao(super.db);

  /// Operations for TBaseSites

  // Fetch all sites
  Future<List<BaseSite>> getAllSites() async {
    final dbSites = await select(tBaseSites).get();
    return dbSites.map((e) => e.toDomain()).toList();
  }
  
  // Get site by ID
  Future<BaseSite?> getSiteById(int siteId) async {
    final query = select(tBaseSites)
      ..where((tbl) => tbl.idBaseSite.equals(siteId));
    final result = await query.getSingleOrNull();
    if (result == null) return null;
    return result.toDomain();
  }

  // Insert multiple sites
  Future<void> insertSites(List<BaseSite> sites) async {
    final dbEntities = sites.map((e) => e.toDatabaseEntity()).toList();
    await batch((batch) {
      batch.insertAll(tBaseSites, dbEntities);
    });
  }

  // Update a single site
  Future<void> updateSite(BaseSite site) async {
    final dbEntity = site.toDatabaseEntity();
    await update(tBaseSites).replace(dbEntity);
  }

  // Delete a single site
  Future<void> deleteSite(int siteId) async {
    await (delete(tBaseSites)..where((tbl) => tbl.idBaseSite.equals(siteId)))
        .go();
  }

  // Clear all sites
  Future<void> clearSites() async {
    try {
      await delete(tBaseSites).go();
    } catch (e) {
      throw Exception("Failed to clear sites: ${e.toString()}");
    }
  }

  /// Operations for TSiteComplements

  // Fetch all site complements
  Future<List<SiteComplement>> getAllComplements() async {
    final dbComplements = await select(tSiteComplements).get();
    return dbComplements.map((e) => e.toDomain()).toList();
  }

  // Insert multiple site complements
  Future<void> insertComplements(List<SiteComplement> complements) async {
    final dbEntities = complements.map((e) => e.toDatabaseEntity()).toList();
    await batch((batch) {
      batch.insertAll(tSiteComplements, dbEntities, mode: InsertMode.insertOrReplace);
    });
  }

  // Clear all site complements
  Future<void> clearComplements() async {
    try {
      await delete(tSiteComplements).go();
    } catch (e) {
      throw Exception("Failed to clear site complements: ${e.toString()}");
    }
  }
  
  // Delete a site complement
  Future<void> deleteSiteComplement(int siteId) async {
    try {
      await (delete(tSiteComplements)
            ..where((tbl) => tbl.idBaseSite.equals(siteId)))
          .go();
    } catch (e) {
      throw Exception("Failed to delete site complement for site $siteId: ${e.toString()}");
    }
  }

  /// Operations for TSitesGroups

  // Fetch all site groups
  Future<List<SiteGroup>> getAllGroups() async {
    final dbGroups = await select(tSitesGroups).get();
    return dbGroups.map((e) => e.toDomain()).toList();
  }

  // Insert multiple site groups
  Future<void> insertGroups(List<SiteGroup> groups) async {
    final dbEntities = groups.map((e) => e.toDatabaseEntity()).toList();
    await batch((batch) {
      batch.insertAll(tSitesGroups, dbEntities);
    });
  }

  // Update a single site group
  Future<void> updateSiteGroup(SiteGroup siteGroup) async {
    final dbEntity = siteGroup.toDatabaseEntity();
    await update(tSitesGroups).replace(dbEntity);
  }

  // Delete a single site group
  Future<void> deleteSiteGroup(int siteGroupId) async {
    await (delete(tSitesGroups)
          ..where((tbl) => tbl.idSitesGroup.equals(siteGroupId)))
        .go();
  }

  // Clear all site groups
  Future<void> clearGroups() async {
    try {
      await delete(tSitesGroups).go();
    } catch (e) {
      throw Exception("Failed to clear site groups: ${e.toString()}");
    }
  }

  Future<List<BaseSite>> getSitesForModule(int moduleId) async {
    // TODO: Implement this
    return [];
  }

  // Fetch all site groups for a specific module
  Future<List<SiteGroup>> getGroupsForModule(int moduleId) async {
    // TODO: Implement this
    return [];
  }

  Future<void> insertSitesGroupModules(List<SitesGroupModule> modules) async {
    final dbEntities = modules.map((e) => e.toDatabaseEntity()).toList();
    await batch((batch) {
      batch.insertAll(corSitesGroupModuleTable, dbEntities);
    });
  }

  Future<void> deleteSiteGroupModule(int siteGroupId, int moduleId) async {
    await (delete(corSitesGroupModuleTable)
          ..where((tbl) =>
              tbl.idSitesGroup.equals(siteGroupId) &
              tbl.idModule.equals(moduleId)))
        .go();
  }

  Future<List<SitesGroupModule>> getAllSiteGroupModules() async {
    final results = await select(corSitesGroupModuleTable).get();
    return results
        .map((e) => SitesGroupModule(
              idSitesGroup: e.idSitesGroup,
              idModule: e.idModule,
            ))
        .toList();
  }

  Future<void> clearSitesGroupModules() async {
    try {
      await delete(corSitesGroupModuleTable).go();
    } catch (e) {
      throw Exception("Failed to clear site group modules: ${e.toString()}");
    }
  }

  Future<List<SiteGroup>> getGroupsByModuleId(int moduleId) async {
    final query = select(corSitesGroupModuleTable).join([
      leftOuterJoin(
          tSitesGroups,
          tSitesGroups.idSitesGroup
              .equalsExp(corSitesGroupModuleTable.idSitesGroup))
    ]);
    query.where(corSitesGroupModuleTable.idModule.equals(moduleId));
    final results = await query.map((row) => row.readTable(tSitesGroups)).get();
    return results.map((e) => e.toDomain()).toList();
  }
  
  Future<List<SitesGroupModule>> getSiteGroupModulesBySiteGroupId(int siteGroupId) async {
    final query = select(corSitesGroupModuleTable)
      ..where((tbl) => tbl.idSitesGroup.equals(siteGroupId));
    final results = await query.get();
    return results
        .map((e) => SitesGroupModule(
              idSitesGroup: e.idSitesGroup,
              idModule: e.idModule,
            ))
        .toList();
  }

  Future<List<BaseSite>> getSitesByModuleId(int moduleId) async {
    final query = select(corSiteModuleTable).join([
      leftOuterJoin(tBaseSites,
          tBaseSites.idBaseSite.equalsExp(corSiteModuleTable.idBaseSite))
    ]);
    query.where(corSiteModuleTable.idModule.equals(moduleId));
    final results = await query.map((row) => row.readTable(tBaseSites)).get();
    return results.map((e) => e.toDomain()).toList();
  }

  Future<List<SiteModule>> getAllSiteModules() async {
    final results = await select(corSiteModuleTable).get();
    return results
        .map((e) => SiteModule(
              idSite: e.idBaseSite,
              idModule: e.idModule,
            ))
        .toList();
  }

  Future<void> insertSitesModules(List<SiteModule> modules) async {
    final dbEntities = modules.map((e) => e.toDatabaseEntity()).toList();
    await batch((batch) {
      batch.insertAll(corSiteModuleTable, dbEntities);
    });
  }
  
  Future<void> insertSiteModule(SiteModule module) async {
    final dbEntity = module.toDatabaseEntity();
    await into(corSiteModuleTable).insert(dbEntity);
  }

  Future<void> deleteSiteModule(int siteId, int moduleId) async {
    await (delete(corSiteModuleTable)
          ..where((tbl) =>
              tbl.idBaseSite.equals(siteId) & tbl.idModule.equals(moduleId)))
        .go();
  }

  Future<void> clearSitesModules() async {
    try {
      await delete(corSiteModuleTable).go();
    } catch (e) {
      throw Exception("Failed to clear site modules: ${e.toString()}");
    }
  }
  
  Future<List<SiteModule>> getSiteModulesByModuleId(int moduleId) async {
    final query = select(corSiteModuleTable)
      ..where((tbl) => tbl.idModule.equals(moduleId));
    final results = await query.get();
    return results
        .map((e) => SiteModule(
              idSite: e.idBaseSite,
              idModule: e.idModule,
            ))
        .toList();
  }
  
  Future<List<SiteModule>> getSiteModulesBySiteId(int siteId) async {
    final query = select(corSiteModuleTable)
      ..where((tbl) => tbl.idBaseSite.equals(siteId));
    final results = await query.get();
    return results
        .map((e) => SiteModule(
              idSite: e.idBaseSite,
              idModule: e.idModule,
            ))
        .toList();
  }

  /// Check if a site belongs to other modules besides the specified one
  Future<bool> siteHasOtherModuleReferences(int siteId, int excludeModuleId) async {
    final query = select(corSiteModuleTable)
      ..where((tbl) => tbl.idBaseSite.equals(siteId) & tbl.idModule.isNotValue(excludeModuleId));
    final results = await query.get();
    return results.isNotEmpty;
  }

  /// Check if a site group belongs to other modules besides the specified one
  Future<bool> siteGroupHasOtherModuleReferences(int siteGroupId, int excludeModuleId) async {
    final query = select(corSitesGroupModuleTable)
      ..where((tbl) => tbl.idSitesGroup.equals(siteGroupId) & tbl.idModule.isNotValue(excludeModuleId));
    final results = await query.get();
    return results.isNotEmpty;
  }

  /// Delete a site completely with all its related data (respects FK constraints)
  Future<void> deleteSiteCompletely(int siteId) async {
    // Delete site complement first (FK constraint)
    await deleteSiteComplement(siteId);
    
    // Then delete the site itself
    await deleteSite(siteId);
  }


  /// Get all sites that belong to a specific site group
  Future<List<BaseSite>> getSitesBySiteGroup(int siteGroupId) async {
    final query = select(tBaseSites).join([
      leftOuterJoin(
          tSiteComplements,
          tSiteComplements.idBaseSite.equalsExp(tBaseSites.idBaseSite))
    ]);
    query.where(tSiteComplements.idSitesGroup.equals(siteGroupId));
    final results = await query.map((row) => row.readTable(tBaseSites)).get();
    return results.map((e) => e.toDomain()).toList();
  }

  /// Get site complements for sites belonging to a specific module
  Future<List<SiteComplement>> getSiteComplementsByModuleId(int moduleId) async {
    final query = select(tSiteComplements).join([
      leftOuterJoin(
          corSiteModuleTable,
          corSiteModuleTable.idBaseSite.equalsExp(tSiteComplements.idBaseSite))
    ]);
    query.where(corSiteModuleTable.idModule.equals(moduleId));
    final results = await query.map((row) => row.readTable(tSiteComplements)).get();
    return results.map((e) => e.toDomain()).toList();
  }
}
