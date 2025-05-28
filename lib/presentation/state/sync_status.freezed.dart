// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SyncStatus {
  SyncState get state => throw _privateConstructorUsedError;
  SyncStep? get currentStep => throw _privateConstructorUsedError;
  List<SyncStep> get completedSteps => throw _privateConstructorUsedError;
  List<SyncStep> get failedSteps => throw _privateConstructorUsedError;
  int get itemsProcessed => throw _privateConstructorUsedError;
  int get itemsTotal => throw _privateConstructorUsedError;
  double get progress => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  DateTime? get lastSync => throw _privateConstructorUsedError;
  List<SyncConflict>? get conflicts => throw _privateConstructorUsedError;
  DateTime get lastUpdated =>
      throw _privateConstructorUsedError; // Type de synchronisation en cours
  SyncType? get currentSyncType =>
      throw _privateConstructorUsedError; // Résultats des dernières synchronisations
// (utilisation de domain.SyncResult temporairement désactivée)
// SyncResult? lastDownstreamSync,
// SyncResult? lastUpstreamSync,
// Détails supplémentaires pour la progression
  String? get currentEntityName =>
      throw _privateConstructorUsedError; // Nom du module, site, etc. en cours de traitement
  int? get currentEntityTotal =>
      throw _privateConstructorUsedError; // Nombre total d'éléments à traiter pour l'entité courante
  int? get currentEntityProcessed =>
      throw _privateConstructorUsedError; // Nombre d'éléments traités pour l'entité courante
  int? get itemsAdded =>
      throw _privateConstructorUsedError; // Nombre d'éléments ajoutés dans l'étape actuelle
  int? get itemsUpdated =>
      throw _privateConstructorUsedError; // Nombre d'éléments mis à jour dans l'étape actuelle
  int? get itemsSkipped =>
      throw _privateConstructorUsedError; // Nombre d'éléments ignorés dans l'étape actuelle
  int? get itemsDeleted =>
      throw _privateConstructorUsedError; // Nombre d'éléments supprimés dans l'étape actuelle
  String? get additionalInfo =>
      throw _privateConstructorUsedError; // Informations supplémentaires sur la progression
  String? get nextFullSyncInfo => throw _privateConstructorUsedError;

  /// Create a copy of SyncStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SyncStatusCopyWith<SyncStatus> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SyncStatusCopyWith<$Res> {
  factory $SyncStatusCopyWith(
          SyncStatus value, $Res Function(SyncStatus) then) =
      _$SyncStatusCopyWithImpl<$Res, SyncStatus>;
  @useResult
  $Res call(
      {SyncState state,
      SyncStep? currentStep,
      List<SyncStep> completedSteps,
      List<SyncStep> failedSteps,
      int itemsProcessed,
      int itemsTotal,
      double progress,
      String? errorMessage,
      DateTime? lastSync,
      List<SyncConflict>? conflicts,
      DateTime lastUpdated,
      SyncType? currentSyncType,
      String? currentEntityName,
      int? currentEntityTotal,
      int? currentEntityProcessed,
      int? itemsAdded,
      int? itemsUpdated,
      int? itemsSkipped,
      int? itemsDeleted,
      String? additionalInfo,
      String? nextFullSyncInfo});
}

