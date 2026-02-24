import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:gn_mobile_monitoring/core/errors/app_logger.dart';
import 'package:gn_mobile_monitoring/core/helpers/sync_cache_manager.dart';
import 'package:gn_mobile_monitoring/core/helpers/sync_error_handler.dart';
import 'package:gn_mobile_monitoring/core/helpers/string_formatter.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/global_api.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/global_database.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/modules_database.dart';
import 'package:gn_mobile_monitoring/data/entity/base_visit_entity.dart';
import 'package:gn_mobile_monitoring/data/mapper/visite_entity_mapper.dart';
import 'package:gn_mobile_monitoring/domain/model/base_visit.dart';
import 'package:gn_mobile_monitoring/domain/model/sync_result.dart';
import 'package:gn_mobile_monitoring/domain/repository/observation_details_repository.dart';
import 'package:gn_mobile_monitoring/domain/repository/observations_repository.dart';
import 'package:gn_mobile_monitoring/domain/repository/sites_repository.dart';
import 'package:gn_mobile_monitoring/domain/repository/upstream_sync_repository.dart';
import 'package:gn_mobile_monitoring/domain/repository/visit_repository.dart';

/// Implémentation du repository de téléversement (appareil vers serveur)
class UpstreamSyncRepositoryImpl implements UpstreamSyncRepository {
  final GlobalApi _globalApi;
  final GlobalDatabase _globalDatabase;
  final ModulesDatabase _modulesDatabase;
  final VisitRepository _visitRepository;
  final ObservationsRepository _observationsRepository;
  final ObservationDetailsRepository _observationDetailsRepository;
  final SitesRepository _sitesRepository;

  final AppLogger _logger = AppLogger();

  // Note: Méthodes de cache supprimées - les éléments échoués sont automatiquement retentés

  UpstreamSyncRepositoryImpl(
    this._globalApi,
    this._globalDatabase,
    this._modulesDatabase, {
    required VisitRepository visitRepository,
    required ObservationsRepository observationsRepository,
    required ObservationDetailsRepository observationDetailsRepository,
    required SitesRepository sitesRepository,
  })  : _visitRepository = visitRepository,
        _observationsRepository = observationsRepository,
        _observationDetailsRepository = observationDetailsRepository,
        _sitesRepository = sitesRepository;

