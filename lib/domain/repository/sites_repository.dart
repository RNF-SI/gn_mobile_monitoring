import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';

abstract class SitesRepository {
  Future<void> fetchSites(String token);
  Future<void> fetchSiteGroups(String token);
  Future<List<BaseSite>> getSites();
  Future<List<SiteGroup>> getSiteGroups();
}
