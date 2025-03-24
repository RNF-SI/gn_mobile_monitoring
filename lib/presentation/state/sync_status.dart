enum SyncStep {
  initial,
  syncingModules,
  syncingSites,
  syncingSiteGroups,
  deletingDatabase,
  complete,
  error
}

class SyncStatus {
  final SyncStep step;
  final String message;
  final double? progress;
  final String? errorDetails;
  final bool isInProgress;

  const SyncStatus({
    required this.step,
    required this.message,
    this.progress,
    this.errorDetails,
    this.isInProgress = false,
  });

  static const initial = SyncStatus(
    step: SyncStep.initial,
    message: 'Prêt à synchroniser',
    isInProgress: false,
  );

  static const deletingDatabase = SyncStatus(
    step: SyncStep.deletingDatabase,
    message: 'Suppression et rechargement de la base de données...',
    isInProgress: true,
  );

  static const syncingModules = SyncStatus(
    step: SyncStep.syncingModules,
    message: 'Synchronisation des modules...',
    isInProgress: true,
  );

  static const syncingSites = SyncStatus(
    step: SyncStep.syncingSites,
    message: 'Synchronisation des sites...',
    isInProgress: true,
  );

  static const syncingSiteGroups = SyncStatus(
    step: SyncStep.syncingSiteGroups,
    message: 'Synchronisation des groupes de sites...',
    isInProgress: true,
  );

  static const complete = SyncStatus(
    step: SyncStep.complete,
    message: 'Synchronisation terminée',
    isInProgress: false,
  );

  factory SyncStatus.error(String details) => SyncStatus(
        step: SyncStep.error,
        message: 'Erreur de synchronisation',
        errorDetails: details,
        isInProgress: false,
      );

  SyncStatus copyWith({
    SyncStep? step,
    String? message,
    double? progress,
    String? errorDetails,
    bool? isInProgress,
  }) {
    return SyncStatus(
      step: step ?? this.step,
      message: message ?? this.message,
      progress: progress ?? this.progress,
      errorDetails: errorDetails ?? this.errorDetails,
      isInProgress: isInProgress ?? this.isInProgress,
    );
  }
}
