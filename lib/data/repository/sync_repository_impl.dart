import 'package:flutter/foundation.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/global_api.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/taxon_api.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/datasets_database.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/global_database.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/nomenclatures_database.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/taxon_database.dart';
import 'package:gn_mobile_monitoring/data/mapper/dataset_entity_mapper.dart';
import 'package:gn_mobile_monitoring/data/mapper/nomenclature_entity_mapper.dart';
import 'package:gn_mobile_monitoring/domain/model/nomenclature_type.dart';
import 'package:gn_mobile_monitoring/domain/model/sync_conflict.dart';
import 'package:gn_mobile_monitoring/domain/model/sync_result.dart';
import 'package:gn_mobile_monitoring/domain/repository/modules_repository.dart';
import 'package:gn_mobile_monitoring/domain/repository/sites_repository.dart';
import 'package:gn_mobile_monitoring/domain/repository/sync_repository.dart';

/// Implémentation du repository de synchronisation
class SyncRepositoryImpl implements SyncRepository {
  final GlobalApi _globalApi;
  final TaxonApi _taxonApi;
  final GlobalDatabase _globalDatabase;
  final NomenclaturesDatabase _nomenclaturesDatabase;
  final DatasetsDatabase _datasetsDatabase;
  final TaxonDatabase _taxonDatabase;

  // Repositories pour la délégation des tâches de synchronisation
  final ModulesRepository _modulesRepository;
  final SitesRepository _sitesRepository;

  SyncRepositoryImpl(
    this._globalApi,
    this._taxonApi,
    this._globalDatabase,
    this._nomenclaturesDatabase,
    this._datasetsDatabase,
    this._taxonDatabase, {
    required ModulesRepository modulesRepository,
    required SitesRepository sitesRepository,
  })  : _modulesRepository = modulesRepository,
        _sitesRepository = sitesRepository;

  @override
  Future<bool> checkConnectivity() async {
    try {
      return await _globalApi.checkConnectivity();
    } catch (e) {
      debugPrint('Erreur lors de la vérification de la connectivité: $e');
      return false;
    }
  }

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

