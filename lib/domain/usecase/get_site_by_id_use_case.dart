import 'package:gn_mobile_monitoring/domain/model/base_site.dart';

/// Use case pour récupérer un site par son ID
abstract class GetSiteByIdUseCase {
  /// Récupère un site par son ID
  Future<BaseSite?> execute(int siteId);
}
