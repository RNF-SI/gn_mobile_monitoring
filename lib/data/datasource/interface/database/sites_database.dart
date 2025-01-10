import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/site_complement.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';

abstract class SitesDatabase {
  /// Methods for handling `TBaseSites`.
  Future<void> clearSites();
  Future<void> insertSites(List<BaseSite> sites);
  Future<List<BaseSite>> getAllSites();

  /// Methods for handling `TSiteComplements`.
  Future<void> clearSiteComplements();
  Future<void> insertSiteComplements(List<SiteComplement> complements);
  Future<List<SiteComplement>> getAllSiteComplements();

  /// Methods for handling `TSitesGroups`.
  Future<void> clearSiteGroups();
  Future<void> insertSiteGroups(List<SiteGroup> siteGroups);
  Future<List<SiteGroup>> getAllSiteGroups();
}
