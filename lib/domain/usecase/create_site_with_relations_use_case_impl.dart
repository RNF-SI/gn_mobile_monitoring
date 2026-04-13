import 'package:gn_mobile_monitoring/data/datasource/interface/database/sites_database.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/site_complement.dart';
import 'package:gn_mobile_monitoring/domain/model/site_module.dart';
import 'package:gn_mobile_monitoring/domain/usecase/create_site_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/create_site_with_relations_use_case.dart';

/// Implémentation du use case pour créer un site avec ses relations
class CreateSiteWithRelationsUseCaseImpl implements CreateSiteWithRelationsUseCase {
  final CreateSiteUseCase _createSiteUseCase;
  final SitesDatabase _sitesDatabase;

  const CreateSiteWithRelationsUseCaseImpl(
    this._createSiteUseCase,
    this._sitesDatabase,
  );

  @override
  Future<int> execute({
    required BaseSite site,
    required int moduleId,
    SiteComplement? complement,
  }) async {
    // 1. Créer le site
    final siteId = await _createSiteUseCase.execute(site);

    // 2. Créer la relation site-module
    await _sitesDatabase.insertSiteModule(SiteModule(
      idSite: siteId,
      idModule: moduleId,
    ));

    // 3. Créer le complément de site si fourni
    if (complement != null) {
      final complementWithSiteId = SiteComplement(
        idBaseSite: siteId,
        idSitesGroup: complement.idSitesGroup,
        data: complement.data,
      );
      await _sitesDatabase.insertSiteComplements([complementWithSiteId]);
    }

    return siteId;
  }
}
