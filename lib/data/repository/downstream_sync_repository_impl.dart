import 'package:flutter/foundation.dart';
import 'package:gn_mobile_monitoring/core/errors/app_logger.dart';
import 'package:gn_mobile_monitoring/core/helpers/form_config_parser.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/global_api.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/taxon_api.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/datasets_database.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/global_database.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/nomenclatures_database.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/observations_database.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/taxon_database.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/visites_database.dart';
import 'package:gn_mobile_monitoring/data/mapper/dataset_entity_mapper.dart';
import 'package:gn_mobile_monitoring/data/mapper/nomenclature_entity_mapper.dart';
import 'package:gn_mobile_monitoring/domain/model/nomenclature_type.dart';
import 'package:gn_mobile_monitoring/domain/model/sync_conflict.dart';
import 'package:gn_mobile_monitoring/domain/model/sync_result.dart';
import 'package:gn_mobile_monitoring/domain/model/taxon_list.dart';
import 'package:gn_mobile_monitoring/domain/repository/downstream_sync_repository.dart';
import 'package:gn_mobile_monitoring/domain/repository/modules_repository.dart';
import 'package:gn_mobile_monitoring/domain/repository/sites_repository.dart';

/// Implémentation du repository de synchronisation descendante (serveur vers appareil)
class DownstreamSyncRepositoryImpl implements DownstreamSyncRepository {
  final GlobalApi _globalApi;
  final TaxonApi _taxonApi;
  final GlobalDatabase _globalDatabase;
  final NomenclaturesDatabase _nomenclaturesDatabase;
  final DatasetsDatabase _datasetsDatabase;
  final TaxonDatabase _taxonDatabase;
  final VisitesDatabase _visitesDatabase;
  final ObservationsDatabase _observationsDatabase;

  // Repositories pour la délégation des tâches de synchronisation
  final ModulesRepository _modulesRepository;
  final SitesRepository _sitesRepository;

  final AppLogger _logger = AppLogger();

  DownstreamSyncRepositoryImpl(
    this._globalApi,
    this._taxonApi,
    this._globalDatabase,
    this._nomenclaturesDatabase,
    this._datasetsDatabase,
    this._taxonDatabase, {
    required ModulesRepository modulesRepository,
    required SitesRepository sitesRepository,
    required VisitesDatabase visitesDatabase,
    required ObservationsDatabase observationsDatabase,
  })  : _modulesRepository = modulesRepository,
        _sitesRepository = sitesRepository,
        _visitesDatabase = visitesDatabase,
        _observationsDatabase = observationsDatabase;

  /// Vérifie la connectivité
  @override
  Future<bool> checkConnectivity() async {
    try {
      return await _globalApi.checkConnectivity();
    } catch (e) {
      debugPrint('Erreur lors de la vérification de la connectivité: $e');
      return false;
    }
  }

  /// Récupère la date de dernière synchronisation
  @override
  Future<DateTime?> getLastSyncDate(String entityType) async {
    try {
      return await _globalDatabase.getLastSyncDate(entityType);
    } catch (e) {
      debugPrint(
          'Erreur lors de la récupération de la date de synchronisation: $e');
      return null;
    }
  }

  /// Met à jour la date de dernière synchronisation
  @override
  Future<void> updateLastSyncDate(String entityType, DateTime syncDate) async {
    try {
      await _globalDatabase.updateLastSyncDate(entityType, syncDate);
    } catch (e) {
      debugPrint(
          'Erreur lors de la mise à jour de la date de synchronisation: $e');
      rethrow;
    }
  }

