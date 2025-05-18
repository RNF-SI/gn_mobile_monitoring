import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/domain/domain_module.dart';
import 'package:gn_mobile_monitoring/domain/model/sync_conflict.dart' as domain;
import 'package:gn_mobile_monitoring/domain/model/sync_result.dart';
import 'package:gn_mobile_monitoring/domain/repository/sync_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_last_sync_date_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_token_from_local_storage_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/incremental_sync_all_usecase.dart';
import 'package:gn_mobile_monitoring/domain/usecase/update_last_sync_date_usecase.dart';
import 'package:gn_mobile_monitoring/presentation/state/sync_status.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/nomenclature_service.dart';

/// Provider pour le service de synchronisation
final syncServiceProvider =
    StateNotifierProvider<SyncService, SyncStatus>((ref) {
  final getTokenUseCase = ref.read(getTokenFromLocalStorageUseCaseProvider);
  final syncUseCase = ref.read(incrementalSyncAllUseCaseProvider);
  final getLastSyncDateUseCase = ref.read(getLastSyncDateUseCaseProvider);
  final updateLastSyncDateUseCase = ref.read(updateLastSyncDateUseCaseProvider);

  return SyncService(
    getTokenUseCase,
    syncUseCase,
    getLastSyncDateUseCase,
    updateLastSyncDateUseCase,
    ref.read(syncRepositoryProvider),
  );
});

/// Service qui gère la synchronisation des données
class SyncService extends StateNotifier<SyncStatus> {
  final GetTokenFromLocalStorageUseCase _getTokenUseCase;
  final IncrementalSyncAllUseCase _syncUseCase;
  final GetLastSyncDateUseCase _getLastSyncDateUseCase;
  final UpdateLastSyncDateUseCase _updateLastSyncDateUseCase;

  Timer? _autoSyncTimer;
  bool _isSyncing = false;

  // Stockage des résultats de synchronisation par étape pour conserver les informations détaillées
  final Map<String, SyncResult> _syncResults = {};

  // Liste globale de tous les conflits pour les retrouver même après changement d'état
  final List<domain.SyncConflict> allConflicts = [];

  // Repository pour la synchronisation
  final SyncRepository _syncRepository;

  // Date de la dernière synchronisation complète
  DateTime? _lastFullSync;

  // Clé pour la date de dernière synchronisation complète
  static const String fullSyncKey = 'full_sync';

  // Durée entre deux synchronisations complètes automatiques (1 semaine)
  static const Duration fullSyncInterval = Duration(days: 7);

  SyncService(
    this._getTokenUseCase,
    this._syncUseCase,
    this._getLastSyncDateUseCase,
    this._updateLastSyncDateUseCase,
    this._syncRepository,
  ) : super(SyncStatus.initial()) {
    // Initialiser la date de dernière synchro complète
    _initLastFullSyncDate();
  }

  /// Démarre une synchronisation complète des données
  /// Détermine si une synchronisation complète est nécessaire en fonction de la date de dernière synchronisation
  bool isFullSyncNeeded() {
    final now = DateTime.now();
    return _lastFullSync == null ||
        now.isAfter(_lastFullSync!.add(fullSyncInterval));
  }

