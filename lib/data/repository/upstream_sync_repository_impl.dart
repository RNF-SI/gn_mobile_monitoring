import 'package:flutter/foundation.dart';
import 'package:gn_mobile_monitoring/core/errors/app_logger.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/api/global_api.dart';
import 'package:gn_mobile_monitoring/data/datasource/interface/database/global_database.dart';
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
  final VisitRepository _visitRepository;
  final ObservationsRepository _observationsRepository;
  final ObservationDetailsRepository _observationDetailsRepository;

  final AppLogger _logger = AppLogger();

  UpstreamSyncRepositoryImpl(
    this._globalApi,
    this._globalDatabase, {
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

        // Récupérer toutes les visites
        final visits = await _visitRepository.getAllVisits();
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
            _logger.i('Traitement de la visite ID: ${visitEntity.idBaseVisit}',
                tag: 'sync');

            // Récupérer tous les détails de la visite
            final visit = await _visitRepository
                .getVisitWithFullDetails(visitEntity.idBaseVisit);

            // 1. Envoyer la visite au serveur
            Map<String, dynamic> serverResponse;
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

              serverResponse =
                  await _globalApi.sendVisit(token, moduleCode, visitModel);

              final serverId = serverResponse['id'] ?? serverResponse['ID'];
              if (serverId == null) {
                throw Exception('Réponse du serveur invalide pour la visite');
              }

              _logger.i('Visite envoyée avec succès, ID serveur: $serverId',
                  tag: 'sync');
              itemsAdded++;
            } catch (e) {
              _logger.e('Erreur lors de l\'envoi de la visite: $e',
                  tag: 'sync', error: e);
              errors.add('Visite ${visitEntity.idBaseVisit}: $e');
              itemsSkipped++;
              continue; // Passer à la visite suivante
            }

            // 2. Récupérer et envoyer toutes les observations associées à cette visite
            // Utiliser l'ID serveur retourné par la création de la visite plutôt que l'ID local
            final serverVisitId =
                serverResponse['id'] ?? serverResponse['ID'] ?? 0;
            if (serverVisitId == 0) {
              throw Exception(
                  'ID serveur de la visite non trouvé dans la réponse');
            }

            // On passe à la fois l'ID local (pour récupérer les observations localement)
            // et l'ID serveur (pour les envoyer avec le bon ID de visite serveur)
            final observationsResult = await syncObservationsToServer(
                token, moduleCode, visitEntity.idBaseVisit,
                serverVisitId: serverVisitId);

            // 3. Si tout a réussi, supprimer la visite localement
            if (observationsResult.success && errors.isEmpty) {
              await _visitRepository.deleteVisit(visitEntity.idBaseVisit);
              itemsDeleted++;
              _logger.i('Visite et observations supprimées avec succès',
                  tag: 'sync');
            } else {
              // Ajouter les erreurs des observations à la liste d'erreurs
              if (observationsResult.errorMessage != null) {
                _logger.e(
                    'Observations de la visite ${visitEntity.idBaseVisit}: ${observationsResult.errorMessage}',
                    tag: 'sync');
                errors.add(
                    'Observations de la visite ${visitEntity.idBaseVisit}: ${observationsResult.errorMessage}');
              }
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
          return SyncResult.failure(
            errorMessage:
                'Erreurs lors de la synchronisation des visites:\n${errors.join('\n')}',
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
            debugPrint(
                'Traitement de l\'observation ID: ${observation.idObservation}');

            // 1. Envoyer l'observation au serveur avec l'ID de visite serveur
            Map<String, dynamic> serverResponse;
            try {
              // Créer une version modifiée de l'observation avec l'ID de visite serveur
              // Utiliser copyWith de freezed au lieu du constructeur direct
              final observationWithServerVisitId = observation.copyWith(
                idBaseVisit: effectiveVisitId, // Utiliser l'ID serveur ici!
              );

              _logger.i(
                  'Envoi de l\'observation avec ID visite serveur = $effectiveVisitId',
                  tag: 'sync');
              serverResponse = await _globalApi.sendObservation(
                  token, moduleCode, observationWithServerVisitId);

              final serverId = serverResponse['id'] ?? serverResponse['ID'];
              if (serverId == null) {
                throw Exception(
                    'Réponse du serveur invalide pour l\'observation');
              }

              debugPrint(
                  'Observation envoyée avec succès, ID serveur: $serverId');
              itemsAdded++;
            } catch (e) {
              debugPrint('Erreur lors de l\'envoi de l\'observation: $e');
              errors.add('Observation ${observation.idObservation}: $e');
              itemsSkipped++;
              continue; // Passer à l'observation suivante
            }

            // 2. Récupérer et envoyer tous les détails associés à cette observation
            if (observation.idObservation != null) {
              // Récupérer l'ID serveur de l'observation depuis la réponse
              final serverObservationId =
                  serverResponse['id'] ?? serverResponse['ID'];
              if (serverObservationId == null) {
                throw Exception(
                    'ID serveur de l\'observation non trouvé dans la réponse');
              }

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
              if (!detailsResult.success &&
                  detailsResult.errorMessage != null) {
                errors.add(
                    'Détails de l\'observation ${observation.idObservation}: ${detailsResult.errorMessage}');
                itemsSkipped++;
                continue;
              }
            }

            // 3. Si tout a réussi, supprimer l'observation localement
            if (errors.isEmpty && observation.idObservation != null) {
              await _observationsRepository
                  .deleteObservation(observation.idObservation);
              itemsDeleted++;
              debugPrint('Observation supprimée avec succès');
            }

            itemsProcessed++;
          } catch (e) {
            debugPrint(
                'Erreur lors du traitement de l\'observation ${observation.idObservation}: $e');
            errors.add('Observation ${observation.idObservation}: $e');
            itemsSkipped++;
          }
        }

        if (errors.isNotEmpty) {
          return SyncResult.failure(
            errorMessage:
                'Erreurs lors de la synchronisation des observations:\n${errors.join('\n')}',
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
              errors.add('Détail ${detail.idObservationDetail}: $e');
              itemsSkipped++;
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
          return SyncResult.failure(
            errorMessage:
                'Erreurs lors de la synchronisation des détails d\'observation:\n${errors.join('\n')}',
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
