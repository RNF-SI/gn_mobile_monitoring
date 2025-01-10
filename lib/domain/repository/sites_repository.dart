import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';

abstract class SitesRepository {
  Future<List<BaseSite>> fetchSites(String token);
  Future<List<SiteGroup>> fetchSiteGroups(String token);
}
