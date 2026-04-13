import 'package:gn_mobile_monitoring/data/entity/site_groups_with_modules.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';

abstract class SitesApi {
  /// Fetches sites for a specific module with detailed information
  Future<Map<String, dynamic>> fetchEnrichedSitesForModule(
      String moduleCode, String token);

  /// Fetches site groups for a specific module using its module code
  Future<List<SiteGroupsWithModulesLabel>> fetchSiteGroupsForModule(
      String moduleCode, String token);

  /// Envoie un site au serveur (POST)
  /// Returns the created site's server ID if successful
  /// [moduleId] est requis pour associer le site au module via cor_site_module
  Future<Map<String, dynamic>> sendSite(
    String token,
    String moduleCode,
    BaseSite site, {
    int? moduleId,
  });

  /// Met à jour un site existant sur le serveur (PATCH)
  /// Returns the updated site data if successful
  Future<Map<String, dynamic>> updateSite(
    String token,
    String moduleCode,
    int siteId,
    BaseSite site,
  );

  /// Envoie un groupe de sites au serveur (POST)
  /// Returns the created site group's server response if successful
  /// [moduleId] est requis pour associer le groupe au module via cor_sites_group_module
  Future<Map<String, dynamic>> sendSiteGroup(
    String token,
    String moduleCode,
    SiteGroup siteGroup, {
    int? moduleId,
  });
}