  /// Démarre une synchronisation complète des données (téléchargement depuis le serveur)
  /// Ce type de synchronisation est pour récupérer les données du serveur vers l'appareil mobile
  Future<SyncStatus> syncFromServer(
    WidgetRef ref, {
    bool syncConfiguration = true,
    bool syncNomenclatures = true,
    bool syncTaxons = true,
    bool syncObservers = true,
    bool syncModules = true,
    bool syncSites = true,
    bool syncSiteGroups = true,
    bool isManualSync = true, // Indique si cette synchronisation est déclenchée manuellement
  }) async {
    if (_isSyncing) {
      return state; // Ne pas synchroniser si déjà en cours
    }

    _isSyncing = true;
    debugPrint('Démarrage de syncAll avec plusieurs éléments');

    // Réinitialiser les résultats au début d'une nouvelle synchronisation complète
    _syncResults.clear();

    final List<SyncStep> completedSteps = [];
    final List<SyncStep> failedSteps = [];
    // On n'utilise pas ici une liste de conflits locale
    // car nous utilisons la liste globale allConflicts de la classe
    final List<String> errorMessages =
        []; // Pour collecter les messages d'erreur
    int totalItemsProcessed = 0;
    int totalItemsToProcess = _countTotalSteps(
      syncConfiguration,
      syncNomenclatures,
      syncTaxons,
      syncObservers,
      syncModules: syncModules,
      syncSites: syncSites,
      syncSiteGroups: syncSiteGroups,
    );

    try {
      final token = await _getTokenUseCase.execute();

      if (token == null) {
        _isSyncing = false;
        final newState = SyncStatus.failure(
          errorMessage: 'Utilisateur non connecté',
          completedSteps: [],
          failedSteps: [],
          itemsProcessed: 0,
          itemsTotal: 0,
        );
        state = newState;
        return newState;
      }

      // Initialiser le statut de synchronisation
      state = SyncStatus.inProgress(
        currentStep: _getFirstStep(
          syncConfiguration,
          syncNomenclatures,
          syncTaxons,
          syncObservers,
          syncModules: syncModules,
          syncSites: syncSites,
          syncSiteGroups: syncSiteGroups,
        ),
        completedSteps: [],
        itemsProcessed: 0,
        itemsTotal: totalItemsToProcess,
      );

      // Synchroniser la configuration
      if (syncConfiguration) {
        state = SyncStatus.inProgress(
          currentStep: SyncStep.configuration,
          completedSteps: completedSteps,
          itemsProcessed: totalItemsProcessed,
          itemsTotal: totalItemsToProcess,
          currentEntityName: "Configuration",
          additionalInfo: "Téléchargement de la configuration",
        );

        try {
          final configResult = await _executeSingleSync(token, 'configuration');
          if (configResult.success) {
            completedSteps.add(SyncStep.configuration);

            // Générer un résumé des étapes complétées jusqu'à présent
            final syncSummary = _buildIncrementalSyncSummary(completedSteps);

            // Mettre à jour l'état avec le résumé
            state = SyncStatus.inProgress(
              currentStep: SyncStep.configuration,
              completedSteps: completedSteps,
              itemsProcessed: totalItemsProcessed + 1,
              itemsTotal: totalItemsToProcess,
              currentEntityName: "Configuration",
              additionalInfo: syncSummary,
            );
          } else {
            failedSteps.add(SyncStep.configuration);
          }
          totalItemsProcessed += 1;
        } catch (e) {
          failedSteps.add(SyncStep.configuration);
          totalItemsProcessed += 1;
          debugPrint(
              'Erreur lors de la synchronisation de la configuration: $e');
        }
      }

      // Synchroniser les nomenclatures
      bool nomenclatureStepDone = false;
      if (syncNomenclatures && _isSyncing) {
        // Mise à jour du résumé avec les étapes déjà complétées
        final currentSummary = _buildIncrementalSyncSummary(completedSteps);

        state = SyncStatus.inProgress(
          currentStep: SyncStep.nomenclatures,
          completedSteps: completedSteps,
          itemsProcessed: totalItemsProcessed,
          itemsTotal: totalItemsToProcess,
          currentEntityName: "Nomenclatures",
          additionalInfo: currentSummary,
        );

        try {
          final nomResult =
              await _executeSingleSync(token, 'nomenclatures_datasets');

          // Vérifier pour les conflits spécifiquement
          if (nomResult.conflicts != null && nomResult.conflicts!.isNotEmpty) {
            // On a des conflits mais on continue le processus
            debugPrint(
                'Des conflits de nomenclatures ont été détectés: ${nomResult.conflicts!.length}');

            // Stocker les conflits pour une utilisation ultérieure
            allConflicts.addAll(nomResult.conflicts!);

            // Ajouter un message d'erreur pour les nomenclatures
            if (nomResult.errorMessage != null) {
              errorMessages.add(nomResult.errorMessage!);
            }

            // Ajouter quand même l'étape comme complétée
            completedSteps.add(SyncStep.nomenclatures);

            // Mise à jour avec le nouveau résumé incluant cette étape
            final updatedSummary = _buildIncrementalSyncSummary(completedSteps);

            // Ajouter une information sur les conflits dans le résumé
            final conflictInfo = nomResult.errorMessage != null
                ? "$updatedSummary\n\nDes nomenclatures supprimées sont référencées par d'autres entités."
                : updatedSummary;

            // Continuer avec l'état en cours - on montrera les conflits à la fin
            state = SyncStatus.inProgress(
              currentStep: SyncStep.nomenclatures,
              completedSteps: completedSteps,
              itemsProcessed: totalItemsProcessed + 1,
              itemsTotal: totalItemsToProcess,
              currentEntityName: "Nomenclatures",
              itemsAdded: nomResult.itemsAdded,
              itemsUpdated: nomResult.itemsUpdated,
              itemsSkipped: nomResult.itemsSkipped,
              itemsDeleted: nomResult.itemsDeleted,
              additionalInfo: conflictInfo,
            );
          } else if (nomResult.success) {
            completedSteps.add(SyncStep.nomenclatures);

            // Mise à jour avec le nouveau résumé incluant cette étape
            final updatedSummary = _buildIncrementalSyncSummary(completedSteps);
            state = SyncStatus.inProgress(
              currentStep: SyncStep.nomenclatures,
              completedSteps: completedSteps,
              itemsProcessed: totalItemsProcessed + 1,
              itemsTotal: totalItemsToProcess,
              currentEntityName: "Nomenclatures",
              itemsAdded: nomResult.itemsAdded,
              itemsUpdated: nomResult.itemsUpdated,
              itemsSkipped: nomResult.itemsSkipped,
              itemsDeleted: nomResult.itemsDeleted,
              additionalInfo: updatedSummary,
            );
          } else {
            failedSteps.add(SyncStep.nomenclatures);

            // Ajouter le message d'erreur
            if (nomResult.errorMessage != null) {
              errorMessages.add(nomResult.errorMessage!);
            }
          }
          totalItemsProcessed += 1;
          nomenclatureStepDone = true;
        } catch (e) {
          failedSteps.add(SyncStep.nomenclatures);
          totalItemsProcessed += 1;
          debugPrint('Erreur lors de la synchronisation des nomenclatures: $e');
          errorMessages
              .add('Erreur lors de la synchronisation des nomenclatures: $e');
        }
      }

      // Invalider le cache des nomenclatures si la synchro a été faite
      if (nomenclatureStepDone) {
        ref.read(nomenclatureServiceProvider.notifier).clearCache();
      }

      // Synchroniser les taxons
      if (syncTaxons && _isSyncing) {
        // Mise à jour du résumé avec les étapes déjà complétées
        final currentSummary = _buildIncrementalSyncSummary(completedSteps);

        state = SyncStatus.inProgress(
          currentStep: SyncStep.taxons,
          completedSteps: completedSteps,
          itemsProcessed: totalItemsProcessed,
          itemsTotal: totalItemsToProcess,
          currentEntityName: "Référentiel taxonomique",
          additionalInfo: currentSummary,
        );

        try {
          debugPrint(
              'SyncService - Démarrage de la synchronisation des taxons');
          final taxonsResult = await _executeSingleSync(token, 'taxons');
          if (taxonsResult.success) {
            debugPrint(
                'SyncService - Synchronisation des taxons réussie avec ${taxonsResult.itemsAdded} ajouts et ${taxonsResult.itemsUpdated} mises à jour');
            completedSteps.add(SyncStep.taxons);

            // Mise à jour avec le nouveau résumé incluant cette étape
            final updatedSummary = _buildIncrementalSyncSummary(completedSteps);
            state = SyncStatus.inProgress(
              currentStep: SyncStep.taxons,
              completedSteps: completedSteps,
              itemsProcessed: totalItemsProcessed + 1,
              itemsTotal: totalItemsToProcess,
              currentEntityName: "Référentiel taxonomique",
              itemsAdded: taxonsResult.itemsAdded,
              itemsUpdated: taxonsResult.itemsUpdated,
              itemsSkipped: taxonsResult.itemsSkipped,
              additionalInfo: updatedSummary,
            );
          } else {
            debugPrint(
                'SyncService - Échec de la synchronisation des taxons: ${taxonsResult.errorMessage}');
            failedSteps.add(SyncStep.taxons);
          }
          totalItemsProcessed += 1;
        } catch (e) {
          failedSteps.add(SyncStep.taxons);
          totalItemsProcessed += 1;
          debugPrint('Erreur lors de la synchronisation des taxons: $e');
        }
      }

      // Synchroniser les observateurs
      if (syncObservers && _isSyncing) {
        // Mise à jour du résumé avec les étapes déjà complétées
        final currentSummary = _buildIncrementalSyncSummary(completedSteps);

        state = SyncStatus.inProgress(
          currentStep: SyncStep.observers,
          completedSteps: completedSteps,
          itemsProcessed: totalItemsProcessed,
          itemsTotal: totalItemsToProcess,
          currentEntityName: "Observateurs",
          additionalInfo: currentSummary,
        );

        try {
          final observersResult = await _executeSingleSync(token, 'observers');
          if (observersResult.success) {
            completedSteps.add(SyncStep.observers);

            // Mise à jour avec le nouveau résumé incluant cette étape
            final updatedSummary = _buildIncrementalSyncSummary(completedSteps);
            state = SyncStatus.inProgress(
              currentStep: SyncStep.observers,
              completedSteps: completedSteps,
              itemsProcessed: totalItemsProcessed + 1,
              itemsTotal: totalItemsToProcess,
              currentEntityName: "Observateurs",
              itemsAdded: observersResult.itemsAdded,
              itemsUpdated: observersResult.itemsUpdated,
              itemsSkipped: observersResult.itemsSkipped,
              additionalInfo: updatedSummary,
            );
          } else {
            failedSteps.add(SyncStep.observers);
          }
          totalItemsProcessed += 1;
        } catch (e) {
          failedSteps.add(SyncStep.observers);
          totalItemsProcessed += 1;
          debugPrint('Erreur lors de la synchronisation des observateurs: $e');
        }
      }

      // Synchroniser les modules
      if (syncModules && _isSyncing) {
        // Mise à jour du résumé avec les étapes déjà complétées
        final currentSummary = _buildIncrementalSyncSummary(completedSteps);

        state = SyncStatus.inProgress(
          currentStep: SyncStep.modules,
          completedSteps: completedSteps,
          itemsProcessed: totalItemsProcessed,
          itemsTotal: totalItemsToProcess,
          currentEntityName: "Modules de suivi",
          additionalInfo: currentSummary.isNotEmpty
              ? "$currentSummary\n\nTéléchargement des modules, formulaires et configurations..."
              : "Téléchargement des modules, formulaires et configurations...",
        );

        try {
          final modulesResult = await _executeSingleSync(token, 'modules');
          if (modulesResult.success) {
            completedSteps.add(SyncStep.modules);

            // Mise à jour avec le nouveau résumé incluant cette étape
            final updatedSummary = _buildIncrementalSyncSummary(completedSteps);
            state = SyncStatus.inProgress(
              currentStep: SyncStep.modules,
              completedSteps: completedSteps,
              itemsProcessed: totalItemsProcessed + 1,
              itemsTotal: totalItemsToProcess,
              currentEntityName: "Modules de suivi",
              itemsAdded: modulesResult.itemsAdded,
              itemsUpdated: modulesResult.itemsUpdated,
              itemsSkipped: modulesResult.itemsSkipped,
              additionalInfo: updatedSummary,
            );
          } else {
            failedSteps.add(SyncStep.modules);
          }
          totalItemsProcessed += 1;
        } catch (e) {
          failedSteps.add(SyncStep.modules);
          totalItemsProcessed += 1;
          debugPrint('Erreur lors de la synchronisation des modules: $e');
        }
      }

      // Synchroniser les sites
      if (syncSites && _isSyncing) {
        // Mise à jour du résumé avec les étapes déjà complétées
        final currentSummary = _buildIncrementalSyncSummary(completedSteps);

        state = SyncStatus.inProgress(
          currentStep: SyncStep.sites,
          completedSteps: completedSteps,
          itemsProcessed: totalItemsProcessed,
          itemsTotal: totalItemsToProcess,
          currentEntityName: "Sites",
          additionalInfo: currentSummary.isNotEmpty
              ? "$currentSummary\n\nTéléchargement des sites..."
              : "Téléchargement des sites...",
        );

        try {
          final sitesResult = await _executeSingleSync(token, 'sites');
          if (sitesResult.success) {
            completedSteps.add(SyncStep.sites);

            // Mise à jour avec le nouveau résumé incluant cette étape
            final updatedSummary = _buildIncrementalSyncSummary(completedSteps);
            state = SyncStatus.inProgress(
              currentStep: SyncStep.sites,
              completedSteps: completedSteps,
              itemsProcessed: totalItemsProcessed + 1,
              itemsTotal: totalItemsToProcess,
              currentEntityName: "Sites",
              itemsAdded: sitesResult.itemsAdded,
              itemsUpdated: sitesResult.itemsUpdated,
              itemsSkipped: sitesResult.itemsSkipped,
              additionalInfo: updatedSummary,
            );
          } else {
            failedSteps.add(SyncStep.sites);
          }
          totalItemsProcessed += 1;
        } catch (e) {
          failedSteps.add(SyncStep.sites);
          totalItemsProcessed += 1;
          debugPrint('Erreur lors de la synchronisation des sites: $e');
        }
      }

      // Synchroniser les groupes de sites
      if (syncSiteGroups && _isSyncing) {
        // Mise à jour du résumé avec les étapes déjà complétées
        final currentSummary = _buildIncrementalSyncSummary(completedSteps);

        state = SyncStatus.inProgress(
          currentStep: SyncStep.siteGroups,
          completedSteps: completedSteps,
          itemsProcessed: totalItemsProcessed,
          itemsTotal: totalItemsToProcess,
          currentEntityName: "Groupes de sites",
          additionalInfo: currentSummary.isNotEmpty
              ? "$currentSummary\n\nTéléchargement des groupes de sites..."
              : "Téléchargement des groupes de sites...",
        );

        try {
          final siteGroupsResult =
              await _executeSingleSync(token, 'siteGroups');
          if (siteGroupsResult.success) {
            completedSteps.add(SyncStep.siteGroups);

            // Mise à jour avec le nouveau résumé incluant cette étape
            final updatedSummary = _buildIncrementalSyncSummary(completedSteps);
            state = SyncStatus.inProgress(
              currentStep: SyncStep.siteGroups,
              completedSteps: completedSteps,
              itemsProcessed: totalItemsProcessed + 1,
              itemsTotal: totalItemsToProcess,
              currentEntityName: "Groupes de sites",
              itemsAdded: siteGroupsResult.itemsAdded,
              itemsUpdated: siteGroupsResult.itemsUpdated,
              itemsSkipped: siteGroupsResult.itemsSkipped,
              additionalInfo: updatedSummary,
            );
          } else {
            failedSteps.add(SyncStep.siteGroups);
          }
          totalItemsProcessed += 1;
        } catch (e) {
          failedSteps.add(SyncStep.siteGroups);
          totalItemsProcessed += 1;
          debugPrint(
              'Erreur lors de la synchronisation des groupes de sites: $e');
        }
      }


      // Générer un résumé des statistiques de synchronisation
      final syncSummary = getSyncSummary();

      // Construire l'état final avec le résumé des statistiques
      // IMPORTANT: Les conflits peuvent être perdus ou remplacés dans l'état, vérifions dans notre collection globale
      if (_syncResults.containsKey('taxons') &&
          _syncResults['taxons']!.conflicts != null &&
          _syncResults['taxons']!.conflicts!.isNotEmpty) {
        debugPrint(
            'Récupération de ${_syncResults["taxons"]!.conflicts!.length} conflits du résultat de synchronisation des taxons');
        // Assurons-nous que tous les conflits sont bien dans notre liste globale
        allConflicts.addAll(_syncResults['taxons']!.conflicts!);
      }

      // Dédupliquer les conflits basés sur une clé unique
      // La clé sera composée du type d'entité, de l'ID d'entité, du champ affecté et du type de conflit
      final Map<String, domain.SyncConflict> uniqueConflicts = {};
      for (final conflict in allConflicts) {
        final key = '${conflict.entityType}_${conflict.entityId}_${conflict.affectedField ?? "NA"}_${conflict.conflictType.name}_${conflict.referencedEntityType ?? "NA"}_${conflict.referencedEntityId ?? "NA"}';
        // Ajouter seulement si la clé n'existe pas déjà
        if (!uniqueConflicts.containsKey(key)) {
          uniqueConflicts[key] = conflict;
          debugPrint('Ajout du conflit unique: $key');
        } else {
          debugPrint('Conflit dupliqué ignoré: $key');
        }
      }
      
      // Remplacer la liste des conflits par les conflits uniques
      allConflicts.clear();
      allConflicts.addAll(uniqueConflicts.values);

      debugPrint(
          'Synchronisation terminée. Conflits uniques: ${allConflicts.length}, Messages d\'erreur: ${errorMessages.length}');

      if (allConflicts.isNotEmpty) {
        debugPrint(
            'Affichage des conflits détectés: ${allConflicts.length} conflits');
        for (var i = 0; i < allConflicts.length; i++) {
          final conflict = allConflicts[i];
          debugPrint(
              'Conflit $i: Type=${conflict.conflictType}, EntityType=${conflict.entityType}, EntityId=${conflict.entityId}, Path=${conflict.navigationPath ?? "null"}');
        }

        // Déterminer le message adapté selon le type de conflit
        String conflictMessage = "Des conflits ont été détectés";
        final hasTaxonConflicts =
            allConflicts.any((c) => c.referencedEntityType == 'taxon');
        final hasNomenclatureConflicts =
            allConflicts.any((c) => c.referencedEntityType == 'nomenclature');

        if (hasTaxonConflicts && hasNomenclatureConflicts) {
          conflictMessage +=
              ": Certains taxons et nomenclatures supprimés sont encore référencés par des entités.";
        } else if (hasTaxonConflicts) {
          conflictMessage +=
              ": Certains taxons supprimés sont encore référencés par des observations.";
        } else if (hasNomenclatureConflicts) {
          conflictMessage +=
              ": Certaines nomenclatures supprimées sont encore référencées par des entités.";
        } else {
          conflictMessage +=
              ": Certaines entités supprimées sont encore référencées par d'autres entités.";
        }

        // Des conflits ont été détectés
        final newState = SyncStatus.conflictDetected(
          conflicts: allConflicts,
          completedSteps: completedSteps,
          itemsProcessed: totalItemsProcessed,
          itemsTotal: totalItemsToProcess,
          additionalInfo: syncSummary.isNotEmpty
              ? "$syncSummary\n\n$conflictMessage"
              : conflictMessage,
        );

        state = newState;
        debugPrint(
            'Nouvel état après synchronisation: ${state.state}, avec ${state.conflicts?.length ?? 0} conflits');
      } else if (failedSteps.isNotEmpty || errorMessages.isNotEmpty) {
        // Certaines étapes ont échoué ou ont des messages d'erreur
        String errorMsg;

        if (errorMessages.isNotEmpty) {
          // Utiliser les messages d'erreur collectés qui sont plus détaillés
          errorMsg = errorMessages.join('\n');
        } else {
          // Retomber sur le comportement par défaut si pas de messages d'erreur
          errorMsg = failedSteps.map((step) {
            return 'Erreur ${_stepToLabel(step)}';
          }).join('\n');
        }

        state = SyncStatus.failure(
          errorMessage: errorMsg,
          completedSteps: completedSteps,
          failedSteps: failedSteps,
          itemsProcessed: totalItemsProcessed,
          itemsTotal: totalItemsToProcess,
          additionalInfo: syncSummary.isNotEmpty ? syncSummary : null,
        );
      } else {
        // Tout s'est bien passé
        DateTime now = DateTime.now();
        // On ne définit pas encore lastSync, il sera défini seulement si c'est une synchro complète
        state = SyncStatus.success(
          completedSteps: completedSteps,
          itemsProcessed: totalItemsProcessed,
          additionalInfo: syncSummary.isNotEmpty ? syncSummary : null,
        );

        // Si c'était une synchronisation complète, mettre à jour la date de dernière synchro
        final isFullSync = _isFullSync(
            syncConfiguration, syncNomenclatures, syncTaxons, syncObservers,
            syncModules: syncModules,
            syncSites: syncSites,
            syncSiteGroups: syncSiteGroups);

        // Mise à jour de la date de synchronisation complète
        if (isFullSync) {
          await _updateLastFullSyncDate();

          // Mise à jour du statut avec la nouvelle date de synchronisation
          state = state.copyWith(
            lastSync:
                now, // Afficher la date de dernière synchro seulement si elle était complète
          );
        } else {
          // Sinon, simplement mettre à jour l'affichage du temps restant
          _updateStateWithTimeRemaining();

          // Ne pas mettre à jour la date de dernière synchronisation dans l'interface
          // car ce n'était pas une synchronisation complète
        }
      }

      _isSyncing = false;
      return state;
    } catch (e) {
      debugPrint('Erreur inattendue lors de la synchronisation: $e');

      // Mettre à jour l'état en cas d'erreur
      final newState = SyncStatus.failure(
        errorMessage: 'Erreur inattendue lors de la synchronisation: $e',
        completedSteps: completedSteps,
        failedSteps: _getEnabledSteps(
          syncConfiguration,
          syncNomenclatures,
          syncTaxons,
          syncObservers,
          syncModules: syncModules,
          syncSites: syncSites,
          syncSiteGroups: syncSiteGroups,
        ).where((step) => !completedSteps.contains(step)).toList(),
        itemsProcessed: totalItemsProcessed,
        itemsTotal: totalItemsToProcess,
      );

      state = newState;
      _isSyncing = false;
      return newState;
    }
  }