  @override
  Future<SyncResult> syncConfiguration(String token) async {
    try {
      // Vérifier la connectivité
      final isConnected = await checkConnectivity();
      if (!isConnected) {
        return SyncResult.failure(
          errorMessage: 'Pas de connexion Internet',
        );
      }

      // Récupérer la liste des modules téléchargés
      final downloadedModules = await _modulesRepository.getModulesFromLocal();
      final downloadedModuleCodes = downloadedModules
          .where((module) => module.downloaded == true)
          .map((module) => module.moduleCode)
          .whereType<String>()
          .toList();

      if (downloadedModuleCodes.isEmpty) {
        return SyncResult.success(
          itemsProcessed: 0,
          itemsAdded: 0,
          itemsUpdated: 0,
          itemsSkipped: 0,
        );
      }

      // Récupérer la configuration depuis l'API pour les modules téléchargés
      final result =
          await _globalApi.syncConfiguration(token, downloadedModuleCodes);

      // Mettre à jour la date de synchronisation
      if (result.success) {
        await updateLastSyncDate('configuration', DateTime.now());
      }

      return result;
    } catch (e) {
      debugPrint('Erreur lors de la synchronisation de la configuration: $e');
      // Import du helper dans ce fichier si nécessaire
      final errorMessage = e.toString().toLowerCase().contains('failed host lookup') 
          ? 'Erreur réseau lors de la synchronisation de la configuration: Impossible de contacter le serveur. Vérifiez votre connexion Internet.'
          : 'Erreur lors de la synchronisation de la configuration: $e';
      
      return SyncResult.failure(
        errorMessage: errorMessage,
      );
    }
  }

  @override
  Future<SyncResult> syncNomenclatures(String token,
      {DateTime? lastSync}) async {
    // Déléguer à la méthode complète qui gère à la fois les nomenclatures et les datasets
    return syncNomenclaturesAndDatasets(token, lastSync: lastSync);
  }

