import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';

abstract class SitesRepository {
  Future<void> fetchSitesAndSiteModules(String token);
  Future<void> fetchSiteGroupsAndSitesGroupModules(String token);
  Future<List<BaseSite>> getSites();
  Future<List<SiteGroup>> getSiteGroups();
}
