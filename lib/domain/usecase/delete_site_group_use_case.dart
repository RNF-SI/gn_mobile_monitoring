abstract class DeleteSiteGroupUseCase {
  /// Supprime un site de la base de données
  /// 
  /// Prend en paramètre l'ID du site à supprimer
  /// Retourne true si la suppression a réussi
  Future<bool> execute(int siteGroupId);
}

