abstract class DeleteVisitUseCase {
  /// Supprime une visite existante de la base de données
  /// 
  /// Prend en paramètre l'ID de la visite à supprimer
  /// Retourne true si la suppression a réussi, false sinon
  Future<bool> execute(int visitId);
}