  @override
  Future<SyncResult> syncNomenclaturesAndDatasets(String token,
      {DateTime? lastSync}) async {
    try {
      // Vérifier la connectivité
      final isConnected = await checkConnectivity();
      if (!isConnected) {
        return SyncResult.failure(
          errorMessage: 'Pas de connexion Internet',
        );
      }

      // Récupérer la liste des modules téléchargés
      final downloadedModules = await _modulesRepository.getModulesFromLocal();
      final downloadedModuleCodes = downloadedModules
          .where((module) => module.downloaded == true)
          .map((module) => module.moduleCode)
          .whereType<String>()
          .toList();

      if (downloadedModuleCodes.isEmpty) {
        return SyncResult.success(
          itemsProcessed: 0,
          itemsAdded: 0,
          itemsUpdated: 0,
          itemsSkipped: 0,
        );
      }

      int itemsProcessed = 0;
      int itemsAdded = 0;
      int itemsUpdated = 0;
      int itemsSkipped = 0;
      int itemsDeleted = 0;
      List<String> errors = [];
      // Le Map conflicts n'est pas utilisé, mais conservé comme référence pour les implémentations futures
      // final conflicts = <String, List<String>>{};

      // Récupérer les nomenclatures existantes dans la base de données
      final existingNomenclatures =
          await _nomenclaturesDatabase.getAllNomenclatures();
      final existingNomenclatureIds =
          existingNomenclatures.map((n) => n.id).toSet();
      final serverNomenclatureIds = <int>{};

      // Obtenir les IDs des modules téléchargés
      final downloadedModuleIds = downloadedModules
          .where((module) => module.downloaded == true)
          .map((module) => module.id)
          .toList();

      int modulesSucceeded = 0;
      int modulesFailed = 0;

      // Synchroniser les nomenclatures et datasets pour chaque module
      for (final moduleId in downloadedModuleIds) {
        try {
          final module = downloadedModules.firstWhere((m) => m.id == moduleId);
          final moduleCode = module.moduleCode ?? 'unknown';
          debugPrint('Synchronisation du module $moduleCode (ID: $moduleId)');

          // Récupérer les nomenclatures et datasets du module
          // IMPORTANT: Passer le token pour l'authentification
          final data = await _globalApi.getNomenclaturesAndDatasets(moduleId, token: token);

          // Convertir les nomenclatures entities en domain models
          final nomenclatures =
              data.nomenclatures.map((e) => e.toDomain()).toList();

          debugPrint(
              'Module $moduleCode: ${nomenclatures.length} nomenclatures reçues');

          // Collecter tous les IDs de nomenclatures du serveur
          serverNomenclatureIds.addAll(nomenclatures.map((n) => n.id));

          // Les nomenclatures seront automatiquement mises à jour ou insérées
          await _nomenclaturesDatabase.insertNomenclatures(nomenclatures);

          // Déterminer combien ont été ajoutées vs. mises à jour
          final insertedCount = nomenclatures
              .where((n) => !existingNomenclatureIds.contains(n.id))
              .length;
          final updatedCount = nomenclatures.length - insertedCount;

          // Traiter les types de nomenclature
          if (data.nomenclatureTypes.isNotEmpty) {
            // Convertir les types de nomenclature
            final types = data.nomenclatureTypes
                .map((typeData) => NomenclatureType(
                      idType: typeData['idType'] as int,
                      mnemonique: typeData['mnemonique'] as String,
                    ))
                .toList();

            // Insérer ou mettre à jour les types
            await _nomenclaturesDatabase.insertNomenclatureTypes(types);
          }

          // Convertir et traiter les datasets
          final datasets = data.datasets.map((e) => e.toDomain()).toList();
          await _datasetsDatabase.insertDatasets(datasets);

          // Recréer les associations module-dataset
          await _modulesRepository.clearDatasetAssociationsForModule(moduleId);
          for (final dataset in datasets) {
            await _modulesRepository.associateModuleWithDataset(moduleId, dataset.id);
          }

          // Rafraîchir la configuration du module (y compris types_site)
          await _modulesRepository.refreshModuleConfiguration(moduleId, data.configuration);

          // Mettre à jour les compteurs
          itemsProcessed += nomenclatures.length +
              datasets.length +
              data.nomenclatureTypes.length;
          itemsAdded += insertedCount;
          itemsUpdated += updatedCount + data.datasets.length;
          
          modulesSucceeded++;
        } catch (e) {
          itemsSkipped++;
          modulesFailed++;
          final module = downloadedModules.firstWhere((m) => m.id == moduleId);
          final moduleCode = module.moduleCode ?? 'unknown';
          errors.add('Module $moduleCode: ${e.toString()}');
          debugPrint(
              'Erreur lors de la synchronisation du module $moduleCode: $e');
        }
      }

      // Identifier les nomenclatures qui existent dans la base locale mais pas sur le serveur
      // Ces nomenclatures ont été supprimées sur le serveur et doivent être supprimées localement
      final deletedNomenclatureIds =
          existingNomenclatureIds.difference(serverNomenclatureIds);

      // Vérifier et traiter les nomenclatures supprimées
      final nomenclatureConflictsMap = <int, List<SyncConflict>>{};

      for (final nomenclatureId in deletedNomenclatureIds) {
        try {
          // Vérifier si cette nomenclature est référencée par des observations, visites, etc.
          final nomenclatureConflicts = await _nomenclaturesDatabase
              .checkNomenclatureReferences(nomenclatureId);

          if (nomenclatureConflicts.isEmpty) {
            // Aucun conflit - supprimer la nomenclature en toute sécurité
            await _nomenclaturesDatabase.deleteNomenclature(nomenclatureId);
            itemsDeleted++;
          } else {
            // Des références existent - enregistrer les conflits
            nomenclatureConflictsMap[nomenclatureId] = nomenclatureConflicts;

            // Construire un message d'erreur plus détaillé avec les références
            final affectedEntitiesStr = nomenclatureConflicts
                .map((c) => '${c.entityType}:${c.entityId}')
                .take(3)
                .join(', ');

            final moreEntities = nomenclatureConflicts.length > 3
                ? " (+ ${nomenclatureConflicts.length - 3} autres)"
                : "";

            errors.add(
                'Nomenclature $nomenclatureId: Impossible de supprimer - référencée par $affectedEntitiesStr$moreEntities');
          }
        } catch (e) {
          itemsSkipped++;
          errors.add(
              'Nomenclature $nomenclatureId: Erreur lors de la suppression: ${e.toString()}');
          debugPrint(
              'Erreur lors de la suppression de la nomenclature $nomenclatureId: $e');
        }
      }

      // Si des conflits ont été détectés, les inclure dans le résultat
      if (nomenclatureConflictsMap.isNotEmpty) {
        // Convertir tous les conflits en une seule liste plate
        final allConflicts = <SyncConflict>[];
        nomenclatureConflictsMap.forEach((id, conflicts) {
          allConflicts.addAll(conflicts);
        });

        // Mettre à jour la date de synchronisation
        await updateLastSyncDate('nomenclatures', DateTime.now());

        // Ajouter un log pour le débogage
        debugPrint(
            'Création d\'un SyncResult.withConflicts avec ${allConflicts.length} conflits');

        // Retourner un résultat de type conflit
        return SyncResult.withConflicts(
          itemsProcessed: itemsProcessed,
          itemsAdded: itemsAdded,
          itemsUpdated: itemsUpdated,
          itemsSkipped: itemsSkipped,
          itemsDeleted: itemsDeleted,
          itemsFailed: errors.length,
          conflicts: allConflicts,
          errorMessage:
              'Des nomenclatures supprimées sont référencées par des entités:\n${errors.join('\n')}',
        );
      }

      // Mettre à jour la date de synchronisation
      await updateLastSyncDate('nomenclatures', DateTime.now());

      // Si tous les modules ont échoué, retourner un échec
      if (modulesSucceeded == 0 && modulesFailed > 0) {
        return SyncResult.failure(
          errorMessage:
              'Tous les modules ont échoué lors de la synchronisation:\n${errors.join('\n')}',
          itemsProcessed: itemsProcessed,
          itemsAdded: itemsAdded,
          itemsUpdated: itemsUpdated,
          itemsSkipped: itemsSkipped,
          itemsDeleted: itemsDeleted,
        );
      }

      // Si certains modules ont réussi mais d'autres ont échoué, retourner un succès avec avertissement
      if (errors.isNotEmpty && modulesSucceeded > 0) {
        debugPrint(
            'Synchronisation partielle: $modulesSucceeded modules réussis, $modulesFailed modules ignorés');
        // Considérer comme un succès partiel - les modules en échec sont comptés dans itemsSkipped
        return SyncResult.success(
          itemsProcessed: itemsProcessed,
          itemsAdded: itemsAdded,
          itemsUpdated: itemsUpdated,
          itemsSkipped: itemsSkipped,
          itemsDeleted: itemsDeleted,
        );
      }

      return SyncResult.success(
        itemsProcessed: itemsProcessed,
        itemsAdded: itemsAdded,
        itemsUpdated: itemsUpdated,
        itemsSkipped: itemsSkipped,
        itemsDeleted: itemsDeleted,
      );
    } catch (e) {
      debugPrint(
          'Erreur lors de la synchronisation des nomenclatures et datasets: $e');
      return SyncResult.failure(
        errorMessage:
            'Erreur lors de la synchronisation des nomenclatures et datasets: $e',
      );
    }
  }

