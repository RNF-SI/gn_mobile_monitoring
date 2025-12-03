import 'package:gn_mobile_monitoring/data/datasource/interface/database/sites_database.dart';
import 'package:gn_mobile_monitoring/domain/model/site_group.dart';
import 'package:gn_mobile_monitoring/domain/usecase/update_site_group_use_case.dart';

class UpdateSiteGroupUseCaseImpl implements UpdateSiteGroupUseCase {
  final SitesDatabase _sitesDatabase;

  const UpdateSiteGroupUseCaseImpl(this._sitesDatabase);

  @override
  Future<bool> execute(SiteGroup siteGroup) async {
    try {
      await _sitesDatabase.updateSiteGroup(siteGroup);
      return true;
    } catch (e) {
      return false;
    }
  }
}

