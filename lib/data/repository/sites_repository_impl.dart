import 'package:gn_mobile_monitoring/data/datasource/interface/api/sites_api.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/modules_database.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/sites_database.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/visites_database.dart';
import 'package:gn_mobile_monitoring/data/entity/base_site_entity.dart';
import 'package:gn_mobile_monitoring/data/mapper/base_site_entity_mapper.dart';
import 'package:gn_mobile_monitoring/data/mapper/site_group_entity_mapper.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/site_complement.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';
import 'package:gn_mobile_monitoring/domain/model/site_module.dart';
import 'package:gn_mobile_monitoring/domain/model/sites_group_module.dart';
import 'package:gn_mobile_monitoring/domain/model/sync_conflict.dart';
import 'package:gn_mobile_monitoring/domain/model/sync_result.dart';
import 'package:gn_mobile_monitoring/domain/repository/sites_repository.dart';

class SitesRepositoryImpl implements SitesRepository {
  final SitesApi api;
  final SitesDatabase database;
  final ModulesDatabase modulesDatabase;
  final VisitesDatabase visitesDatabase;

  SitesRepositoryImpl(
      this.api, this.database, this.modulesDatabase, this.visitesDatabase);

  @override
  Future<SyncResult> incrementalSyncSitesWithConflictHandling(
      String token) async {
    // Variables pour les métriques et conflits
    final List<SyncConflict> allConflicts = [];
    int itemsProcessed = 0;
    int itemsAdded = 0;
    int itemsUpdated = 0;
    int itemsDeleted = 0;
    int itemsSkipped = 0;

    try {
      // Récupérer tous les modules téléchargés
      final modules = await modulesDatabase.getDownloadedModules();

      // Traiter chaque module individuellement
      for (final module in modules) {
        if (module.moduleCode == null) continue;

        print('=== Synchronisation du module ${module.moduleCode} ===');

        // 1. Récupérer les sites LOCAUX pour CE MODULE spécifiquement
        final localSiteModules =
            await database.getSiteModulesByModuleId(module.id);
        final localSiteIdsForModule =
            localSiteModules.map((sm) => sm.idSite).toSet();

        // Récupérer les détails des sites locaux pour ce module
        final localSitesForModule = <BaseSite>[];
        for (final siteId in localSiteIdsForModule) {
          final site = await database.getSiteById(siteId);
          if (site != null) {
            localSitesForModule.add(site);
          }
        }

        print(
            'Sites locaux pour le module ${module.moduleCode}: ${localSitesForModule.length}');

        // 2. Récupérer les sites DISTANTS pour CE MODULE
        Map<String, dynamic> remoteSitesData;
        List<BaseSite> remoteSites;
        List<SiteComplement> remoteSiteComplements;

        try {
          remoteSitesData =
              await api.fetchEnrichedSitesForModule(module.moduleCode!, token);
          final List<Map<String, dynamic>> enrichedSites =
              (remoteSitesData['enriched_sites'] as List)
                  .cast<Map<String, dynamic>>();

          remoteSites = enrichedSites
              .map((json) => BaseSiteEntity.fromJson(json).toDomain())
              .toList();

          remoteSiteComplements = (remoteSitesData['site_complements'] as List)
              .cast<SiteComplement>();

          print(
              'Sites distants pour le module ${module.moduleCode}: ${remoteSites.length}');
        } catch (e) {
          print(
              'Erreur lors de la récupération des sites pour le module ${module.moduleCode}: $e');
          continue;
        }

        // 3. Créer les ensembles d'IDs pour la comparaison
        final remoteSiteIds = remoteSites.map((s) => s.idBaseSite).toSet();

        // 4. Identifier les changements pour CE MODULE

        // Sites à ajouter : existent sur le serveur mais pas localement pour ce module
        final sitesToAdd = remoteSites
            .where((s) => !localSiteIdsForModule.contains(s.idBaseSite))
            .toList();

        // Sites à supprimer : existent localement pour ce module mais plus sur le serveur
        final sitesToDelete = localSitesForModule
            .where((s) => !remoteSiteIds.contains(s.idBaseSite))
            .toList();

        // Sites à mettre à jour : existent des deux côtés
        final sitesToUpdate = remoteSites
            .where((s) => localSiteIdsForModule.contains(s.idBaseSite))
            .toList();

        print(
            'Module ${module.moduleCode} - À ajouter: ${sitesToAdd.length}, À supprimer: ${sitesToDelete.length}, À mettre à jour: ${sitesToUpdate.length}');

        // 5. Gérer les suppressions avec détection de conflits
        for (final site in sitesToDelete) {
          // Re-vérifier s'il y a encore des visites (elles pourraient avoir été supprimées depuis le dernier conflit)
          final visits = await visitesDatabase.getVisitsBySite(site.idBaseSite);

          if (visits.isNotEmpty) {
            // Créer un conflit seulement s'il y a encore des visites
            final conflict = SyncConflict(
              conflictType: ConflictType.deletedReference,
              entityType: 'site',
              entityId: site.idBaseSite.toString(),
              affectedField: null,
              localValue: null,
              remoteValue: null,
              localModifiedAt: DateTime.now(),
              remoteModifiedAt: DateTime.now(),
              resolutionStrategy: ConflictResolutionStrategy.userDecision,
              message:
                  'Site "${site.baseSiteName}" supprimé du module ${module.moduleCode} mais a ${visits.length} visite(s)',
              localData: {
                'siteId': site.idBaseSite,
                'siteName': site.baseSiteName,
                'moduleCode': module.moduleCode,
                'moduleName': module.moduleLabel,
                'visitCount': visits.length,
                'lastVisitDate':
                    visits.isNotEmpty ? visits.first.visitDateMin : null,
              },
              remoteData: {},
              severity: ConflictSeverity.high,
              navigationPath: '/module/${module.id}/site/${site.idBaseSite}',
              referencedEntityType: 'visit',
              referencedEntityId:
                  visits.isNotEmpty ? visits.first.idBaseVisit.toString() : '',
              referencesCount: visits.length,
            );
            allConflicts.add(conflict);
            itemsSkipped++;
            print('Conflit maintenu pour le site ${site.idBaseSite} : ${visits.length} visite(s) toujours présente(s)');
          } else {
            // Plus de visites - le conflit peut être résolu automatiquement
            print('Site ${site.idBaseSite} : plus de visites, suppression automatique du site');
            
            // Supprimer la relation site-module
            await database.deleteSiteModule(site.idBaseSite, module.id);

            // Vérifier si le site appartient à d'autres modules avant suppression complète
            final hasOtherReferences = await database.siteHasOtherModuleReferences(site.idBaseSite, module.id);

            if (!hasOtherReferences) {
              // Le site n'est lié à aucun autre module, on peut le supprimer complètement
              await database.deleteSiteCompletely(site.idBaseSite);
              print('Site ${site.idBaseSite} supprimé complètement (pas d\'autres références de modules)');
              itemsDeleted++;
            } else {
              // Le site est encore lié à d'autres modules, on ne supprime que la relation
              print('Site ${site.idBaseSite} conservé (lié à d\'autres modules), relation supprimée uniquement');
            }
          }
        }

        // 6. Ajouter les nouveaux sites
        for (final site in sitesToAdd) {
          // Vérifier si le site existe déjà dans la base (pour un autre module)
          final existingSite = await database.getSiteById(site.idBaseSite);

          if (existingSite == null) {
            // Le site n'existe pas du tout, l'ajouter
            await database.insertSites([site]);
          }

          // Créer la relation site-module
          await database.insertSiteModule(SiteModule(
            idSite: site.idBaseSite,
            idModule: module.id,
          ));
          itemsAdded++;
        }

        // 7. Mettre à jour les sites existants
        for (final site in sitesToUpdate) {
          await database.updateSite(site);
          itemsUpdated++;
        }

        // 8. Gérer les site complements pour ce module
        // Récupérer directement les compléments des sites de ce module via la base de données
        final existingComplementsForModule = await database.getSiteComplementsByModuleId(module.id);
        
        final existingComplementsMap = Map.fromEntries(
            existingComplementsForModule.map((c) => MapEntry(c.idBaseSite, c)));

        for (final complement in remoteSiteComplements) {
          final existing = existingComplementsMap[complement.idBaseSite];
          if (existing == null) {
            // Nouveau complément pour ce site
            await database.insertSiteComplements([complement]);
            print('Complément ajouté pour le site ${complement.idBaseSite}');
          } else if (existing != complement) {
            // Complément modifié - détailler les changements
            bool hasChanges = false;
            final changes = <String>[];
            
            if (existing.idSitesGroup != complement.idSitesGroup) {
              changes.add('id_sites_group: ${existing.idSitesGroup} -> ${complement.idSitesGroup}');
              hasChanges = true;
            }
            
            // Ajouter d'autres vérifications si nécessaire pour d'autres champs du complément
            
            if (hasChanges) {
              await database.insertSiteComplements([complement]);
              print('Site ${complement.idBaseSite} mis à jour - ${changes.join(', ')}');
            }
          }
        }

        itemsProcessed += remoteSites.length;
      }

      print('=== Résumé de la synchronisation ===');
      print(
          'Traités: $itemsProcessed, Ajoutés: $itemsAdded, Mis à jour: $itemsUpdated, Supprimés: $itemsDeleted, Conflits: ${allConflicts.length}');

      if (allConflicts.isNotEmpty) {
        return SyncResult.withConflicts(
          itemsProcessed: itemsProcessed,
          itemsAdded: itemsAdded,
          itemsUpdated: itemsUpdated,
          itemsDeleted: itemsDeleted,
          itemsSkipped: itemsSkipped,
          itemsFailed: 0,
          conflicts: allConflicts,
          errorMessage:
              'Certains sites ont des références locales dans différents modules',
        );
      } else {
        return SyncResult.success(
          itemsProcessed: itemsProcessed,
          itemsAdded: itemsAdded,
          itemsUpdated: itemsUpdated,
          itemsDeleted: itemsDeleted,
          itemsSkipped: itemsSkipped,
        );
      }
    } catch (error) {
      print('Erreur lors de la synchronisation module par module: $error');
      return SyncResult.failure(
        errorMessage: 'Erreur: $error',
      );
    }
  }