  @override
  Future<SyncResult> syncObservers(String token, {DateTime? lastSync}) async {
    try {
      // Vérifier la connectivité
      final isConnected = await checkConnectivity();
      if (!isConnected) {
        return SyncResult.failure(
          errorMessage: 'Pas de connexion Internet',
        );
      }

      // Récupérer la date de dernière synchronisation si non spécifiée
      final effectiveLastSync = lastSync ?? await getLastSyncDate('observers');

      // Télécharger les observateurs depuis l'API
      // Appel de l'API pas encore implémenté, on simule ici
      final result = SyncResult.success(
        itemsProcessed: 0,
        itemsAdded: 0,
        itemsUpdated: 0,
        itemsSkipped: 0,
      );

      // Mettre à jour la date de synchronisation
      await updateLastSyncDate('observers', DateTime.now());

      return result;
    } catch (e) {
      debugPrint('Erreur lors de la synchronisation des observateurs: $e');
      return SyncResult.failure(
        errorMessage: 'Erreur lors de la synchronisation des observateurs: $e',
      );
    }
  }

  @override
  Future<SyncResult> syncTaxons(String token, {DateTime? lastSync}) async {
    try {
      debugPrint(
          'syncTaxons - Début de la synchronisation des taxons (page-par-page)');

      // Vérifier la connectivité
      final isConnected = await checkConnectivity();
      if (!isConnected) {
        return SyncResult.failure(
          errorMessage: 'Pas de connexion Internet',
        );
      }

      // Récupérer la liste des modules téléchargés
      final allModules = await _modulesRepository.getModulesFromLocal();
      final downloadedModules =
          allModules.where((module) => module.downloaded == true).toList();

      if (downloadedModules.isEmpty) {
        return SyncResult.success(
          itemsProcessed: 0,
          itemsAdded: 0,
          itemsUpdated: 0,
          itemsSkipped: 0,
        );
      }

      // Extraire les IDs de listes taxonomiques des modules téléchargés
      final taxonomyListIdsSet = <int>{};
      for (final module in downloadedModules) {
        final moduleCode = module.moduleCode ?? 'unknown';
        try {
          final config = module.complement?.configuration;
          if (config != null) {
            final configListIds =
                FormConfigParser.extractAllTaxonomyListIds(config);
            if (configListIds.isNotEmpty) {
              taxonomyListIdsSet.addAll(configListIds);
              debugPrint(
                  'syncTaxons - Module $moduleCode: ${configListIds.length} listes taxonomiques: $configListIds');
            }
          }
          final complementListId = module.complement?.idListTaxonomy;
          if (complementListId != null) {
            taxonomyListIdsSet.add(complementListId);
          }
        } catch (e) {
          debugPrint(
              'syncTaxons - Erreur extraction listes pour module $moduleCode: $e');
        }
      }

      if (taxonomyListIdsSet.isEmpty) {
        debugPrint('syncTaxons - Aucune liste taxonomique à synchroniser');
        return SyncResult.success(
          itemsProcessed: 0,
          itemsAdded: 0,
          itemsUpdated: 0,
          itemsSkipped: 0,
        );
      }

      debugPrint(
          'syncTaxons - ${taxonomyListIdsSet.length} listes à synchroniser: $taxonomyListIdsSet');

      try {
        // ── PHASE 1 : Snapshot léger (IDs only) ──
        final existingTaxonIds = await _taxonDatabase.getAllTaxonCdNoms();
        final existingListIds = await _taxonDatabase.getAllListIds();
        final Map<int, Set<int>> existingPerListTaxonIds = {};
        for (final listId in taxonomyListIdsSet) {
          existingPerListTaxonIds[listId] =
              await _taxonDatabase.getCdNomsByListId(listId);
        }
        debugPrint(
            'syncTaxons - Snapshot: ${existingTaxonIds.length} taxons, ${existingListIds.length} listes');

        // ── PHASE 2 : Fetch + save page-par-page ──
        final serverTaxonIds = <int>{};
        final serverListIds = <int>{};
        final Map<int, Set<int>> serverPerListTaxonIds = {};
        int listsProcessed = 0;
        int listsSkipped = 0;
        int totalTaxonsSaved = 0;
        const int pageSize = 5000;

        for (final listId in taxonomyListIdsSet) {
          try {
            // 2a) Fetch + save metadata liste
            final taxonList = await _taxonApi.getTaxonList(listId);
            await _taxonDatabase.saveTaxonLists([taxonList]);
            serverListIds.add(listId);

            // 2b) Boucle de pagination
            final listCdNoms = <int>{};
            int page = 1;
            bool hasMore = true;

            while (hasMore) {
              final pageTaxons = await _taxonApi.fetchTaxonPage(
                listId,
                page: page,
                limit: pageSize,
              );

              if (pageTaxons.isNotEmpty) {
                // Save taxons (insertOrReplace, batch 500)
                await _taxonDatabase.saveTaxons(pageTaxons);

                // Collect cdNoms for this page
                final pageCdNoms = pageTaxons.map((t) => t.cdNom).toList();

                // Save associations (insertOrIgnore, batch 500)
                await _taxonDatabase.saveTaxonsToList(listId, pageCdNoms);

                // Track IDs
                serverTaxonIds.addAll(pageCdNoms);
                listCdNoms.addAll(pageCdNoms);
                totalTaxonsSaved += pageTaxons.length;

                debugPrint(
                    'syncTaxons - List $listId page $page: ${pageTaxons.length} taxons saved');
              }

              hasMore = pageTaxons.length >= pageSize;
              page++;
              // pageTaxons is now GC-eligible
            }

            serverPerListTaxonIds[listId] = listCdNoms;
            listsProcessed++;
            debugPrint(
                'syncTaxons - List $listId complete: ${listCdNoms.length} taxons total');
          } catch (e) {
            debugPrint('syncTaxons - List $listId failed: $e');
            listsSkipped++;
            continue;
          }
        }

        debugPrint(
            'syncTaxons - Phase 2 done: $listsProcessed lists OK, $listsSkipped skipped, $totalTaxonsSaved taxons saved, ${serverTaxonIds.length} unique');

        // ── PHASE 3 : Analyse de suppression ──
        final Set<int> previousListTaxonIds = <int>{};
        final Set<int> deletedTaxonIds = <int>{};
        final Map<int, Set<int>> taxonRemovedFromLists = <int, Set<int>>{};

        for (final entry in existingPerListTaxonIds.entries) {
          final listId = entry.key;
          final previousTaxonsInList = entry.value;
          final currentTaxonsInList = serverPerListTaxonIds[listId] ?? <int>{};

          final taxonsRemovedFromList =
              previousTaxonsInList.difference(currentTaxonsInList);

          if (taxonsRemovedFromList.isNotEmpty) {
            debugPrint(
                'syncTaxons - Liste $listId: ${taxonsRemovedFromList.length} taxons supprimés');
            previousListTaxonIds.addAll(taxonsRemovedFromList);
            for (final cdNom in taxonsRemovedFromList) {
              taxonRemovedFromLists
                  .putIfAbsent(cdNom, () => <int>{})
                  .add(listId);
            }
          }
        }

        // Check which taxons are completely removed (absent from all server lists)
        for (final cdNom in previousListTaxonIds) {
          if (!serverTaxonIds.contains(cdNom)) {
            deletedTaxonIds.add(cdNom);
          }
        }

        int itemsDeleted = 0;
        final allConflicts = <SyncConflict>[];

        // Process fully deleted taxons
        for (final cdNom in deletedTaxonIds) {
          final conflicts = await _taxonDatabase
              .checkTaxonReferencesInDatabaseObservations(cdNom);
          if (conflicts.isEmpty) {
            await _taxonDatabase.deleteTaxon(cdNom);
            itemsDeleted++;
          } else {
            allConflicts.addAll(conflicts);
            debugPrint(
                'syncTaxons - Taxon $cdNom: ${conflicts.length} conflicts');
          }
        }

        // Process taxons removed from some lists but still in others
        for (final entry in taxonRemovedFromLists.entries) {
          final cdNom = entry.key;
          final removedFromLists = entry.value;
          if (!deletedTaxonIds.contains(cdNom)) {
            final conflicts = await _taxonDatabase
                .checkTaxonReferencesInDatabaseObservations(cdNom,
                    removedFromListIds: removedFromLists);
            if (conflicts.isNotEmpty) {
              allConflicts.addAll(conflicts);
            }
          }
        }

        // ── PHASE 4 : Métriques ──
        await updateLastSyncDate('taxons', DateTime.now());

        final newTaxonIds = serverTaxonIds.difference(existingTaxonIds);
        final int realNewTaxons = newTaxonIds.length;

        int totalAssociationsCreated = 0;
        for (final entry in serverPerListTaxonIds.entries) {
          final listId = entry.key;
          final serverCdNoms = entry.value;
          final previousCdNoms = existingPerListTaxonIds[listId] ?? <int>{};
          totalAssociationsCreated +=
              serverCdNoms.difference(previousCdNoms).length;
        }

        final int itemsProcessed = totalTaxonsSaved;
        final int itemsAdded = realNewTaxons + totalAssociationsCreated;
        final int itemsUpdated = serverTaxonIds.length - realNewTaxons;

        debugPrint(
            'syncTaxons - Stats: $realNewTaxons new, $itemsUpdated updated, $totalAssociationsCreated new associations, $itemsDeleted deleted, $listsSkipped lists skipped');

        if (allConflicts.isNotEmpty) {
          return SyncResult.withConflicts(
            itemsProcessed: itemsProcessed,
            itemsAdded: itemsAdded > 0 ? itemsAdded : 0,
            itemsUpdated: itemsUpdated,
            itemsSkipped: listsSkipped,
            itemsDeleted: itemsDeleted,
            itemsFailed: allConflicts.length,
            conflicts: allConflicts,
            errorMessage:
                'Des taxons supprimés sont référencés par des observations',
          );
        }

        return SyncResult.success(
          itemsProcessed: itemsProcessed,
          itemsAdded: itemsAdded > 0 ? itemsAdded : 0,
          itemsUpdated: itemsUpdated,
          itemsSkipped: listsSkipped,
          itemsDeleted: itemsDeleted,
        );
      } catch (e) {
        debugPrint('syncTaxons - Erreur: $e');
        return SyncResult.failure(
          errorMessage: 'Erreur lors de la synchronisation des taxons: $e',
        );
      }
    } catch (e) {
      debugPrint('syncTaxons - Erreur générale: $e');
      return SyncResult.failure(
        errorMessage: 'Erreur lors de la synchronisation des taxons: $e',
      );
    }
  }