  /// Exécute une seule étape de synchronisation
  Future<SyncResult> _executeSingleSync(String token, String stepKey,
      {String? moduleCode}) async {
    debugPrint('Démarrage de _executeSingleSync pour l\'étape: $stepKey');

    final Map<String, dynamic> params = {
      'syncConfiguration': false,
      'syncNomenclatures': false,
      'syncTaxons': false,
      'syncObservers': false,
      'syncModules': false,
      'syncSites': false,
      'syncSiteGroups': false,
      'syncVisitsToServer': false,
      'syncObservationsToServer': false,
      'syncObservationDetailsToServer': false,
    };

    // Activer uniquement l'étape spécifiée
    switch (stepKey) {
      case 'configuration':
        params['syncConfiguration'] = true;
        break;
      case 'nomenclatures':
      case 'nomenclatures_datasets':
        params['syncNomenclatures'] = true;
        break;
      case 'taxons':
        params['syncTaxons'] = true;
        break;
      case 'observers':
        params['syncObservers'] = true;
        break;
      case 'modules':
        params['syncModules'] = true;
        break;
      case 'sites':
        params['syncSites'] = true;
        break;
      case 'siteGroups':
        params['syncSiteGroups'] = true;
        break;
      case 'visitsToServer':
        params['syncVisitsToServer'] = true;
        break;
      case 'observationsToServer':
        params['syncObservationsToServer'] = true;
        break;
      case 'observationDetailsToServer':
        params['syncObservationDetailsToServer'] = true;
        break;
    }

    // Si c'est une synchronisation de données vers le serveur, utiliser un cas spécial
    if (params['syncVisitsToServer'] ||
        params['syncObservationsToServer'] ||
        params['syncObservationDetailsToServer']) {
      if (moduleCode == null) {
        return SyncResult.failure(
          errorMessage: 'Module code is required for server upload operations',
        );
      }

      SyncResult result;
      if (params['syncVisitsToServer']) {
        result = await _syncRepository.syncVisitsToServer(token, moduleCode);
      } else if (params['syncObservationsToServer']) {
        // Normalement, pour syncObservationsToServer, il faudrait un ID de visite
        // Mais comme on ne l'a pas ici, on enverra une erreur
        return SyncResult.failure(
          errorMessage:
              'Visit ID is required for observation upload operations',
        );
      } else {
        // Normalement, pour syncObservationDetailsToServer, il faudrait un ID d'observation
        // Mais comme on ne l'a pas ici, on enverra une erreur
        return SyncResult.failure(
          errorMessage:
              'Observation ID is required for observation detail upload operations',
        );
      }

      // Stocker le résultat et le retourner
      _syncResults[stepKey] = result;
      return result;
    }

    // Pour les autres types de synchronisation, utiliser le cas normal
    final results = await _syncUseCase.execute(
      token,
      syncConfiguration: params['syncConfiguration'],
      syncNomenclatures: params['syncNomenclatures'],
      syncTaxons: params['syncTaxons'],
      syncObservers: params['syncObservers'],
      syncModules: params['syncModules'],
      syncSites: params['syncSites'],
      syncSiteGroups: params['syncSiteGroups'],
    );

    // Retourner le résultat de cette étape
    if (results.containsKey(stepKey)) {
      final result = results[stepKey]!;

      // Vérifier si le résultat contient des conflits et les traiter immédiatement
      if (result.conflicts != null && result.conflicts!.isNotEmpty) {
        debugPrint(
            'Conflits détectés lors de l\'étape $stepKey: ${result.conflicts!.length} conflits');

        // Pour le débogage - afficher plus de détails sur les conflits
        for (var i = 0; i < result.conflicts!.length; i++) {
          final conflict = result.conflicts![i];
          debugPrint(
              'Conflit $i: Type=${conflict.conflictType}, EntityType=${conflict.entityType}, EntityId=${conflict.entityId}, Path=${conflict.navigationPath}');
        }

        // Mise à jour immédiate de l'état avec les conflits
        // Pour tous les types de synchronisation, pas seulement les nomenclatures
        String entityName;
        SyncStep currentStep;

        switch (stepKey) {
          case 'nomenclatures_datasets':
          case 'nomenclatures':
            entityName = "Nomenclatures";
            currentStep = SyncStep.nomenclatures;
            break;
          case 'taxons':
            entityName = "Taxons";
            currentStep = SyncStep.taxons;
            break;
          case 'observers':
            entityName = "Observateurs";
            currentStep = SyncStep.observers;
            break;
          case 'modules':
            entityName = "Modules";
            currentStep = SyncStep.modules;
            break;
          case 'sites':
            entityName = "Sites";
            currentStep = SyncStep.sites;
            break;
          case 'siteGroups':
            entityName = "Groupes de sites";
            currentStep = SyncStep.siteGroups;
            break;
          case 'visitsToServer':
            entityName = "Visites (envoi)";
            currentStep = SyncStep.visitsToServer;
            break;
          case 'observationsToServer':
            entityName = "Observations (envoi)";
            currentStep = SyncStep.observationsToServer;
            break;
          case 'observationDetailsToServer':
            entityName = "Détails d'observations (envoi)";
            currentStep = SyncStep.observationDetailsToServer;
            break;
          default:
            entityName = "Configuration";
            currentStep = SyncStep.configuration;
        }

        // Création du nouvel état
        final newState = SyncStatus.conflictDetected(
          conflicts: result.conflicts!,
          completedSteps: [_getStepFromKey(stepKey)],
          itemsProcessed: 1,
          itemsTotal: 1,
          itemsAdded: result.itemsAdded,
          itemsUpdated: result.itemsUpdated,
          itemsSkipped: result.itemsSkipped,
          itemsDeleted: result.itemsDeleted,
          additionalInfo: result.errorMessage ??
              "Des références supprimées sont référencées par d'autres entités.",
          currentEntityName: entityName,
          currentStep: currentStep,
        );

        // Log de l'état avant et après la mise à jour
        debugPrint('État avant mise à jour: ${state.state.toString()}');
        state = newState;
        debugPrint('État après mise à jour: ${state.state.toString()}');
        debugPrint(
            'Nombre de conflits dans le nouvel état: ${state.conflicts?.length ?? 0}');

        // IMPORTANT: Ajouter les conflits à la liste globale pour pouvoir les retrouver
        // dans le résultat final même si l'état est ensuite modifié
        if (result.conflicts != null && result.conflicts!.isNotEmpty) {
          // Cette ligne est critique pour s'assurer que les conflits sont propagés au processus principal
          allConflicts.addAll(result.conflicts!);
          debugPrint(
              'Ajout de ${result.conflicts!.length} conflits au total, maintenant ${allConflicts.length} conflits');
        }
      }

      // Si ce sont des nomenclatures et qu'il y a des conflits, assurons-nous que l'état est correctement mis à jour
      if ((stepKey == 'nomenclatures' ||
              stepKey == 'nomenclatures_datasets' ||
              stepKey == 'taxons') &&
          result.conflicts != null &&
          result.conflicts!.isNotEmpty) {
        // Forcer une mise à jour de l'état après un court délai pour s'assurer que les changements sont appliqués
        Future.delayed(const Duration(milliseconds: 100), () {
          if (state.state != SyncState.conflictDetected) {
            debugPrint(
                'Forçage de la mise à jour de l\'état pour afficher les conflits');

            // Créer explicitement un nouvel état avec les conflits
            final newState = SyncStatus.conflictDetected(
              conflicts: result.conflicts!,
              completedSteps: [_getStepFromKey(stepKey)],
              itemsProcessed: 1,
              itemsTotal: 1,
              itemsAdded: result.itemsAdded,
              itemsUpdated: result.itemsUpdated,
              itemsSkipped: result.itemsSkipped,
              itemsDeleted: result.itemsDeleted,
              additionalInfo: result.errorMessage ??
                  "Des références supprimées sont toujours utilisées par des entités.",
              currentEntityName:
                  stepKey == "taxons" ? "Taxons" : "Nomenclatures",
              currentStep: stepKey == "taxons"
                  ? SyncStep.taxons
                  : SyncStep.nomenclatures,
            );

            state = newState;
          }
        });
      }

      // Stocker le résultat pour une utilisation ultérieure
      _syncResults[stepKey] = result;
      return result;
    } else {
      final failureResult = SyncResult.failure(
        errorMessage: 'Résultat manquant pour l\'étape $stepKey',
      );
      _syncResults[stepKey] = failureResult;
      return failureResult;
    }
  }

