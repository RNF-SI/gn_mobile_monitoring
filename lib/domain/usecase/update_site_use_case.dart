import 'package:gn_mobile_monitoring/domain/model/base_site.dart';

abstract class UpdateSiteUseCase {
  /// Met à jour un site existant dans la base de données
  /// 
  /// Prend en paramètre un objet [BaseSite] contenant les données du site à mettre à jour
  /// Retourne true si la mise à jour a réussi
  Future<bool> execute(BaseSite site);
}