  @override
  Future<SyncResult> syncModules(String token, {DateTime? lastSync}) async {
    try {
      // Vérifier la connectivité
      final isConnected = await checkConnectivity();
      if (!isConnected) {
        return SyncResult.failure(
          errorMessage: 'Pas de connexion Internet',
        );
      }

      try {
        // Récupérer l'état avant la synchronisation pour les métriques
        final modulesBefore = await _modulesRepository.getModulesFromLocal();

        // Déléguer la synchronisation au repository spécialisé
        await _modulesRepository.incrementalSyncModulesFromApi(token);

        // Récupérer l'état après la synchronisation pour les métriques
        final modulesAfter = await _modulesRepository.getModulesFromLocal();

        // Calculer les métriques de synchronisation
        final itemsTotal = modulesAfter.length;
        final itemsAdded = modulesAfter.length - modulesBefore.length;
        // Une estimation simplifiée des mises à jour
        final itemsUpdated = modulesBefore.length -
            (modulesBefore.length > modulesAfter.length
                ? modulesBefore.length - modulesAfter.length
                : 0);

        // Mettre à jour la date de synchronisation
        await updateLastSyncDate('modules', DateTime.now());

        return SyncResult.success(
          itemsProcessed: itemsTotal,
          itemsAdded: itemsAdded > 0 ? itemsAdded : 0,
          itemsUpdated: itemsUpdated,
          itemsSkipped: 0, // Difficile à estimer sans plus d'informations
        );
      } catch (e) {
        debugPrint('Erreur lors de la synchronisation des modules: $e');
        return SyncResult.failure(
          errorMessage: 'Erreur lors de la synchronisation des modules: $e',
        );
      }
    } catch (e) {
      debugPrint('Erreur générale lors de la synchronisation des modules: $e');
      return SyncResult.failure(
        errorMessage: 'Erreur lors de la synchronisation des modules: $e',
      );
    }
  }