  /// Convertit une clé de synchronisation en étape de synchronisation
  SyncStep _getStepFromKey(String stepKey) {
    switch (stepKey) {
      case 'configuration':
        return SyncStep.configuration;
      case 'nomenclatures':
      case 'nomenclatures_datasets':
        return SyncStep.nomenclatures;
      case 'taxons':
        return SyncStep.taxons;
      case 'observers':
        return SyncStep.observers;
      case 'modules':
        return SyncStep.modules;
      case 'sites':
        return SyncStep.sites;
      case 'siteGroups':
        return SyncStep.siteGroups;
      case 'visitsToServer':
        return SyncStep.visitsToServer;
      case 'observationsToServer':
        return SyncStep.observationsToServer;
      case 'observationDetailsToServer':
        return SyncStep.observationDetailsToServer;
      default:
        return SyncStep.configuration; // Valeur par défaut
    }
  }

  /// Résout un conflit de synchronisation
  Future<void> resolveConflict(domain.SyncConflict conflict) async {
    if (_isSyncing) {
      return; // Ne pas résoudre les conflits pendant la synchronisation
    }

    try {
      // Code pour résoudre le conflit (à implémenter dans le repository)

      // Mettre à jour l'état
      final conflicts = state.conflicts ?? [];
      final remainingConflicts = conflicts
          .cast<domain.SyncConflict>()
          .where((c) => c.entityId != conflict.entityId)
          .toList();

      if (remainingConflicts.isEmpty) {
        // Tous les conflits sont résolus
        state = SyncStatus.success(
          completedSteps: state.completedSteps,
          itemsProcessed: state.itemsProcessed,
          lastSync: DateTime.now(),
        );
      } else {
        // Il reste des conflits à résoudre
        state = SyncStatus.conflictDetected(
          conflicts: remainingConflicts,
          completedSteps: state.completedSteps,
          itemsProcessed: state.itemsProcessed,
          itemsTotal: state.itemsTotal,
        );
      }
    } catch (e) {
      debugPrint('Erreur lors de la résolution du conflit: $e');
    }
  }

