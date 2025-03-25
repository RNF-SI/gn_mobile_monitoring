import 'package:gn_mobile_monitoring/data/datasource/interface/api/sites_api.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/modules_database.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/sites_database.dart';
import 'package:gn_mobile_monitoring/data/entity/base_site_entity.dart';
import 'package:gn_mobile_monitoring/data/mapper/base_site_entity_mapper.dart';
import 'package:gn_mobile_monitoring/data/mapper/site_group_entity_mapper.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/site_complement.dart';
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
      // Store site complements that we'll save to the database
      final Map<int, SiteComplement> siteComplements = {};

      // For each module, fetch its sites
      for (final module in modules) {
        if (module.moduleCode == null) continue;

        try {
          // Fetch enriched sites data for this module
          final enrichedData =
              await api.fetchEnrichedSitesForModule(module.moduleCode!, token);

          final List<Map<String, dynamic>> enrichedSites =
              (enrichedData['enriched_sites'] as List)
                  .cast<Map<String, dynamic>>();

          final List<SiteComplement> moduleSiteComplements =
              (enrichedData['site_complements'] as List).cast<SiteComplement>();

          // Process the enriched sites
          for (final siteJson in enrichedSites) {
            // Create BaseSite from the enriched data
            final site = BaseSiteEntity.fromJson(siteJson);
            final domainSite = site.toDomain();
            uniqueSites[domainSite.idBaseSite] = domainSite;

            // Create site-module relationship
            siteModules.add(SiteModule(
              idSite: domainSite.idBaseSite,
              idModule: module.id,
            ));
          }

          // Store site complements
          for (final complement in moduleSiteComplements) {
            siteComplements[complement.idBaseSite] = complement;
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

      // Save site complements
      await database.clearSiteComplements();
      if (siteComplements.isNotEmpty) {
        await database.insertSiteComplements(siteComplements.values.toList());
      }

      print(
          'Saved ${uniqueSites.length} sites, ${siteModules.length} site-module relationships, and ${siteComplements.length} site complements');
    } catch (error) {
      print('Error fetching sites: $error');
      throw Exception('Failed to fetch sites');
    }
  }

  @override
  Future<void> incrementalSyncSitesAndSiteModules(String token) async {
    try {
      // First get all modules from the database
      final modules = await modulesDatabase.getAllModules();

      // Get existing sites to determine what's new
      final existingSites = await database.getAllSites();
      final existingSiteIds = existingSites.map((s) => s.idBaseSite).toSet();

      // Get existing site modules to determine what relationships are new
      final existingSiteModules = await database.getAllSiteModules();
      final existingSiteModuleKeys = existingSiteModules
          .map((sm) => '${sm.idSite}_${sm.idModule}')
          .toSet();

      // Get existing site complements
      final existingSiteComplements = await database.getAllSiteComplements();

      // Maps to store sites and complements data
      final Map<int, BaseSite> remoteSites = {};
      final Map<String, SiteModule> remoteSiteModuleMap = {};
      final Map<int, SiteComplement> remoteSiteComplements = {};
      final Set<int> remotelyAccessibleSiteIds = {};

      // For each module, fetch its sites with detailed information
      for (final module in modules) {
        if (module.moduleCode == null) continue;

        try {
          // Fetch enriched sites data for this module
          final enrichedData =
              await api.fetchEnrichedSitesForModule(module.moduleCode!, token);

          final List<Map<String, dynamic>> enrichedSites =
              (enrichedData['enriched_sites'] as List)
                  .cast<Map<String, dynamic>>();

          final List<SiteComplement> moduleSiteComplements =
              (enrichedData['site_complements'] as List).cast<SiteComplement>();

          // Process all sites from remote API
          for (final siteJson in enrichedSites) {
            final site = BaseSiteEntity.fromJson(siteJson);
            final domainSite = site.toDomain();
            remoteSites[domainSite.idBaseSite] = domainSite;
            remotelyAccessibleSiteIds.add(domainSite.idBaseSite);

            // Create site-module relationship key
            final relationshipKey = '${domainSite.idBaseSite}_${module.id}';
            remoteSiteModuleMap[relationshipKey] = SiteModule(
              idSite: domainSite.idBaseSite,
              idModule: module.id,
            );
          }

          // Process site complements
          for (final complement in moduleSiteComplements) {
            remoteSiteComplements[complement.idBaseSite] = complement;
          }
        } catch (e) {
          print(
              'Error incrementally fetching sites for module ${module.moduleCode}: $e');
          continue;
        }
      }

      // 1. Identify sites to ADD (exist remotely but not locally)
      final sitesToAdd = remoteSites.values
          .where((s) => !existingSiteIds.contains(s.idBaseSite))
          .toList();

      // 2. Identify sites to DELETE (exist locally but no longer accessible)
      final sitesToDelete = existingSites
          .where((s) => !remotelyAccessibleSiteIds.contains(s.idBaseSite))
          .toList();

      // 3. Identify sites to UPDATE (exist both locally and remotely)
      final sitesToUpdate = remoteSites.values
          .where((s) => existingSiteIds.contains(s.idBaseSite))
          .toList();

      // 4. Identify site-module relationships to ADD and DELETE
      final siteModulesToAdd = remoteSiteModuleMap.values.where((sm) {
        final key = '${sm.idSite}_${sm.idModule}';
        return !existingSiteModuleKeys.contains(key);
      }).toList();

      final siteModulesToDelete = existingSiteModules.where((sm) {
        final key = '${sm.idSite}_${sm.idModule}';
        return !remoteSiteModuleMap.containsKey(key);
      }).toList();

      // 5. Identify site complements to ADD or UPDATE
      final siteComplementsToProcess = remoteSiteComplements.values.toList();

      // 6. Perform database operations

      // Delete sites and site-module relationships first
      for (final siteToDelete in sitesToDelete) {
        await database.deleteSite(siteToDelete.idBaseSite);
      }

      for (final siteModuleToDelete in siteModulesToDelete) {
        await database.deleteSiteModule(
            siteModuleToDelete.idSite, siteModuleToDelete.idModule);
      }

      // Add new sites
      if (sitesToAdd.isNotEmpty) {
        await database.insertSites(sitesToAdd);
        print('Added ${sitesToAdd.length} new sites to the database');
      }

      // Update existing sites
      for (final siteToUpdate in sitesToUpdate) {
        await database.updateSite(siteToUpdate);
      }

      // Add new site-module relationships
      if (siteModulesToAdd.isNotEmpty) {
        await database.insertSiteModules(siteModulesToAdd);
        print(
            'Added ${siteModulesToAdd.length} new site-module relationships to the database');
      }

      // Process site complements - clear and re-add all for simplicity
      if (siteComplementsToProcess.isNotEmpty) {
        await database.clearSiteComplements();
        await database.insertSiteComplements(siteComplementsToProcess);
        print('Processed ${siteComplementsToProcess.length} site complements');
      }

      print('Removed ${sitesToDelete.length} sites no longer accessible');
      print(
          'Removed ${siteModulesToDelete.length} site-module relationships no longer valid');
      print('Updated ${sitesToUpdate.length} existing sites');
    } catch (error) {
      print('Error incrementally syncing sites: $error');
      throw Exception('Failed to incrementally sync sites');
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
          final siteGroups =
              await api.fetchSiteGroupsForModule(module.moduleCode!, token);

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
          print(
              'Error fetching site groups for module ${module.moduleCode}: $e');
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
  Future<void> incrementalSyncSiteGroupsAndSitesGroupModules(
      String token) async {
    try {
      // First get all modules from the database
      final modules = await modulesDatabase.getAllModules();

      // Get existing site groups to determine what's new
      final existingSiteGroups = await database.getAllSiteGroups();
      final existingSiteGroupIds =
          existingSiteGroups.map((g) => g.idSitesGroup).toSet();

      // Get existing site group modules to determine what relationships are new
      final existingSiteGroupModules = await database.getAllSiteGroupModules();
      final existingSiteGroupModuleKeys = existingSiteGroupModules
          .map((sgm) => '${sgm.idSitesGroup}_${sgm.idModule}')
          .toSet();

      // Maps to store site groups data
      final Map<int, SiteGroup> remoteSiteGroups = {};
      final Map<String, SitesGroupModule> remoteSiteGroupModuleMap = {};
      final Set<int> remotelyAccessibleSiteGroupIds = {};

      // For each module, fetch its site groups
      for (final module in modules) {
        if (module.moduleCode == null) continue;

        try {
          // Fetch site groups for this module
          final siteGroups =
              await api.fetchSiteGroupsForModule(module.moduleCode!, token);

          // Process all site groups from remote API
          for (final siteGroup in siteGroups) {
            final domainSiteGroup = siteGroup.siteGroup.toDomain();
            remoteSiteGroups[domainSiteGroup.idSitesGroup] = domainSiteGroup;
            remotelyAccessibleSiteGroupIds.add(domainSiteGroup.idSitesGroup);

            // Create site-group-module relationship key
            final relationshipKey =
                '${domainSiteGroup.idSitesGroup}_${module.id}';
            remoteSiteGroupModuleMap[relationshipKey] = SitesGroupModule(
              idSitesGroup: domainSiteGroup.idSitesGroup,
              idModule: module.id,
            );
          }
        } catch (e) {
          print(
              'Error incrementally fetching site groups for module ${module.moduleCode}: $e');
          continue;
        }
      }

      // 1. Identify site groups to ADD (exist remotely but not locally)
      final siteGroupsToAdd = remoteSiteGroups.values
          .where((sg) => !existingSiteGroupIds.contains(sg.idSitesGroup))
          .toList();

      // 2. Identify site groups to DELETE (exist locally but no longer accessible)
      final siteGroupsToDelete = existingSiteGroups
          .where(
              (sg) => !remotelyAccessibleSiteGroupIds.contains(sg.idSitesGroup))
          .toList();

      // 3. Identify site groups to UPDATE (exist both locally and remotely)
      final siteGroupsToUpdate = remoteSiteGroups.values
          .where((sg) => existingSiteGroupIds.contains(sg.idSitesGroup))
          .toList();

      // 4. Identify site group-module relationships to ADD and DELETE
      final siteGroupModulesToAdd =
          remoteSiteGroupModuleMap.values.where((sgm) {
        final key = '${sgm.idSitesGroup}_${sgm.idModule}';
        return !existingSiteGroupModuleKeys.contains(key);
      }).toList();

      final siteGroupModulesToDelete = existingSiteGroupModules.where((sgm) {
        final key = '${sgm.idSitesGroup}_${sgm.idModule}';
        return !remoteSiteGroupModuleMap.containsKey(key);
      }).toList();

      // 5. Perform database operations

      // Delete site groups and site group-module relationships first
      for (final siteGroupToDelete in siteGroupsToDelete) {
        await database.deleteSiteGroup(siteGroupToDelete.idSitesGroup);
      }

      for (final siteGroupModuleToDelete in siteGroupModulesToDelete) {
        await database.deleteSiteGroupModule(
            siteGroupModuleToDelete.idSitesGroup,
            siteGroupModuleToDelete.idModule);
      }

      // Add new site groups
      if (siteGroupsToAdd.isNotEmpty) {
        await database.insertSiteGroups(siteGroupsToAdd);
        print(
            'Added ${siteGroupsToAdd.length} new site groups to the database');
      }

      // Update existing site groups
      for (final siteGroupToUpdate in siteGroupsToUpdate) {
        await database.updateSiteGroup(siteGroupToUpdate);
      }

      // Add new site group-module relationships
      if (siteGroupModulesToAdd.isNotEmpty) {
        await database.insertSiteGroupModules(siteGroupModulesToAdd);
        print(
            'Added ${siteGroupModulesToAdd.length} new site group-module relationships to the database');
      }

      print(
          'Removed ${siteGroupsToDelete.length} site groups no longer accessible');
      print(
          'Removed ${siteGroupModulesToDelete.length} site group-module relationships no longer valid');
      print('Updated ${siteGroupsToUpdate.length} existing site groups');
    } catch (error) {
      print('Error incrementally syncing site groups: $error');
      throw Exception('Failed to incrementally sync site groups');
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
