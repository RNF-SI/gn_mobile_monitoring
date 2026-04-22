import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/site_complement.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';
import 'package:gn_mobile_monitoring/domain/model/sync_result.dart';

abstract class SitesRepository {
  /// Fetches site groups for all modules and replaces existing data
  Future<void> fetchSiteGroupsAndSitesGroupModules(String token);

  /// Fetches sites with conflict management and returns a SyncResult
  Future<SyncResult> incrementalSyncSitesWithConflictHandling(String token);

  /// Fetches site groups for all modules and adds only new ones without clearing existing data
  Future<void> incrementalSyncSiteGroupsAndSitesGroupModules(String token);

  /// Fetches site groups with conflict management and returns a SyncResult
  Future<SyncResult> incrementalSyncSiteGroupsWithConflictHandling(String token);

  /// Gets all site groups from local database
  Future<List<SiteGroup>> getSiteGroups();

  /// Gets site groups from local database
  Future<SiteGroup?> getSiteGroupsById(int siteGroupId);

  /// Gets sites associated with a specific site group
  Future<List<BaseSite>> getSitesBySiteGroup(int siteGroupId);

  /// Gets sites of a site group that are also associated with a given module
  /// (via cor_site_module). Matches GeoNature web behavior when browsing a
  /// site group under a module.
  Future<List<BaseSite>> getSitesBySiteGroupAndModule(
      int siteGroupId, int moduleId);

  /// Gets sites of a module that don't belong to any site group (orphans).
  /// Used for the "Sites" tab when the module also has groups (issue #157).
  Future<List<BaseSite>> getOrphanSitesByModuleId(int moduleId);

  /// Fetches sites for a specific module
  Future<void> fetchSitesForModule(String moduleCode, String token);

  /// Fetches site groups for a specific module
  Future<void> fetchSiteGroupsForModule(String moduleCode, String token);

  /// Gets all site complements from local database
  Future<List<SiteComplement>> getAllSiteComplements();

  /// Gets a site by its ID
  Future<BaseSite?> getSiteById(int siteId);

  /// Gets a site group by its ID
  Future<SiteGroup?> getSiteGroupById(int siteGroupId);

  /// Gets local sites by module code (isLocal = true)
  Future<List<BaseSite>> getLocalSitesByModuleCode(String moduleCode);

  /// Updates the server site ID after successful sync
  Future<void> updateSiteServerId(int localSiteId, int serverSiteId);

  /// Gets local site groups by module code (isLocal = true)
  Future<List<SiteGroup>> getLocalSiteGroupsByModuleCode(String moduleCode);

  /// Updates the server site group ID after successful sync
  Future<void> updateSiteGroupServerId(int localSiteGroupId, int serverSiteGroupId);

  /// Updates idSitesGroup references in site complements when a local group gets a server ID
  Future<void> updateSiteComplementsGroupId(int oldGroupId, int newGroupId);

  /// Gets site complement by site ID
  Future<SiteComplement?> getSiteComplementBySiteId(int siteId);
}
