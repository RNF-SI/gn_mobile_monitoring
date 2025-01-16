import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/domain/domain_module.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_site_groups_usecase.dart';
import 'package:gn_mobile_monitoring/presentation/state/state.dart'
    as custom_async_state;

final siteGroupListProvider =
    Provider.autoDispose<custom_async_state.State<List<SiteGroup>>>((ref) {
  final siteGroupListState = ref.watch(siteGroupViewModelStateNotifierProvider);

  return siteGroupListState.when(
    init: () => const custom_async_state.State.init(),
    success: (siteGroupList) {
      return custom_async_state.State.success(siteGroupList);
    },
    loading: () => const custom_async_state.State.loading(),
    error: (exception) => custom_async_state.State.error(exception),
  );
});

final siteGroupViewModelStateNotifierProvider =
    StateNotifierProvider.autoDispose<SiteGroupsViewModel,
        custom_async_state.State<List<SiteGroup>>>((ref) {
  return SiteGroupsViewModel(
    const AsyncValue<List<SiteGroup>>.data([]),
    ref.watch(getSiteGroupsUseCaseProvider),
  );
});

class SiteGroupsViewModel
    extends StateNotifier<custom_async_state.State<List<SiteGroup>>> {
  final GetSiteGroupsUseCase _getSiteGroupsUseCase;

  SiteGroupsViewModel(
    AsyncValue<List<SiteGroup>> siteGroupList,
    this._getSiteGroupsUseCase,
  ) : super(const custom_async_state.State.init()) {
    _loadSiteGroups();
  }

  Future<void> refreshSiteGroups() async {
    await _loadSiteGroups();
  }

  Future<void> _loadSiteGroups() async {
    try {
      state = const custom_async_state.State.loading();
      final siteGroups = await _getSiteGroupsUseCase.execute();
      state = custom_async_state.State.success(siteGroups);
    } catch (e) {
      state = custom_async_state.State.error(
          Exception("Failed to load site groups"));
    }
  }
}
