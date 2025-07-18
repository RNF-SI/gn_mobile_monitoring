/// Use case pour télécharger toutes les données d'un module depuis le serveur.
/// 
/// Cette méthode télécharge et stocke localement l'ensemble des données du module :
/// - La configuration complète (formulaires, règles de gestion, etc.)
/// - Les datasets associés
/// - Les nomenclatures utilisées
/// - Les sites du module
/// - Les groupes de sites 
/// - Les taxons (si le module en utilise)
/// 
/// Le téléchargement nécessite une connexion internet active et un token d'authentification valide.
abstract class DownloadCompleteModuleUseCase {
  /// Télécharge toutes les données d'un module depuis le serveur.
  /// 
  /// [moduleId] L'identifiant du module à télécharger
  /// [token] Le token d'authentification pour accéder à l'API
  /// [onProgressUpdate] Callback pour suivre la progression du téléchargement (0.0 à 1.0)
  /// [onStepUpdate] Callback optionnel pour fournir des informations sur l'étape en cours
  /// 
  /// Cette méthode :
  /// - Télécharge la configuration du module
  /// - Récupère tous les datasets, nomenclatures et types de sites
  /// - Synchronise les sites et groupes de sites
  /// - Télécharge les taxons si nécessaire
  /// - Met à jour le statut du module comme "téléchargé"
  /// 
  /// En cas d'erreur, la progression est remise à 0.0 et l'exception est propagée.
  Future<void> execute(
    int moduleId,
    String token,
    Function(double) onProgressUpdate, [
    Function(String)? onStepUpdate,
  ]);
}
