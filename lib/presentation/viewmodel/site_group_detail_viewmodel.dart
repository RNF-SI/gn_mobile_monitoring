import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/domain/domain_module.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_sites_by_site_group_usecase.dart';

// Provider pour le ViewModel qui gère les sites d'un groupe de sites
final siteGroupDetailViewModelProvider = StateNotifierProvider.family<
    SiteGroupDetailViewModel, AsyncValue<List<BaseSite>>, SiteGroup>(
  (ref, siteGroup) => SiteGroupDetailViewModel(
    ref.watch(getSitesBySiteGroupUseCaseProvider),
    siteGroup,
  )..loadSites(),
);

/// ViewModel responsible for managing sites associated with a site group
class SiteGroupDetailViewModel extends StateNotifier<AsyncValue<List<BaseSite>>> {
  final GetSitesBySiteGroupUseCase _getSitesBySiteGroupUseCase;
  final SiteGroup _siteGroup;

  SiteGroupDetailViewModel(this._getSitesBySiteGroupUseCase, this._siteGroup)
      : super(const AsyncValue.loading());

  /// Loads sites associated with the site group
  Future<void> loadSites() async {
    try {
      state = const AsyncValue.loading();
      final sites = await _getSitesBySiteGroupUseCase.execute(_siteGroup.idSitesGroup);
      state = AsyncValue.data(sites);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}