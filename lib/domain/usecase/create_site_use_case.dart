import 'package:gn_mobile_monitoring/domain/model/base_site.dart';

abstract class CreateSiteUseCase {
  /// Crée un nouveau site dans la base de données
  /// 
  /// Prend en paramètre un objet [BaseSite] contenant les données du site à créer
  /// Retourne l'ID du site créé
  Future<int> execute(BaseSite site);
}

