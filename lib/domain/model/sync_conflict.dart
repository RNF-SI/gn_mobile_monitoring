import 'package:freezed_annotation/freezed_annotation.dart';

part 'sync_conflict.freezed.dart';

enum ConflictResolutionStrategy {
  serverWins,
  clientWins,
  merge,
  userDecision
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
  }) = _SyncConflict;
}