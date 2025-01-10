import 'package:gn_mobile_monitoring/data/datasource/interface/api/sites_api.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/sites_database.dart';
import 'package:gn_mobile_monitoring/data/mapper/base_site_entity_mapper.dart';
import 'package:gn_mobile_monitoring/data/mapper/site_group_entity_mapper.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';
import 'package:gn_mobile_monitoring/domain/repository/sites_repository.dart';

class SitesRepositoryImpl implements SitesRepository {
  final SitesApi api;
  final SitesDatabase database;

  SitesRepositoryImpl(this.api, this.database);

  @override
  Future<List<BaseSite>> fetchSites(String token) async {
    try {
      // Fetch sites from API
      final sites = await api.fetchSitesFromApi(token);

      // Map and cache
      final domainSites = sites.map((e) => e.toDomain()).toList();
      await database.clearSites();
      await database.insertSites(domainSites);

      return domainSites;
    } catch (error) {
      // Return cached sites in case of failure
      return await database.getAllSites();
    }
  }

  @override
  Future<List<SiteGroup>> fetchSiteGroups(String token) async {
    try {
      // Fetch BaseSite groups from API
      final groups = await api.fetchSiteGroupsFromApi(token);

      // Map and cache
      final domainGroups = groups.map((e) => e.toDomain()).toList();
      await database.clearSiteGroups();
      await database.insertSiteGroups(domainGroups);

      return domainGroups;
    } catch (error) {
      // Return cached groups in case of failure
      return await database.getAllSiteGroups();
    }
  }
}