  @override
  Future<void> fetchSitesForModule(String moduleCode, String token) async {
    try {
      // Récupérer le module par son code
      final module = await modulesDatabase.getModuleByCode(moduleCode);
      if (module == null) {
        throw Exception('Module $moduleCode not found');
      }

      // Récupérer les sites enrichis pour ce module
      final enrichedData =
          await api.fetchEnrichedSitesForModule(moduleCode, token);

      final List<Map<String, dynamic>> enrichedSites =
          (enrichedData['enriched_sites'] as List).cast<Map<String, dynamic>>();

      final List<SiteComplement> moduleSiteComplements =
          (enrichedData['site_complements'] as List).cast<SiteComplement>();

      // Traiter les sites
      for (final siteJson in enrichedSites) {
        final site = BaseSiteEntity.fromJson(siteJson);
        final domainSite = site.toDomain();

        // Vérifier si le site existe déjà
        final existingSite = await database.getSiteById(domainSite.idBaseSite);

        if (existingSite == null) {
          // Le site n'existe pas, l'ajouter
          await database.insertSites([domainSite]);
        } else {
          // Le site existe, le mettre à jour
          await database.updateSite(domainSite);
        }

        // Créer la relation site-module (même si elle existe déjà, ça ne fait pas de doublon)
        await database.insertSiteModule(SiteModule(
          idSite: domainSite.idBaseSite,
          idModule: module.id,
        ));
      }

      // Traiter les compléments de sites
      for (final complement in moduleSiteComplements) {
        await database.insertSiteComplements([complement]);
      }

      print('Fetched ${enrichedSites.length} sites for module $moduleCode');
    } catch (error) {
      print('Error fetching sites for module $moduleCode: $error');
      throw Exception('Failed to fetch sites for module $moduleCode');
    }
  }

