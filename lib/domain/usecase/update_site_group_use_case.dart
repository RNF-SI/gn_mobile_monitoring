import 'package:gn_mobile_monitoring/domain/model/site_group.dart';

abstract class UpdateSiteGroupUseCase {
  /// Met à jour un site existant dans la base de données
  /// 
  /// Prend en paramètre un objet [BaseSite] contenant les données du site à mettre à jour
  /// Retourne true si la mise à jour a réussi
  Future<bool> execute(SiteGroup site);
}

