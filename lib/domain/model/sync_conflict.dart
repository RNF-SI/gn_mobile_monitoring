import 'package:freezed_annotation/freezed_annotation.dart';

part 'sync_conflict.freezed.dart';

enum ConflictResolutionStrategy { serverWins, clientWins, merge, userDecision }

enum ConflictType {
  dataConflict, // Conflit entre données locales et distantes
  deletedReference // Référence à un élément supprimé sur le serveur
}

@freezed
class SyncConflict with _$SyncConflict {
  const SyncConflict._(); // Constructeur privé pour ajouter des méthodes si nécessaire

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
  }) = _SyncConflict;
}
