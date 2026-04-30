abstract class UninstallModuleUseCase {
  /// Désinstalle un module : supprime ses visites, observations et toutes
  /// les données qui n'appartiennent qu'à lui (sites/groupes exclusifs,
  /// associations datasets, configuration). Conserve les nomenclatures,
  /// types de site et taxons (partagés). Bascule `downloaded = false` sur
  /// le module pour permettre une réinstallation ultérieure.
  Future<void> execute(int moduleId);
}