  /// Vérifie la connectivité avec le serveur
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
  Future<SyncResult> syncVisitsToServer(String token, String moduleCode) async {
    try {
      // Vérifier la connectivité
      final isConnected = await checkConnectivity();
      if (!isConnected) {
        return SyncResult.failure(
          errorMessage: 'Pas de connexion Internet',
        );
      }

      int itemsProcessed = 0;
      int itemsAdded = 0;
      int itemsUpdated = 0;
      int itemsSkipped = 0;
      int itemsDeleted = 0;
      List<String> errors = [];

      try {
        StringBuffer logBuffer = StringBuffer();
        logBuffer.writeln(
            '\n==================================================================');
        logBuffer.writeln(
            '[SYNC_REPO] DÉBUT TÉLÉVERSEMENT - MODULE: $moduleCode');
        logBuffer.writeln(
            '==================================================================');

        // Récupérer seulement les visites du module spécifié
        final visits = await _visitRepository.getVisitsByModuleCode(moduleCode);
        logBuffer.writeln('Total des visites dans la base: ${visits.length}');

        // Afficher les détails de chaque visite pour le débogage
        if (visits.isNotEmpty) {
          logBuffer.writeln('\nDÉTAILS DES VISITES:');
          for (var visit in visits) {
            logBuffer.writeln('- ID: ${visit.idBaseVisit}');
            logBuffer.writeln('  Site: ${visit.idBaseSite}');
            logBuffer.writeln('  Date: ${visit.visitDateMin}');
            logBuffer.writeln('  Server ID: ${visit.serverVisitId}');
            logBuffer.writeln('  ---');
          }
        }

        // Écrire dans le fichier log via AppLogger
        _logger.i(logBuffer.toString(), tag: 'sync');

        // Si aucune visite, renvoyer un succès vide
        if (visits.isEmpty) {
          _logger.i('AUCUNE VISITE TROUVÉE - SYNCHRONISATION TERMINÉE\n',
              tag: 'sync');
          return SyncResult.success(
            itemsProcessed: 0,
            itemsAdded: 0,
            itemsUpdated: 0,
            itemsSkipped: 0,
          );
        }

        // Variables pour accumuler les statistiques détaillées
        int totalVisitsAdded = 0;
        int totalObservationsAdded = 0;
        int totalObservationDetailsAdded = 0;
        int totalVisitsDeleted = 0;
        int totalObservationsDeleted = 0;
        int totalObservationDetailsDeleted = 0;

        // Séparer les visites en deux groupes : nouvelles visites (POST) et visites existantes (PATCH)
        final newVisits = <BaseVisitEntity>[];
        final existingVisits = <BaseVisitEntity>[];
        
        for (final visit in visits) {
          if (visit.serverVisitId == null) {
            newVisits.add(visit);
          } else {
            existingVisits.add(visit);
          }
        }
        
        _logger.i('Répartition des visites: ${newVisits.length} nouvelles, ${existingVisits.length} existantes', tag: 'sync');

        // PARTIE 1: Traiter d'abord les visites existantes (PATCH) avec l'ordre inversé
        // Pour les visites existantes, traiter d'abord les observations, puis la visite
        _logger.i('Démarrage du traitement des ${existingVisits.length} visites existantes (PATCH) - Observations d\'abord', tag: 'sync');
        
        for (final visitEntity in existingVisits) {
          try {
            _logger.i('Traitement de la visite existante ID: ${visitEntity.idBaseVisit} (serverId: ${visitEntity.serverVisitId})',
                tag: 'sync');

            // Récupérer tous les détails de la visite
            final visit = await _visitRepository
                .getVisitWithFullDetails(visitEntity.idBaseVisit);

            // Validation pré-sync : vérifier que id_dataset est valide
            if (visit.idDataset == null || visit.idDataset! <= 0) {
              errors.add('Visite ${visitEntity.idBaseVisit}: id_dataset manquant. Veuillez sélectionner un jeu de données.');
              itemsSkipped++;
              itemsProcessed++;
              continue;
            }

            // Récupérer le vrai code du module pour les observations
            final realModuleCode = await _modulesDatabase.getModuleCodeFromIdModule(visit.idModule);

            // INVERSION: 1. D'abord synchroniser les observations (avant la visite)
            _logger.i('ORDRE INVERSÉ: Synchronisation des observations avant la visite ${visitEntity.idBaseVisit}', tag: 'sync');
            
            // On passe à la fois l'ID local (pour récupérer les observations localement)
            // et l'ID serveur (pour les envoyer avec le bon ID de visite serveur)
            final observationsResult = await syncObservationsToServer(
                token, realModuleCode, visitEntity.idBaseVisit,
                serverVisitId: visit.serverVisitId);
            
            // Consolider les statistiques des observations et détails
            itemsAdded += observationsResult.itemsAdded;
            itemsUpdated += observationsResult.itemsUpdated;
            itemsSkipped += observationsResult.itemsSkipped;
            itemsDeleted += observationsResult.itemsDeleted ?? 0;
            
            // Accumuler les statistiques détaillées pour les observations
            totalObservationsAdded += observationsResult.itemsAdded;
            totalObservationsDeleted += observationsResult.itemsDeleted ?? 0;
            
            _logger.i('Stats observations: +${observationsResult.itemsAdded} ajoutées, +${observationsResult.itemsUpdated} mises à jour, +${observationsResult.itemsSkipped} ignorées, +${observationsResult.itemsDeleted ?? 0} supprimées', tag: 'sync');
            
            // Vérifier si les observations ont réussi
            if (!observationsResult.success) {
              // Si les observations ont échoué, ne pas continuer avec la visite
              _logger.w('Observations de la visite ${visitEntity.idBaseVisit} échouées, abandon de la mise à jour de la visite', tag: 'sync');
              
              if (observationsResult.errorMessage != null) {
                _logger.e('Erreur observations: ${observationsResult.errorMessage}', tag: 'sync');
                errors.add('Observations de la visite ${visitEntity.idBaseVisit}: ${observationsResult.errorMessage}');
              }
              
              itemsSkipped++;
              continue; // Passer à la visite suivante
            }
            
            // 2. Ensuite seulement, mettre à jour la visite (PATCH)
            _logger.i('Mise à jour de la visite existante après synchronisation réussie des observations', tag: 'sync');

            Map<String, dynamic> serverResponse;
            bool visitProcessedSuccessfully = false;
            int serverId = visit.serverVisitId!;

            try {
              // Prétraitement des observateurs pour éviter les erreurs
              List<int> safeObservers = [];
              if (visit.observers != null) {
                for (var o in visit.observers!) {
                  safeObservers.add(o);
                }
              }

              // IMPORTANT: Mapper l'ID local du site vers l'ID serveur si le site a été créé localement
              // Pour les sites téléchargés du serveur, idBaseSite EST déjà l'ID serveur (serverSiteId est null, isLocal est false/null)
              // Pour les sites créés localement et synchronisés, on utilise serverSiteId
              // Pour les sites créés localement mais non synchronisés, on génère une erreur
              int? effectiveSiteId = visit.idBaseSite;
              if (visit.idBaseSite != null) {
                final site = await _sitesRepository.getSiteById(visit.idBaseSite!);
                if (site != null && site.serverSiteId != null) {
                  // Site créé localement et déjà synchronisé - utiliser l'ID serveur
                  _logger.i('Mapping site local ${visit.idBaseSite} -> serveur ${site.serverSiteId}', tag: 'sync');
                  effectiveSiteId = site.serverSiteId;
                } else if (site != null && site.serverSiteId == null && site.isLocal == true) {
                  // Site créé localement mais pas encore synchronisé - erreur fatale
                  throw Exception(
                    'Le site local ${visit.idBaseSite} n\'a pas encore été synchronisé avec le serveur. '
                    'Veuillez d\'abord synchroniser les sites avant les visites.'
                  );
                }
                // Si site.isLocal == false/null et serverSiteId == null,
                // c'est un site téléchargé du serveur, idBaseSite EST l'ID serveur
              }

              // Créer une nouvelle entité avec des observateurs sécurisés
              final safeEntity = BaseVisitEntity(
                idBaseVisit: visit.idBaseVisit,
                idBaseSite: effectiveSiteId,
                idDataset: visit.idDataset,
                idModule: visit.idModule,
                idDigitiser: visit.idDigitiser,
                visitDateMin: visit.visitDateMin,
                visitDateMax: visit.visitDateMax,
                idNomenclatureTechCollectCampanule: visit.idNomenclatureTechCollectCampanule,
                idNomenclatureGrpTyp: visit.idNomenclatureGrpTyp,
                comments: visit.comments,
                uuidBaseVisit: visit.uuidBaseVisit,
                metaCreateDate: visit.metaCreateDate,
                metaUpdateDate: visit.metaUpdateDate,
                observers: safeObservers,
                data: visit.data,
              );

              // Convertir l'entité sécurisée en modèle de domaine
              final visitModel = safeEntity.toDomain();

              _logger.i('PATCH visite: ${visitEntity.idBaseVisit} -> serverId: $serverId', tag: 'sync');
              serverResponse = await _globalApi.updateVisit(token, realModuleCode, serverId, visitModel);

              _logger.i('Visite mise à jour avec succès, ID serveur: $serverId', tag: 'sync');
              itemsUpdated++;
              visitProcessedSuccessfully = true;
            } catch (e) {
              _logger.e('Erreur lors de la mise à jour de la visite: $e', tag: 'sync', error: e);
              
              // Extraire des informations plus détaillées de l'erreur
              String detailedError = SyncErrorHandler.extractDetailedError(e, 'visite', visitEntity.idBaseVisit);
              errors.add(detailedError);
              
              // Incrémenter le compteur d'échecs pour cette visite
              int failureCount = SyncCacheManager.incrementVisitFailureCount(visitEntity.idBaseVisit);
              
              // Analyser l'erreur pour déterminer si elle est fatale
              bool isFatal = SyncErrorHandler.isFatalError(e);
              _logger.w('Analyse erreur visite ${visitEntity.idBaseVisit}: tentative=$failureCount, isFatal=$isFatal, errorType=${e.runtimeType}', tag: 'sync');
              
              // Les observations ont été synchronisées avec succès mais la visite a échoué
              // On conserve la visite locale pour pouvoir réessayer plus tard
              _logger.w('La mise à jour de la visite a échoué, mais les observations ont été synchronisées. Conservation de la visite locale pour une prochaine tentative.', tag: 'sync');
              itemsSkipped++;
              
              // Indiquer que nous allons conserver cette visite
              _logger.i('Visite conservée localement malgré observations synchronisées', tag: 'sync');
              
              // On ne continue pas - il faut garder la visite locale
              itemsProcessed++;
              continue;
            }
            
            // 3. Si la visite a été mise à jour avec succès, on peut supprimer la visite locale
            await _visitRepository.deleteVisit(visitEntity.idBaseVisit);
            itemsDeleted++;
            totalVisitsDeleted++;
            
            _logger.i('Visite mise à jour et supprimée avec succès', tag: 'sync');

            itemsProcessed++;
          } catch (e) {
            _logger.e('Erreur lors du traitement de la visite ${visitEntity.idBaseVisit}: $e',
                tag: 'sync', error: e);
            errors.add('Visite ${visitEntity.idBaseVisit}: $e');
            itemsSkipped++;
          }
        }

        // PARTIE 2: Traiter ensuite les nouvelles visites (POST) avec l'ordre normal
        // Pour les nouvelles visites, garder l'ordre habituel: visites d'abord, puis observations
        _logger.i('Démarrage du traitement des ${newVisits.length} nouvelles visites (POST) - Visites d\'abord', tag: 'sync');
        
        for (final visitEntity in newVisits) {
          try {
            _logger.i('Traitement de la nouvelle visite ID: ${visitEntity.idBaseVisit}', tag: 'sync');

            // Récupérer tous les détails de la visite
            final visit = await _visitRepository.getVisitWithFullDetails(visitEntity.idBaseVisit);

            // Validation pré-sync : vérifier que id_dataset est valide
            if (visit.idDataset == null || visit.idDataset! <= 0) {
              errors.add('Visite ${visitEntity.idBaseVisit}: id_dataset manquant. Veuillez sélectionner un jeu de données.');
              itemsSkipped++;
              itemsProcessed++;
              continue;
            }

            // 1. Envoyer d'abord la visite au serveur (ordre normal pour les POST)
            Map<String, dynamic> serverResponse;
            int? serverId;
            bool visitProcessedSuccessfully = false;

            try {
              // Prétraitement des observateurs pour éviter les erreurs
              List<int> safeObservers = [];
              if (visit.observers != null) {
                for (var o in visit.observers!) {
                  safeObservers.add(o);
                }
              }

              // IMPORTANT: Mapper l'ID local du site vers l'ID serveur si le site a été créé localement
              // Pour les sites téléchargés du serveur, idBaseSite EST déjà l'ID serveur (serverSiteId est null, isLocal est false/null)
              // Pour les sites créés localement et synchronisés, on utilise serverSiteId
              // Pour les sites créés localement mais non synchronisés, on génère une erreur
              int? effectiveSiteId = visit.idBaseSite;
              if (visit.idBaseSite != null) {
                final site = await _sitesRepository.getSiteById(visit.idBaseSite!);
                if (site != null && site.serverSiteId != null) {
                  // Site créé localement et déjà synchronisé - utiliser l'ID serveur
                  _logger.i('Mapping site local ${visit.idBaseSite} -> serveur ${site.serverSiteId}', tag: 'sync');
                  effectiveSiteId = site.serverSiteId;
                } else if (site != null && site.serverSiteId == null && site.isLocal == true) {
                  // Site créé localement mais pas encore synchronisé - erreur fatale
                  throw Exception(
                    'Le site local ${visit.idBaseSite} n\'a pas encore été synchronisé avec le serveur. '
                    'Veuillez d\'abord synchroniser les sites avant les visites.'
                  );
                }
                // Si site.isLocal == false/null et serverSiteId == null,
                // c'est un site téléchargé du serveur, idBaseSite EST l'ID serveur
              }

              // Créer une nouvelle entité avec des observateurs sécurisés
              final safeEntity = BaseVisitEntity(
                idBaseVisit: visit.idBaseVisit,
                idBaseSite: effectiveSiteId,
                idDataset: visit.idDataset,
                idModule: visit.idModule,
                idDigitiser: visit.idDigitiser,
                visitDateMin: visit.visitDateMin,
                visitDateMax: visit.visitDateMax,
                idNomenclatureTechCollectCampanule: visit.idNomenclatureTechCollectCampanule,
                idNomenclatureGrpTyp: visit.idNomenclatureGrpTyp,
                comments: visit.comments,
                uuidBaseVisit: visit.uuidBaseVisit,
                metaCreateDate: visit.metaCreateDate,
                metaUpdateDate: visit.metaUpdateDate,
                observers: safeObservers,
                data: visit.data,
              );

              // Convertir l'entité sécurisée en modèle de domaine
              final visitModel = safeEntity.toDomain();

              // POST - Créer une nouvelle visite
              _logger.i('Création d\'une nouvelle visite sur le serveur', tag: 'sync');
              
              // Récupérer le vrai code du module depuis l'ID module de la visite
              final realModuleCode = await _modulesDatabase.getModuleCodeFromIdModule(visit.idModule);
              
              serverResponse = await _globalApi.sendVisit(token, realModuleCode, visitModel);

              serverId = serverResponse['id'] ?? serverResponse['ID'];
              if (serverId == null) {
                throw Exception('Réponse du serveur invalide pour la visite');
              }

              _logger.i('Visite créée avec succès, ID serveur: $serverId', tag: 'sync');
              itemsAdded++;
              totalVisitsAdded++;

              // Mettre à jour l'ID serveur pour les futures tentatives de synchronisation
              await _visitRepository.updateVisitServerId(visitEntity.idBaseVisit, serverId);
              _logger.i('ID serveur de la visite enregistré: local=${visitEntity.idBaseVisit}, serveur=$serverId', tag: 'sync');
              
              visitProcessedSuccessfully = true;
            } catch (e) {
              _logger.e('Erreur lors de l\'envoi de la visite: $e', tag: 'sync', error: e);
              
              // Extraire des informations plus détaillées de l'erreur
              String detailedError = SyncErrorHandler.extractDetailedError(e, 'visite', visitEntity.idBaseVisit);
              errors.add(detailedError);
              
              // Incrémenter le compteur d'échecs pour cette visite
              int failureCount = SyncCacheManager.incrementVisitFailureCount(visitEntity.idBaseVisit);
              
              // Analyser l'erreur pour déterminer si elle est fatale
              bool isFatal = SyncErrorHandler.isFatalError(e);
              _logger.w('Analyse erreur visite ${visitEntity.idBaseVisit}: tentative=$failureCount, isFatal=$isFatal, errorType=${e.runtimeType}', tag: 'sync');
              
              // Pas de serverVisitId, impossible de synchroniser les observations
              _logger.e('Erreur critique pour la visite ${visitEntity.idBaseVisit}. Pas de serverVisitId, impossible de synchroniser les observations.', tag: 'sync');
              errors.add('ERREUR - Visite ${visitEntity.idBaseVisit}: ${SyncErrorHandler.extractDetailedError(e, 'visite', visitEntity.idBaseVisit)}. La visite sera retentée à la prochaine synchronisation.');
              itemsSkipped++;
              continue; // Passer à la visite suivante
            }

            // 2. Ensuite seulement, envoyer les observations (pour les nouvelles visites)
            // Récupérer le vrai code du module pour les observations
            final realModuleCode = await _modulesDatabase.getModuleCodeFromIdModule(visit.idModule);

            // On passe à la fois l'ID local (pour récupérer les observations localement)
            // et l'ID serveur (pour les envoyer avec le bon ID de visite serveur)
            final observationsResult = await syncObservationsToServer(
                token, realModuleCode, visitEntity.idBaseVisit,
                serverVisitId: serverId);
            
            // Consolider les statistiques des observations et détails
            itemsAdded += observationsResult.itemsAdded;
            itemsUpdated += observationsResult.itemsUpdated;
            itemsSkipped += observationsResult.itemsSkipped;
            itemsDeleted += observationsResult.itemsDeleted ?? 0;
            
            // Accumuler les statistiques détaillées pour les observations
            totalObservationsAdded += observationsResult.itemsAdded;
            totalObservationsDeleted += observationsResult.itemsDeleted ?? 0;
            
            _logger.i('Stats observations: +${observationsResult.itemsAdded} ajoutées, +${observationsResult.itemsUpdated} mises à jour, +${observationsResult.itemsSkipped} ignorées, +${observationsResult.itemsDeleted ?? 0} supprimées', tag: 'sync');
            
            if (observationsResult.success) {
              // Si les observations ont réussi, supprimer la visite localement
              await _visitRepository.deleteVisit(visitEntity.idBaseVisit);
              itemsDeleted++;
              totalVisitsDeleted++;
              
              _logger.i('Visite et observations supprimées avec succès', tag: 'sync');
            } else {
              // Si les observations ont échoué, ne pas supprimer la visite
              _logger.w('Visite ${visitEntity.idBaseVisit} créée sur le serveur (ID: $serverId) mais observations échouées', tag: 'sync');

              if (observationsResult.errorMessage != null) {
                _logger.e('Observations de la visite ${visitEntity.idBaseVisit}: ${observationsResult.errorMessage}', tag: 'sync');
                errors.add('Observations de la visite ${visitEntity.idBaseVisit}: ${observationsResult.errorMessage}');
              }

              // Marquer la visite comme partiellement synchronisée
              itemsSkipped++;
            }

            itemsProcessed++;
          } catch (e) {
            _logger.e('Erreur lors du traitement de la visite ${visitEntity.idBaseVisit}: $e',
                tag: 'sync', error: e);
            errors.add('Visite ${visitEntity.idBaseVisit}: $e');
            itemsSkipped++;
          }
        }

        // Mettre à jour la date de synchronisation
        await updateLastSyncDate('visitsToServer', DateTime.now());

        if (errors.isNotEmpty) {
          String errorMessage = 'Erreurs lors de la synchronisation des visites:\n${errors.join('\n')}';
          
          // Ajouter une note si des erreurs fatales ont été détectées
          if (errors.any((error) => error.contains('ERREUR FATALE'))) {
            errorMessage += '\n\nIMPORTANT: Des erreurs fatales ont été détectées. Les données restent sauvegardées localement mais la synchronisation a été interrompue pour éviter les boucles infinies. Veuillez corriger les données mentionnées ci-dessus et relancer la synchronisation.';
          }
          
          return SyncResult.failure(
            errorMessage: errorMessage,
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
          data: {
            'visits_added': totalVisitsAdded,
            'observations_added': totalObservationsAdded,
            'observation_details_added': totalObservationDetailsAdded,
            'visits_deleted': totalVisitsDeleted,
            'observations_deleted': totalObservationsDeleted,
            'observation_details_deleted': totalObservationDetailsDeleted,
          },
        );
      } catch (e) {
        debugPrint('Erreur lors de la synchronisation des visites: $e');
        return SyncResult.failure(
          errorMessage: 'Erreur lors de la synchronisation des visites: $e',
        );
      }
    } catch (e) {
      debugPrint('Erreur générale lors de la synchronisation des visites: $e');
      return SyncResult.failure(
        errorMessage: 'Erreur lors de la synchronisation des visites: $e',
      );
    }
  }

  @override
  Future<SyncResult> syncObservationsToServer(
      String token, String moduleCode, int visitId,
      {int? serverVisitId}) async {
    try {
      // Vérifier la connectivité
      final isConnected = await checkConnectivity();
      if (!isConnected) {
        return SyncResult.failure(
          errorMessage: 'Pas de connexion Internet',
        );
      }

      // Utiliser l'ID serveur de la visite s'il est fourni (sinon utiliser l'ID local)
      final effectiveVisitId = serverVisitId ?? visitId;
      debugPrint(
          'Synchronisation des observations: ID visite local = $visitId, ID visite serveur = $effectiveVisitId');

      int itemsProcessed = 0;
      int itemsAdded = 0;
      int itemsUpdated = 0;
      int itemsSkipped = 0;
      int itemsDeleted = 0;
      List<String> errors = [];

      try {
        // Récupérer toutes les observations pour cette visite
        final observations =
            await _observationsRepository.getObservationsByVisitId(visitId);

        // Si aucune observation, renvoyer un succès vide
        if (observations.isEmpty) {
          debugPrint('Aucune observation trouvée pour la visite $visitId');
          return SyncResult.success(
            itemsProcessed: 0,
            itemsAdded: 0,
            itemsUpdated: 0,
            itemsSkipped: 0,
          );
        }

        // Pour chaque observation, envoyer l'observation et tous ses détails
        for (final observation in observations) {
          try {
            // Note: Suppression de la vérification du cache des échecs pour permettre les retry

            debugPrint(
                'Traitement de l\'observation ID: ${observation.idObservation}');

            // 1. Envoyer l'observation au serveur avec l'ID de visite serveur
            Map<String, dynamic> serverResponse;
            int? serverId;
            bool isNewObservation = observation.serverObservationId == null;

            try {
              // Créer une version modifiée de l'observation avec l'ID de visite serveur
              final observationWithServerVisitId = observation.copyWith(
                idBaseVisit: effectiveVisitId, // Utiliser l'ID serveur ici!
              );

              if (isNewObservation) {
                // POST - Créer une nouvelle observation
                _logger.i(
                    '📤 POST Création d\'une nouvelle observation avec ID visite serveur = $effectiveVisitId',
                    tag: 'sync');
                debugPrint('📤 POST observation locale ID: ${observation.idObservation}');
                
                serverResponse = await _globalApi.sendObservation(
                    token, moduleCode, observationWithServerVisitId);

                debugPrint('📥 RÉPONSE SERVEUR pour observation ${observation.idObservation}: $serverResponse');
                
                serverId = serverResponse['id'] ?? serverResponse['ID'];
                debugPrint('🔍 EXTRACTION ID SERVEUR: ${serverResponse['id']} ?? ${serverResponse['ID']} = $serverId');
                
                if (serverId == null) {
                  debugPrint('❌ ERREUR: ID serveur NULL dans la réponse: $serverResponse');
                  throw Exception(
                      'Réponse du serveur invalide pour l\'observation');
                }

                debugPrint('✅ ID SERVEUR EXTRAIT: $serverId pour observation locale ${observation.idObservation}');

                // Mettre à jour l'ID serveur pour les futures tentatives de synchronisation
                debugPrint('🔄 APPEL updateObservationServerId: local=${observation.idObservation}, serveur=$serverId');
                await _observationsRepository.updateObservationServerId(
                    observation.idObservation, serverId);
                debugPrint('✅ RETOUR updateObservationServerId terminé');
                
                _logger.i(
                    'ID serveur de l\'observation enregistré: local=${observation.idObservation}, serveur=$serverId',
                    tag: 'sync');

                debugPrint(
                    'Observation créée avec succès, ID serveur: $serverId');
                itemsAdded++;
              } else {
                // PATCH - Mettre à jour une observation existante
                serverId = observation.serverObservationId!;
                _logger.i(
                    'Mise à jour d\'une observation existante sur le serveur, ID serveur: $serverId',
                    tag: 'sync');

                serverResponse = await _globalApi.updateObservation(
                    token, moduleCode, serverId, observationWithServerVisitId);

                _logger.i(
                    'Observation mise à jour avec succès, ID serveur: $serverId',
                    tag: 'sync');
                itemsUpdated++;
              }
            } catch (e) {
              debugPrint('❌ ERREUR lors de l\'envoi de l\'observation: $e');
              
              // GESTION SPÉCIALE : Si l'observation a été créée sur le serveur mais la transaction a échoué,
              // extraire l'ID serveur de l'erreur pour éviter les doublons lors du prochain retry
              String errorString = e.toString();
              debugPrint('🔍 RECHERCHE ID SERVEUR dans l\'erreur...');
              debugPrint('🔍 ERREUR COMPLÈTE: ${errorString.length > 500 ? "${errorString.substring(0, 500)}..." : errorString}');
              
              // Pour les NetworkException qui encapsulent les erreurs DIO, 
              // essayer d'extraire des informations supplémentaires
              String fullErrorContent = errorString;
              
              // Si c'est une NetworkException, utiliser la nouvelle propriété responseData
              if (e.runtimeType.toString() == 'NetworkException') {
                try {
                  final dynamic networkException = e as dynamic;
                  final String? responseData = networkException.responseData;
                  
                  if (responseData != null) {
                    fullErrorContent += '\n$responseData';
                    debugPrint('🔍 RÉPONSE SERVEUR HTML: ${responseData.length > 300 ? "${responseData.substring(0, 300)}..." : responseData}');
                  } else {
                    debugPrint('⚠️ responseData est null');
                  }
                } catch (extractionError) {
                  debugPrint('⚠️ Impossible d\'extraire les détails de l\'erreur: $extractionError');
                }
              }
              
              // Pattern pour extraire l'ID d'observation du message d'erreur
              // Ex: "MONITORING: create_or_update monitoringobject chiro, observation, 36880"
              RegExp observationIdPattern = RegExp(r'observation,\s*(\d+)');
              Match? match = observationIdPattern.firstMatch(fullErrorContent);
              
              if (match != null) {
                String extractedIdStr = match.group(1)!;
                int? extractedServerId = int.tryParse(extractedIdStr);
                
                if (extractedServerId != null) {
                  debugPrint('✅ ID SERVEUR EXTRAIT DE L\'ERREUR: $extractedServerId pour observation locale ${observation.idObservation}');
                  
                  try {
                    // Sauvegarder l'ID serveur même si la transaction a échoué
                    debugPrint('🔄 SAUVEGARDE ID SERVEUR depuis erreur: local=${observation.idObservation}, serveur=$extractedServerId');
                    await _observationsRepository.updateObservationServerId(
                        observation.idObservation, extractedServerId);
                    debugPrint('✅ ID serveur sauvegardé depuis l\'erreur - prochaine sync sera un PATCH');
                    
                    _logger.w('RÉCUPÉRATION - Observation ${observation.idObservation}: créée sur serveur (ID: $extractedServerId) mais transaction échouée. ID serveur sauvegardé pour PATCH lors du prochain retry.', tag: 'sync');
                  } catch (updateError) {
                    debugPrint('❌ Erreur lors de la sauvegarde de l\'ID serveur extrait: $updateError');
                  }
                } else {
                  debugPrint('❌ Impossible de parser l\'ID serveur: $extractedIdStr');
                }
              } else {
                debugPrint('❌ Aucun ID serveur trouvé dans l\'erreur complète');
                debugPrint('🔍 RECHERCHE DANS CONTENU: ${fullErrorContent.length > 200 ? "${fullErrorContent.substring(0, 200)}..." : fullErrorContent}');
              }
              
              // Extraire des informations plus détaillées de l'erreur
              String detailedError = SyncErrorHandler.extractDetailedError(e, 'observation', observation.idObservation);
              errors.add(detailedError);
              
              // Incrémenter le compteur d'échecs pour cette observation
              int failureCount = SyncCacheManager.incrementObservationFailureCount(observation.idObservation);
              
              // Analyser l'erreur pour déterminer si elle est fatale
              bool isFatal = SyncErrorHandler.isFatalError(e);
              _logger.w('Analyse erreur observation ${observation.idObservation}: tentative=$failureCount, isFatal=$isFatal, errorType=${e.runtimeType}', tag: 'sync');
              
              // Continuer avec l'observation suivante sans bloquer pour les prochaines sync
              _logger.e('Erreur détectée pour l\'observation ${observation.idObservation} (tentative $failureCount). L\'observation sera retentée à la prochaine synchronisation.', tag: 'sync');
              errors.add('ERREUR - Observation ${observation.idObservation}: ${SyncErrorHandler.extractDetailedError(e, 'observation', observation.idObservation)}. L\'observation sera retentée à la prochaine synchronisation.');
              itemsSkipped++;
              continue; // Passer à l'observation suivante
            }

            // 2. Récupérer et envoyer tous les détails associés à cette observation
            // Utiliser l'ID serveur approprié selon le type d'opération
            final serverObservationId = serverId;

            _logger.i(
                'Envoi des détails pour l\'observation local=${observation.idObservation}, serveur=$serverObservationId',
                tag: 'sync');

            // Vérifier la réponse du serveur pour les champs importants
            if (serverResponse.containsKey('properties')) {
              final properties = serverResponse['properties'];
              if (properties is Map) {
                _logger.i(
                    'Propriétés de l\'observation dans la réponse du serveur: $properties',
                    tag: 'sync');
              }
            }

            // Passer l'ID serveur de l'observation pour les détails
            final detailsResult = await syncObservationDetailsToServer(
                token, moduleCode, observation.idObservation,
                serverObservationId: serverObservationId);

            // Consolider les statistiques des détails d'observation
            itemsAdded += detailsResult.itemsAdded;
            itemsUpdated += detailsResult.itemsUpdated;
            itemsSkipped += detailsResult.itemsSkipped;
            itemsDeleted += detailsResult.itemsDeleted ?? 0;
            
            _logger.i('Stats détails: +${detailsResult.itemsAdded} ajoutés, +${detailsResult.itemsUpdated} mis à jour, +${detailsResult.itemsSkipped} ignorés, +${detailsResult.itemsDeleted ?? 0} supprimés', tag: 'sync');

            // En cas d'erreur avec les détails, l'ajouter à la liste d'erreurs
            if (!detailsResult.success && detailsResult.errorMessage != null) {
              errors.add(
                  'Détails de l\'observation ${observation.idObservation}: ${detailsResult.errorMessage}');
              itemsSkipped++;
              continue; // Passer à l'observation suivante sans la supprimer
            }

            // 3. Si cette observation spécifique a réussi, la supprimer localement
            debugPrint('🗑️ SUPPRESSION observation locale ID: ${observation.idObservation} après succès complet');
            await _observationsRepository
                .deleteObservation(observation.idObservation);
            itemsDeleted++;
            debugPrint(
                '✅ Observation ${observation.idObservation} supprimée avec succès de la base locale');

            itemsProcessed++;
          } catch (e) {
            debugPrint(
                'Erreur lors du traitement de l\'observation ${observation.idObservation}: $e');
            errors.add('Observation ${observation.idObservation}: $e');
            itemsSkipped++;
          }
        }

        if (errors.isNotEmpty) {
          String errorMessage = 'Erreurs lors de la synchronisation des observations:\n${errors.join('\n')}';
          
          // Ajouter une note si des erreurs fatales ont été détectées
          if (errors.any((error) => error.contains('ERREUR FATALE'))) {
            errorMessage += '\n\nIMPORTANT: Des erreurs fatales ont été détectées. Les données restent sauvegardées localement mais la synchronisation a été interrompue pour éviter les boucles infinies. Veuillez corriger les données mentionnées ci-dessus et relancer la synchronisation.';
          }
          
          return SyncResult.failure(
            errorMessage: errorMessage,
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
        debugPrint('Erreur lors de la synchronisation des observations: $e');
        return SyncResult.failure(
          errorMessage:
              'Erreur lors de la synchronisation des observations: $e',
        );
      }
    } catch (e) {
      debugPrint(
          'Erreur générale lors de la synchronisation des observations: $e');
      return SyncResult.failure(
        errorMessage: 'Erreur lors de la synchronisation des observations: $e',
      );
    }
  }

  @override
  Future<SyncResult> syncObservationDetailsToServer(
      String token, String moduleCode, int observationId,
      {int? serverObservationId}) async {
    try {
      // Vérifier la connectivité
      final isConnected = await checkConnectivity();
      if (!isConnected) {
        return SyncResult.failure(
          errorMessage: 'Pas de connexion Internet',
        );
      }

      // Utiliser l'ID serveur de l'observation s'il est fourni (sinon utiliser l'ID local)
      final effectiveObservationId = serverObservationId ?? observationId;
      _logger.i(
          'Synchronisation des détails d\'observation: ID observation local = $observationId, ID observation serveur = $effectiveObservationId',
          tag: 'sync');

      int itemsProcessed = 0;
      int itemsAdded = 0;
      int itemsUpdated = 0;
      int itemsSkipped = 0;
      int itemsDeleted = 0;
      List<String> errors = [];

      try {
        // Récupérer tous les détails pour cette observation
        final details = await _observationDetailsRepository
            .getObservationDetailsByObservationId(observationId);

        // Si aucun détail, renvoyer un succès vide
        if (details.isEmpty) {
          _logger.i('Aucun détail trouvé pour l\'observation $observationId',
              tag: 'sync');
          return SyncResult.success(
            itemsProcessed: 0,
            itemsAdded: 0,
            itemsUpdated: 0,
            itemsSkipped: 0,
          );
        }

        // Log pour le débogage
        _logger.i(
            '${details.length} détails trouvés pour l\'observation $observationId',
            tag: 'sync');
        for (final detail in details) {
          _logger.i(
              'Détail ${detail.idObservationDetail} - données: ${detail.data}',
              tag: 'sync');
        }

        // Pour chaque détail, l'envoyer au serveur
        for (final detail in details) {
          try {
            _logger.i('Traitement du détail ID: ${detail.idObservationDetail}',
                tag: 'sync');

            // Vérifier la présence des champs clés dans les données
            if (detail.data.containsKey('denombrement')) {
              _logger.i(
                  'Champ "denombrement" présent dans les données: ${detail.data['denombrement']} (${detail.data['denombrement'].runtimeType})',
                  tag: 'sync');
            } else {
              _logger.w('Champ "denombrement" ABSENT des données', tag: 'sync');
            }

            if (detail.data.containsKey('hauteur_strate')) {
              _logger.i(
                  'Champ "hauteur_strate" présent dans les données: ${detail.data['hauteur_strate']} (${detail.data['hauteur_strate'].runtimeType})',
                  tag: 'sync');
            } else {
              _logger.w('Champ "hauteur_strate" ABSENT des données',
                  tag: 'sync');
            }

            // Envoyer le détail au serveur avec l'ID d'observation serveur
            Map<String, dynamic> serverResponse;
            try {
              // Créer une version modifiée du détail avec l'ID d'observation serveur
              // IMPORTANT: Nous utilisons ici l'ID serveur de l'observation, pas l'ID local
              final detailWithServerObservationId = detail.copyWith(
                idObservation:
                    effectiveObservationId, // Utiliser l'ID serveur ici!
              );

              _logger.i(
                  'Envoi du détail avec ID observation serveur = $effectiveObservationId',
                  tag: 'sync');

              // Vérifier les données avant l'envoi
              _logger.i(
                  'Données avant envoi: ${detailWithServerObservationId.data}',
                  tag: 'sync');

              // Envoyer la requête au serveur
              serverResponse = await _globalApi.sendObservationDetail(
                  token, moduleCode, detailWithServerObservationId);

              // Vérifier la réponse du serveur
              _logger.i('Réponse du serveur: $serverResponse', tag: 'sync');

              final serverId = serverResponse['id'] ?? serverResponse['ID'];
              if (serverId == null) {
                throw Exception(
                    'Réponse du serveur invalide pour le détail d\'observation');
              }

              // Vérifier la réponse pour les champs spécifiques
              if (serverResponse.containsKey('properties')) {
                final properties = serverResponse['properties'];
                if (properties is Map) {
                  if (properties.containsKey('denombrement')) {
                    _logger.i(
                        'Champ "denombrement" dans la réponse: ${properties['denombrement']}',
                        tag: 'sync');
                  } else {
                    _logger.w('Champ "denombrement" ABSENT de la réponse',
                        tag: 'sync');
                  }

                  if (properties.containsKey('hauteur_strate')) {
                    _logger.i(
                        'Champ "hauteur_strate" dans la réponse: ${properties['hauteur_strate']}',
                        tag: 'sync');
                  } else {
                    _logger.w('Champ "hauteur_strate" ABSENT de la réponse',
                        tag: 'sync');
                  }
                }
              }

              _logger.i(
                  'Détail d\'observation envoyé avec succès, ID serveur: $serverId',
                  tag: 'sync');
              // Pour l'instant, les détails d'observation sont toujours des créations (POST)
              // mais la logique peut être étendue pour gérer les mises à jour (PATCH) si nécessaire
              itemsAdded++;
            } catch (e) {
              _logger.e('Erreur lors de l\'envoi du détail d\'observation: $e',
                  tag: 'sync', error: e);
              
              // Extraire des informations plus détaillées de l'erreur
              String detailedError = SyncErrorHandler.extractDetailedError(e, 'detail', detail.idObservationDetail ?? 0);
              errors.add(detailedError);
              
              // Analyser l'erreur pour déterminer si elle est fatale
              bool isFatal = SyncErrorHandler.isFatalError(e);
              _logger.w('Analyse erreur détail ${detail.idObservationDetail}: isFatal=$isFatal, errorType=${e.runtimeType}', tag: 'sync');
              
              // Si c'est une erreur fatale (contrainte de base de données), 
              // arrêter complètement la synchronisation pour éviter la boucle infinie
              if (isFatal) {
                _logger.e('Erreur fatale détectée pour le détail ${detail.idObservationDetail}. Arrêt de la synchronisation pour éviter la boucle infinie. L\'utilisateur doit corriger les données.', tag: 'sync');
                errors.add('ERREUR FATALE - Détail ${detail.idObservationDetail}: ${SyncErrorHandler.extractDetailedError(e, 'detail', detail.idObservationDetail ?? 0)}. Synchronisation interrompue pour éviter les boucles infinies. Veuillez corriger les données et relancer la synchronisation.');
                
                // Retourner immédiatement avec l'erreur
                return SyncResult.failure(
                  errorMessage: errors.join('\n'),
                  itemsProcessed: itemsProcessed,
                  itemsAdded: itemsAdded,
                  itemsUpdated: itemsUpdated,
                  itemsSkipped: itemsSkipped,
                  itemsDeleted: itemsDeleted,
                );
              } else {
                itemsSkipped++;
              }
              continue; // Passer au détail suivant
            }

            // Si tout a réussi, supprimer le détail localement
            if (detail.idObservationDetail != null) {
              _logger.i(
                  'Suppression du détail local: ${detail.idObservationDetail}',
                  tag: 'sync');
              await _observationDetailsRepository
                  .deleteObservationDetail(detail.idObservationDetail!);
              itemsDeleted++;
              _logger.i('Détail d\'observation supprimé avec succès',
                  tag: 'sync');
            }

            itemsProcessed++;
          } catch (e) {
            _logger.e(
                'Erreur lors du traitement du détail ${detail.idObservationDetail}: $e',
                tag: 'sync',
                error: e);
            errors.add('Détail ${detail.idObservationDetail}: $e');
            itemsSkipped++;
          }
        }

        if (errors.isNotEmpty) {
          _logger.e('Erreurs lors de la synchronisation: ${errors.join(", ")}',
              tag: 'sync');
          
          String errorMessage = 'Erreurs lors de la synchronisation des détails d\'observation:\n${errors.join('\n')}';
          
          // Ajouter une note si des erreurs fatales ont été détectées
          if (errors.any((error) => error.contains('ERREUR FATALE'))) {
            errorMessage += '\n\nIMPORTANT: Des erreurs fatales ont été détectées. Les données restent sauvegardées localement mais la synchronisation a été interrompue pour éviter les boucles infinies. Veuillez corriger les données mentionnées ci-dessus et relancer la synchronisation.';
          }
          
          return SyncResult.failure(
            errorMessage: errorMessage,
            itemsProcessed: itemsProcessed,
            itemsAdded: itemsAdded,
            itemsUpdated: itemsUpdated,
            itemsSkipped: itemsSkipped,
            itemsDeleted: itemsDeleted,
          );
        }

        _logger.i(
            'Synchronisation des détails d\'observation réussie: $itemsProcessed traités, $itemsAdded ajoutés, $itemsUpdated mis à jour',
            tag: 'sync');
        return SyncResult.success(
          itemsProcessed: itemsProcessed,
          itemsAdded: itemsAdded,
          itemsUpdated: itemsUpdated,
          itemsSkipped: itemsSkipped,
          itemsDeleted: itemsDeleted,
        );
      } catch (e) {
        _logger.e(
            'Erreur lors de la synchronisation des détails d\'observation: $e',
            tag: 'sync',
            error: e);
        return SyncResult.failure(
          errorMessage:
              'Erreur lors de la synchronisation des détails d\'observation: $e',
        );
      }
    } catch (e) {
      _logger.e(
          'Erreur générale lors de la synchronisation des détails d\'observation: $e',
          tag: 'sync',
          error: e);
      return SyncResult.failure(
        errorMessage:
            'Erreur lors de la synchronisation des détails d\'observation: $e',
      );
    }
  }

  @override
  Future<SyncResult> syncSiteGroupsToServer(String token, String moduleCode) async {
    try {
      // Vérifier la connectivité
      final isConnected = await checkConnectivity();
      if (!isConnected) {
        return SyncResult.failure(
          errorMessage: 'Pas de connexion Internet',
        );
      }

      int itemsProcessed = 0;
      int itemsAdded = 0;
      int itemsUpdated = 0;
      int itemsSkipped = 0;
      List<String> errors = [];

      try {
        _logger.i(
            '\n==================================================================',
            tag: 'sync');
        _logger.i(
            '[SYNC_REPO] DÉBUT TÉLÉVERSEMENT GROUPES DE SITES - MODULE: $moduleCode',
            tag: 'sync');
        _logger.i(
            '==================================================================',
            tag: 'sync');

        // Récupérer l'ID du module pour l'association via cor_sites_group_module
        final module = await _modulesDatabase.getModuleByCode(moduleCode);
        final moduleId = module?.id;
        if (moduleId != null) {
          _logger.i('Module ID résolu: $moduleId pour $moduleCode', tag: 'sync');
        } else {
          _logger.w('Impossible de résoudre l\'ID du module $moduleCode', tag: 'sync');
        }

        // Récupérer les groupes de sites locaux pour ce module
        final localSiteGroups =
            await _sitesRepository.getLocalSiteGroupsByModuleCode(moduleCode);
        _logger.i('Groupes de sites locaux trouvés: ${localSiteGroups.length}',
            tag: 'sync');

        if (localSiteGroups.isEmpty) {
          _logger.i(
              'AUCUN GROUPE DE SITES LOCAL TROUVÉ POUR MODULE $moduleCode - SYNCHRONISATION TERMINÉE\n',
              tag: 'sync');
          return SyncResult.success(
            itemsProcessed: 0,
            itemsAdded: 0,
            itemsUpdated: 0,
            itemsSkipped: 0,
          );
        }

        // Séparer les groupes en nouveaux (POST) et existants
        final newGroups = localSiteGroups
            .where((g) => g.serverSiteGroupId == null)
            .toList();
        final existingGroups = localSiteGroups
            .where((g) => g.serverSiteGroupId != null)
            .toList();

        _logger.i(
            'Répartition des groupes: ${newGroups.length} nouveaux, ${existingGroups.length} existants',
            tag: 'sync');

        // Traiter les nouveaux groupes (POST)
        for (final group in newGroups) {
          try {
            _logger.i(
                'Traitement du nouveau groupe ID: ${group.idSitesGroup} (${group.sitesGroupName})',
                tag: 'sync');

            // POST - Créer un nouveau groupe de sites
            final serverResponse =
                await _globalApi.sendSiteGroup(token, moduleCode, group, moduleId: moduleId);

            final serverId = serverResponse['id'] ?? serverResponse['ID'];
            if (serverId == null) {
              throw Exception(
                  'Réponse du serveur invalide pour le groupe de sites');
            }

            _logger.i(
                'Groupe de sites créé avec succès, ID serveur: $serverId',
                tag: 'sync');
            itemsAdded++;

            // Mettre à jour l'ID serveur du groupe
            await _sitesRepository.updateSiteGroupServerId(
                group.idSitesGroup, serverId);
            _logger.i(
                'ID serveur du groupe enregistré: local=${group.idSitesGroup}, serveur=$serverId',
                tag: 'sync');

            // Mettre à jour les références id_sites_group dans les site complements
            // Les sites locaux qui référencent l'ancien ID local doivent maintenant référencer l'ID serveur
            await _sitesRepository.updateSiteComplementsGroupId(
                group.idSitesGroup, serverId);
            _logger.i(
                'Références id_sites_group mises à jour: ${group.idSitesGroup} -> $serverId',
                tag: 'sync');

            itemsProcessed++;
          } catch (e) {
            _logger.e(
                'Erreur lors de l\'envoi du groupe de sites ${group.idSitesGroup}: $e',
                tag: 'sync',
                error: e);
            errors.add('Groupe ${group.idSitesGroup}: $e');
            itemsSkipped++;
          }
        }

        // Les groupes existants (avec serverSiteGroupId) sont déjà synchronisés
        for (final group in existingGroups) {
          _logger.i(
              'Groupe ${group.idSitesGroup} déjà synchronisé (serverId: ${group.serverSiteGroupId})',
              tag: 'sync');
          itemsProcessed++;
        }

        // Mettre à jour la date de synchronisation
        await updateLastSyncDate('siteGroupsToServer', DateTime.now());

        if (errors.isNotEmpty) {
          String errorMessage =
              'Erreurs lors de la synchronisation des groupes de sites:\n${errors.join('\n')}';

          return SyncResult.failure(
            errorMessage: errorMessage,
            itemsProcessed: itemsProcessed,
            itemsAdded: itemsAdded,
            itemsUpdated: itemsUpdated,
            itemsSkipped: itemsSkipped,
          );
        }

        return SyncResult.success(
          itemsProcessed: itemsProcessed,
          itemsAdded: itemsAdded,
          itemsUpdated: itemsUpdated,
          itemsSkipped: itemsSkipped,
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

  @override
  Future<SyncResult> syncSitesToServer(String token, String moduleCode) async {
    try {
      // Vérifier la connectivité
      final isConnected = await checkConnectivity();
      if (!isConnected) {
        return SyncResult.failure(
          errorMessage: 'Pas de connexion Internet',
        );
      }

      int itemsProcessed = 0;
      int itemsAdded = 0;
      int itemsUpdated = 0;
      int itemsSkipped = 0;
      List<String> errors = [];

      try {
        _logger.i(
            '\n==================================================================',
            tag: 'sync');
        _logger.i(
            '[SYNC_REPO] DÉBUT TÉLÉVERSEMENT SITES - MODULE: $moduleCode',
            tag: 'sync');
        _logger.i(
            '==================================================================',
            tag: 'sync');

        // Récupérer l'ID du module pour l'association via cor_site_module
        final module = await _modulesDatabase.getModuleByCode(moduleCode);
        final moduleId = module?.id;
        if (moduleId != null) {
          _logger.i('Module ID résolu: $moduleId pour $moduleCode', tag: 'sync');
        } else {
          _logger.w('Impossible de résoudre l\'ID du module $moduleCode', tag: 'sync');
        }

        // Récupérer les sites locaux pour ce module
        _logger.i('Appel de getLocalSitesByModuleCode pour module: $moduleCode', tag: 'sync');
        final localSites =
            await _sitesRepository.getLocalSitesByModuleCode(moduleCode);
        _logger.i('Sites locaux trouvés: ${localSites.length}', tag: 'sync');

        // Afficher les détails de chaque site local trouvé
        if (localSites.isNotEmpty) {
          for (final site in localSites) {
            _logger.i(
              'Site local: id=${site.idBaseSite}, nom="${site.baseSiteName}", '
              'isLocal=${site.isLocal}, serverSiteId=${site.serverSiteId}',
              tag: 'sync',
            );
          }
        }

        // Si aucun site local, renvoyer un succès vide
        if (localSites.isEmpty) {
          _logger.i('AUCUN SITE LOCAL TROUVÉ POUR MODULE $moduleCode - SYNCHRONISATION TERMINÉE\n',
              tag: 'sync');
          return SyncResult.success(
            itemsProcessed: 0,
            itemsAdded: 0,
            itemsUpdated: 0,
            itemsSkipped: 0,
          );
        }

        // Séparer les sites en deux groupes : nouveaux (POST) et existants (PATCH)
        final newSites = localSites
            .where((site) => site.serverSiteId == null)
            .toList();
        final existingSites = localSites
            .where((site) => site.serverSiteId != null)
            .toList();

        _logger.i(
            'Répartition des sites: ${newSites.length} nouveaux, ${existingSites.length} existants',
            tag: 'sync');

        // PARTIE 1: Traiter les nouveaux sites (POST)
        for (final site in newSites) {
          try {
            _logger.i(
                'Traitement du nouveau site ID: ${site.idBaseSite} (${site.baseSiteName})',
                tag: 'sync');

            // Récupérer le complément du site pour obtenir types_site et autres données
            final siteComplement = await _sitesRepository.getSiteComplementBySiteId(site.idBaseSite);

            // Fusionner les données du site avec celles du complément
            Map<String, dynamic> mergedData = Map<String, dynamic>.from(site.data ?? {});

            if (siteComplement != null && siteComplement.data != null) {
              try {
                final complementData = jsonDecode(siteComplement.data!) as Map<String, dynamic>;
                _logger.i('Données du complément pour site ${site.idBaseSite}: $complementData', tag: 'sync');

                // Fusionner les données du complément avec celles du site
                // Le complément a priorité sur les données du site
                mergedData.addAll(complementData);
              } catch (e) {
                _logger.w('Erreur lors du parsing des données du complément pour site ${site.idBaseSite}: $e', tag: 'sync');
              }
            }

            // Ajouter id_sites_group si présent dans le complément
            if (siteComplement != null && siteComplement.idSitesGroup != null) {
              mergedData['id_sites_group'] = siteComplement.idSitesGroup;
            }

            // IMPORTANT: Convertir id_nomenclature_type_site en types_site (liste)
            // Le serveur attend types_site comme une liste d'entiers
            if (mergedData.containsKey('id_nomenclature_type_site') && !mergedData.containsKey('types_site')) {
              final typeId = mergedData['id_nomenclature_type_site'];
              if (typeId != null) {
                mergedData['types_site'] = [typeId];
                _logger.i('Conversion id_nomenclature_type_site=$typeId en types_site=[$typeId]', tag: 'sync');
              }
              // Supprimer l'ancien champ pour éviter la confusion
              mergedData.remove('id_nomenclature_type_site');
            }

            // FALLBACK: Si types_site est toujours absent, le récupérer depuis la config du module
            if (!mergedData.containsKey('types_site')) {
              final typesSiteFromConfig = await _getTypesSiteFromModuleConfig(moduleCode);
              if (typesSiteFromConfig != null && typesSiteFromConfig.isNotEmpty) {
                mergedData['types_site'] = typesSiteFromConfig;
                _logger.i('Fallback types_site depuis config module: $typesSiteFromConfig', tag: 'sync');
              } else {
                _logger.w('ATTENTION: types_site absent pour site ${site.idBaseSite} et non trouvé dans la config module', tag: 'sync');
              }
            }

            // Validation pré-sync : vérifier que types_site est présent
            if (!mergedData.containsKey('types_site') || (mergedData['types_site'] is List && (mergedData['types_site'] as List).isEmpty)) {
              errors.add('Site ${site.idBaseSite}: types_site manquant. Veuillez vérifier la configuration du module.');
              itemsSkipped++;
              itemsProcessed++;
              continue;
            }

            _logger.i('Données fusionnées pour site ${site.idBaseSite}: $mergedData', tag: 'sync');

            // Créer un site modifié avec les données fusionnées
            final siteWithComplementData = site.copyWith(data: mergedData);

            // POST - Créer un nouveau site
            final serverResponse =
                await _globalApi.sendSite(token, moduleCode, siteWithComplementData, moduleId: moduleId);

            final serverId = serverResponse['id'] ?? serverResponse['ID'];
            if (serverId == null) {
              throw Exception('Réponse du serveur invalide pour le site');
            }

            _logger.i('Site créé avec succès, ID serveur: $serverId',
                tag: 'sync');
            itemsAdded++;

            // Mettre à jour l'ID serveur pour les futures tentatives de synchronisation
            await _sitesRepository.updateSiteServerId(
                site.idBaseSite, serverId);
            _logger.i(
                'ID serveur du site enregistré: local=${site.idBaseSite}, serveur=$serverId',
                tag: 'sync');

            itemsProcessed++;
          } catch (e) {
            _logger.e(
                'Erreur lors de l\'envoi du site ${site.idBaseSite}: $e',
                tag: 'sync',
                error: e);
            errors.add('Site ${site.idBaseSite}: $e');
            itemsSkipped++;
          }
        }

        // PARTIE 2: Traiter les sites existants (PATCH)
        for (final site in existingSites) {
          try {
            _logger.i(
                'Mise à jour du site ID: ${site.idBaseSite} (serverId: ${site.serverSiteId})',
                tag: 'sync');

            // Récupérer le complément du site pour obtenir types_site et autres données
            final siteComplement = await _sitesRepository.getSiteComplementBySiteId(site.idBaseSite);

            // Fusionner les données du site avec celles du complément
            Map<String, dynamic> mergedData = Map<String, dynamic>.from(site.data ?? {});

            if (siteComplement != null && siteComplement.data != null) {
              try {
                final complementData = jsonDecode(siteComplement.data!) as Map<String, dynamic>;
                _logger.i('Données du complément pour site ${site.idBaseSite}: $complementData', tag: 'sync');

                // Fusionner les données du complément avec celles du site
                mergedData.addAll(complementData);
              } catch (e) {
                _logger.w('Erreur lors du parsing des données du complément pour site ${site.idBaseSite}: $e', tag: 'sync');
              }
            }

            // Ajouter id_sites_group si présent dans le complément
            if (siteComplement != null && siteComplement.idSitesGroup != null) {
              mergedData['id_sites_group'] = siteComplement.idSitesGroup;
            }

            // IMPORTANT: Convertir id_nomenclature_type_site en types_site (liste)
            // Le serveur attend types_site comme une liste d'entiers
            if (mergedData.containsKey('id_nomenclature_type_site') && !mergedData.containsKey('types_site')) {
              final typeId = mergedData['id_nomenclature_type_site'];
              if (typeId != null) {
                mergedData['types_site'] = [typeId];
                _logger.i('Conversion id_nomenclature_type_site=$typeId en types_site=[$typeId]', tag: 'sync');
              }
              // Supprimer l'ancien champ pour éviter la confusion
              mergedData.remove('id_nomenclature_type_site');
            }

            // FALLBACK: Si types_site est toujours absent, le récupérer depuis la config du module
            if (!mergedData.containsKey('types_site')) {
              final typesSiteFromConfig = await _getTypesSiteFromModuleConfig(moduleCode);
              if (typesSiteFromConfig != null && typesSiteFromConfig.isNotEmpty) {
                mergedData['types_site'] = typesSiteFromConfig;
                _logger.i('Fallback types_site depuis config module: $typesSiteFromConfig', tag: 'sync');
              } else {
                _logger.w('ATTENTION: types_site absent pour site ${site.idBaseSite} et non trouvé dans la config module', tag: 'sync');
              }
            }

            // Validation pré-sync : vérifier que types_site est présent
            if (!mergedData.containsKey('types_site') || (mergedData['types_site'] is List && (mergedData['types_site'] as List).isEmpty)) {
              errors.add('Site ${site.idBaseSite}: types_site manquant. Veuillez vérifier la configuration du module.');
              itemsSkipped++;
              itemsProcessed++;
              continue;
            }

            // Créer un site modifié avec les données fusionnées
            final siteWithComplementData = site.copyWith(data: mergedData);

            // PATCH - Mettre à jour un site existant
            await _globalApi.updateSite(
                token, moduleCode, site.serverSiteId!, siteWithComplementData);

            _logger.i(
                'Site mis à jour avec succès, ID serveur: ${site.serverSiteId}',
                tag: 'sync');
            itemsUpdated++;

            itemsProcessed++;
          } catch (e) {
            _logger.e(
                'Erreur lors de la mise à jour du site ${site.idBaseSite}: $e',
                tag: 'sync',
                error: e);
            errors.add('Site ${site.idBaseSite}: $e');
            itemsSkipped++;
          }
        }

        // Mettre à jour la date de synchronisation
        await updateLastSyncDate('sitesToServer', DateTime.now());

        if (errors.isNotEmpty) {
          String errorMessage =
              'Erreurs lors de la synchronisation des sites:\n${errors.join('\n')}';

          return SyncResult.failure(
            errorMessage: errorMessage,
            itemsProcessed: itemsProcessed,
            itemsAdded: itemsAdded,
            itemsUpdated: itemsUpdated,
            itemsSkipped: itemsSkipped,
          );
        }

        return SyncResult.success(
          itemsProcessed: itemsProcessed,
          itemsAdded: itemsAdded,
          itemsUpdated: itemsUpdated,
          itemsSkipped: itemsSkipped,
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

  /// Récupère les types_site depuis la configuration du module
  /// Retourne une liste d'entiers [id_nomenclature_type_site] ou null
  Future<List<int>?> _getTypesSiteFromModuleConfig(String moduleCode) async {
    try {
      final moduleComplement = await _modulesDatabase.getModuleComplementByModuleCode(moduleCode);
      if (moduleComplement == null) {
        _logger.w('Module complement non trouvé pour $moduleCode', tag: 'sync');
        return null;
      }

      final config = moduleComplement.configuration;
      if (config == null) {
        _logger.w('Configuration non trouvée pour module $moduleCode', tag: 'sync');
        return null;
      }

      // Essayer d'abord depuis custom.__MODULE.TYPES_SITE
      final typesSiteList = config.custom?.typesSite;
      if (typesSiteList != null && typesSiteList.isNotEmpty) {
        final ids = typesSiteList
            .where((t) => t.idNomenclatureTypeSite != null)
            .map((t) => t.idNomenclatureTypeSite!)
            .toList();
        if (ids.isNotEmpty) {
          _logger.i('types_site depuis customConfig: $ids', tag: 'sync');
          return ids;
        }
      }

      // Essayer depuis la config site (types_site comme Map<String, TypeSiteConfig>)
      final siteConfig = config.site;
      if (siteConfig != null && siteConfig.typesSite != null && siteConfig.typesSite!.isNotEmpty) {
        final ids = siteConfig.typesSite!.keys
            .map((k) => int.tryParse(k))
            .where((id) => id != null)
            .map((id) => id!)
            .toList();
        if (ids.isNotEmpty) {
          _logger.i('types_site depuis siteConfig: $ids', tag: 'sync');
          return ids;
        }
      }

      // Essayer depuis la config module
      final moduleConfig = config.module;
      if (moduleConfig != null && moduleConfig.typesSite != null && moduleConfig.typesSite!.isNotEmpty) {
        final ids = moduleConfig.typesSite!.keys
            .map((k) => int.tryParse(k))
            .where((id) => id != null)
            .map((id) => id!)
            .toList();
        if (ids.isNotEmpty) {
          _logger.i('types_site depuis moduleConfig: $ids', tag: 'sync');
          return ids;
        }
      }

      return null;
    } catch (e) {
      _logger.w('Erreur lors de la récupération types_site depuis config: $e', tag: 'sync');
      return null;
    }
  }
}
