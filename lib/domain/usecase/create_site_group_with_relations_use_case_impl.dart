import 'package:gn_mobile_monitoring/data/datasource/interface/database/sites_database.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';
import 'package:gn_mobile_monitoring/domain/model/sites_group_module.dart';
import 'package:gn_mobile_monitoring/domain/usecase/create_site_group_use_case.dart';
import 'package:gn_mobile_monitoring/domain/usecase/create_site_group_with_relations_use_case.dart';

/// Implémentation du use case pour créer un groupe de sites avec ses relations
class CreateSiteGroupWithRelationsUseCaseImpl implements CreateSiteGroupWithRelationsUseCase {
  final CreateSiteGroupUseCase _createSiteGroupUseCase;
  final SitesDatabase _sitesDatabase;

  const CreateSiteGroupWithRelationsUseCaseImpl(
    this._createSiteGroupUseCase,
    this._sitesDatabase,
  );

  @override
  Future<int> execute({
    required SiteGroup siteGroup,
    required int moduleId,
  }) async {
    // 1. Créer le groupe de sites
    final siteGroupId = await _createSiteGroupUseCase.execute(siteGroup);

    // 2. Créer la relation groupe de sites-module
    await _sitesDatabase.insertSiteGroupModule(SitesGroupModule(
      idSitesGroup: siteGroupId,
      idModule: moduleId,
    ));

    return siteGroupId;
  }
}
