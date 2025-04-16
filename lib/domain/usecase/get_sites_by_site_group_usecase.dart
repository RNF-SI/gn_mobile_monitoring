import 'package:gn_mobile_monitoring/domain/model/base_site.dart';

abstract class GetSitesBySiteGroupUseCase {
  /// Returns a list of sites associated with the given site group id.
  Future<List<BaseSite>> execute(int siteGroupId);
}