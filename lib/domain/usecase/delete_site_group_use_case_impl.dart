import 'package:gn_mobile_monitoring/data/datasource/interface/database/sites_database.dart';
import 'package:gn_mobile_monitoring/domain/usecase/delete_site_group_use_case.dart';

class DeleteSiteGroupUseCaseImpl implements DeleteSiteGroupUseCase {
  final SitesDatabase _sitesDatabase;

  const DeleteSiteGroupUseCaseImpl(this._sitesDatabase);

  @override
  Future<bool> execute(int siteId) async {
    try {
      await _sitesDatabase.deleteSiteGroup(siteId);
      return true;
    } catch (e) {
      return false;
    }
  }
}

