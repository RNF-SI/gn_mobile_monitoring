import 'package:drift/drift.dart';
import 'package:gn_mobile_monitoring/data/db/database.dart';
import 'package:gn_mobile_monitoring/data/db/mapper/t_base_site_mapper.dart';
import 'package:gn_mobile_monitoring/data/db/mapper/t_site_complement_mapper.dart';
import 'package:gn_mobile_monitoring/data/db/mapper/t_sites_group_mapper.dart';
import 'package:gn_mobile_monitoring/data/db/tables/t_base_sites.dart';
import 'package:gn_mobile_monitoring/data/db/tables/t_sites_complements.dart';
import 'package:gn_mobile_monitoring/data/db/tables/t_sites_groups.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/site_complement.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';

part 'sites_dao.g.dart';

@DriftAccessor(tables: [TBaseSites, TSiteComplements, TSitesGroups])
class SitesDao extends DatabaseAccessor<AppDatabase> with _$SitesDaoMixin {
  SitesDao(super.db);

  /// Operations for TBaseSites

  // Fetch all sites
  Future<List<BaseSite>> getAllSites() async {
    final dbSites = await select(tBaseSites).get();
    return dbSites.map((e) => e.toDomain()).toList();
  }

  // Insert multiple sites
  Future<void> insertSites(List<BaseSite> sites) async {
    final dbEntities = sites.map((e) => e.toDatabaseEntity()).toList();
    await batch((batch) {
      batch.insertAll(tBaseSites, dbEntities);
    });
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
      batch.insertAll(tSiteComplements, dbEntities);
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

  // Clear all site groups
  Future<void> clearGroups() async {
    try {
      await delete(tSitesGroups).go();
    } catch (e) {
      throw Exception("Failed to clear site groups: ${e.toString()}");
    }
  }
}