  @override
  Future<SyncResult> syncSites(String token, {DateTime? lastSync}) async {
    try {
      // Vérifier la connectivité
      final isConnected = await checkConnectivity();
      if (!isConnected) {
        return SyncResult.failure(
          errorMessage: 'Pas de connexion Internet',
        );
      }

      try {
        // Utiliser la nouvelle méthode qui gère les conflits
        final result = await _sitesRepository
            .incrementalSyncSitesWithConflictHandling(token);

        // Mettre à jour la date de synchronisation si succès ou conflits
        if (result.success ||
            (result.conflicts != null && result.conflicts!.isNotEmpty)) {
          await updateLastSyncDate('sites', DateTime.now());
        }

        return result;
      } catch (e) {
        debugPrint('Erreur lors de la synchronisation des sites: $e');
        return SyncResult.failure(
          errorMessage: 'Erreur lors de la synchronisation des sites: $e',
        );
      }
    } catch (e) {
      debugPrint('Erreur générale lors de la synchronisation des sites: $e');
      return SyncResult.failure(
        errorMessage: 'Erreur lors de la synchronisation des sites: $e',
      );
    }
  }

  @override
  Future<SyncResult> syncSiteGroups(String token, {DateTime? lastSync}) async {
    try {
      // Vérifier la connectivité
      final isConnected = await checkConnectivity();
      if (!isConnected) {
        return SyncResult.failure(
          errorMessage: 'Pas de connexion Internet',
        );
      }

      try {
        // Utiliser la nouvelle méthode qui gère les conflits
        final result = await _sitesRepository
            .incrementalSyncSiteGroupsWithConflictHandling(token);

        // Mettre à jour la date de synchronisation si succès ou conflits
        if (result.success ||
            (result.conflicts != null && result.conflicts!.isNotEmpty)) {
          await updateLastSyncDate('siteGroups', DateTime.now());
        }

        return result;
      } catch (e) {
        debugPrint(
            'Erreur lors de la synchronisation des groupes de sites: $e');
        return SyncResult.failure(
          errorMessage:
              'Erreur lors de la synchronisation des groupes de sites: $e',
        );
      }
    } catch (e) {
      debugPrint(
          'Erreur générale lors de la synchronisation des groupes de sites: $e');
      return SyncResult.failure(
        errorMessage:
            'Erreur lors de la synchronisation des groupes de sites: $e',
      );
    }
  }

}
