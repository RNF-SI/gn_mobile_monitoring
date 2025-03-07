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
      // First get all modules from the database
      final modules = await modulesDatabase.getAllModules();
      
      // Maps to store unique site groups and the relationships to modules
      final Map<int, SiteGroup> uniqueSiteGroups = {};
      final List<SitesGroupModule> sitesGroupModules = [];

      // For each module, fetch its site groups
      for (final module in modules) {
        if (module.moduleCode == null) continue;

        try {
          // Fetch site groups for this module using the new method
          final siteGroups = await api.fetchSiteGroupsForModule(
              module.moduleCode!, token);

          // Add site groups to our map and create site-group-module relationships
          for (final siteGroup in siteGroups) {
            final domainSiteGroup = siteGroup.siteGroup.toDomain();
            uniqueSiteGroups[domainSiteGroup.idSitesGroup] = domainSiteGroup;

            // Create site-group-module relationship
            sitesGroupModules.add(SitesGroupModule(
              idSitesGroup: domainSiteGroup.idSitesGroup,
              idModule: module.id,
            ));
          }
        } catch (e) {
          print('Error fetching site groups for module ${module.moduleCode}: $e');
          // Continue with next module instead of failing completely
          continue;
        }
      }

      // Save unique site groups to database
      await database.clearSiteGroups();
      await database.insertSiteGroups(uniqueSiteGroups.values.toList());

      // Save site-group-module relationships
      await database.clearAllSiteGroupModules();
      await database.insertSiteGroupModules(sitesGroupModules);
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
