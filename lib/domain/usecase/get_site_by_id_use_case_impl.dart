import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/repository/sites_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_site_by_id_use_case.dart';

/// Implémentation du use case pour récupérer un site par son ID
class GetSiteByIdUseCaseImpl implements GetSiteByIdUseCase {
  final SitesRepository _sitesRepository;

  const GetSiteByIdUseCaseImpl(this._sitesRepository);

  @override
  Future<BaseSite?> execute(int siteId) {
    return _sitesRepository.getSiteById(siteId);
  }
}
