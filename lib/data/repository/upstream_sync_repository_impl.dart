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
import 'package:gn_mobile_monitoring/domain/repository/upstream_sync_repository.dart';
import 'package:gn_mobile_monitoring/domain/repository/visit_repository.dart';

/// Implémentation du repository de synchronisation ascendante (appareil vers serveur)
class UpstreamSyncRepositoryImpl implements UpstreamSyncRepository {
  final GlobalApi _globalApi;
  final GlobalDatabase _globalDatabase;
  final ModulesDatabase _modulesDatabase;
  final VisitRepository _visitRepository;
  final ObservationsRepository _observationsRepository;
  final ObservationDetailsRepository _observationDetailsRepository;

  final AppLogger _logger = AppLogger();

  /// Nettoie le cache des visites en échec (pour les retentatives)
  /// Cette méthode est appelée au début de chaque synchronisation complète
  static void clearFailedVisitsCache() {
    SyncCacheManager.clearFailedVisitsCache();
  }

  /// Nettoie le cache pour une nouvelle session de synchronisation
  /// Permet de retenter tous les éléments qui avaient échoué précédemment
  static void resetForNewSyncSession() {
    SyncCacheManager.resetForNewSyncSession();
  }

  /// Retire une visite spécifique du cache des échecs
  static void removeFromFailedCache(int visitId) {
    SyncCacheManager.removeFromFailedCache(visitId);
  }

  UpstreamSyncRepositoryImpl(
    this._globalApi,
    this._globalDatabase,
    this._modulesDatabase, {
    required VisitRepository visitRepository,
    required ObservationsRepository observationsRepository,
    required ObservationDetailsRepository observationDetailsRepository,
  })  : _visitRepository = visitRepository,
        _observationsRepository = observationsRepository,
        _observationDetailsRepository = observationDetailsRepository;

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
      // Note: On ne nettoie PAS le cache ici car il doit persister au sein d'une même session de sync
      // Le cache est nettoyé uniquement au début d'une nouvelle synchronisation complète
      
      // Vérifier la connectivité
      final isConnected = await checkConnectivity();
      if (!isConnected) {
        return SyncResult.failure(
          errorMessage: 'Pas de connexion Internet',
        );
      }

      int itemsProcessed = 0;
      int itemsAdded = 0;
      int itemsSkipped = 0;
      int itemsDeleted = 0;
      List<String> errors = [];

