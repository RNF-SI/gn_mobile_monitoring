import 'package:gn_mobile_monitoring/domain/model/site_group.dart';

/// Use case pour créer un groupe de sites avec ses relations (module)
abstract class CreateSiteGroupWithRelationsUseCase {
  /// Crée un groupe de sites avec ses relations
  /// Retourne l'ID du groupe de sites créé
  Future<int> execute({
    required SiteGroup siteGroup,
    required int moduleId,
  });
}
