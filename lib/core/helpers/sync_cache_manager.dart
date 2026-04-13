/// Helper pour la gestion des statistiques d'échecs lors de la synchronisation
/// Conserve un compteur des tentatives pour le débogage, mais ne bloque plus les éléments
class SyncCacheManager {
  // Compteur d'échecs par élément pour le débogage et les statistiques
  static final Map<int, int> _visitFailureCount = <int, int>{};
  static final Map<int, int> _observationFailureCount = <int, int>{};

  /// Nettoie les compteurs d'échecs
  static void clearFailureStats() {
    _visitFailureCount.clear();
    _observationFailureCount.clear();
  }

  /// Incrémente le compteur d'échecs pour une visite et retourne le nouveau compte
  static int incrementVisitFailureCount(int visitId) {
    _visitFailureCount[visitId] = (_visitFailureCount[visitId] ?? 0) + 1;
    return _visitFailureCount[visitId]!;
  }

  /// Incrémente le compteur d'échecs pour une observation et retourne le nouveau compte
  static int incrementObservationFailureCount(int observationId) {
    _observationFailureCount[observationId] = (_observationFailureCount[observationId] ?? 0) + 1;
    return _observationFailureCount[observationId]!;
  }

  /// Obtient le nombre d'échecs pour une visite
  static int getVisitFailureCount(int visitId) {
    return _visitFailureCount[visitId] ?? 0;
  }

  /// Obtient le nombre d'échecs pour une observation
  static int getObservationFailureCount(int observationId) {
    return _observationFailureCount[observationId] ?? 0;
  }

  /// Obtient des statistiques sur les échecs
  static Map<String, dynamic> getFailureStats() {
    return {
      'visitFailureCounts': Map.from(_visitFailureCount),
      'observationFailureCounts': Map.from(_observationFailureCount),
    };
  }

  // ===== MÉTHODES OBSOLÈTES - GARDÉES POUR LA COMPATIBILITÉ =====
  // Ces méthodes ne font plus rien mais sont conservées pour éviter les erreurs de compilation

  @Deprecated('Utiliser clearFailureStats() - le cache de blocage est supprimé')
  static void clearFailedVisitsCache() {
    clearFailureStats();
  }

  @Deprecated('Méthode obsolète - les éléments ne sont plus bloqués')
  static void resetForNewSyncSession() {
    // Ne fait plus rien - les éléments ne sont plus bloqués
  }

  @Deprecated('Méthode obsolète - les éléments ne sont plus bloqués')
  static void removeFromFailedCache(int visitId) {
    // Ne fait plus rien - les éléments ne sont plus bloqués
  }

  @Deprecated('Méthode obsolète - les éléments ne sont plus bloqués')
  static void removeObservationFromFailedCache(int observationId) {
    // Ne fait plus rien - les éléments ne sont plus bloqués
  }

  @Deprecated('Méthode obsolète - retourne toujours false')
  static bool isVisitFailed(int visitId) {
    // Retourne toujours false - les éléments ne sont plus bloqués
    return false;
  }

  @Deprecated('Méthode obsolète - retourne toujours false')
  static bool isObservationFailed(int observationId) {
    // Retourne toujours false - les éléments ne sont plus bloqués
    return false;
  }

  @Deprecated('Méthode obsolète - les éléments ne sont plus bloqués')
  static void markVisitAsFailed(int visitId) {
    // Ne fait plus rien - les éléments ne sont plus bloqués
  }

  @Deprecated('Méthode obsolète - les éléments ne sont plus bloqués')
  static void markObservationAsFailed(int observationId) {
    // Ne fait plus rien - les éléments ne sont plus bloqués
  }

  @Deprecated('Utiliser getFailureStats() - le cache de blocage est supprimé')
  static Map<String, dynamic> getCacheStats() {
    return getFailureStats();
  }
}