      try {
        StringBuffer logBuffer = StringBuffer();
        logBuffer.writeln(
            '\n==================================================================');
        logBuffer.writeln(
            '[SYNC_REPO] DÉBUT SYNCHRONISATION ASCENDANTE - MODULE: $moduleCode');
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

        // Pour chaque visite, envoyer la visite et toutes ses observations
        for (final visitEntity in visits) {
          try {
            // Vérifier si cette visite a déjà échoué récemment
            if (SyncCacheManager.isVisitFailed(visitEntity.idBaseVisit)) {
              _logger.w('Visite ${visitEntity.idBaseVisit} ignorée car déjà en échec récent', tag: 'sync');
              itemsSkipped++;
              continue;
            }

            _logger.i('Traitement de la visite ID: ${visitEntity.idBaseVisit}',
                tag: 'sync');

            // Récupérer tous les détails de la visite
            final visit = await _visitRepository
                .getVisitWithFullDetails(visitEntity.idBaseVisit);


            // 1. Envoyer la visite au serveur
            Map<String, dynamic> serverResponse;
            int? serverId;
            bool isNewVisit = visit.serverVisitId == null;

            try {
              // Convertir l'entité en domaine en utilisant directement le mapper
              BaseVisit visitModel;

              // Prétraitement des observateurs pour éviter les erreurs
              List<int> safeObservers = [];
              if (visit.observers != null) {
                _logger.i(
                    "Prétraitement des observateurs : ${visit.observers!.length} observateurs trouvés",
                    tag: "sync");

                for (var o in visit.observers!) {
                  _logger.i("Observateur déjà au format int: $o", tag: "sync");
                  safeObservers.add(o);
                }

                _logger.i(
                    "Prétraitement terminé: ${safeObservers.length} observateurs valides trouvés",
                    tag: "sync");
              }

              // Créer une nouvelle entité avec des observateurs sécurisés
              final safeEntity = BaseVisitEntity(
                idBaseVisit: visit.idBaseVisit,
                idBaseSite: visit.idBaseSite,
                idDataset: visit.idDataset,
                idModule: visit.idModule,
                idDigitiser: visit.idDigitiser,
                visitDateMin: visit.visitDateMin,
                visitDateMax: visit.visitDateMax,
                idNomenclatureTechCollectCampanule:
                    visit.idNomenclatureTechCollectCampanule,
                idNomenclatureGrpTyp: visit.idNomenclatureGrpTyp,
                comments: visit.comments,
                uuidBaseVisit: visit.uuidBaseVisit,
                metaCreateDate: visit.metaCreateDate,
                metaUpdateDate: visit.metaUpdateDate,
                observers: safeObservers,
                data: visit.data,
              );

              // Convertir l'entité sécurisée en modèle de domaine
              visitModel = safeEntity.toDomain();

              if (isNewVisit) {
                // POST - Créer une nouvelle visite
                _logger.i('Création d\'une nouvelle visite sur le serveur',
                    tag: 'sync');
                
                // Récupérer le vrai code du module depuis l'ID module de la visite
                final realModuleCode = await _modulesDatabase.getModuleCodeFromIdModule(visit.idModule);
                if (realModuleCode == null) {
                  throw Exception('Code de module introuvable pour l\'ID module: ${visit.idModule}');
                }
                
                serverResponse =
                    await _globalApi.sendVisit(token, realModuleCode, visitModel);

                serverId = serverResponse['id'] ?? serverResponse['ID'];
                if (serverId == null) {
                  throw Exception('Réponse du serveur invalide pour la visite');
                }

                _logger.i('Visite créée avec succès, ID serveur: $serverId',
                    tag: 'sync');
                itemsAdded++;

                // Mettre à jour l'ID serveur pour les futures tentatives de synchronisation
                await _visitRepository.updateVisitServerId(
                    visitEntity.idBaseVisit, serverId);
                _logger.i(
                    'ID serveur de la visite enregistré: local=${visitEntity.idBaseVisit}, serveur=$serverId',
                    tag: 'sync');
              } else {
                // PATCH - Mettre à jour une visite existante
                serverId = visit.serverVisitId!;
                _logger.i(
                    'Mise à jour d\'une visite existante sur le serveur, ID serveur: $serverId',
                    tag: 'sync');

                // Récupérer le vrai code du module depuis l'ID module de la visite
                final realModuleCode = await _modulesDatabase.getModuleCodeFromIdModule(visit.idModule);
                if (realModuleCode == null) {
                  throw Exception('Code de module introuvable pour l\'ID module: ${visit.idModule}');
                }

                serverResponse = await _globalApi.updateVisit(
                    token, realModuleCode, serverId, visitModel);

                _logger.i(
                    'Visite mise à jour avec succès, ID serveur: $serverId',
                    tag: 'sync');
                // Pour les mises à jour, on ne compte pas comme "ajouté" mais comme traité
              }
            } catch (e) {
              _logger.e('Erreur lors de l\'envoi de la visite: $e',
                  tag: 'sync', error: e);
              
              // Extraire des informations plus détaillées de l'erreur
              String detailedError = SyncErrorHandler.extractDetailedError(e, 'visite', visitEntity.idBaseVisit);
              errors.add(detailedError);
              
              // Incrémenter le compteur d'échecs pour cette visite
              int failureCount = SyncCacheManager.incrementVisitFailureCount(visitEntity.idBaseVisit);
              
              // Analyser l'erreur pour déterminer si elle est fatale
              bool isFatal = SyncErrorHandler.isFatalError(e);
              _logger.w('Analyse erreur visite ${visitEntity.idBaseVisit}: tentative=$failureCount, isFatal=$isFatal, errorType=${e.runtimeType}, message=${e.toString().length > 200 ? e.toString().substring(0, 200) + "..." : e.toString()}', tag: 'sync');
              
              // Marquer comme échoué pour cette session de synchronisation uniquement
              _logger.e('Erreur détectée pour la visite ${visitEntity.idBaseVisit} (tentative $failureCount). Marquage comme échoué pour cette session.', tag: 'sync');
              SyncCacheManager.markVisitAsFailed(visitEntity.idBaseVisit);
              errors.add('ERREUR - Visite ${visitEntity.idBaseVisit}: ${SyncErrorHandler.extractDetailedError(e, 'visite', visitEntity.idBaseVisit)}. Visite ignorée pour le reste de cette synchronisation, sera retentée lors de la prochaine synchronisation.');
              itemsSkipped++;
              continue; // Passer à la visite suivante
            }

            // 2. Récupérer et envoyer toutes les observations associées à cette visite
            // Utiliser l'ID serveur retourné par la création/mise à jour de la visite

            // Récupérer le vrai code du module pour les observations aussi
            final realModuleCode = await _modulesDatabase.getModuleCodeFromIdModule(visit.idModule);
            if (realModuleCode == null) {
              throw Exception('Code de module introuvable pour l\'ID module: ${visit.idModule}');
            }

            // On passe à la fois l'ID local (pour récupérer les observations localement)
            // et l'ID serveur (pour les envoyer avec le bon ID de visite serveur)
            final observationsResult = await syncObservationsToServer(
                token, realModuleCode, visitEntity.idBaseVisit,
                serverVisitId: serverId);

            // 3. Gérer le résultat de la synchronisation des observations
            if (observationsResult.success) {
              // Si tout a réussi, supprimer la visite localement
              await _visitRepository.deleteVisit(visitEntity.idBaseVisit);
              itemsDeleted++;
              _logger.i('Visite et observations supprimées avec succès',
                  tag: 'sync');
            } else {
              // Si les observations ont échoué, ne pas supprimer la visite
              // mais loguer l'erreur pour permettre une nouvelle tentative
              _logger.w(
                  'Visite ${visitEntity.idBaseVisit} créée sur le serveur (ID: $serverId) mais observations échouées',
                  tag: 'sync');

              if (observationsResult.errorMessage != null) {
                _logger.e(
                    'Observations de la visite ${visitEntity.idBaseVisit}: ${observationsResult.errorMessage}',
                    tag: 'sync');
                errors.add(
                    'Observations de la visite ${visitEntity.idBaseVisit}: ${observationsResult.errorMessage}');
              }

              // Marquer la visite comme partiellement synchronisée
              // En gardant l'ID serveur pour les futures tentatives de synchronisation
              itemsSkipped++;
            }

            itemsProcessed++;
          } catch (e) {
            _logger.e(
                'Erreur lors du traitement de la visite ${visitEntity.idBaseVisit}: $e',
                tag: 'sync',
                error: e);
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
            itemsUpdated: 0, // Pas de mise à jour, seulement ajout/suppression
            itemsSkipped: itemsSkipped,
            itemsDeleted: itemsDeleted,
          );
        }

        return SyncResult.success(
          itemsProcessed: itemsProcessed,
          itemsAdded: itemsAdded,
          itemsUpdated: 0,
          itemsSkipped: itemsSkipped,
          itemsDeleted: itemsDeleted,
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
            // Vérifier si cette observation a déjà échoué récemment
            if (SyncCacheManager.isObservationFailed(observation.idObservation)) {
              _logger.w('Observation ${observation.idObservation} ignorée car déjà en échec récent', tag: 'sync');
              itemsSkipped++;
              continue;
            }

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
                    'Création d\'une nouvelle observation avec ID visite serveur = $effectiveVisitId',
                    tag: 'sync');
                serverResponse = await _globalApi.sendObservation(
                    token, moduleCode, observationWithServerVisitId);

                serverId = serverResponse['id'] ?? serverResponse['ID'];
                if (serverId == null) {
                  throw Exception(
                      'Réponse du serveur invalide pour l\'observation');
                }

                // Mettre à jour l'ID serveur pour les futures tentatives de synchronisation
                await _observationsRepository.updateObservationServerId(
                    observation.idObservation, serverId);
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
                // Pour les mises à jour, on ne compte pas comme "ajouté" mais comme traité
              }
            } catch (e) {
              debugPrint('Erreur lors de l\'envoi de l\'observation: $e');
              
              // Extraire des informations plus détaillées de l'erreur
              String detailedError = SyncErrorHandler.extractDetailedError(e, 'observation', observation.idObservation);
              errors.add(detailedError);
              
              // Incrémenter le compteur d'échecs pour cette observation
              int failureCount = SyncCacheManager.incrementObservationFailureCount(observation.idObservation);
              
              // Analyser l'erreur pour déterminer si elle est fatale
              bool isFatal = SyncErrorHandler.isFatalError(e);
              _logger.w('Analyse erreur observation ${observation.idObservation}: tentative=$failureCount, isFatal=$isFatal, errorType=${e.runtimeType}', tag: 'sync');
              
              // Marquer comme échoué pour cette session de synchronisation uniquement
              _logger.e('Erreur détectée pour l\'observation ${observation.idObservation} (tentative $failureCount). Marquage comme échoué pour cette session.', tag: 'sync');
              SyncCacheManager.markObservationAsFailed(observation.idObservation);
              errors.add('ERREUR - Observation ${observation.idObservation}: ${SyncErrorHandler.extractDetailedError(e, 'observation', observation.idObservation)}. Observation ignorée pour le reste de cette synchronisation, sera retentée lors de la prochaine synchronisation.');
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

            // En cas d'erreur avec les détails, l'ajouter à la liste d'erreurs
            if (!detailsResult.success && detailsResult.errorMessage != null) {
              errors.add(
                  'Détails de l\'observation ${observation.idObservation}: ${detailsResult.errorMessage}');
              itemsSkipped++;
              continue; // Passer à l'observation suivante sans la supprimer
            }

            // 3. Si cette observation spécifique a réussi, la supprimer localement
            await _observationsRepository
                .deleteObservation(observation.idObservation);
            itemsDeleted++;
            debugPrint(
                'Observation ${observation.idObservation} supprimée avec succès');

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
            itemsUpdated: 0,
            itemsSkipped: itemsSkipped,
            itemsDeleted: itemsDeleted,
          );
        }

        return SyncResult.success(
          itemsProcessed: itemsProcessed,
          itemsAdded: itemsAdded,
          itemsUpdated: 0,
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
                  itemsUpdated: 0,
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
            itemsUpdated: 0,
            itemsSkipped: itemsSkipped,
            itemsDeleted: itemsDeleted,
          );
        }

        _logger.i(
            'Synchronisation des détails d\'observation réussie: $itemsProcessed traités, $itemsAdded ajoutés',
            tag: 'sync');
        return SyncResult.success(
          itemsProcessed: itemsProcessed,
          itemsAdded: itemsAdded,
          itemsUpdated: 0,
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

}