  @override
  Future<void> fetchSiteGroupsForModule(String moduleCode, String token) async {
    try {
      // Récupérer le module par son code
      final module = await modulesDatabase.getModuleByCode(moduleCode);
      if (module == null) {
        throw Exception('Module $moduleCode not found');
      }

      // Récupérer les groupes de sites pour ce module
      final siteGroups = await api.fetchSiteGroupsForModule(moduleCode, token);

      for (final siteGroup in siteGroups) {
        final domainSiteGroup = siteGroup.siteGroup.toDomain();

        // Vérifier si le groupe existe déjà
        final existingGroups = await database.getAllSiteGroups();
        final existingGroup = existingGroups.firstWhere(
          (g) => g.idSitesGroup == domainSiteGroup.idSitesGroup,
          orElse: () => const SiteGroup(
            idSitesGroup: -1,
          ),
        );

        if (existingGroup.idSitesGroup == -1) {
          // Le groupe n'existe pas, l'ajouter
          await database.insertSiteGroups([domainSiteGroup]);
        } else {
          // Le groupe existe, le mettre à jour
          await database.updateSiteGroup(domainSiteGroup);
        }

        // Créer la relation groupe-module
        await database.insertSiteGroupModules([
          SitesGroupModule(
            idSitesGroup: domainSiteGroup.idSitesGroup,
            idModule: module.id,
          )
        ]);
      }

      print('Fetched ${siteGroups.length} site groups for module $moduleCode');
    } catch (error) {
      print('Error fetching site groups for module $moduleCode: $error');
      throw Exception('Failed to fetch site groups for module $moduleCode');
    }
  }

