import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gn_mobile_monitoring/domain/model/sync_conflict.dart';

part 'sync_result.freezed.dart';

@freezed
class SyncResult with _$SyncResult {
  const factory SyncResult({
    required bool success,
    required int itemsProcessed,
    required int itemsAdded,
    required int itemsUpdated,
    required int itemsSkipped,
    required int itemsFailed,
    required DateTime syncTime,
    @Default(0) int itemsDeleted,
    String? errorMessage,
    List<SyncConflict>? conflicts,
    Map<String, dynamic>? data,
  }) = _SyncResult;

  factory SyncResult.success({
    required int itemsProcessed,
    required int itemsAdded,
    required int itemsUpdated,
    required int itemsSkipped,
    int itemsFailed = 0,
    int itemsDeleted = 0,
    Map<String, dynamic>? data,
  }) => SyncResult(
    success: true,
    itemsProcessed: itemsProcessed,
    itemsAdded: itemsAdded,
    itemsUpdated: itemsUpdated,
    itemsSkipped: itemsSkipped,
    itemsFailed: itemsFailed,
    itemsDeleted: itemsDeleted,
    syncTime: DateTime.now(),
    data: data,
  );

  factory SyncResult.failure({
    required String errorMessage,
    int itemsProcessed = 0,
    int itemsAdded = 0,
    int itemsUpdated = 0,
    int itemsSkipped = 0,
    int itemsFailed = 0,
    int itemsDeleted = 0,
  }) => SyncResult(
    success: false,
    itemsProcessed: itemsProcessed,
    itemsAdded: itemsAdded,
    itemsUpdated: itemsUpdated,
    itemsSkipped: itemsSkipped,
    itemsFailed: itemsFailed,
    itemsDeleted: itemsDeleted,
    syncTime: DateTime.now(),
    errorMessage: errorMessage,
  );

  factory SyncResult.withConflicts({
    required int itemsProcessed,
    required int itemsAdded,
    required int itemsUpdated,
    required int itemsSkipped,
    required int itemsFailed,
    int itemsDeleted = 0,
    required List<SyncConflict> conflicts,
    String? errorMessage,
    Map<String, dynamic>? data,
  }) => SyncResult(
    success: true,
    itemsProcessed: itemsProcessed,
    itemsAdded: itemsAdded,
    itemsUpdated: itemsUpdated,
    itemsSkipped: itemsSkipped,
    itemsFailed: itemsFailed,
    itemsDeleted: itemsDeleted,
    syncTime: DateTime.now(),
    conflicts: conflicts,
    errorMessage: errorMessage,
    data: data,
  );
}