  /// Démarre la synchronisation automatique
  void startAutoSync(WidgetRef ref,
      {Duration period = const Duration(minutes: 30)}) {
    _autoSyncTimer?.cancel();
    _autoSyncTimer = Timer.periodic(period, (_) => syncFromServer(ref));
  }

  /// Arrête la synchronisation automatique
  void stopAutoSync() {
    _autoSyncTimer?.cancel();
    _autoSyncTimer = null;
  }

  /// Initialise la date de dernière synchronisation complète
  /// depuis le stockage persistant via le use case
  Future<void> _initLastFullSyncDate() async {
    try {
      // Utiliser le use case pour récupérer la date
      _lastFullSync = await _getLastSyncDateUseCase.execute(fullSyncKey);

      // Si c'est la première fois, initialiser avec une date qui forcera une synchro complète bientôt
      if (_lastFullSync == null) {
        _lastFullSync = DateTime.now().subtract(const Duration(days: 5));
      }
    } catch (e) {
      debugPrint(
          'Erreur lors de la récupération de la date de dernière synchronisation: $e');
      _lastFullSync = null;
    }

    // Mettre à jour l'état pour afficher le temps restant
    _updateStateWithTimeRemaining();
  }

  /// Met à jour la date de dernière synchronisation complète en utilisant le use case
  Future<void> _updateLastFullSyncDate() async {
    final now = DateTime.now();
    _lastFullSync = now;

    try {
      // Utiliser le use case pour sauvegarder la date
      await _updateLastSyncDateUseCase.execute(fullSyncKey, now);
    } catch (e) {
      debugPrint(
          'Erreur lors de la sauvegarde de la date de dernière synchronisation: $e');
    }

    // Mettre à jour l'état pour afficher le temps restant actualisé
    _updateStateWithTimeRemaining();
  }