  @override
  Future<void> fetchSiteGroupsAndSitesGroupModules(String token) async {
    try {
      // Récupérer uniquement les modules téléchargés
      final modules = await modulesDatabase.getDownloadedModules();

      if (modules.isEmpty) {
        print(
            'Aucun module téléchargé trouvé, récupération des groupes de sites ignorée');
        return;
      }

      // Maps to store unique site groups and the relationships to modules
      final Map<int, SiteGroup> uniqueSiteGroups = {};
      final List<SitesGroupModule> sitesGroupModules = [];

      // Pour chaque module téléchargé, récupérer ses groupes de sites
      print(
          'Récupération des groupes de sites pour ${modules.length} modules téléchargés');
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
  Future<SyncResult> incrementalSyncSiteGroupsWithConflictHandling(
      String token) async {
    // Variables pour les métriques et conflits
    final List<SyncConflict> allConflicts = [];
    int itemsProcessed = 0;
    int itemsAdded = 0;
    int itemsUpdated = 0;
    int itemsDeleted = 0;
    int itemsSkipped = 0;

    try {
      // Récupérer uniquement les modules téléchargés
      final modules = await modulesDatabase.getDownloadedModules();

      if (modules.isEmpty) {
        print(
            'Aucun module téléchargé trouvé, synchronisation des groupes de sites ignorée');
        return SyncResult.success(
          itemsProcessed: 0,
          itemsAdded: 0,
          itemsUpdated: 0,
          itemsSkipped: 0,
        );
      }

      // Traiter chaque module individuellement
      for (final module in modules) {
        if (module.moduleCode == null) continue;

        print('=== Synchronisation groupes de sites module ${module.moduleCode} ===');

        // NOTE: Les compléments de sites sont mis à jour lors de la synchronisation des sites
        // qui précède cette synchronisation des groupes de sites dans le processus complet

        // 1. Récupérer les groupes de sites LOCAUX pour CE MODULE spécifiquement
        final localSiteGroupsForModule = await database.getSiteGroupsByModuleId(module.id);
        final localSiteGroupIdsForModule =
            localSiteGroupsForModule.map((sg) => sg.idSitesGroup).toSet();

        print(
            'Groupes de sites locaux pour le module ${module.moduleCode}: ${localSiteGroupsForModule.length}');

        // 2. Récupérer les groupes de sites DISTANTS pour CE MODULE
        List<SiteGroup> remoteSiteGroups;

        try {
          final siteGroups =
              await api.fetchSiteGroupsForModule(module.moduleCode!, token);

          remoteSiteGroups = siteGroups
              .map((sg) => sg.siteGroup.toDomain())
              .toList();

          print(
              'Groupes de sites distants pour le module ${module.moduleCode}: ${remoteSiteGroups.length}');
        } catch (e) {
          print(
              'Module ${module.moduleCode}: Aucun groupe de sites trouvé ou erreur API - $e');
          // Si le module n'a pas de groupes de sites, traiter comme une liste vide
          remoteSiteGroups = [];
          // Ne pas faire continue, traiter comme un cas normal avec 0 groupe
        }

        // 3. Créer les ensembles d'IDs pour la comparaison
        final remoteSiteGroupIds = remoteSiteGroups.map((sg) => sg.idSitesGroup).toSet();

        // 4. Identifier les changements pour CE MODULE

        // Groupes de sites à ajouter : existent sur le serveur mais pas localement pour ce module
        final siteGroupsToAdd = remoteSiteGroups
            .where((sg) => !localSiteGroupIdsForModule.contains(sg.idSitesGroup))
            .toList();

        // Groupes de sites à supprimer : existent localement pour ce module mais plus sur le serveur
        final siteGroupsToDelete = localSiteGroupsForModule
            .where((sg) => !remoteSiteGroupIds.contains(sg.idSitesGroup))
            .toList();

        // Groupes de sites à mettre à jour : existent des deux côtés
        final siteGroupsToUpdate = remoteSiteGroups
            .where((sg) => localSiteGroupIdsForModule.contains(sg.idSitesGroup))
            .toList();

        print(
            'Module ${module.moduleCode} - À ajouter: ${siteGroupsToAdd.length}, À supprimer: ${siteGroupsToDelete.length}, À mettre à jour: ${siteGroupsToUpdate.length}');

        // 5. Gérer les suppressions des groupes de sites - pas de conflit car la suppression
        // d'un groupe n'entraine pas de perte de données (les sites restent, seul id_sites_group devient NULL)
        for (final siteGroup in siteGroupsToDelete) {
          print('Suppression du groupe de sites ${siteGroup.idSitesGroup} du module ${module.moduleCode}');
          
          // Supprimer la relation groupe-module
          await database.deleteSiteGroupModule(siteGroup.idSitesGroup, module.id);

          // Vérifier si le groupe appartient à d'autres modules avant suppression complète
          final hasOtherReferences = await database.siteGroupHasOtherModuleReferences(siteGroup.idSitesGroup, module.id);

          if (!hasOtherReferences) {
            // Le groupe n'est lié à aucun autre module, on peut le supprimer complètement
            // Note: Les compléments de sites ont déjà été mis à jour lors de la synchronisation des sites (qui précède celle des groupes)
            await database.deleteSiteGroup(siteGroup.idSitesGroup);
            print('Groupe de sites ${siteGroup.idSitesGroup} supprimé complètement (pas d\'autres références de modules)');
            itemsDeleted++;
          } else {
            // Le groupe est encore lié à d'autres modules, on ne supprime que la relation
            print('Groupe de sites ${siteGroup.idSitesGroup} conservé (lié à d\'autres modules), relation supprimée uniquement');
          }
        }

        // 6. Ajouter les nouveaux groupes de sites
        for (final siteGroup in siteGroupsToAdd) {
          // Vérifier si le groupe existe déjà dans la base (pour un autre module)
          final existingSiteGroups = await database.getAllSiteGroups();
          final existingGroup = existingSiteGroups.firstWhere(
            (g) => g.idSitesGroup == siteGroup.idSitesGroup,
            orElse: () => const SiteGroup(idSitesGroup: -1),
          );

          if (existingGroup.idSitesGroup == -1) {
            // Le groupe n'existe pas du tout, l'ajouter
            await database.insertSiteGroups([siteGroup]);
          }

          // Créer la relation groupe-module
          await database.insertSiteGroupModules([
            SitesGroupModule(
              idSitesGroup: siteGroup.idSitesGroup,
              idModule: module.id,
            )
          ]);
          itemsAdded++;
        }

        // 7. Mettre à jour les groupes existants
        for (final siteGroup in siteGroupsToUpdate) {
          await database.updateSiteGroup(siteGroup);
          itemsUpdated++;
        }

        itemsProcessed += remoteSiteGroups.length;
      }

      print('=== Résumé de la synchronisation des groupes de sites ===');
      print(
          'Traités: $itemsProcessed, Ajoutés: $itemsAdded, Mis à jour: $itemsUpdated, Supprimés: $itemsDeleted, Conflits: ${allConflicts.length}');

      if (allConflicts.isNotEmpty) {
        return SyncResult.withConflicts(
          itemsProcessed: itemsProcessed,
          itemsAdded: itemsAdded,
          itemsUpdated: itemsUpdated,
          itemsDeleted: itemsDeleted,
          itemsSkipped: itemsSkipped,
          itemsFailed: 0,
          conflicts: allConflicts,
          errorMessage:
              'Certains groupes de sites ont des références locales dans différents modules',
        );
      } else {
        return SyncResult.success(
          itemsProcessed: itemsProcessed,
          itemsAdded: itemsAdded,
          itemsUpdated: itemsUpdated,
          itemsDeleted: itemsDeleted,
          itemsSkipped: itemsSkipped,
        );
      }
    } catch (error) {
      print('Erreur lors de la synchronisation des groupes de sites par module: $error');
      return SyncResult.failure(
        errorMessage: 'Erreur: $error',
      );
    }
  }

  @override
  Future<void> incrementalSyncSiteGroupsAndSitesGroupModules(
      String token) async {
    try {
      // Récupérer uniquement les modules marqués comme téléchargés
      final modules = await modulesDatabase.getDownloadedModules();

      if (modules.isEmpty) {
        print(
            'Aucun module téléchargé trouvé, synchronisation des groupes de sites ignorée');
        return;
      }

      // Get existing site groups to determine what's new
      final existingSiteGroups = await database.getAllSiteGroups();
      final existingSiteGroupIds =
          existingSiteGroups.map((sg) => sg.idSitesGroup).toSet();

      // Get existing site group modules to determine what relationships are new
      final existingSiteGroupModules = await database.getAllSiteGroupModules();
      final existingSiteGroupModuleKeys = existingSiteGroupModules
          .map((sgm) => '${sgm.idSitesGroup}_${sgm.idModule}')
          .toSet();

      // Maps to store site groups and relationships data
      final Map<int, SiteGroup> remoteSiteGroups = {};
      final Map<String, SitesGroupModule> remoteSiteGroupModuleMap = {};
      final Set<int> remotelyAccessibleSiteGroupIds = {};

      // For each module, fetch its site groups
      print(
          'Synchronisation des groupes de sites pour ${modules.length} modules téléchargés');

      for (final module in modules) {
        if (module.moduleCode == null) continue;

        try {
          print(
              'Fetching site groups for module: ${module.moduleCode} (${module.moduleLabel})');

          // Fetch site groups for this module
          final siteGroups =
              await api.fetchSiteGroupsForModule(module.moduleCode!, token);

          print(
              'Found ${siteGroups.length} site groups for module ${module.moduleCode}');

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

      // Track site group IDs that are associated with downloaded modules
      final Set<int> downloadedModuleSiteGroupIds = {};
      for (final module in modules) {
        final siteGroupModulesForThisModule =
            existingSiteGroupModules.where((sgm) => sgm.idModule == module.id);
        downloadedModuleSiteGroupIds.addAll(
            siteGroupModulesForThisModule.map((sgm) => sgm.idSitesGroup));
      }

      // 1. Identify site groups to ADD (exist remotely but not locally)
      final siteGroupsToAdd = remoteSiteGroups.values
          .where((sg) => !existingSiteGroupIds.contains(sg.idSitesGroup))
          .toList();

      // 2. Identify site groups to DELETE (exist locally in downloaded modules but no longer accessible remotely)
      final siteGroupsToDelete = downloadedModuleSiteGroupIds
          .where((siteGroupId) =>
              !remotelyAccessibleSiteGroupIds.contains(siteGroupId))
          .toList();

      // 3. Identify site groups to UPDATE (exist both locally and remotely)
      final siteGroupsToUpdate = remoteSiteGroups.values
          .where((sg) => existingSiteGroupIds.contains(sg.idSitesGroup))
          .toList();

      // 4. Identify site-group-module relationships to ADD and DELETE
      final siteGroupModulesToAdd =
          remoteSiteGroupModuleMap.values.where((sgm) {
        final key = '${sgm.idSitesGroup}_${sgm.idModule}';
        return !existingSiteGroupModuleKeys.contains(key);
      }).toList();

      // Only delete site-group-module relationships for downloaded modules
      final siteGroupModulesToDelete = existingSiteGroupModules.where((sgm) {
        // Only consider relationships for downloaded modules
        if (!modules.any((m) => m.id == sgm.idModule)) {
          return false;
        }
        final key = '${sgm.idSitesGroup}_${sgm.idModule}';
        return !remoteSiteGroupModuleMap.containsKey(key);
      }).toList();

      print(
          'À ajouter: ${siteGroupsToAdd.length} groupes de sites, ${siteGroupModulesToAdd.length} relations groupe-module');
      print(
          'Groupes de sites à supprimer des modules téléchargés: ${siteGroupsToDelete.length}');
      print(
          'Relations groupe-module à supprimer: ${siteGroupModulesToDelete.length}');
      print('À mettre à jour: ${siteGroupsToUpdate.length} groupes de sites');

      // 5. Perform database operations

      // Delete site-group-module relationships first
      for (final relationship in siteGroupModulesToDelete) {
        await database.deleteSiteGroupModule(
            relationship.idSitesGroup, relationship.idModule);
      }

      // Now check which site groups can be completely deleted (no remaining module associations)
      for (final siteGroupId in siteGroupsToDelete) {
        print('Vérification suppression groupe de sites $siteGroupId');
        
        // Check if the site group is still linked to any module
        final remainingSiteGroupModules =
            await database.getSiteGroupModulesBySiteGroupId(siteGroupId);

        if (remainingSiteGroupModules.isEmpty) {
          // This site group isn't linked to any module anymore, completely remove it
          // Note: Les compléments de sites ont déjà été mis à jour lors de la synchronisation des sites (qui précède celle des groupes)
          await database.deleteSiteGroup(siteGroupId);
          print('Groupe de sites $siteGroupId supprimé - plus lié à aucun module');
        } else {
          print('Groupe de sites $siteGroupId conservé - encore lié à ${remainingSiteGroupModules.length} module(s)');
        }
      }

      // Add new site groups
      if (siteGroupsToAdd.isNotEmpty) {
        await database.insertSiteGroups(siteGroupsToAdd);
      }

      // Add new site-group-module relationships
      if (siteGroupModulesToAdd.isNotEmpty) {
        await database.insertSiteGroupModules(siteGroupModulesToAdd);
      }

      // Update existing site groups
      for (final siteGroup in siteGroupsToUpdate) {
        await database.updateSiteGroup(siteGroup);
      }

      print(
          'Synchronisation incrémentale des groupes de sites terminée pour tous les modules téléchargés');
    } catch (error) {
      print('Erreur lors de la synchronisation des groupes de sites: $error');
      throw Exception('Failed to incrementally sync site groups');
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

  @override
  Future<List<BaseSite>> getSitesBySiteGroup(int siteGroupId) async {
    try {
      return await database.getSitesBySiteGroup(siteGroupId);
    } catch (error) {
      print('Error getting sites by site group: $error');
      throw Exception('Failed to get sites by site group');
    }
  }
}
