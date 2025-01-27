import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/site_complement.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';
import 'package:gn_mobile_monitoring/domain/model/site_module.dart';
import 'package:gn_mobile_monitoring/domain/model/sites_group_module.dart';

abstract class SitesDatabase {
  /// Methods for handling `TBaseSites`.
  Future<void> clearSites();
  Future<void> insertSites(List<BaseSite> sites);
  Future<List<BaseSite>> getAllSites();

  /// Methods for handling `TSiteComplements`.
  Future<void> clearSiteComplements();
  Future<void> insertSiteComplements(List<SiteComplement> complements);
  Future<List<SiteComplement>> getAllSiteComplements();

  /// Methods for handling `TSitesGroups`.
  Future<void> clearSiteGroups();
  Future<void> insertSiteGroups(List<SiteGroup> siteGroups);
  Future<List<SiteGroup>> getAllSiteGroups();

  Future<List<BaseSite>> getSitesForModule(int moduleId);
  Future<List<SiteGroup>> getSiteGroupsForModule(int moduleId);

  /// Methods for handling CorSitesGroupModules
  Future<void> clearAllSiteGroupModules();
  Future<void> insertSiteGroupModules(List<SitesGroupModule> modules);

  Future<List<SiteGroup>> getSiteGroupsByModuleId(int moduleId);

  /// Methods for handling CorSitesModules
  Future<void> clearAllSiteModules();
  Future<void> insertSiteModules(List<SiteModule> modules);
  Future<List<BaseSite>> getSitesByModuleId(int moduleId);
}
