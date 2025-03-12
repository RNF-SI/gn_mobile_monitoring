import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/domain/domain_module.dart';
import 'package:gn_mobile_monitoring/domain/model/base_visit.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_visits_by_site_id_use_case.dart';

final siteVisitsViewModelProvider = StateNotifierProvider.family<
    SiteVisitsViewModel, AsyncValue<List<BaseVisit>>, int>((ref, siteId) {
  final getVisitsBySiteIdUseCase = ref.watch(getVisitsBySiteIdUseCaseProvider);
  return SiteVisitsViewModel(getVisitsBySiteIdUseCase, siteId);
});

class SiteVisitsViewModel extends StateNotifier<AsyncValue<List<BaseVisit>>> {
  final GetVisitsBySiteIdUseCase _getVisitsBySiteIdUseCase;
  final int _siteId;
  bool _mounted = true;

  SiteVisitsViewModel(this._getVisitsBySiteIdUseCase, this._siteId)
      : super(const AsyncValue.loading()) {
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

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }
}
