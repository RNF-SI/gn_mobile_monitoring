import 'package:gn_mobile_monitoring/data/entity/base_site_entity.dart';
import 'package:gn_mobile_monitoring/data/entity/module_entity.dart';
import 'package:gn_mobile_monitoring/data/entity/site_groups_with_modules.dart';

abstract class SitesApi {
  Future<List<BaseSiteEntity>> fetchSitesFromApi(String token);
  Future<List<SiteGroupsWithModulesLabel>> fetchSiteGroupsFromApi(String token);
  Future<List<ModuleEntity>> fetchModulesFromIdSite(int idSite, String token);
}
