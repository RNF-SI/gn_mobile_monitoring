import 'package:gn_mobile_monitoring/domain/model/site_complement.dart';
import 'package:gn_mobile_monitoring/domain/repository/sites_repository.dart';
import 'package:gn_mobile_monitoring/domain/usecase/get_site_complements_use_case.dart';

/// Implémentation du use case pour récupérer les compléments de sites
class GetSiteComplementsUseCaseImpl implements GetSiteComplementsUseCase {
  final SitesRepository _sitesRepository;

  const GetSiteComplementsUseCaseImpl(this._sitesRepository);

  @override
  Future<List<SiteComplement>> execute() async {
    return _sitesRepository.getAllSiteComplements();
  }

  @override
  Future<Map<int, SiteComplement?>> executeForSites(List<int> siteIds) async {
    final allComplements = await _sitesRepository.getAllSiteComplements();

    final Map<int, SiteComplement?> result = {};
    for (final siteId in siteIds) {
      final complement = allComplements
          .where((c) => c.idBaseSite == siteId)
          .firstOrNull;
      result[siteId] = complement;
    }

    return result;
  }

  @override
  Future<SiteComplement?> executeForSite(int siteId) async {
    final allComplements = await _sitesRepository.getAllSiteComplements();
    return allComplements
        .where((c) => c.idBaseSite == siteId)
        .firstOrNull;
  }
}
