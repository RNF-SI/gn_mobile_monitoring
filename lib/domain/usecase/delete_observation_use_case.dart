/// Cas d'utilisation pour supprimer une observation
abstract class DeleteObservationUseCase {
  /// Exécute le cas d'utilisation pour supprimer une observation
  /// Retourne true si la suppression a réussi
  Future<bool> execute(int observationId);
}