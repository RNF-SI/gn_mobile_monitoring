import 'package:gn_mobile_monitoring/domain/model/site_group.dart';

abstract class GetSiteGroupsByIdUseCase {
  Future<SiteGroup?> execute(int siteGroupId);
}
