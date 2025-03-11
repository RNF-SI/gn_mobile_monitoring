import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/domain/domain_module.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_sites_use_case.dart';
import 'package:gn_mobile_monitoring/presentation/state/state.dart'
    as custom_async_state;

// Provider pour la requête de recherche
final searchQueryProvider = StateProvider<String>((ref) => '');

// Provider pour les sites filtrés
final filteredSitesProvider = Provider<List<BaseSite>>((ref) {
  final userSitesState = ref.watch(userSitesViewModelStateNotifierProvider);
  final searchQuery = ref.watch(searchQueryProvider);
  
  return userSitesState.when(
    init: () => [],
    success: (sites) {
      if (searchQuery.isEmpty) {
        return sites;
      }
      return sites.where((site) {
        final siteName = site.baseSiteName?.toLowerCase() ?? '';
        final siteDescription = site.baseSiteDescription?.toLowerCase() ?? '';
        final siteCode = site.baseSiteCode?.toLowerCase() ?? '';
        final query = searchQuery.toLowerCase();
        
        return siteName.contains(query) || 
               siteDescription.contains(query) || 
               siteCode.contains(query);
      }).toList();
    },
    loading: () => [],
    error: (_) => [],
  );
});

final userSitesProvider =
    Provider.autoDispose<custom_async_state.State<List<BaseSite>>>((ref) {
  final userSitesState = ref.watch(userSitesViewModelStateNotifierProvider);

  return userSitesState.when(
    init: () => const custom_async_state.State.init(),
    success: (data) => custom_async_state.State.success(data),
    loading: () => const custom_async_state.State.loading(),
    error: (e) => custom_async_state.State.error(e),
  );
});

final userSitesViewModelStateNotifierProvider =
    StateNotifierProvider.autoDispose<UserSitesViewModel,
        custom_async_state.State<List<BaseSite>>>((ref) {
  return UserSitesViewModel(
    const AsyncValue<List<BaseSite>>.data([]),
    ref.watch(getSitesUseCaseProvider),
  );
});

class UserSitesViewModel
    extends StateNotifier<custom_async_state.State<List<BaseSite>>> {
  final GetSitesUseCase _getSitesUseCase;

  UserSitesViewModel(
    AsyncValue<List<BaseSite>> initialSites,
    this._getSitesUseCase,
  ) : super(const custom_async_state.State.init()) {
    loadSites();
  }

  Future<void> loadSites() async {
    try {
      state = const custom_async_state.State.loading();
      final sites = await _getSitesUseCase.execute();
      state = custom_async_state.State.success(sites);
    } catch (e) {
      state = custom_async_state.State.error(Exception("Failed to load sites"));
    }
  }
}
