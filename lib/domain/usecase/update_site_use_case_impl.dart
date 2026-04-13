import 'package:gn_mobile_monitoring/data/datasource/interface/database/sites_database.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/usecase/update_site_use_case.dart';

class UpdateSiteUseCaseImpl implements UpdateSiteUseCase {
  final SitesDatabase _sitesDatabase;

  const UpdateSiteUseCaseImpl(this._sitesDatabase);

  @override
  Future<bool> execute(BaseSite site) async {
    try {
      await _sitesDatabase.updateSite(site);
      return true;
    } catch (e) {
      return false;
    }
  }
}

