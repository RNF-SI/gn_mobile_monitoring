import 'package:gn_mobile_monitoring/domain/model/base_site.dart';

abstract class GetOrphanSitesByModuleUseCase {
  /// Returns the sites of a module that don't belong to any site group
  /// (id_sites_group is NULL). Used by the "Sites" tab when a module also
  /// has groups (issue #157).
  Future<List<BaseSite>> execute(int moduleId);
}
