import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/domain/domain_module.dart';
import 'package:gn_mobile_monitoring/domain/model/base_visit.dart';
import 'package:gn_mobile_monitoring/domain/usecase/create_visit_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/delete_visit_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_visits_by_site_id_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/update_visit_use_case.dart';

final siteVisitsViewModelProvider = StateNotifierProvider.family<
    SiteVisitsViewModel, AsyncValue<List<BaseVisit>>, int>((ref, siteId) {
  final getVisitsBySiteIdUseCase = ref.watch(getVisitsBySiteIdUseCaseProvider);
  final createVisitUseCase = ref.watch(createVisitUseCaseProvider);
  final updateVisitUseCase = ref.watch(updateVisitUseCaseProvider);
  final deleteVisitUseCase = ref.watch(deleteVisitUseCaseProvider);
  
  return SiteVisitsViewModel(
    getVisitsBySiteIdUseCase,
    createVisitUseCase,
    updateVisitUseCase,
    deleteVisitUseCase,
    siteId,
  );
});

class SiteVisitsViewModel extends StateNotifier<AsyncValue<List<BaseVisit>>> {
  final GetVisitsBySiteIdUseCase _getVisitsBySiteIdUseCase;
  final CreateVisitUseCase _createVisitUseCase;
  final UpdateVisitUseCase _updateVisitUseCase;
  final DeleteVisitUseCase _deleteVisitUseCase;
  final int _siteId;
  bool _mounted = true;

  SiteVisitsViewModel(
    this._getVisitsBySiteIdUseCase,
    this._createVisitUseCase,
    this._updateVisitUseCase,
    this._deleteVisitUseCase,
    this._siteId,
  ) : super(const AsyncValue.loading()) {
    loadVisits();
  }

  Future<void> loadVisits() async {
    if (!_mounted) return;

    try {
      state = const AsyncValue.loading();
      final visits = await _getVisitsBySiteIdUseCase.execute(_siteId);
      if (_mounted) {
        state = AsyncValue.data(visits);
      }
    } catch (e, stack) {
      if (_mounted) {
        state = AsyncValue.error(e, stack);
      }
    }
  }

  /// Sauvegarde une nouvelle visite dans la base de données
  /// Retourne l'ID de la visite créée
  Future<int> saveVisit(BaseVisit visit) async {
    try {
      final visitId = await _createVisitUseCase.execute(visit);
      await loadVisits(); // Recharger la liste des visites
      return visitId;
    } catch (e, stack) {
      debugPrint('Erreur lors de la sauvegarde de la visite: $e');
      rethrow;
    }
  }

  /// Met à jour une visite existante dans la base de données
  Future<bool> updateVisit(BaseVisit visit) async {
    try {
      final success = await _updateVisitUseCase.execute(visit);
      if (success) {
        await loadVisits(); // Recharger la liste des visites
      }
      return success;
    } catch (e) {
      debugPrint('Erreur lors de la mise à jour de la visite: $e');
      rethrow;
    }
  }

  /// Supprime une visite de la base de données
  Future<bool> deleteVisit(int visitId) async {
    try {
      final success = await _deleteVisitUseCase.execute(visitId);
      if (success) {
        await loadVisits(); // Recharger la liste des visites
      }
      return success;
    } catch (e) {
      debugPrint('Erreur lors de la suppression de la visite: $e');
      rethrow;
    }
  }

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }
}
