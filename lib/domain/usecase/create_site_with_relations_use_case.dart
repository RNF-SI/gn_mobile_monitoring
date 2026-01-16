import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/site_complement.dart';
import 'package:gn_mobile_monitoring/domain/model/site_module.dart';

/// Use case pour créer un site avec ses relations (module et complément)
abstract class CreateSiteWithRelationsUseCase {
  /// Crée un site avec ses relations
  /// Retourne l'ID du site créé
  Future<int> execute({
    required BaseSite site,
    required int moduleId,
    SiteComplement? complement,
  });
}
