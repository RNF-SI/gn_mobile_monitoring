import 'package:gn_mobile_monitoring/domain/model/sync_result.dart';

abstract class GlobalDatabase {
  // Méthodes de base de l'interface existante
  Future<void> initDatabase();
  Future<void> deleteDatabase();
  Future<void> resetDatabase();
  
  // Nouvelles méthodes pour la synchronisation
  /// Récupère la date de dernière synchronisation pour un type d'entité spécifique
  Future<DateTime?> getLastSyncDate(String entityType);
  
  /// Met à jour la date de dernière synchronisation pour un type d'entité
  Future<void> updateLastSyncDate(String entityType, DateTime syncDate);
  
  /// Récupère le nombre d'éléments en attente de synchronisation
  Future<int> getPendingItemsCount();
  
  /// Sauvegarde les paramètres de configuration globaux
  Future<SyncResult> saveConfiguration(Map<String, dynamic> configData);
}