/// @nodoc
class _$SyncStatusCopyWithImpl<$Res, $Val extends SyncStatus>
    implements $SyncStatusCopyWith<$Res> {
  _$SyncStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SyncStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? state = null,
    Object? currentStep = freezed,
    Object? completedSteps = null,
    Object? failedSteps = null,
    Object? itemsProcessed = null,
    Object? itemsTotal = null,
    Object? progress = null,
    Object? errorMessage = freezed,
    Object? lastSync = freezed,
    Object? conflicts = freezed,
    Object? lastUpdated = null,
    Object? currentSyncType = freezed,
    Object? currentEntityName = freezed,
    Object? currentEntityTotal = freezed,
    Object? currentEntityProcessed = freezed,
    Object? itemsAdded = freezed,
    Object? itemsUpdated = freezed,
    Object? itemsSkipped = freezed,
    Object? itemsDeleted = freezed,
    Object? additionalInfo = freezed,
    Object? nextFullSyncInfo = freezed,
  }) {
    return _then(_value.copyWith(
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as SyncState,
      currentStep: freezed == currentStep
          ? _value.currentStep
          : currentStep // ignore: cast_nullable_to_non_nullable
              as SyncStep?,
      completedSteps: null == completedSteps
          ? _value.completedSteps
          : completedSteps // ignore: cast_nullable_to_non_nullable
              as List<SyncStep>,
      failedSteps: null == failedSteps
          ? _value.failedSteps
          : failedSteps // ignore: cast_nullable_to_non_nullable
              as List<SyncStep>,
      itemsProcessed: null == itemsProcessed
          ? _value.itemsProcessed
          : itemsProcessed // ignore: cast_nullable_to_non_nullable
              as int,
      itemsTotal: null == itemsTotal
          ? _value.itemsTotal
          : itemsTotal // ignore: cast_nullable_to_non_nullable
              as int,
      progress: null == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as double,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      lastSync: freezed == lastSync
          ? _value.lastSync
          : lastSync // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      conflicts: freezed == conflicts
          ? _value.conflicts
          : conflicts // ignore: cast_nullable_to_non_nullable
              as List<SyncConflict>?,
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
      currentSyncType: freezed == currentSyncType
          ? _value.currentSyncType
          : currentSyncType // ignore: cast_nullable_to_non_nullable
              as SyncType?,
      currentEntityName: freezed == currentEntityName
          ? _value.currentEntityName
          : currentEntityName // ignore: cast_nullable_to_non_nullable
              as String?,
      currentEntityTotal: freezed == currentEntityTotal
          ? _value.currentEntityTotal
          : currentEntityTotal // ignore: cast_nullable_to_non_nullable
              as int?,
      currentEntityProcessed: freezed == currentEntityProcessed
          ? _value.currentEntityProcessed
          : currentEntityProcessed // ignore: cast_nullable_to_non_nullable
              as int?,
      itemsAdded: freezed == itemsAdded
          ? _value.itemsAdded
          : itemsAdded // ignore: cast_nullable_to_non_nullable
              as int?,
      itemsUpdated: freezed == itemsUpdated
          ? _value.itemsUpdated
          : itemsUpdated // ignore: cast_nullable_to_non_nullable
              as int?,
      itemsSkipped: freezed == itemsSkipped
          ? _value.itemsSkipped
          : itemsSkipped // ignore: cast_nullable_to_non_nullable
              as int?,
      itemsDeleted: freezed == itemsDeleted
          ? _value.itemsDeleted
          : itemsDeleted // ignore: cast_nullable_to_non_nullable
              as int?,
      additionalInfo: freezed == additionalInfo
          ? _value.additionalInfo
          : additionalInfo // ignore: cast_nullable_to_non_nullable
              as String?,
      nextFullSyncInfo: freezed == nextFullSyncInfo
          ? _value.nextFullSyncInfo
          : nextFullSyncInfo // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SyncStatusImplCopyWith<$Res>
    implements $SyncStatusCopyWith<$Res> {
  factory _$$SyncStatusImplCopyWith(
          _$SyncStatusImpl value, $Res Function(_$SyncStatusImpl) then) =
      __$$SyncStatusImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {SyncState state,
      SyncStep? currentStep,
      List<SyncStep> completedSteps,
      List<SyncStep> failedSteps,
      int itemsProcessed,
      int itemsTotal,
      double progress,
      String? errorMessage,
      DateTime? lastSync,
      List<SyncConflict>? conflicts,
      DateTime lastUpdated,
      SyncType? currentSyncType,
      String? currentEntityName,
      int? currentEntityTotal,
      int? currentEntityProcessed,
      int? itemsAdded,
      int? itemsUpdated,
      int? itemsSkipped,
      int? itemsDeleted,
      String? additionalInfo,
      String? nextFullSyncInfo});
}

/// @nodoc
class __$$SyncStatusImplCopyWithImpl<$Res>
    extends _$SyncStatusCopyWithImpl<$Res, _$SyncStatusImpl>
    implements _$$SyncStatusImplCopyWith<$Res> {
  __$$SyncStatusImplCopyWithImpl(
      _$SyncStatusImpl _value, $Res Function(_$SyncStatusImpl) _then)
      : super(_value, _then);

  /// Create a copy of SyncStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? state = null,
    Object? currentStep = freezed,
    Object? completedSteps = null,
    Object? failedSteps = null,
    Object? itemsProcessed = null,
    Object? itemsTotal = null,
    Object? progress = null,
    Object? errorMessage = freezed,
    Object? lastSync = freezed,
    Object? conflicts = freezed,
    Object? lastUpdated = null,
    Object? currentSyncType = freezed,
    Object? currentEntityName = freezed,
    Object? currentEntityTotal = freezed,
    Object? currentEntityProcessed = freezed,
    Object? itemsAdded = freezed,
    Object? itemsUpdated = freezed,
    Object? itemsSkipped = freezed,
    Object? itemsDeleted = freezed,
    Object? additionalInfo = freezed,
    Object? nextFullSyncInfo = freezed,
  }) {
    return _then(_$SyncStatusImpl(
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as SyncState,
      currentStep: freezed == currentStep
          ? _value.currentStep
          : currentStep // ignore: cast_nullable_to_non_nullable
              as SyncStep?,
      completedSteps: null == completedSteps
          ? _value._completedSteps
          : completedSteps // ignore: cast_nullable_to_non_nullable
              as List<SyncStep>,
      failedSteps: null == failedSteps
          ? _value._failedSteps
          : failedSteps // ignore: cast_nullable_to_non_nullable
              as List<SyncStep>,
      itemsProcessed: null == itemsProcessed
          ? _value.itemsProcessed
          : itemsProcessed // ignore: cast_nullable_to_non_nullable
              as int,
      itemsTotal: null == itemsTotal
          ? _value.itemsTotal
          : itemsTotal // ignore: cast_nullable_to_non_nullable
              as int,
      progress: null == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as double,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      lastSync: freezed == lastSync
          ? _value.lastSync
          : lastSync // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      conflicts: freezed == conflicts
          ? _value._conflicts
          : conflicts // ignore: cast_nullable_to_non_nullable
              as List<SyncConflict>?,
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
      currentSyncType: freezed == currentSyncType
          ? _value.currentSyncType
          : currentSyncType // ignore: cast_nullable_to_non_nullable
              as SyncType?,
      currentEntityName: freezed == currentEntityName
          ? _value.currentEntityName
          : currentEntityName // ignore: cast_nullable_to_non_nullable
              as String?,
      currentEntityTotal: freezed == currentEntityTotal
          ? _value.currentEntityTotal
          : currentEntityTotal // ignore: cast_nullable_to_non_nullable
              as int?,
      currentEntityProcessed: freezed == currentEntityProcessed
          ? _value.currentEntityProcessed
          : currentEntityProcessed // ignore: cast_nullable_to_non_nullable
              as int?,
      itemsAdded: freezed == itemsAdded
          ? _value.itemsAdded
          : itemsAdded // ignore: cast_nullable_to_non_nullable
              as int?,
      itemsUpdated: freezed == itemsUpdated
          ? _value.itemsUpdated
          : itemsUpdated // ignore: cast_nullable_to_non_nullable
              as int?,
      itemsSkipped: freezed == itemsSkipped
          ? _value.itemsSkipped
          : itemsSkipped // ignore: cast_nullable_to_non_nullable
              as int?,
      itemsDeleted: freezed == itemsDeleted
          ? _value.itemsDeleted
          : itemsDeleted // ignore: cast_nullable_to_non_nullable
              as int?,
      additionalInfo: freezed == additionalInfo
          ? _value.additionalInfo
          : additionalInfo // ignore: cast_nullable_to_non_nullable
              as String?,
      nextFullSyncInfo: freezed == nextFullSyncInfo
          ? _value.nextFullSyncInfo
          : nextFullSyncInfo // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$SyncStatusImpl extends _SyncStatus with DiagnosticableTreeMixin {
  const _$SyncStatusImpl(
      {required this.state,
      required this.currentStep,
      required final List<SyncStep> completedSteps,
      required final List<SyncStep> failedSteps,
      required this.itemsProcessed,
      required this.itemsTotal,
      required this.progress,
      this.errorMessage,
      this.lastSync,
      final List<SyncConflict>? conflicts,
      required this.lastUpdated,
      this.currentSyncType,
      this.currentEntityName,
      this.currentEntityTotal,
      this.currentEntityProcessed,
      this.itemsAdded,
      this.itemsUpdated,
      this.itemsSkipped,
      this.itemsDeleted,
      this.additionalInfo,
      this.nextFullSyncInfo})
      : _completedSteps = completedSteps,
        _failedSteps = failedSteps,
        _conflicts = conflicts,
        super._();

  @override
  final SyncState state;
  @override
  final SyncStep? currentStep;
  final List<SyncStep> _completedSteps;
  @override
  List<SyncStep> get completedSteps {
    if (_completedSteps is EqualUnmodifiableListView) return _completedSteps;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_completedSteps);
  }

  final List<SyncStep> _failedSteps;
  @override
  List<SyncStep> get failedSteps {
    if (_failedSteps is EqualUnmodifiableListView) return _failedSteps;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_failedSteps);
  }

  @override
  final int itemsProcessed;
  @override
  final int itemsTotal;
  @override
  final double progress;
  @override
  final String? errorMessage;
  @override
  final DateTime? lastSync;
  final List<SyncConflict>? _conflicts;
  @override
  List<SyncConflict>? get conflicts {
    final value = _conflicts;
    if (value == null) return null;
    if (_conflicts is EqualUnmodifiableListView) return _conflicts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final DateTime lastUpdated;
// Type de synchronisation en cours
  @override
  final SyncType? currentSyncType;
// Résultats des dernières synchronisations
// (utilisation de domain.SyncResult temporairement désactivée)
// SyncResult? lastDownstreamSync,
// SyncResult? lastUpstreamSync,
// Détails supplémentaires pour la progression
  @override
  final String? currentEntityName;
// Nom du module, site, etc. en cours de traitement
  @override
  final int? currentEntityTotal;
// Nombre total d'éléments à traiter pour l'entité courante
  @override
  final int? currentEntityProcessed;
// Nombre d'éléments traités pour l'entité courante
  @override
  final int? itemsAdded;
// Nombre d'éléments ajoutés dans l'étape actuelle
  @override
  final int? itemsUpdated;
// Nombre d'éléments mis à jour dans l'étape actuelle
  @override
  final int? itemsSkipped;
// Nombre d'éléments ignorés dans l'étape actuelle
  @override
  final int? itemsDeleted;
// Nombre d'éléments supprimés dans l'étape actuelle
  @override
  final String? additionalInfo;
// Informations supplémentaires sur la progression
  @override
  final String? nextFullSyncInfo;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SyncStatus(state: $state, currentStep: $currentStep, completedSteps: $completedSteps, failedSteps: $failedSteps, itemsProcessed: $itemsProcessed, itemsTotal: $itemsTotal, progress: $progress, errorMessage: $errorMessage, lastSync: $lastSync, conflicts: $conflicts, lastUpdated: $lastUpdated, currentSyncType: $currentSyncType, currentEntityName: $currentEntityName, currentEntityTotal: $currentEntityTotal, currentEntityProcessed: $currentEntityProcessed, itemsAdded: $itemsAdded, itemsUpdated: $itemsUpdated, itemsSkipped: $itemsSkipped, itemsDeleted: $itemsDeleted, additionalInfo: $additionalInfo, nextFullSyncInfo: $nextFullSyncInfo)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'SyncStatus'))
      ..add(DiagnosticsProperty('state', state))
      ..add(DiagnosticsProperty('currentStep', currentStep))
      ..add(DiagnosticsProperty('completedSteps', completedSteps))
      ..add(DiagnosticsProperty('failedSteps', failedSteps))
      ..add(DiagnosticsProperty('itemsProcessed', itemsProcessed))
      ..add(DiagnosticsProperty('itemsTotal', itemsTotal))
      ..add(DiagnosticsProperty('progress', progress))
      ..add(DiagnosticsProperty('errorMessage', errorMessage))
      ..add(DiagnosticsProperty('lastSync', lastSync))
      ..add(DiagnosticsProperty('conflicts', conflicts))
      ..add(DiagnosticsProperty('lastUpdated', lastUpdated))
      ..add(DiagnosticsProperty('currentSyncType', currentSyncType))
      ..add(DiagnosticsProperty('currentEntityName', currentEntityName))
      ..add(DiagnosticsProperty('currentEntityTotal', currentEntityTotal))
      ..add(
          DiagnosticsProperty('currentEntityProcessed', currentEntityProcessed))
      ..add(DiagnosticsProperty('itemsAdded', itemsAdded))
      ..add(DiagnosticsProperty('itemsUpdated', itemsUpdated))
      ..add(DiagnosticsProperty('itemsSkipped', itemsSkipped))
      ..add(DiagnosticsProperty('itemsDeleted', itemsDeleted))
      ..add(DiagnosticsProperty('additionalInfo', additionalInfo))
      ..add(DiagnosticsProperty('nextFullSyncInfo', nextFullSyncInfo));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SyncStatusImpl &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.currentStep, currentStep) ||
                other.currentStep == currentStep) &&
            const DeepCollectionEquality()
                .equals(other._completedSteps, _completedSteps) &&
            const DeepCollectionEquality()
                .equals(other._failedSteps, _failedSteps) &&
            (identical(other.itemsProcessed, itemsProcessed) ||
                other.itemsProcessed == itemsProcessed) &&
            (identical(other.itemsTotal, itemsTotal) ||
                other.itemsTotal == itemsTotal) &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.lastSync, lastSync) ||
                other.lastSync == lastSync) &&
            const DeepCollectionEquality()
                .equals(other._conflicts, _conflicts) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated) &&
            (identical(other.currentSyncType, currentSyncType) ||
                other.currentSyncType == currentSyncType) &&
            (identical(other.currentEntityName, currentEntityName) ||
                other.currentEntityName == currentEntityName) &&
            (identical(other.currentEntityTotal, currentEntityTotal) ||
                other.currentEntityTotal == currentEntityTotal) &&
            (identical(other.currentEntityProcessed, currentEntityProcessed) ||
                other.currentEntityProcessed == currentEntityProcessed) &&
            (identical(other.itemsAdded, itemsAdded) ||
                other.itemsAdded == itemsAdded) &&
            (identical(other.itemsUpdated, itemsUpdated) ||
                other.itemsUpdated == itemsUpdated) &&
            (identical(other.itemsSkipped, itemsSkipped) ||
                other.itemsSkipped == itemsSkipped) &&
            (identical(other.itemsDeleted, itemsDeleted) ||
                other.itemsDeleted == itemsDeleted) &&
            (identical(other.additionalInfo, additionalInfo) ||
                other.additionalInfo == additionalInfo) &&
            (identical(other.nextFullSyncInfo, nextFullSyncInfo) ||
                other.nextFullSyncInfo == nextFullSyncInfo));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        state,
        currentStep,
        const DeepCollectionEquality().hash(_completedSteps),
        const DeepCollectionEquality().hash(_failedSteps),
        itemsProcessed,
        itemsTotal,
        progress,
        errorMessage,
        lastSync,
        const DeepCollectionEquality().hash(_conflicts),
        lastUpdated,
        currentSyncType,
        currentEntityName,
        currentEntityTotal,
        currentEntityProcessed,
        itemsAdded,
        itemsUpdated,
        itemsSkipped,
        itemsDeleted,
        additionalInfo,
        nextFullSyncInfo
      ]);

  /// Create a copy of SyncStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SyncStatusImplCopyWith<_$SyncStatusImpl> get copyWith =>
      __$$SyncStatusImplCopyWithImpl<_$SyncStatusImpl>(this, _$identity);
}