  /// Met à jour l'état avec le temps restant avant la prochaine synchronisation complète
  void _updateStateWithTimeRemaining() {
    final currentState = state;

    // Calculer le temps restant
    String? timeRemaining = _getTimeRemainingText();

    // Mettre à jour l'état avec le temps restant
    state = SyncStatus(
      state: currentState.state,
      currentStep: currentState.currentStep,
      completedSteps: currentState.completedSteps,
      failedSteps: currentState.failedSteps,
      itemsProcessed: currentState.itemsProcessed,
      itemsTotal: currentState.itemsTotal,
      progress: currentState.progress,
      errorMessage: currentState.errorMessage,
      lastSync: currentState.lastSync,
      conflicts: currentState.conflicts,
      lastUpdated: DateTime.now(),
      currentEntityName: currentState.currentEntityName,
      currentEntityTotal: currentState.currentEntityTotal,
      currentEntityProcessed: currentState.currentEntityProcessed,
      itemsAdded: currentState.itemsAdded,
      itemsUpdated: currentState.itemsUpdated,
      itemsSkipped: currentState.itemsSkipped,
      additionalInfo: currentState.additionalInfo,
      nextFullSyncInfo: timeRemaining,
    );
  }

  /// Retourne un texte indiquant le temps restant avant la prochaine synchronisation
  /// complète automatique
  String? _getTimeRemainingText() {
    if (_lastFullSync == null) {
      return "Synchronisation complète requise";
    }

    final now = DateTime.now();
    final nextFullSync = _lastFullSync!.add(fullSyncInterval);

    if (now.isAfter(nextFullSync)) {
      return "Synchronisation complète requise";
    }

    final remaining = nextFullSync.difference(now);

    // Formatage convivial
    if (remaining.inDays > 1) {
      return "Synchronisation complète dans ${remaining.inDays} jours";
    } else if (remaining.inDays == 1) {
      return "Synchronisation complète demain";
    } else if (remaining.inHours > 1) {
      return "Synchronisation complète dans ${remaining.inHours} heures";
    } else if (remaining.inMinutes > 1) {
      return "Synchronisation complète dans ${remaining.inMinutes} minutes";
    } else {
      return "Synchronisation complète imminente";
    }
  }

  // Cette méthode est commentée car elle n'est pas utilisée actuellement
  // Elle pourrait être utilisée à l'avenir pour implémenter la synchronisation automatique
  /*
  void _scheduleAutoSync(WidgetRef ref) {
    // Vérifier si une synchronisation complète est nécessaire
    final now = DateTime.now();
    final isFullSyncNeeded = _lastFullSync == null ||
        now.isAfter(_lastFullSync!.add(fullSyncInterval));

    if (isFullSyncNeeded) {
      // Planifier une synchronisation complète
      Timer(const Duration(minutes: 5), () => _performFullSync(ref));
    } else {
      // Planifier une vérification régulière
      startAutoSync(ref, period: const Duration(hours: 2));
    }
  }
  */
  
  /// Démarre la synchronisation des données vers le serveur (envoi des données locales)
  /// Ce type de synchronisation est pour envoyer les données de l'appareil mobile vers le serveur
  /// Les données sont supprimées de l'appareil seulement après confirmation de réception par le serveur
  Future<SyncStatus> syncToServer(
    WidgetRef ref, {
    required String moduleCode,
    bool isManualSync = true,
  }) async {
    if (_isSyncing) {
      return state; // Ne pas synchroniser si déjà en cours
    }

    _isSyncing = true;
    debugPrint('Démarrage de syncToServer pour le module $moduleCode');

    // Réinitialiser les résultats au début d'une nouvelle synchronisation
    _syncResults.clear();

    final List<SyncStep> completedSteps = [];
    final List<SyncStep> failedSteps = [];
    // N'utilisons pas de liste locale pour les conflits
    final List<String> errorMessages = [];
    int totalItemsProcessed = 0;
    int totalItemsToProcess = 1; // Une seule étape pour cette synchronisation

    try {
      final token = await _getTokenUseCase.execute();

      if (token == null) {
        _isSyncing = false;
        final newState = SyncStatus.failure(
          errorMessage: 'Utilisateur non connecté',
          completedSteps: [],
          failedSteps: [],
          itemsProcessed: 0,
          itemsTotal: 0,
        );
        state = newState;
        return newState;
      }

      // Initialiser le statut de synchronisation
      state = SyncStatus.inProgress(
        currentStep: SyncStep.visitsToServer,
        completedSteps: [],
        itemsProcessed: 0,
        itemsTotal: totalItemsToProcess,
        currentEntityName: "Visites (envoi)",
      );

      try {
        debugPrint('Démarrage de la synchronisation des visites vers le serveur');
        
        final result = await _executeSingleSync(token, 'visitsToServer', moduleCode: moduleCode);
        
        // Ajouter les statistiques
        if (result.success) {
          completedSteps.add(SyncStep.visitsToServer);
          
          // Mettre à jour avec le nouveau résumé incluant cette étape
          final updatedSummary = "Synchronisation des visites terminée avec succès:\n"
              "• ${result.itemsAdded} visites envoyées\n"
              "• ${result.itemsDeleted} visites supprimées localement";
              
          state = SyncStatus.inProgress(
            currentStep: SyncStep.visitsToServer,
            completedSteps: completedSteps,
            itemsProcessed: 1,
            itemsTotal: totalItemsToProcess,
            currentEntityName: "Visites (envoi)",
            itemsAdded: result.itemsAdded,
            itemsUpdated: result.itemsUpdated,
            itemsSkipped: result.itemsSkipped,
            itemsDeleted: result.itemsDeleted,
            additionalInfo: updatedSummary,
          );
          
          debugPrint('Synchronisation des visites vers le serveur terminée avec succès');
          debugPrint('Statistiques: ${result.itemsAdded} ajoutées, ${result.itemsDeleted} supprimées');
        } else {
          failedSteps.add(SyncStep.visitsToServer);
          if (result.errorMessage != null) {
            errorMessages.add('Visites: ${result.errorMessage}');
          }
          debugPrint('Échec de la synchronisation des visites vers le serveur: ${result.errorMessage}');
        }
        totalItemsProcessed += 1;
      } catch (e) {
        failedSteps.add(SyncStep.visitsToServer);
        totalItemsProcessed += 1;
        debugPrint('Erreur lors de la synchronisation des visites vers le serveur: $e');
        errorMessages.add('Erreur: $e');
      }

      // Générer un résumé des statistiques de synchronisation
      final syncSummary = getSyncSummary();

      // Mettre à jour la date de dernière synchronisation
      if (isManualSync && completedSteps.isNotEmpty) {
        await _updateLastSyncDateUseCase.execute(fullSyncKey, DateTime.now());
        _lastFullSync = DateTime.now();
      }

      // Construire l'état final
      SyncStatus newState;

      if (errorMessages.isNotEmpty || failedSteps.isNotEmpty) {
        // Des erreurs se sont produites
        newState = SyncStatus.failure(
          errorMessage: errorMessages.isNotEmpty
              ? errorMessages.join('\n')
              : "Des erreurs se sont produites lors de la synchronisation",
          completedSteps: completedSteps,
          failedSteps: failedSteps,
          itemsProcessed: totalItemsProcessed,
          itemsTotal: totalItemsToProcess,
          additionalInfo: syncSummary,
        );
      } else {
        // Tout s'est bien passé
        newState = SyncStatus.success(
          completedSteps: completedSteps,
          itemsProcessed: totalItemsProcessed,
          additionalInfo: syncSummary,
        );
      }

      state = newState;
      _isSyncing = false;
      return newState;
    } catch (e) {
      // Gérer les erreurs globales
      debugPrint('Erreur générale lors de la synchronisation ascendante: $e');
      
      final newState = SyncStatus.failure(
        errorMessage: 'Erreur lors de la synchronisation ascendante: $e',
        completedSteps: completedSteps,
        failedSteps: failedSteps,
        itemsProcessed: totalItemsProcessed,
        itemsTotal: totalItemsToProcess,
      );

      state = newState;
      _isSyncing = false;
      return newState;
    }
  }

