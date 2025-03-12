import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/domain/model/base_visit.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_visits_by_site_id_use_case.dart';
import 'package:gn_mobile_monitoring/domain/domain_module.dart';

final siteVisitsViewModelProvider = StateNotifierProvider.family<
    SiteVisitsViewModel, AsyncValue<List<BaseVisit>>, int>((ref, siteId) {
  final getVisitsBySiteIdUseCase = ref.watch(getVisitsBySiteIdUseCaseProvider);
  return SiteVisitsViewModel(getVisitsBySiteIdUseCase, siteId);
});

class SiteVisitsViewModel extends StateNotifier<AsyncValue<List<BaseVisit>>> {
  final GetVisitsBySiteIdUseCase _getVisitsBySiteIdUseCase;
  final int _siteId;

  SiteVisitsViewModel(this._getVisitsBySiteIdUseCase, this._siteId)
      : super(const AsyncValue.loading()) {
    loadVisits();
  }

  Future<void> loadVisits() async {
    try {
      state = const AsyncValue.loading();
      final visits = await _getVisitsBySiteIdUseCase.execute(_siteId);
      if (mounted) {
        state = AsyncValue.data(visits);
      }
    } catch (e, stack) {
      if (mounted) {
        state = AsyncValue.error(e, stack);
      }
    }
  }

  bool get mounted => !state.isLoading;
}