abstract class _SyncStatus extends SyncStatus {
  const factory _SyncStatus(
      {required final SyncState state,
      required final SyncStep? currentStep,
      required final List<SyncStep> completedSteps,
      required final List<SyncStep> failedSteps,
      required final int itemsProcessed,
      required final int itemsTotal,
      required final double progress,
      final String? errorMessage,
      final DateTime? lastSync,
      final List<SyncConflict>? conflicts,
      required final DateTime lastUpdated,
      final SyncType? currentSyncType,
      final String? currentEntityName,
      final int? currentEntityTotal,
      final int? currentEntityProcessed,
      final int? itemsAdded,
      final int? itemsUpdated,
      final int? itemsSkipped,
      final int? itemsDeleted,
      final String? additionalInfo,
      final String? nextFullSyncInfo}) = _$SyncStatusImpl;
  const _SyncStatus._() : super._();

  @override
  SyncState get state;
  @override
  SyncStep? get currentStep;
  @override
  List<SyncStep> get completedSteps;
  @override
  List<SyncStep> get failedSteps;
  @override
  int get itemsProcessed;
  @override
  int get itemsTotal;
  @override
  double get progress;
  @override
  String? get errorMessage;
  @override
  DateTime? get lastSync;
  @override
  List<SyncConflict>? get conflicts;
  @override
  DateTime get lastUpdated; // Type de synchronisation en cours
  @override
  SyncType? get currentSyncType; // Résultats des dernières synchronisations
// (utilisation de domain.SyncResult temporairement désactivée)
// SyncResult? lastDownstreamSync,
// SyncResult? lastUpstreamSync,
// Détails supplémentaires pour la progression
  @override
  String?
      get currentEntityName; // Nom du module, site, etc. en cours de traitement
  @override
  int?
      get currentEntityTotal; // Nombre total d'éléments à traiter pour l'entité courante
  @override
  int?
      get currentEntityProcessed; // Nombre d'éléments traités pour l'entité courante
  @override
  int? get itemsAdded; // Nombre d'éléments ajoutés dans l'étape actuelle
  @override
  int? get itemsUpdated; // Nombre d'éléments mis à jour dans l'étape actuelle
  @override
  int? get itemsSkipped; // Nombre d'éléments ignorés dans l'étape actuelle
  @override
  int? get itemsDeleted; // Nombre d'éléments supprimés dans l'étape actuelle
  @override
  String? get additionalInfo; // Informations supplémentaires sur la progression
  @override
  String? get nextFullSyncInfo;

  /// Create a copy of SyncStatus
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SyncStatusImplCopyWith<_$SyncStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
