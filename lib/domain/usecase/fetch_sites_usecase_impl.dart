import 'package:gn_mobile_monitoring/domain/repository/sites_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/fetch_sites_usecase.dart';

class FetchSitesUseCaseImpl implements FetchSitesUseCase {
  final SitesRepository _sitesRepository;

  const FetchSitesUseCaseImpl(this._sitesRepository);

  @override
  Future<void> execute(String token) async {
    try {
      await _sitesRepository.fetchSitesAndSiteModules(token);
    } catch (e) {
      print('Error in FetchSitesUseCase: $e');
      rethrow;
    }
  }
}