import 'package:gn_mobile_monitoring/data/datasource/implementation/database/db.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/sites_database.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/site_complement.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';

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
  Future<List<SiteGroup>> getAllSiteGroups() async {
    final db = await _database;
    return await db.sitesDao.getAllGroups();
  }
}
