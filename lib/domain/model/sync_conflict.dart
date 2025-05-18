import 'package:freezed_annotation/freezed_annotation.dart';

part 'sync_conflict.freezed.dart';

enum ConflictResolutionStrategy { serverWins, clientWins, merge, userDecision }

enum ConflictType {
  dataConflict, // Conflit entre données locales et distantes
  deletedReference // Référence à un élément supprimé sur le serveur
}

enum SyncOperation {
  modules,
  sites,
  siteGroups,
  visits,
  observations,
  nomenclatures,
  taxons,
  all
}

enum SyncStatus {
  pending,
  inProgress,
  success,
  partial,
  error,
  cancelled
}

enum ConflictSeverity {
  low,
  medium,
  high
}

@freezed
class SyncConflict with _$SyncConflict {
  const SyncConflict._();

  const factory SyncConflict({
    required String entityId,
    required String entityType,
    required Map<String, dynamic> localData,
    required Map<String, dynamic> remoteData,
    required DateTime localModifiedAt,
    required DateTime remoteModifiedAt,
    required ConflictResolutionStrategy resolutionStrategy,
    Map<String, dynamic>? resolvedData,
    String? resolutionComment,
    @Default(ConflictType.dataConflict) ConflictType conflictType,
    // Pour les références supprimées, on stocke des informations sur l'entité référencée
    String?
        referencedEntityType, // Type de l'entité supprimée (nomenclature, taxon, etc.)
    String? referencedEntityId, // ID de l'entité supprimée
    String? affectedField, // Champ affecté par la suppression
    String? navigationPath, // Chemin de navigation pour résoudre le conflit
    @Default(false) bool isResolved, // Indique si le conflit a été géré
    String? resolutionType, // Comment le conflit a été résolu (ex: "modifié", "supprimé", etc.)
    // Nouvelles propriétés pour la gestion améliorée des conflits
    SyncOperation? operation, // Opération qui a causé le conflit
    String? message, // Message détaillé du conflit
    ConflictSeverity? severity, // Sévérité du conflit
    String? localValue, // Valeur locale spécifique en conflit
    String? remoteValue, // Valeur distante spécifique en conflit
    int? referencesCount, // Nombre de références à l'élément supprimé
  }) = _SyncConflict;
}
