import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gn_mobile_monitoring/domain/model/sync_conflict.dart' as domain;

part 'sync_status.freezed.dart';

// Type alias for freezed generation
typedef SyncConflict = domain.SyncConflict;

/// Représente les différentes étapes du processus de synchronisation
enum SyncStep {
  // === Étapes de MISE À JOUR DES DONNÉES (serveur -> appareil) ===
  // Ces étapes sont pour le téléchargement des données depuis le serveur
  configuration,
  nomenclatures,
  taxons,
  observers,
  modules,
  sites,
  siteGroups,
  
  // === Étapes de TÉLÉVERSEMENT (appareil -> serveur) ===
  // Ces étapes sont pour l'envoi des données vers le serveur
  // Une fois envoyées et confirmées par le serveur, les données sont supprimées localement
  visitsToServer,
  observationsToServer,
  observationDetailsToServer,
}

/// Représente les différents états de synchronisation
enum SyncState {
  idle,
  inProgress,
  success,
  failure,
  conflictDetected,
}

/// Type de synchronisation en cours
enum SyncType {
  downstream, // Serveur → Appareil
  upload,     // Appareil → Serveur (téléversement)
}


/// Représente le statut d'une opération de synchronisation
@freezed
class SyncStatus with _$SyncStatus {
  const SyncStatus._(); // Constructeur privé pour ajouter des méthodes si nécessaire
  
  const factory SyncStatus({
    required SyncState state,
    required SyncStep? currentStep,
    required List<SyncStep> completedSteps,
    required List<SyncStep> failedSteps,
    required int itemsProcessed,
    required int itemsTotal,
    required double progress,
    String? errorMessage,
    DateTime? lastSync,
    List<SyncConflict>? conflicts,
    required DateTime lastUpdated,
    
    // Type de synchronisation en cours
    SyncType? currentSyncType,
    
    // Résultats des dernières synchronisations  
    // (utilisation de domain.SyncResult temporairement désactivée)
    // SyncResult? lastDownstreamSync,
    // SyncResult? lastUpstreamSync,
    
    // Détails supplémentaires pour la progression
    String? currentEntityName,   // Nom du module, site, etc. en cours de traitement
    int? currentEntityTotal,     // Nombre total d'éléments à traiter pour l'entité courante
    int? currentEntityProcessed, // Nombre d'éléments traités pour l'entité courante
    int? itemsAdded,             // Nombre d'éléments ajoutés dans l'étape actuelle
    int? itemsUpdated,           // Nombre d'éléments mis à jour dans l'étape actuelle
    int? itemsSkipped,           // Nombre d'éléments ignorés dans l'étape actuelle
    int? itemsDeleted,           // Nombre d'éléments supprimés dans l'étape actuelle
    String? additionalInfo,      // Informations supplémentaires sur la progression
    String? nextFullSyncInfo,     // Informations sur la prochaine synchronisation complète
  }) = _SyncStatus;

  /// État initial par défaut
  factory SyncStatus.initial() => SyncStatus(
        state: SyncState.idle,
        currentStep: null,
        completedSteps: const [],
        failedSteps: const [],
        itemsProcessed: 0,
        itemsTotal: 0,
        progress: 0.0,
        lastUpdated: DateTime.now(),
        nextFullSyncInfo: null,
      );

  /// État lorsque la synchronisation est en cours
  factory SyncStatus.inProgress({
    required SyncStep currentStep,
    required List<SyncStep> completedSteps,
    required int itemsProcessed,
    required int itemsTotal,
    String? currentEntityName,
    int? currentEntityTotal,
    int? currentEntityProcessed,
    int? itemsAdded,
    int? itemsUpdated,
    int? itemsSkipped,
    int? itemsDeleted,
    String? additionalInfo,
  }) =>
      SyncStatus(
        state: SyncState.inProgress,
        currentStep: currentStep,
        completedSteps: completedSteps,
        failedSteps: const [],
        itemsProcessed: itemsProcessed,
        itemsTotal: itemsTotal,
        progress: itemsTotal > 0 ? itemsProcessed / itemsTotal : 0.0,
        lastUpdated: DateTime.now(),
        currentEntityName: currentEntityName,
        currentEntityTotal: currentEntityTotal,
        currentEntityProcessed: currentEntityProcessed,
        itemsAdded: itemsAdded,
        itemsUpdated: itemsUpdated,
        itemsSkipped: itemsSkipped,
        itemsDeleted: itemsDeleted,
        additionalInfo: additionalInfo,
      );

  /// État lorsque la synchronisation est terminée avec succès
  factory SyncStatus.success({
    required List<SyncStep> completedSteps,
    required int itemsProcessed,
    DateTime? lastSync,
    int? itemsAdded,
    int? itemsUpdated,
    int? itemsSkipped,
    int? itemsDeleted,
    String? additionalInfo,
  }) =>
      SyncStatus(
        state: SyncState.success,
        currentStep: null,
        completedSteps: completedSteps,
        failedSteps: const [],
        itemsProcessed: itemsProcessed,
        itemsTotal: itemsProcessed,
        progress: 1.0,
        lastSync: lastSync ?? DateTime.now(),
        lastUpdated: DateTime.now(),
        itemsAdded: itemsAdded,
        itemsUpdated: itemsUpdated,
        itemsSkipped: itemsSkipped,
        itemsDeleted: itemsDeleted,
        additionalInfo: additionalInfo,
      );

  /// État lorsque la synchronisation a échoué
  factory SyncStatus.failure({
    required String errorMessage,
    required List<SyncStep> completedSteps,
    required List<SyncStep> failedSteps,
    required int itemsProcessed,
    required int itemsTotal,
    String? currentEntityName,
    String? additionalInfo,
  }) =>
      SyncStatus(
        state: SyncState.failure,
        currentStep: null,
        completedSteps: completedSteps,
        failedSteps: failedSteps,
        itemsProcessed: itemsProcessed,
        itemsTotal: itemsTotal,
        progress: itemsTotal > 0 ? itemsProcessed / itemsTotal : 0.0,
        errorMessage: errorMessage,
        lastUpdated: DateTime.now(),
        currentEntityName: currentEntityName,
        additionalInfo: additionalInfo,
      );

  /// État lorsque des conflits sont détectés
  factory SyncStatus.conflictDetected({
    required List<SyncConflict> conflicts,
    required List<SyncStep> completedSteps,
    required int itemsProcessed,
    required int itemsTotal,
    String? additionalInfo,
    int? itemsAdded,
    int? itemsUpdated,
    int? itemsSkipped,
    int? itemsDeleted,
    String? currentEntityName,
    SyncStep? currentStep,
  }) =>
      SyncStatus(
        state: SyncState.conflictDetected,
        currentStep: currentStep,
        completedSteps: completedSteps,
        failedSteps: const [],
        itemsProcessed: itemsProcessed,
        itemsTotal: itemsTotal,
        progress: itemsTotal > 0 ? itemsProcessed / itemsTotal : 0.0,
        conflicts: conflicts,
        lastUpdated: DateTime.now(),
        additionalInfo: additionalInfo,
        itemsAdded: itemsAdded,
        itemsUpdated: itemsUpdated,
        itemsSkipped: itemsSkipped,
        itemsDeleted: itemsDeleted,
        currentEntityName: currentEntityName,
      );
}