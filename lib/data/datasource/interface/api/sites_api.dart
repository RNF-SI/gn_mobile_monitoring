import 'package:gn_mobile_monitoring/data/entity/base_site_entity.dart';
import 'package:gn_mobile_monitoring/data/entity/site_group_entity.dart';

abstract class SitesApi {
  Future<List<BaseSiteEntity>> fetchSitesFromApi(String token);
  Future<List<SiteGroupEntity>> fetchSiteGroupsFromApi(String token);
}
