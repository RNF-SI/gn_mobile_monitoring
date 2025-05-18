import 'package:freezed_annotation/freezed_annotation.dart';

part 'sync_conflict_temp.freezed.dart';

enum ConflictResolutionStrategy { serverWins, clientWins, merge, userDecision }

enum ConflictType {
  dataConflict, // Conflit entre données locales et distantes
  deletedReference // Référence à un élément supprimé sur le serveur
}

@freezed
class SyncConflict with _$SyncConflict {
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
    String? referencedEntityType,
    String? referencedEntityId,
    String? affectedField,
    String? navigationPath,
    @Default(false) bool isResolved,
    String? resolutionType,
  }) = _SyncConflict;
}