  /// Vérifie si les paramètres correspondent à une synchronisation complète
  bool _isFullSync(
    bool syncConfiguration,
    bool syncNomenclatures,
    bool syncTaxons,
    bool syncObservers, {
    bool syncModules = true,
    bool syncSites = true,
    bool syncSiteGroups = true,
  }) {
    return syncConfiguration &&
        syncNomenclatures &&
        syncTaxons &&
        syncObservers &&
        syncModules &&
        syncSites &&
        syncSiteGroups;
  }

  /// Effectue une synchronisation complète automatique
  Future<void> _performFullSync(WidgetRef ref) async {
    if (_isSyncing) return;

    try {
      await syncFromServer(
        ref,
        syncConfiguration: true,
        syncNomenclatures: true,
        syncTaxons: true,
        syncObservers: true,
        syncModules: true,
        syncSites: true,
        syncSiteGroups: true,
        isManualSync: false, // C'est une synchronisation automatique
      );
    } catch (e) {
      debugPrint('Erreur lors de la synchronisation complète automatique: $e');
    }
  }

  /// Récupère la première étape de synchronisation en fonction des paramètres
  SyncStep _getFirstStep(
    bool syncConfiguration,
    bool syncNomenclatures,
    bool syncTaxons,
    bool syncObservers, {
    bool syncModules = true,
    bool syncSites = true,
    bool syncSiteGroups = true,
    bool syncVisitsToServer = false,
  }) {
    if (syncConfiguration) return SyncStep.configuration;
    if (syncNomenclatures) return SyncStep.nomenclatures;
    if (syncTaxons) return SyncStep.taxons;
    if (syncObservers) return SyncStep.observers;
    if (syncModules) return SyncStep.modules;
    if (syncSites) return SyncStep.sites;
    if (syncSiteGroups) return SyncStep.siteGroups;
    if (syncVisitsToServer) return SyncStep.visitsToServer;

    return SyncStep.configuration; // Valeur par défaut
  }

  /// Compte le nombre total d'étapes à synchroniser
  int _countTotalSteps(
    bool syncConfiguration,
    bool syncNomenclatures,
    bool syncTaxons,
    bool syncObservers, {
    bool syncModules = true,
    bool syncSites = true,
    bool syncSiteGroups = true,
    bool syncVisitsToServer = false,
  }) {
    int count = 0;
    if (syncConfiguration) count++;
    if (syncNomenclatures) count++;
    if (syncTaxons) count++;
    if (syncObservers) count++;
    if (syncModules) count++;
    if (syncSites) count++;
    if (syncSiteGroups) count++;
    if (syncVisitsToServer) count++;

    return count;
  }

  /// Récupère la liste des étapes activées
  List<SyncStep> _getEnabledSteps(
    bool syncConfiguration,
    bool syncNomenclatures,
    bool syncTaxons,
    bool syncObservers, {
    bool syncModules = true,
    bool syncSites = true,
    bool syncSiteGroups = true,
    bool syncVisitsToServer = false,
  }) {
    final steps = <SyncStep>[];
    if (syncConfiguration) steps.add(SyncStep.configuration);
    if (syncNomenclatures) steps.add(SyncStep.nomenclatures);
    if (syncTaxons) steps.add(SyncStep.taxons);
    if (syncObservers) steps.add(SyncStep.observers);
    if (syncModules) steps.add(SyncStep.modules);
    if (syncSites) steps.add(SyncStep.sites);
    if (syncSiteGroups) steps.add(SyncStep.siteGroups);
    if (syncVisitsToServer) steps.add(SyncStep.visitsToServer);

    return steps;
  }

  /// Convertit une étape en clé de résultat
  String _stepToKey(SyncStep step) {
    switch (step) {
      case SyncStep.configuration:
        return 'configuration';
      case SyncStep.nomenclatures:
        return 'nomenclatures';
      case SyncStep.taxons:
        return 'taxons';
      case SyncStep.observers:
        return 'observers';
      case SyncStep.modules:
        return 'modules';
      case SyncStep.sites:
        return 'sites';
      case SyncStep.siteGroups:
        return 'siteGroups';
      case SyncStep.visitsToServer:
        return 'visitsToServer';
      case SyncStep.observationsToServer:
        return 'observationsToServer';
      case SyncStep.observationDetailsToServer:
        return 'observationDetailsToServer';
    }
  }

  /// Convertit une étape en libellé
  String _stepToLabel(SyncStep step) {
    switch (step) {
      case SyncStep.configuration:
        return 'configuration';
      case SyncStep.nomenclatures:
        return 'nomenclatures';
      case SyncStep.taxons:
        return 'taxons';
      case SyncStep.observers:
        return 'observateurs';
      case SyncStep.modules:
        return 'modules';
      case SyncStep.sites:
        return 'sites';
      case SyncStep.siteGroups:
        return 'groupes de sites';
      case SyncStep.visitsToServer:
        return 'envoi des visites';
      case SyncStep.observationsToServer:
        return 'envoi des observations';
      case SyncStep.observationDetailsToServer:
        return 'envoi des détails d\'observation';
    }
  }

