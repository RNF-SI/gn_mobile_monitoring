import 'package:gn_mobile_monitoring/data/datasource/interface/api/sites_api.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/modules_database.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/sites_database.dart';
import 'package:gn_mobile_monitoring/data/entity/site_groups_with_modules.dart';
import 'package:gn_mobile_monitoring/data/mapper/base_site_entity_mapper.dart';
import 'package:gn_mobile_monitoring/data/mapper/site_group_entity_mapper.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';
import 'package:gn_mobile_monitoring/domain/model/site_module.dart';
import 'package:gn_mobile_monitoring/domain/model/sites_group_module.dart';
import 'package:gn_mobile_monitoring/domain/repository/sites_repository.dart';

class SitesRepositoryImpl implements SitesRepository {
  final SitesApi api;
  final SitesDatabase database;
  final ModulesDatabase modulesDatabase;

  SitesRepositoryImpl(this.api, this.database, this.modulesDatabase);

  @override
  Future<void> fetchSitesAndSiteModules(String token) async {
    try {
      // Fetch sites from API
      final sites = await api.fetchSitesFromApi(token);

      // Map and cache
      final domainSites = sites.map((e) => e.toDomain()).toList();
      await database.clearSites();
      await database.insertSites(domainSites);

      List<SiteModule> siteModules = [];
      // Fetch modules for each site calling siteApi.fetchModulesFromIdSite
      for (var site in domainSites) {
        final modules =
            await api.fetchModulesFromIdSite(site.idBaseSite, token);

        // create and insert corSiteModules for each module
        for (var module in modules) {
          siteModules.add(SiteModule(
            idSite: site.idBaseSite,
            idModule: module.idModule,
          ));
        }
      }
      await database.clearAllSiteModules();
      await database.insertSiteModules(siteModules);
    } catch (error) {
      // Exception handling
      print('Error fetching sites: $error');
      // Optionally, rethrow the error or handle it as needed
      throw Exception('Failed to fetch sites');
    }
  }

  @override
  Future<void> fetchSiteGroupsAndSitesGroupModules(String token) async {
    try {
      // Fetch BaseSite groups and their modules from API
      final List<SiteGroupsWithModulesLabel> result =
          await api.fetchSiteGroupsFromApi(token);

      // Map and cache site groups
      final domainGroups = result.map((e) => e.siteGroup.toDomain()).toList();
      await database.clearSiteGroups();
      await database.insertSiteGroups(domainGroups);

      // For each SiteGroupsWithModulesLabel and for each moduleLabel, get the module id and create SitesGroupModule objects
      List<SitesGroupModule> corSitesGroupModules = [];
      for (var siteGroup in result) {
        for (var label in siteGroup.moduleLabelList) {
          final module = await modulesDatabase.getModuleIdByLabel(label);
          if (module != null) {
            corSitesGroupModules.add(SitesGroupModule(
              idSitesGroup: siteGroup.siteGroup.idSitesGroup,
              idModule: module.id,
            ));
          }
        }
      }

      await database.clearAllSiteGroupModules();
      await database.insertSiteGroupModules(corSitesGroupModules);
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
