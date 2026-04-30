import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/domain/domain_module.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_sites_by_site_group_and_module_usecase.dart';

/// Clé de la family: groupe de sites + module courant (filtre cor_site_module).
class SiteGroupDetailArgs {
  final SiteGroup siteGroup;
  final int moduleId;

  const SiteGroupDetailArgs(this.siteGroup, this.moduleId);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SiteGroupDetailArgs &&
          other.siteGroup.idSitesGroup == siteGroup.idSitesGroup &&
          other.moduleId == moduleId;

  @override
  int get hashCode => Object.hash(siteGroup.idSitesGroup, moduleId);
}

// Provider pour le ViewModel qui gère les sites d'un groupe filtrés par module
final siteGroupDetailViewModelProvider = StateNotifierProvider.family<
    SiteGroupDetailViewModel,
    AsyncValue<List<BaseSite>>,
    SiteGroupDetailArgs>(
  (ref, args) => SiteGroupDetailViewModel(
    ref.watch(getSitesBySiteGroupAndModuleUseCaseProvider),
    args.siteGroup,
    args.moduleId,
  )..loadSites(),
);

/// ViewModel responsible for managing sites associated with a site group
/// within the context of a given module.
class SiteGroupDetailViewModel extends StateNotifier<AsyncValue<List<BaseSite>>> {
  final GetSitesBySiteGroupAndModuleUseCase _useCase;
  final SiteGroup _siteGroup;
  final int _moduleId;

  SiteGroupDetailViewModel(this._useCase, this._siteGroup, this._moduleId)
      : super(const AsyncValue.loading());

  /// Loads sites associated with the site group and module
  Future<void> loadSites() async {
    try {
      final sites =
          await _useCase.execute(_siteGroup.idSitesGroup, _moduleId);
      state = AsyncValue.data(sites);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Refreshes the sites list
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    await loadSites();
  }
}
