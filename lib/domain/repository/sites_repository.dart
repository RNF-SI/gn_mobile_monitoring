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
}
