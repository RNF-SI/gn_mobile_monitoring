import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/domain/model/sync_conflict.dart' as domain;

/// Service pour gérer la résolution des conflits
class ConflictResolutionService extends StateNotifier<Map<String, ConflictResolutionState>> {
  ConflictResolutionService() : super({});

  /// Marquer un conflit comme résolu
  void markAsResolved(domain.SyncConflict conflict, String resolutionType) {
    final key = _getConflictKey(conflict);
    state = {
      ...state,
      key: ConflictResolutionState(
        isResolved: true,
        resolutionType: resolutionType,
        resolvedAt: DateTime.now(),
      ),
    };
  }

  /// Vérifier si un conflit est résolu
  bool isResolved(domain.SyncConflict conflict) {
    final key = _getConflictKey(conflict);
    return state[key]?.isResolved ?? false;
  }

  /// Obtenir l'état de résolution d'un conflit
  ConflictResolutionState? getResolutionState(domain.SyncConflict conflict) {
    final key = _getConflictKey(conflict);
    return state[key];
  }

  /// Réinitialiser tous les états de résolution
  void resetAll() {
    state = {};
  }

  /// Générer une clé unique pour un conflit
  String _getConflictKey(domain.SyncConflict conflict) {
    return '${conflict.entityType}_${conflict.entityId}_${conflict.affectedField ?? "NA"}_${conflict.conflictType.name}_${conflict.referencedEntityType ?? "NA"}_${conflict.referencedEntityId ?? "NA"}';
  }
}

/// État de résolution d'un conflit
class ConflictResolutionState {
  final bool isResolved;
  final String? resolutionType;
  final DateTime? resolvedAt;

  ConflictResolutionState({
    required this.isResolved,
    this.resolutionType,
    this.resolvedAt,
  });
}

/// Provider pour le service de résolution des conflits
final conflictResolutionProvider = StateNotifierProvider<ConflictResolutionService, Map<String, ConflictResolutionState>>((ref) {
  return ConflictResolutionService();
});