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
      // First get all modules from the database
      final modules = await modulesDatabase.getAllModules();

      // Map to store unique sites based on their ID
      final Map<int, BaseSite> uniqueSites = {};
      final List<SiteModule> siteModules = [];

      // For each module, fetch its sites
      for (final module in modules) {
        if (module.moduleCode == null) continue;

        try {
          // Fetch sites for this module
          final sites =
              await api.fetchSitesForModule(module.moduleCode!, token);

          // Add sites to our map and create site-module relationships
          for (final site in sites) {
            final domainSite = site.toDomain();
            uniqueSites[domainSite.idBaseSite] = domainSite;

            // Create site-module relationship
            siteModules.add(SiteModule(
              idSite: domainSite.idBaseSite,
              idModule: module.id,
            ));
          }
        } catch (e) {
          print('Error fetching sites for module ${module.moduleCode}: $e');
          continue;
        }
      }

      // Save unique sites to database
      await database.clearSites();
      await database.insertSites(uniqueSites.values.toList());

      // Save site-module relationships
      await database.clearAllSiteModules();
      await database.insertSiteModules(siteModules);
    } catch (error) {
      print('Error fetching sites: $error');
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
      print('Error fetching site groups: $error');
      throw Exception('Failed to fetch site groups');
    }
  }

  @override
  Future<List<BaseSite>> getSites() async {
    try {
      final sites = await database.getAllSites();
      return sites;
    } catch (error) {
      print('Error getting sites: $error');
      throw Exception('Failed to get sites');
    }
  }

  @override
  Future<List<SiteGroup>> getSiteGroups() async {
    try {
      final groups = await database.getAllSiteGroups();
      return groups;
    } catch (error) {
      print('Error getting site groups: $error');
      throw Exception('Failed to get site groups');
    }
  }
}
