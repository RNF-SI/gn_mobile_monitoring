import 'package:gn_mobile_monitoring/domain/model/site_group.dart';

abstract class CreateSiteGroupUseCase {
  /// Crée un nouveau site dans la base de données
  /// 
  /// Prend en paramètre un objet [BaseSite] contenant les données du site à créer
  /// Retourne l'ID du site créé
  Future<int> execute(SiteGroup siteGroup);
}

