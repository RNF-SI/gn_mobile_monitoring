/// Helper pour la gestion du cache des éléments en échec lors de la synchronisation
/// Permet d'éviter les boucles infinies en marquant temporairement les éléments qui échouent
class SyncCacheManager {
  // Tracker des visites qui ont déjà échoué pour éviter les boucles infinies
  static final Set<int> _failedVisitIds = <int>{};
  static final Set<int> _failedObservationIds = <int>{};
  
  // Compteur d'échecs par élément pour détecter les boucles
  static final Map<int, int> _visitFailureCount = <int, int>{};
  static final Map<int, int> _observationFailureCount = <int, int>{};

  /// Nettoie le cache des visites en échec (pour les retentatives)
  /// Cette méthode est appelée au début de chaque synchronisation complète
  static void clearFailedVisitsCache() {
    _failedVisitIds.clear();
    _failedObservationIds.clear();
    _visitFailureCount.clear();
    _observationFailureCount.clear();
  }

  /// Nettoie le cache pour une nouvelle session de synchronisation
  /// Permet de retenter tous les éléments qui avaient échoué précédemment
  static void resetForNewSyncSession() {
    clearFailedVisitsCache();
  }

  /// Retire une visite spécifique du cache des échecs
  static void removeFromFailedCache(int visitId) {
    _failedVisitIds.remove(visitId);
    _visitFailureCount.remove(visitId);
  }

  /// Retire une observation spécifique du cache des échecs
  static void removeObservationFromFailedCache(int observationId) {
    _failedObservationIds.remove(observationId);
    _observationFailureCount.remove(observationId);
  }

  /// Vérifie si une visite est marquée comme ayant échoué
  static bool isVisitFailed(int visitId) {
    return _failedVisitIds.contains(visitId);
  }

  /// Vérifie si une observation est marquée comme ayant échoué
  static bool isObservationFailed(int observationId) {
    return _failedObservationIds.contains(observationId);
  }

  /// Marque une visite comme ayant échoué
  static void markVisitAsFailed(int visitId) {
    _failedVisitIds.add(visitId);
  }

  /// Marque une observation comme ayant échoué
  static void markObservationAsFailed(int observationId) {
    _failedObservationIds.add(observationId);
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

  /// Obtient des statistiques sur le cache des échecs
  static Map<String, dynamic> getCacheStats() {
    return {
      'failedVisits': _failedVisitIds.length,
      'failedObservations': _failedObservationIds.length,
      'visitFailureCounts': Map.from(_visitFailureCount),
      'observationFailureCounts': Map.from(_observationFailureCount),
    };
  }
}