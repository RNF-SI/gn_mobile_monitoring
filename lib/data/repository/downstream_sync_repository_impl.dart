import 'package:flutter/foundation.dart';
import 'package:gn_mobile_monitoring/core/errors/app_logger.dart';
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
import 'package:gn_mobile_monitoring/domain/model/taxon.dart';
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
  })  : _modulesRepository = modulesRepository,
        _sitesRepository = sitesRepository;

  /// Vérifie la connectivité
  Future<bool> checkConnectivity() async {
    try {
      return await _globalApi.checkConnectivity();
    } catch (e) {
      debugPrint('Erreur lors de la vérification de la connectivité: $e');
      return false;
    }
  }

  /// Récupère la date de dernière synchronisation
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

      // Synchroniser les nomenclatures et datasets pour chaque module
      for (final moduleCode in downloadedModuleCodes) {
        try {
          debugPrint('Synchronisation du module $moduleCode');
          
          // Récupérer les nomenclatures et datasets du module
          final data = await _globalApi.getNomenclaturesAndDatasets(moduleCode);

          // Convertir les nomenclatures entities en domain models
          final nomenclatures =
              data.nomenclatures.map((e) => e.toDomain()).toList();
          
          debugPrint('Module $moduleCode: ${nomenclatures.length} nomenclatures reçues');
          
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
      debugPrint('DownstreamSyncRepositoryImpl.syncTaxons - Début de la synchronisation des taxons');
      // Vérifier la connectivité
      final isConnected = await checkConnectivity();
      if (!isConnected) {
        debugPrint('DownstreamSyncRepositoryImpl.syncTaxons - Pas de connexion Internet');
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
      debugPrint('DownstreamSyncRepositoryImpl.syncTaxons - Date de dernière synchronisation: ${effectiveLastSync?.toIso8601String() ?? "jamais"}');

      try {
        // Récupérer l'état avant la synchronisation pour les métriques
        final taxonsBefore = await _taxonDatabase.getAllTaxons();
        final taxonListsBefore = await _taxonDatabase.getAllTaxonLists();
        debugPrint('DownstreamSyncRepositoryImpl.syncTaxons - État avant synchronisation: ${taxonsBefore.length} taxons, ${taxonListsBefore.length} listes');

        // Stocker les IDs existants pour comparer après synchronisation
        final existingTaxonIds = taxonsBefore.map((t) => t.cdNom).toSet();
        final existingListIds = taxonListsBefore.map((l) => l.idListe).toSet();

        // Stocker les IDs server pour comparer et gérer les suppressions
        final serverTaxonIds = <int>{};
        final serverListIds = <int>{};

        // Récupérer les IDs de listes taxonomiques pour les modules téléchargés
        final taxonomyListIds = <int>[];
        for (final moduleCode in downloadedModuleCodes) {
          try {
            final module = await _modulesRepository.getModuleByCode(moduleCode);
            if (module != null) {
              final taxonomyListId = await _modulesRepository.getModuleTaxonomyListId(module.id);
              if (taxonomyListId != null) {
                taxonomyListIds.add(taxonomyListId);
                debugPrint('DownstreamSyncRepositoryImpl.syncTaxons - Module $moduleCode: ID liste taxonomique $taxonomyListId trouvé');
              } else {
                debugPrint('DownstreamSyncRepositoryImpl.syncTaxons - Module $moduleCode: Aucun ID liste taxonomique trouvé');
              }
            }
          } catch (e) {
            debugPrint('DownstreamSyncRepositoryImpl.syncTaxons - Erreur lors de la récupération de l\'ID liste taxonomique pour le module $moduleCode: $e');
          }
        }
        
        debugPrint('DownstreamSyncRepositoryImpl.syncTaxons - ${taxonomyListIds.length} listes taxonomiques uniques à synchroniser: $taxonomyListIds');
        
        // Télécharger les taxons depuis l'API
        debugPrint('DownstreamSyncRepositoryImpl.syncTaxons - Appel à l\'API pour synchroniser les taxons');
        final result = await _taxonApi.syncTaxonsFromAPI(
          token,
          downloadedModuleCodes,
          taxonomyListIds,
          lastSync: effectiveLastSync,
        );

        if (result.success && result.data != null) {
          debugPrint('DownstreamSyncRepositoryImpl.syncTaxons - Données reçues avec succès de l\'API');
          // Traiter les données retournées par l'API
          final data = result.data!;

          // Récupérer les listes taxonomiques
          if (data.containsKey('taxon_lists')) {
            final List<TaxonList> taxonLists = data['taxon_lists'];
            debugPrint('DownstreamSyncRepositoryImpl.syncTaxons - ${taxonLists.length} listes taxonomiques reçues');

            // Mettre à jour les IDs de serveur pour comparaison
            serverListIds.addAll(taxonLists.map((l) => l.idListe));

            // Sauvegarder les listes taxonomiques
            await _taxonDatabase.saveTaxonLists(taxonLists);
            debugPrint('DownstreamSyncRepositoryImpl.syncTaxons - Listes taxonomiques sauvegardées dans la base de données');
          } else {
            debugPrint('DownstreamSyncRepositoryImpl.syncTaxons - Aucune liste taxonomique trouvée dans les données');
          }

          // Récupérer les taxons
          if (data.containsKey('taxons')) {
            final List<Taxon> taxons = data['taxons'];
            debugPrint('DownstreamSyncRepositoryImpl.syncTaxons - ${taxons.length} taxons reçus');

            // Éliminer les doublons potentiels par cd_nom
            final Map<int, Taxon> uniqueTaxons = {};
            for (final taxon in taxons) {
              uniqueTaxons[taxon.cdNom] = taxon;
              serverTaxonIds.add(taxon.cdNom);
            }
            debugPrint('DownstreamSyncRepositoryImpl.syncTaxons - ${uniqueTaxons.length} taxons uniques après déduplication');

            // Sauvegarder les taxons unique
            await _taxonDatabase.saveTaxons(uniqueTaxons.values.toList());
            debugPrint('DownstreamSyncRepositoryImpl.syncTaxons - Taxons sauvegardés dans la base de données');
          } else {
            debugPrint('DownstreamSyncRepositoryImpl.syncTaxons - Aucun taxon trouvé dans les données');
          }

          // Traiter les associations liste-taxons
          if (data.containsKey('list_to_taxon_map')) {
            final Map<int, List<int>> listToTaxonMap =
                data['list_to_taxon_map'];
            debugPrint('DownstreamSyncRepositoryImpl.syncTaxons - ${listToTaxonMap.length} mappings liste-taxons reçus');

            // Pour chaque liste, sauvegarder les associations
            for (final entry in listToTaxonMap.entries) {
              final listId = entry.key;
              final taxonIds = entry.value;
              debugPrint('DownstreamSyncRepositoryImpl.syncTaxons - Traitement de la liste $listId avec ${taxonIds.length} taxons');

              // Sauvegarder les relations taxon-liste
              await _taxonDatabase.saveTaxonsToList(listId, taxonIds);
              debugPrint('DownstreamSyncRepositoryImpl.syncTaxons - Relations liste-taxons sauvegardées pour la liste $listId');
            }
          } else {
            debugPrint('DownstreamSyncRepositoryImpl.syncTaxons - Aucune association liste-taxons trouvée dans les données');
          }

          // Identifier les taxons qui ont été supprimés dans le cadre des listes taxonomiques
          final Set<int> previousListTaxonIds = <int>{};
          
          // Map pour suivre quels taxons ont été complètement supprimés
          final Set<int> deletedTaxonIds = <int>{};
          
          // Map pour suivre de quelles listes chaque taxon a été supprimé
          final Map<int, Set<int>> taxonRemovedFromLists = <int, Set<int>>{};

          // Pour chaque liste retournée par l'API, récupérer les taxons qui lui étaient associés avant
          if (data.containsKey('taxon_lists') &&
              data.containsKey('list_to_taxon_map')) {
            final List<TaxonList> taxonLists = data['taxon_lists'];
            final Map<int, List<int>> listToTaxonMap =
                data['list_to_taxon_map'];

            // 1. Pour chaque liste, identifier les taxons qui ont été supprimés de cette liste
            for (final list in taxonLists) {
              debugPrint('Analyse des taxons pour la liste taxonomique ${list.idListe}');
              
              // Récupérer les taxons qui étaient précédemment dans cette liste
              final taxonsInListBefore =
                  await _taxonDatabase.getTaxonsByListId(list.idListe);
              final previousTaxonsInList =
                  taxonsInListBefore.map((t) => t.cdNom).toSet();
              
              debugPrint('Liste ${list.idListe}: ${previousTaxonsInList.length} taxons avant synchronisation');

              // Les taxons actuels dans cette liste selon le serveur
              final currentTaxonsInList =
                  Set<int>.from(listToTaxonMap[list.idListe] ?? []);
              
              debugPrint('Liste ${list.idListe}: ${currentTaxonsInList.length} taxons après synchronisation');
              

              // Les taxons qui étaient dans cette liste mais n'y sont plus
              final taxonsRemovedFromList =
                  previousTaxonsInList.difference(currentTaxonsInList);
              
              debugPrint('Liste ${list.idListe}: ${taxonsRemovedFromList.length} taxons supprimés de cette liste');
              if (taxonsRemovedFromList.isNotEmpty) {
                debugPrint('Liste ${list.idListe} - Taxons supprimés: ${taxonsRemovedFromList.join(', ')}');
              }

              // Ajouter ces taxons à la liste des candidats pour suppression
              previousListTaxonIds.addAll(taxonsRemovedFromList);
              
              // Pour chaque taxon supprimé de cette liste, l'ajouter au map de suivi
              for (final cdNom in taxonsRemovedFromList) {
                if (!taxonRemovedFromLists.containsKey(cdNom)) {
                  taxonRemovedFromLists[cdNom] = <int>{};
                }
                taxonRemovedFromLists[cdNom]!.add(list.idListe);
                debugPrint('Taxon $cdNom a été supprimé de la liste ${list.idListe}');
              }
            }

            // 2. Pour chaque taxon identifié comme supprimé de certaines listes,
            // vérifier s'il est encore présent dans au moins une liste
            for (final cdNom in previousListTaxonIds) {
              // Vérifier si ce taxon existe encore dans d'autres listes
              bool existsInAnyCurrentList = false;

              for (final listEntry in listToTaxonMap.entries) {
                if (listEntry.value.contains(cdNom)) {
                  existsInAnyCurrentList = true;
                  break;
                }
              }

              // Si le taxon n'existe plus dans aucune liste, le marquer comme complètement supprimé
              if (!existsInAnyCurrentList) {
                deletedTaxonIds.add(cdNom);
                debugPrint('Taxon $cdNom a été complètement supprimé (n\'existe plus dans aucune liste)');
              }
            }
          } else {
            debugPrint('Aucune liste taxonomique ou mapping liste-taxon trouvé dans les données');
          }
          
          debugPrint('Taxons totalement supprimés à traiter: ${deletedTaxonIds.length}');
          if (deletedTaxonIds.isNotEmpty) {
            debugPrint('IDs des taxons totalement supprimés: ${deletedTaxonIds.join(', ')}');
          }
          
          debugPrint('Taxons partiellement supprimés de listes: ${taxonRemovedFromLists.length}');
          if (taxonRemovedFromLists.isNotEmpty) {
            for (final entry in taxonRemovedFromLists.entries) {
              debugPrint('Taxon ${entry.key} supprimé des listes: ${entry.value.join(', ')}');
            }
          }

          int itemsDeleted = 0;
          final allConflicts = <SyncConflict>[];


          if (deletedTaxonIds.isNotEmpty) {
            debugPrint(
                'Vérification de ${deletedTaxonIds.length} taxons réellement supprimés sur le serveur');

            // Pour chaque taxon supprimé sur le serveur
            // Vérifier les références avant de supprimer
            for (final cdNom in deletedTaxonIds) {
              debugPrint('Traitement de la suppression du taxon $cdNom');
              final conflicts = await _taxonDatabase
                  .checkTaxonReferencesInDatabaseObservations(cdNom);

              if (conflicts.isEmpty) {
                // Pas de conflit - supprimer le taxon
                await _taxonDatabase.deleteTaxon(cdNom);
                itemsDeleted++;
                debugPrint('Taxon $cdNom supprimé sans conflit');
              } else {
                // Des références existent - ajouter aux conflits
                allConflicts.addAll(conflicts);
                debugPrint(
                    'Taxon $cdNom a ${conflicts.length} références - conflit détecté');
              }
            }
          }
          
          // Traiter les taxons qui ont été supprimés de certaines listes mais existent encore dans d'autres
          for (final entry in taxonRemovedFromLists.entries) {
            final cdNom = entry.key;
            final removedFromLists = entry.value;
            
            // Ne traiter que les taxons qui n'ont pas déjà été supprimés complètement
            if (!deletedTaxonIds.contains(cdNom)) {
              debugPrint('Vérification des références pour le taxon $cdNom supprimé de ${removedFromLists.length} liste(s)');
              
              // Vérifier les références en tenant compte des listes spécifiques
              final conflicts = await _taxonDatabase
                  .checkTaxonReferencesInDatabaseObservations(cdNom, removedFromListIds: removedFromLists);
              
              if (conflicts.isNotEmpty) {
                allConflicts.addAll(conflicts);
                debugPrint('Taxon $cdNom a ${conflicts.length} références dans les listes supprimées - conflits détectés');
              }
            }
          }

          // Mettre à jour la date de synchronisation
          await updateLastSyncDate('taxons', DateTime.now());

          // Récupérer l'état après la synchronisation pour des métriques plus précises
          final taxonsAfter = await _taxonDatabase.getAllTaxons();
          final taxonListsAfter = await _taxonDatabase.getAllTaxonLists();
          
          // Récupérer les ID des taxons avant la synchronisation
          final beforeTaxonIds = taxonsBefore.map((t) => t.cdNom).toSet();
          
          // Récupérer les ID des taxons après la synchronisation
          final afterTaxonIds = taxonsAfter.map((t) => t.cdNom).toSet();
          
          // Calculer le nombre réel de nouveaux taxons
          final newTaxonIds = afterTaxonIds.difference(beforeTaxonIds);
          final int realNewTaxons = newTaxonIds.length;
          
          debugPrint('DownstreamSyncRepositoryImpl.syncTaxons - $realNewTaxons nouveaux taxons ajoutés à la base de données');
          if (realNewTaxons > 0) {
            debugPrint('DownstreamSyncRepositoryImpl.syncTaxons - Nouveaux taxons: ${newTaxonIds.join(', ')}');
          }
          
          // Comptons également les associations entre taxons et listes qui ont été créées
          int totalAssociationsCreated = 0;
          
          // Pour chaque liste taxonomique
          if (data.containsKey('list_to_taxon_map')) {
            final Map<int, List<int>> listToTaxonMap = data['list_to_taxon_map'];
            
            for (final entry in listToTaxonMap.entries) {
              final listId = entry.key;
              final newTaxonIds = entry.value;
              
              // Récupérer les taxons qui étaient déjà dans cette liste avant la synchronisation
              final previousTaxonsInList = await _taxonDatabase.getTaxonsByListId(listId);
              final previousTaxonIds = previousTaxonsInList.map((t) => t.cdNom).toSet();
              
              // Compter combien de nouvelles associations ont été créées
              final newAssociations = newTaxonIds.where((id) => !previousTaxonIds.contains(id)).length;
              totalAssociationsCreated += newAssociations;
              
              // Identifier spécifiquement les nouveaux ID de taxons pour cette liste
              final newTaxonsInThisList = newTaxonIds.where((id) => !previousTaxonIds.contains(id)).toList();
              
              debugPrint('DownstreamSyncRepositoryImpl.syncTaxons - $newAssociations nouvelles associations créées pour la liste $listId');
              if (newTaxonsInThisList.isNotEmpty) {
                debugPrint('DownstreamSyncRepositoryImpl.syncTaxons - Taxons ajoutés à la liste $listId: ${newTaxonsInThisList.join(', ')}');
              }
            }
          }

          // Calculer les métriques de synchronisation réelles
          final int itemsProcessed = result.itemsProcessed;
          
          // Le nombre total d'éléments ajoutés inclut à la fois les nouveaux taxons et les nouvelles associations
          final int itemsAdded = realNewTaxons + totalAssociationsCreated;
          
          // Calculer le nombre de taxons mis à jour (les taxons qui existaient déjà mais ont été modifiés)
          // Dans ce cas, itemsUpdated est le nombre total de taxons traités moins les nouveaux taxons
          final int itemsUpdated = data.containsKey('taxons') ? 
              (data['taxons'] as List<Taxon>).length - realNewTaxons : 0;
          
          final int itemsSkipped = result.itemsSkipped;
          
          debugPrint('DownstreamSyncRepositoryImpl.syncTaxons - Statistiques finales: $realNewTaxons nouveaux taxons, $itemsUpdated taxons mis à jour, $totalAssociationsCreated nouvelles associations taxon-liste, $itemsDeleted taxons supprimés');

          // Si des conflits ont été détectés, les inclure dans le résultat
          if (allConflicts.isNotEmpty) {
            debugPrint('Retour de ${allConflicts.length} conflits de taxons');
            return SyncResult.withConflicts(
              itemsProcessed: itemsProcessed,
              itemsAdded: itemsAdded > 0 ? itemsAdded : 0,
              itemsUpdated: itemsUpdated,
              itemsSkipped: itemsSkipped,
              itemsDeleted: itemsDeleted,
              itemsFailed: allConflicts.length,
              conflicts: allConflicts,
              errorMessage:
                  'Des taxons supprimés sont référencés par des observations',
            );
          } else {
            return SyncResult.success(
              itemsProcessed: itemsProcessed,
              itemsAdded: itemsAdded > 0 ? itemsAdded : 0,
              itemsUpdated: itemsUpdated,
              itemsSkipped: itemsSkipped,
              itemsDeleted: itemsDeleted,
            );
          }
        } else {
          // Si pas de données ou échec de la synchronisation
          return result;
        }
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