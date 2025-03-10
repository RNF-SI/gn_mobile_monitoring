import 'package:gn_mobile_monitoring/domain/repository/sites_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/fetch_site_groups_usecase.dart';

class FetchSiteGroupsUseCaseImpl implements FetchSiteGroupsUseCase {
  final SitesRepository _sitesRepository;

  const FetchSiteGroupsUseCaseImpl(this._sitesRepository);

  @override
  Future<void> execute(String token) async {
    try {
      await _sitesRepository.fetchSiteGroupsAndSitesGroupModules(token);
    } catch (e) {
      print('Error in FetchSiteGroupsUseCase: $e');
      rethrow;
    }
  }
}