  /// Génère les statistiques de synchronisation pour une étape donnée
  String _getSyncStatsForStep(String stepKey) {
    if (!_syncResults.containsKey(stepKey)) {
      return "Aucune donnée";
    }

    final result = _syncResults[stepKey]!;

    if (!result.success) {
      return "Échec";
    }

    final syncTotal = result.itemsAdded + result.itemsUpdated;
    final deletedPart =
        result.itemsDeleted > 0 ? ", ${result.itemsDeleted} supprimés" : "";
    return "$syncTotal éléments (${result.itemsAdded} ajoutés, ${result.itemsUpdated} mis à jour, ${result.itemsSkipped} ignorés$deletedPart)";
  }

  /// Génère un résumé des statistiques de synchronisation pour les étapes complétées
  String _buildIncrementalSyncSummary(List<SyncStep> completedSteps) {
    if (completedSteps.isEmpty || _syncResults.isEmpty) {
      return "En cours de synchronisation...";
    }

    final List<String> summaryLines = [];
    summaryLines.add("Éléments déjà synchronisés:");

    // Synthétiser les statistiques globales
    int totalAdded = 0;
    int totalUpdated = 0;
    int totalSkipped = 0;

    // Ajouter les infos pour les modules si terminé
    if (completedSteps.contains(SyncStep.modules) &&
        _syncResults.containsKey('modules')) {
      final stats = _syncResults['modules']!;
      summaryLines.add("• Modules: ${_formatSyncStats(stats)}");
      totalAdded += stats.itemsAdded;
      totalUpdated += stats.itemsUpdated;
      totalSkipped += stats.itemsSkipped;
    }

    // Ajouter les infos pour les taxons si terminé
    if (completedSteps.contains(SyncStep.taxons) &&
        _syncResults.containsKey('taxons')) {
      final stats = _syncResults['taxons']!;
      summaryLines.add("• Taxons: ${_formatSyncStats(stats)}");
      totalAdded += stats.itemsAdded;
      totalUpdated += stats.itemsUpdated;
      totalSkipped += stats.itemsSkipped;
    }

    // Ajouter les infos pour les sites si terminé
    if (completedSteps.contains(SyncStep.sites) &&
        _syncResults.containsKey('sites')) {
      final stats = _syncResults['sites']!;
      summaryLines.add("• Sites: ${_formatSyncStats(stats)}");
      totalAdded += stats.itemsAdded;
      totalUpdated += stats.itemsUpdated;
      totalSkipped += stats.itemsSkipped;
    }

    // Ajouter les infos pour les groupes de sites si terminé
    if (completedSteps.contains(SyncStep.siteGroups) &&
        _syncResults.containsKey('siteGroups')) {
      final stats = _syncResults['siteGroups']!;
      summaryLines.add("• Groupes de sites: ${_formatSyncStats(stats)}");
      totalAdded += stats.itemsAdded;
      totalUpdated += stats.itemsUpdated;
      totalSkipped += stats.itemsSkipped;
    }

    // Ajouter les infos pour les nomenclatures si terminé
    if (completedSteps.contains(SyncStep.nomenclatures)) {
      if (_syncResults.containsKey('nomenclatures_datasets')) {
        final stats = _syncResults['nomenclatures_datasets']!;
        summaryLines.add("• Nomenclatures: ${_formatSyncStats(stats)}");
        totalAdded += stats.itemsAdded;
        totalUpdated += stats.itemsUpdated;
        totalSkipped += stats.itemsSkipped;
      } else if (_syncResults.containsKey('nomenclatures')) {
        final stats = _syncResults['nomenclatures']!;
        summaryLines.add("• Nomenclatures: ${_formatSyncStats(stats)}");
        totalAdded += stats.itemsAdded;
        totalUpdated += stats.itemsUpdated;
        totalSkipped += stats.itemsSkipped;
      }
    }

    // Ajouter les infos pour les observateurs si terminé
    if (completedSteps.contains(SyncStep.observers) &&
        _syncResults.containsKey('observers')) {
      final stats = _syncResults['observers']!;
      summaryLines.add("• Observateurs: ${_formatSyncStats(stats)}");
      totalAdded += stats.itemsAdded;
      totalUpdated += stats.itemsUpdated;
      totalSkipped += stats.itemsSkipped;
    }

    // Si aucune étape complétée n'a d'informations disponibles
    if (summaryLines.length <= 1) {
      return "En cours de synchronisation...";
    }

    // Ajouter un résumé total en tête
    if (totalAdded > 0 || totalUpdated > 0) {
      // Variables pour collecter les statistiques totales
      int totalDeleted = 0;

      // Parcourir les résultats pour collecter le total des suppressions
      for (var step in completedSteps) {
        final stepKey = _stepToKey(step);
        if (_syncResults.containsKey(stepKey)) {
          totalDeleted += _syncResults[stepKey]!.itemsDeleted;
        }
      }

      final deletedPart = totalDeleted > 0 ? ", $totalDeleted supprimés" : "";
      summaryLines.insert(1,
          "• TOTAL: ${totalAdded + totalUpdated} éléments (${totalAdded} ajoutés, ${totalUpdated} mis à jour, ${totalSkipped} ignorés$deletedPart)");
    }

    return summaryLines.join("\n");
  }

  /// Formate les statistiques de synchronisation pour une étape donnée
  String _formatSyncStats(SyncResult result) {
    if (!result.success) {
      return "Échec";
    }

    final syncTotal = result.itemsAdded + result.itemsUpdated;
    final deletedPart =
        result.itemsDeleted > 0 ? ", ${result.itemsDeleted} supprimés" : "";
    return "$syncTotal éléments (${result.itemsAdded} ajoutés, ${result.itemsUpdated} mis à jour, ${result.itemsSkipped} ignorés$deletedPart)";
  }

  /// Génère un résumé complet des statistiques de synchronisation
  String getSyncSummary() {
    final List<String> summaryLines = [];

    if (_syncResults.containsKey('modules')) {
      summaryLines.add("• Modules: ${_getSyncStatsForStep('modules')}");
    }

    if (_syncResults.containsKey('taxons')) {
      summaryLines.add("• Taxons: ${_getSyncStatsForStep('taxons')}");
    }

    if (_syncResults.containsKey('sites')) {
      summaryLines.add("• Sites: ${_getSyncStatsForStep('sites')}");
    }

    if (_syncResults.containsKey('siteGroups')) {
      summaryLines
          .add("• Groupes de sites: ${_getSyncStatsForStep('siteGroups')}");
    }

    if (_syncResults.containsKey('nomenclatures_datasets')) {
      summaryLines.add(
          "• Nomenclatures: ${_getSyncStatsForStep('nomenclatures_datasets')}");
    } else if (_syncResults.containsKey('nomenclatures')) {
      summaryLines
          .add("• Nomenclatures: ${_getSyncStatsForStep('nomenclatures')}");
    }

    if (_syncResults.containsKey('observers')) {
      summaryLines.add("• Observateurs: ${_getSyncStatsForStep('observers')}");
    }

    if (summaryLines.isEmpty) {
      return "";
    }

    return "Résumé de la synchronisation:\n${summaryLines.join("\n")}";
  }

  @override
  void dispose() {
    _autoSyncTimer?.cancel();
    super.dispose();
  }
}
