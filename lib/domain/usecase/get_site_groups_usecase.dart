import 'package:gn_mobile_monitoring/domain/model/site_group.dart';

abstract class GetSiteGroupsUseCase {
  Future<List<SiteGroup>> execute();
}
