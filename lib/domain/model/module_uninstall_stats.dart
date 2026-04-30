/// Stats d'une désinstallation de module à venir : sert à informer
/// l'utilisateur des données qui seraient perdues. Retourné par
/// [GetModuleUninstallStatsUseCase] avant la confirmation.
///
/// `unsyncedVisits` met explicitement en avant les saisies pas encore
/// téléversées : c'est le seul cas où la désinstallation détruit des
/// données que l'utilisateur n'a pas pu récupérer côté serveur.
class ModuleUninstallStats {
  final int totalVisits;
  final int unsyncedVisits;
  final int totalObservations;

  /// Sites qui n'appartiennent qu'à ce module et seront supprimés
  /// (les sites partagés avec d'autres modules sont conservés).
  final int exclusiveSites;

  const ModuleUninstallStats({
    required this.totalVisits,
    required this.unsyncedVisits,
    required this.totalObservations,
    required this.exclusiveSites,
  });

  /// `true` si la désinstallation détruit des données que l'utilisateur
  /// n'a pas téléversées et qui seront définitivement perdues.
  bool get hasUnsavedData => unsyncedVisits > 0;
}
