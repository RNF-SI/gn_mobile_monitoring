import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/core/helpers/format_datetime.dart';
import 'package:gn_mobile_monitoring/domain/domain_module.dart';
import 'package:gn_mobile_monitoring/domain/model/observation.dart';
import 'package:gn_mobile_monitoring/domain/usecase/create_observation_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/delete_observation_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_observation_by_id_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_observations_by_visit_id_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/update_observation_use_case.dart';

/// Provider pour accéder aux observations pour une visite spécifique
final observationsProvider = StateNotifierProvider.family<ObservationsViewModel,
    AsyncValue<List<Observation>>, int>((ref, visitId) {
  final getObservationsByVisitIdUseCase =
      ref.watch(getObservationsByVisitIdUseCaseProvider);
  final createObservationUseCase = ref.watch(createObservationUseCaseProvider);
  final updateObservationUseCase = ref.watch(updateObservationUseCaseProvider);
  final deleteObservationUseCase = ref.watch(deleteObservationUseCaseProvider);
  final getObservationByIdUseCase =
      ref.watch(getObservationByIdUseCaseProvider);

  return ObservationsViewModel(
    getObservationsByVisitIdUseCase,
    createObservationUseCase,
    updateObservationUseCase,
    deleteObservationUseCase,
    getObservationByIdUseCase,
    visitId,
  );
});

final observationsViewModelProvider = Provider<ObservationsViewModel>((ref) {
  // On utilise un ID de visite par défaut pour le provider
  // Cela permet de l'utiliser sans ID de visite spécifique dans certains cas
  return ref.read(observationsProvider(0).notifier);
});

class ObservationsViewModel
    extends StateNotifier<AsyncValue<List<Observation>>> {
  final GetObservationsByVisitIdUseCase _getObservationsByVisitIdUseCase;
  final CreateObservationUseCase _createObservationUseCase;
  final UpdateObservationUseCase _updateObservationUseCase;
  final DeleteObservationUseCase _deleteObservationUseCase;
  final GetObservationByIdUseCase _getObservationByIdUseCase;

  final int _visitId;
  bool _mounted = true;

  ObservationsViewModel(
    this._getObservationsByVisitIdUseCase,
    this._createObservationUseCase,
    this._updateObservationUseCase,
    this._deleteObservationUseCase,
    this._getObservationByIdUseCase,
    this._visitId,
  ) : super(const AsyncValue.loading()) {
    if (_visitId > 0) {
      loadObservations();
    }
  }

  /// Charge toutes les observations pour la visite courante
  Future<void> loadObservations() async {
    if (!_mounted) return;

    try {
      state = const AsyncValue.loading();
      final observations =
          await _getObservationsByVisitIdUseCase.execute(_visitId);
      if (_mounted) {
        state = AsyncValue.data(observations);
      }
    } catch (e, stack) {
      if (_mounted) {
        state = AsyncValue.error(e, stack);
      }
    }
  }

  /// Récupère toutes les observations associées à une visite
  Future<List<Observation>> getObservationsByVisitId() async {
    try {
      return await _getObservationsByVisitIdUseCase.execute(_visitId);
    } catch (e) {
      debugPrint('Erreur lors du chargement des observations: $e');
      return [];
    }
  }

  /// Crée une nouvelle observation
  Future<int> createObservation(Map<String, dynamic> formData) async {
    try {
      // Préparer l'objet Observation à partir des données du formulaire
      final observation = Observation(
        idObservation: 0, // Nouvel ID généré par la BDD
        idBaseVisit: _visitId,
        cdNom: formData['cd_nom'] is int ? formData['cd_nom'] : null,
        comments: formData['comments']?.toString(),
        data: _extractObservationSpecificData(formData),
      );

      final newObservationId =
          await _createObservationUseCase.execute(observation);

      // Recharger la liste des observations
      await loadObservations();

      return newObservationId;
    } catch (e) {
      debugPrint('Erreur lors de la création de l\'observation: $e');
      rethrow;
    }
  }

  /// Met à jour une observation existante
  Future<bool> updateObservation(
      Map<String, dynamic> formData, int observationId) async {
    try {
      // Récupérer l'observation existante
      final observations =
          await _getObservationsByVisitIdUseCase.execute(_visitId);
      final existingObservation = observations.firstWhere(
        (o) => o.idObservation == observationId,
        orElse: () => throw Exception('Observation not found'),
      );

      // Créer une nouvelle observation avec les données mises à jour
      final updatedObservation = Observation(
        idObservation: observationId,
        idBaseVisit: _visitId,
        cdNom: formData['cd_nom'] is int
            ? formData['cd_nom']
            : existingObservation.cdNom,
        comments:
            formData['comments']?.toString() ?? existingObservation.comments,
        uuidObservation: existingObservation.uuidObservation,
        metaCreateDate: existingObservation.metaCreateDate,
        metaUpdateDate: DateTime.now().toIso8601String(),
        data: _extractObservationSpecificData(formData),
      );

      final success =
          await _updateObservationUseCase.execute(updatedObservation);

      // Recharger la liste des observations si la mise à jour a réussi
      if (success) {
        await loadObservations();
      }

      return success;
    } catch (e) {
      debugPrint('Erreur lors de la mise à jour de l\'observation: $e');
      rethrow;
    }
  }

  /// Supprime une observation
  Future<bool> deleteObservation(int observationId) async {
    try {
      final success = await _deleteObservationUseCase.execute(observationId);

      // Recharger la liste des observations si la suppression a réussi
      if (success) {
        await loadObservations();
      }

      return success;
    } catch (e) {
      debugPrint('Erreur lors de la suppression de l\'observation: $e');
      rethrow;
    }
  }

  /// Extrait les données spécifiques à l'observation en excluant les champs standard
  Map<String, dynamic> _extractObservationSpecificData(
      Map<String, dynamic> formData) {
    // Liste des champs standard à exclure
    const standardFields = {
      'id_observation',
      'id_base_visit',
      'cd_nom',
      'comments',
      'uuid_observation',
    };

    // Créer un nouveau Map avec uniquement les données spécifiques
    final Map<String, dynamic> specificData = {};

    formData.forEach((key, value) {
      if (!standardFields.contains(key) && value != null) {
        // Conversion des types si nécessaire
        if (value is String && double.tryParse(value) != null) {
          if (double.parse(value) % 1 == 0) {
            specificData[key] = int.parse(value);
          } else {
            specificData[key] = double.parse(value);
          }
        } else if (value is DateTime) {
          specificData[key] = value.toIso8601String();
        } else if (key.toLowerCase().contains('time') &&
            !key.toLowerCase().contains('date') &&
            value is String) {
          specificData[key] = normalizeTimeFormat(value);
        } else {
          specificData[key] = value;
        }
      }
    });

    return specificData;
  }

  /// Récupère une observation par son ID
  Future<Observation> getObservationById(int observationId) async {
    try {
      final observation =
          await _getObservationByIdUseCase.execute(observationId);
      if (observation == null) {
        throw Exception('Observation not found');
      }
      return observation;
    } catch (e) {
      throw Exception('Failed to get observation: $e');
    }
  }

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }
}
