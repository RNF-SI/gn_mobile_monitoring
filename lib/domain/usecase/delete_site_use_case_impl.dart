import 'package:gn_mobile_monitoring/data/datasource/interface/database/sites_database.dart';
import 'package:gn_mobile_monitoring/domain/usecase/delete_site_use_case.dart';

class DeleteSiteUseCaseImpl implements DeleteSiteUseCase {
  final SitesDatabase _sitesDatabase;

  const DeleteSiteUseCaseImpl(this._sitesDatabase);

  @override
  Future<bool> execute(int siteId) async {
    try {
      await _sitesDatabase.deleteSite(siteId);
      return true;
    } catch (e) {
      return false;
    }
  }
}

