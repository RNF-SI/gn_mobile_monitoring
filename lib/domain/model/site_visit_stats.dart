/// Statistiques de visites agrégées localement pour un site donné d'un
/// module. Calculées à partir de `t_base_visits` (visites synchronisées +
/// visites locales pas encore téléversées), au lieu de s'appuyer sur les
/// champs serveur `last_visit` / `nb_visits` qui ne reflètent pas les
/// saisies offline tant qu'elles ne sont pas uploadées.
class SiteVisitStats {
  final DateTime? lastVisit;
  final int nbVisits;

  const SiteVisitStats({
    required this.lastVisit,
    required this.nbVisits,
  });
}
