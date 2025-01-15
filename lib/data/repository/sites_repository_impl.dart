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
  Future<void> fetchSites(String token) async {
    try {
      // Fetch sites from API
      final sites = await api.fetchSitesFromApi(token);

      // Map and cache
      final domainSites = sites.map((e) => e.toDomain()).toList();
      await database.clearSites();
      await database.insertSites(domainSites);
    } catch (error) {
      // Exception handling
      print('Error fetching sites: $error');
      // Optionally, rethrow the error or handle it as needed
      throw Exception('Failed to fetch sites');
    }
  }

  @override
  Future<void> fetchSiteGroups(String token) async {
    try {
      // Fetch BaseSite groups from API
      final groups = await api.fetchSiteGroupsFromApi(token);

      // Map and cache
      final domainGroups = groups.map((e) => e.toDomain()).toList();
      await database.clearSiteGroups();
      await database.insertSiteGroups(domainGroups);
    } catch (error) {
      // Exception handling
      print('Error fetching site groups: $error');
      // Optionally, rethrow the error or handle it as needed
      throw Exception('Failed to fetch site groups');
    }
  }

  @override
  Future<List<BaseSite>> getSites() async {
    try {
      // Get sites from database
      final sites = await database.getAllSites();
      return sites;
    } catch (error) {
      // Exception handling
      print('Error getting sites: $error');
      // Optionally, rethrow the error or handle it as needed
      throw Exception('Failed to get sites');
    }
  }

  @override
  Future<List<SiteGroup>> getSiteGroups() async {
    try {
      // Get site groups from database
      final groups = await database.getAllSiteGroups();

      return groups;
    } catch (error) {
      // Exception handling
      print('Error getting site groups: $error');
      // Optionally, rethrow the error or handle it as needed
      throw Exception('Failed to get site groups');
    }
  }
}
