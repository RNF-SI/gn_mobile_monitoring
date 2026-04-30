import 'package:gn_mobile_monitoring/domain/model/base_site.dart';

abstract class GetSitesBySiteGroupAndModuleUseCase {
  /// Returns the sites of a group that are associated with the given module
  /// via cor_site_module.
  Future<List<BaseSite>> execute(int siteGroupId, int moduleId);
}
