import 'package:gn_mobile_monitoring/data/datasource/implementation/database/db.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/sites_database.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
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
  Future<List<SiteComplement>> getAllSiteComplements() async {
    final db = await _database;
    return await db.sitesDao.getAllComplements();
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
}
