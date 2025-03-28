import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/domain/domain_module.dart';
import 'package:gn_mobile_monitoring/domain/model/observation_detail.dart';
import 'package:gn_mobile_monitoring/domain/usecase/delete_observation_detail_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_observation_detail_by_id_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_observation_details_by_observation_id_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/save_observation_detail_use_case.dart';

/// Provider pour accéder aux détails d'observation pour une observation spécifique
final observationDetailsProvider = StateNotifierProvider.family<
    ObservationDetailViewModel,
    AsyncValue<List<ObservationDetail>>,
    int>((ref, observationId) {
  final getObservationDetailsByObservationIdUseCase =
      ref.watch(getObservationDetailsByObservationIdUseCaseProvider);
  final getObservationDetailByIdUseCase =
      ref.watch(getObservationDetailByIdUseCaseProvider);
  final saveObservationDetailUseCase =
      ref.watch(saveObservationDetailUseCaseProvider);
  final deleteObservationDetailUseCase =
      ref.watch(deleteObservationDetailUseCaseProvider);

  return ObservationDetailViewModel(
    getObservationDetailsByObservationIdUseCase,
    getObservationDetailByIdUseCase,
    saveObservationDetailUseCase,
    deleteObservationDetailUseCase,
    observationId,
  );
});

final observationDetailViewModelProvider =
    Provider<ObservationDetailViewModel>((ref) {
  return ref.read(observationDetailsProvider(0).notifier);
});

class ObservationDetailViewModel
    extends StateNotifier<AsyncValue<List<ObservationDetail>>> {
  final GetObservationDetailsByObservationIdUseCase
      _getObservationDetailsByObservationIdUseCase;
  final GetObservationDetailByIdUseCase _getObservationDetailByIdUseCase;
  final SaveObservationDetailUseCase _saveObservationDetailUseCase;
  final DeleteObservationDetailUseCase _deleteObservationDetailUseCase;

  final int _observationId;
  bool _mounted = true;

  ObservationDetailViewModel(
    this._getObservationDetailsByObservationIdUseCase,
    this._getObservationDetailByIdUseCase,
    this._saveObservationDetailUseCase,
    this._deleteObservationDetailUseCase,
    this._observationId,
  ) : super(const AsyncValue.loading()) {
    if (_observationId > 0) {
      loadObservationDetails();
    }
  }

  /// Charge tous les détails pour l'observation courante
  Future<void> loadObservationDetails() async {
    if (!_mounted) return;

    try {
      state = const AsyncValue.loading();
      final details = await _getObservationDetailsByObservationIdUseCase
          .execute(_observationId);
      if (_mounted) {
        state = AsyncValue.data(details);
      }
    } catch (e, stack) {
      if (_mounted) {
        state = AsyncValue.error(e, stack);
      }
    }
  }

  /// Récupère tous les détails d'une observation par son ID
  Future<List<ObservationDetail>> getObservationDetailsByObservationId(
      int observationId) async {
    try {
      return await _getObservationDetailsByObservationIdUseCase
          .execute(observationId);
    } catch (e) {
      debugPrint(
          'Erreur lors de la récupération des détails d\'observation: $e');
      return [];
    }
  }

  /// Récupère un détail d'observation par son ID
  Future<ObservationDetail?> getObservationDetailById(int detailId) async {
    try {
      return await _getObservationDetailByIdUseCase.execute(detailId);
    } catch (e) {
      debugPrint('Erreur lors de la récupération du détail d\'observation: $e');
      return null;
    }
  }

  /// Sauvegarde un détail d'observation
  Future<int> saveObservationDetail(ObservationDetail detail) async {
    try {
      final result = await _saveObservationDetailUseCase.execute(detail);
      // Recharger les détails après la sauvegarde
      await loadObservationDetails();
      return result;
    } catch (e) {
      debugPrint('Erreur lors de la sauvegarde du détail d\'observation: $e');
      rethrow;
    }
  }

  /// Supprime un détail d'observation
  Future<bool> deleteObservationDetail(int detailId) async {
    try {
      final success = await _deleteObservationDetailUseCase.execute(detailId);
      if (success) {
        // Recharger les détails après la suppression
        await loadObservationDetails();
      }
      return success;
    } catch (e) {
      debugPrint('Erreur lors de la suppression du détail d\'observation: $e');
      rethrow;
    }
  }

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }
}