  // Les méthodes relatives aux observations seront implémentées dans une future version

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
      return SyncResult.failure(
        errorMessage:
            'Erreur lors de la synchronisation de la configuration: $e',
      );
    }
  }

  @override
  Future<SyncResult> syncNomenclatures(String token,
      {DateTime? lastSync}) async {
    // Déléguer à la méthode complète qui gère à la fois les nomenclatures et les datasets
    return syncNomenclaturesAndDatasets(token, lastSync: lastSync);
  }

  // Méthode pour synchroniser à la fois les nomenclatures et les datasets
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

      // Récupérer la date de dernière synchronisation si nécessaire
      // Note: Actuellement non utilisée, mais gardée pour une utilisation future
      // avec des filtres de date côté API
      // final effectiveLastSync = lastSync ?? await getLastSyncDate('nomenclatures');

      int itemsProcessed = 0;
      int itemsAdded = 0;
      int itemsUpdated = 0;
      int itemsSkipped = 0;
      int itemsDeleted = 0;
      List<String> errors = [];
      final conflicts = <String, List<String>>{};

      // Récupérer les nomenclatures existantes dans la base de données
      final existingNomenclatures =
          await _nomenclaturesDatabase.getAllNomenclatures();
      final existingNomenclatureIds =
          existingNomenclatures.map((n) => n.id).toSet();
      final serverNomenclatureIds = <int>{};

      // Synchroniser les nomenclatures et datasets pour chaque module
      for (final moduleCode in downloadedModuleCodes) {
        try {
          // Récupérer les nomenclatures et datasets du module
          final data = await _globalApi.getNomenclaturesAndDatasets(moduleCode);

          // Convertir les nomenclatures entities en domain models
          final nomenclatures =
              data.nomenclatures.map((e) => e.toDomain()).toList();

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

          // Mettre à jour les compteurs
          itemsProcessed += nomenclatures.length +
              datasets.length +
              data.nomenclatureTypes.length;
          itemsAdded += insertedCount;
          itemsUpdated += updatedCount + data.datasets.length;
        } catch (e) {
          itemsSkipped++;
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
            // Ne pas incrémenter itemsSkipped pour les conflits
            // itemsSkipped++;

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
        debugPrint('Création d\'un SyncResult.withConflicts avec ${allConflicts.length} conflits');
        
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

      if (errors.isNotEmpty) {
        return SyncResult.failure(
          errorMessage:
              'Erreurs lors de la synchronisation:\n${errors.join('\n')}',
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

      // Récupérer la date de dernière synchronisation si non spécifiée
      final effectiveLastSync = lastSync ?? await getLastSyncDate('taxons');

      try {
        // Récupérer l'état avant la synchronisation pour les métriques
        final taxonsBefore = await _taxonDatabase.getAllTaxons();
        // Note: taxonListsBefore pourrait être utilisé pour des métriques détaillées plus tard
        // await _taxonDatabase.getAllTaxonLists();

        // Télécharger les taxons depuis l'API
        final result = await _taxonApi.syncTaxons(
          token,
          downloadedModuleCodes,
          lastSync: effectiveLastSync,
        );

        if (result.success) {
          // Mettre à jour la date de synchronisation
          await updateLastSyncDate('taxons', DateTime.now());

          // Récupérer l'état après la synchronisation pour les métriques
          final taxonsAfter = await _taxonDatabase.getAllTaxons();
          // Note: taxonListsAfter pourrait être utilisé pour des métriques détaillées plus tard
          // await _taxonDatabase.getAllTaxonLists();

          // Calculer les métriques de synchronisation
          final itemsTotal = taxonsAfter.length;
          final itemsAdded = taxonsAfter.length - taxonsBefore.length;
          // Une estimation des mises à jour
          final itemsUpdated = taxonsBefore.length -
              (taxonsBefore.length > taxonsAfter.length
                  ? taxonsBefore.length - taxonsAfter.length
                  : 0);

          return SyncResult.success(
            itemsProcessed: itemsTotal,
            itemsAdded: itemsAdded > 0 ? itemsAdded : 0,
            itemsUpdated: itemsUpdated,
            itemsSkipped: result.itemsSkipped,
          );
        }

        return result;
      } catch (e) {
        debugPrint('Erreur lors de la synchronisation des taxons: $e');
        return SyncResult.failure(
          errorMessage: 'Erreur lors de la synchronisation des taxons: $e',
        );
      }
    } catch (e) {
      debugPrint('Erreur générale lors de la synchronisation des taxons: $e');
      return SyncResult.failure(
        errorMessage: 'Erreur lors de la synchronisation des taxons: $e',
      );
    }
  }

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
  Future<SyncResult> syncModules(String token, {DateTime? lastSync}) async {
    try {
      // Vérifier la connectivité
      final isConnected = await checkConnectivity();
      if (!isConnected) {
        return SyncResult.failure(
          errorMessage: 'Pas de connexion Internet',
        );
      }

      // Récupérer la date de dernière synchronisation (non utilisée ici mais préparée pour implémentations futures)
      // final effectiveLastSync = lastSync ?? await getLastSyncDate('modules');

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

      // Récupérer la date de dernière synchronisation (non utilisée actuellement)
      // final effectiveLastSync = lastSync ?? await getLastSyncDate('sites');

      try {
        // Récupérer les sites avant la synchronisation pour les métriques
        final sitesBefore = await _sitesRepository.getSites();

        // Déléguer la synchronisation au repository spécialisé
        await _sitesRepository.incrementalSyncSitesAndSiteModules(token);

        // Récupérer les sites après la synchronisation pour les métriques
        final sitesAfter = await _sitesRepository.getSites();

        // Calculer les métriques de synchronisation
        final itemsTotal = sitesAfter.length;
        final itemsAdded = sitesAfter.length > sitesBefore.length
            ? sitesAfter.length - sitesBefore.length
            : 0;
        // Une estimation des mises à jour - difficile à être précis sans plus d'informations
        final itemsUpdated = sitesBefore.length -
            (sitesBefore.length > sitesAfter.length
                ? sitesBefore.length - sitesAfter.length
                : 0);

        // Mettre à jour la date de synchronisation
        await updateLastSyncDate('sites', DateTime.now());

        return SyncResult.success(
          itemsProcessed: itemsTotal,
          itemsAdded: itemsAdded,
          itemsUpdated: itemsUpdated,
          itemsSkipped: 0, // Difficile à estimer sans plus d'informations
        );
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

      // Récupérer la date de dernière synchronisation (pour une utilisation future)
      // final effectiveLastSync = lastSync ?? await getLastSyncDate('siteGroups');

      try {
        // Récupérer les groupes de sites avant la synchronisation pour les métriques
        final siteGroupsBefore = await _sitesRepository.getSiteGroups();

        // Déléguer la synchronisation au repository spécialisé
        await _sitesRepository
            .incrementalSyncSiteGroupsAndSitesGroupModules(token);

        // Récupérer les groupes de sites après la synchronisation pour les métriques
        final siteGroupsAfter = await _sitesRepository.getSiteGroups();

        // Calculer les métriques de synchronisation
        final itemsTotal = siteGroupsAfter.length;
        final itemsAdded = siteGroupsAfter.length > siteGroupsBefore.length
            ? siteGroupsAfter.length - siteGroupsBefore.length
            : 0;
        final itemsUpdated = siteGroupsBefore.length -
            (siteGroupsBefore.length > siteGroupsAfter.length
                ? siteGroupsBefore.length - siteGroupsAfter.length
                : 0);

        // Mettre à jour la date de synchronisation
        await updateLastSyncDate('siteGroups', DateTime.now());

        return SyncResult.success(
          itemsProcessed: itemsTotal,
          itemsAdded: itemsAdded,
          itemsUpdated: itemsUpdated,
          itemsSkipped: 0, // Difficile à estimer sans plus d'informations
        );
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
