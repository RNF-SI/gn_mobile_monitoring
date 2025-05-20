import 'package:gn_mobile_monitoring/domain/model/module.dart';

/// Use case pour récupérer un module complet depuis la base de données locale.
/// 
/// Cette méthode récupère toutes les données liées au module :
/// - Les informations de base du module
/// - La configuration complète (objectifs, formulaires, etc.)
/// - Les sites associés au module
/// - Les groupes de sites associés
/// - Les compléments de module (données additionnelles)
/// 
/// Note: Cette méthode ne télécharge pas de données depuis le serveur,
/// elle lit uniquement les données déjà présentes en local.
abstract class GetCompleteModuleUseCase {
  /// Récupère un module complet avec toutes ses données associées depuis la base locale.
  /// 
  /// [moduleId] L'identifiant du module à récupérer
  /// 
  /// Retourne un [Module] contenant :
  /// - Les métadonnées du module (nom, description, etc.)
  /// - La configuration complète si disponible
  /// - Les sites et groupes de sites associés
  /// - Les données complémentaires
  /// 
  /// Lève une exception si le module n'existe pas en base locale.
  Future<Module> execute(int moduleId);
}
