import 'package:gn_mobile_monitoring/data/datasource/implementation/api/sites_api_impl.dart';
import 'package:gn_mobile_monitoring/data/datasource/implementation/database/sites_database_impl.dart';
import 'package:gn_mobile_monitoring/data/mapper/base_site_entity_mapper.dart';
import 'package:gn_mobile_monitoring/data/mapper/site_group_entity_mapper.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';
import 'package:gn_mobile_monitoring/domain/repository/sites_repository.dart';

class SitesRepositoryImpl implements SitesRepository {
  final SitesApiImpl apiImpl;
  final SitesDatabaseImpl databaseImpl;

  SitesRepositoryImpl(this.apiImpl, this.databaseImpl);

  @override
  Future<List<BaseSite>> fetchSites(String token) async {
    try {
      // Fetch sites from API
      final sites = await apiImpl.fetchSitesFromApi(token);

      // Map and cache
      final domainSites = sites.map((e) => e.toDomain()).toList();
      await databaseImpl.clearSites();
      await databaseImpl.insertSites(domainSites);

      return domainSites;
    } catch (error) {
      // Return cached sites in case of failure
      return await databaseImpl.getAllSites();
    }
  }

  @override
  Future<List<SiteGroup>> fetchSiteGroups(String token) async {
    try {
      // Fetch BaseSite groups from API
      final groups = await apiImpl.fetchSiteGroupsFromApi(token);

      // Map and cache
      final domainGroups = groups.map((e) => e.toDomain()).toList();
      await databaseImpl.clearSiteGroups();
      await databaseImpl.insertSiteGroups(domainGroups);

      return domainGroups;
    } catch (error) {
      // Return cached groups in case of failure
      return await databaseImpl.getAllSiteGroups();
    }
  }
}
