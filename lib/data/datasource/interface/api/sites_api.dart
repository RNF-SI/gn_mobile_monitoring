import 'package:gn_mobile_monitoring/data/entity/site_groups_with_modules.dart';

abstract class SitesApi {
  /// Fetches sites for a specific module with detailed information
  Future<Map<String, dynamic>> fetchEnrichedSitesForModule(
      String moduleCode, String token);

  /// Fetches site groups for a specific module using its module code
  Future<List<SiteGroupsWithModulesLabel>> fetchSiteGroupsForModule(
      String moduleCode, String token);
}
