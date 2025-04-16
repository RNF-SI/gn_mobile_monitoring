import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';

abstract class SitesRepository {
  /// Fetches sites for all modules and replaces existing data
  Future<void> fetchSitesAndSiteModules(String token);
  
  /// Fetches site groups for all modules and replaces existing data
  Future<void> fetchSiteGroupsAndSitesGroupModules(String token);
  
  /// Fetches sites for all modules and adds only new ones without clearing existing data
  Future<void> incrementalSyncSitesAndSiteModules(String token);
  
  /// Fetches site groups for all modules and adds only new ones without clearing existing data
  Future<void> incrementalSyncSiteGroupsAndSitesGroupModules(String token);
  
  /// Gets all sites from local database
  Future<List<BaseSite>> getSites();
  
  /// Gets all site groups from local database
  Future<List<SiteGroup>> getSiteGroups();
  
  /// Gets sites associated with a specific site group
  Future<List<BaseSite>> getSitesBySiteGroup(int siteGroupId);
}
