// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_conflict.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SyncConflict {
  String get entityId => throw _privateConstructorUsedError;
  String get entityType => throw _privateConstructorUsedError;
  Map<String, dynamic> get localData => throw _privateConstructorUsedError;
  Map<String, dynamic> get remoteData => throw _privateConstructorUsedError;
  DateTime get localModifiedAt => throw _privateConstructorUsedError;
  DateTime get remoteModifiedAt => throw _privateConstructorUsedError;
  ConflictResolutionStrategy get resolutionStrategy =>
      throw _privateConstructorUsedError;
  Map<String, dynamic>? get resolvedData => throw _privateConstructorUsedError;
  String? get resolutionComment => throw _privateConstructorUsedError;
  ConflictType get conflictType =>
      throw _privateConstructorUsedError; // Pour les références supprimées, on stocke des informations sur l'entité référencée
  String? get referencedEntityType =>
      throw _privateConstructorUsedError; // Type de l'entité supprimée (nomenclature, taxon, etc.)
  String? get referencedEntityId =>
      throw _privateConstructorUsedError; // ID de l'entité supprimée
  String? get affectedField =>
      throw _privateConstructorUsedError; // Champ affecté par la suppression
  String? get navigationPath =>
      throw _privateConstructorUsedError; // Chemin de navigation pour résoudre le conflit
  bool get isResolved =>
      throw _privateConstructorUsedError; // Indique si le conflit a été géré
  String? get resolutionType =>
      throw _privateConstructorUsedError; // Comment le conflit a été résolu (ex: "modifié", "supprimé", etc.)
// Nouvelles propriétés pour la gestion améliorée des conflits
  SyncOperation? get operation =>
      throw _privateConstructorUsedError; // Opération qui a causé le conflit
  String? get message =>
      throw _privateConstructorUsedError; // Message détaillé du conflit
  ConflictSeverity? get severity =>
      throw _privateConstructorUsedError; // Sévérité du conflit
  String? get localValue =>
      throw _privateConstructorUsedError; // Valeur locale spécifique en conflit
  String? get remoteValue =>
      throw _privateConstructorUsedError; // Valeur distante spécifique en conflit
  int? get referencesCount => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SyncConflictCopyWith<SyncConflict> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SyncConflictCopyWith<$Res> {
  factory $SyncConflictCopyWith(
          SyncConflict value, $Res Function(SyncConflict) then) =
      _$SyncConflictCopyWithImpl<$Res, SyncConflict>;
  @useResult
  $Res call(
      {String entityId,
      String entityType,
      Map<String, dynamic> localData,
      Map<String, dynamic> remoteData,
      DateTime localModifiedAt,
      DateTime remoteModifiedAt,
      ConflictResolutionStrategy resolutionStrategy,
      Map<String, dynamic>? resolvedData,
      String? resolutionComment,
      ConflictType conflictType,
      String? referencedEntityType,
      String? referencedEntityId,
      String? affectedField,
      String? navigationPath,
      bool isResolved,
      String? resolutionType,
      SyncOperation? operation,
      String? message,
      ConflictSeverity? severity,
      String? localValue,
      String? remoteValue,
      int? referencesCount});
}

/// @nodoc
class _$SyncConflictCopyWithImpl<$Res, $Val extends SyncConflict>
    implements $SyncConflictCopyWith<$Res> {
  _$SyncConflictCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? entityId = null,
    Object? entityType = null,
    Object? localData = null,
    Object? remoteData = null,
    Object? localModifiedAt = null,
    Object? remoteModifiedAt = null,
    Object? resolutionStrategy = null,
    Object? resolvedData = freezed,
    Object? resolutionComment = freezed,
    Object? conflictType = null,
    Object? referencedEntityType = freezed,
    Object? referencedEntityId = freezed,
    Object? affectedField = freezed,
    Object? navigationPath = freezed,
    Object? isResolved = null,
    Object? resolutionType = freezed,
    Object? operation = freezed,
    Object? message = freezed,
    Object? severity = freezed,
    Object? localValue = freezed,
    Object? remoteValue = freezed,
    Object? referencesCount = freezed,
  }) {
    return _then(_value.copyWith(
      entityId: null == entityId
          ? _value.entityId
          : entityId // ignore: cast_nullable_to_non_nullable
              as String,
      entityType: null == entityType
          ? _value.entityType
          : entityType // ignore: cast_nullable_to_non_nullable
              as String,
      localData: null == localData
          ? _value.localData
          : localData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      remoteData: null == remoteData
          ? _value.remoteData
          : remoteData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      localModifiedAt: null == localModifiedAt
          ? _value.localModifiedAt
          : localModifiedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      remoteModifiedAt: null == remoteModifiedAt
          ? _value.remoteModifiedAt
          : remoteModifiedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      resolutionStrategy: null == resolutionStrategy
          ? _value.resolutionStrategy
          : resolutionStrategy // ignore: cast_nullable_to_non_nullable
              as ConflictResolutionStrategy,
      resolvedData: freezed == resolvedData
          ? _value.resolvedData
          : resolvedData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      resolutionComment: freezed == resolutionComment
          ? _value.resolutionComment
          : resolutionComment // ignore: cast_nullable_to_non_nullable
              as String?,
      conflictType: null == conflictType
          ? _value.conflictType
          : conflictType // ignore: cast_nullable_to_non_nullable
              as ConflictType,
      referencedEntityType: freezed == referencedEntityType
          ? _value.referencedEntityType
          : referencedEntityType // ignore: cast_nullable_to_non_nullable
              as String?,
      referencedEntityId: freezed == referencedEntityId
          ? _value.referencedEntityId
          : referencedEntityId // ignore: cast_nullable_to_non_nullable
              as String?,
      affectedField: freezed == affectedField
          ? _value.affectedField
          : affectedField // ignore: cast_nullable_to_non_nullable
              as String?,
      navigationPath: freezed == navigationPath
          ? _value.navigationPath
          : navigationPath // ignore: cast_nullable_to_non_nullable
              as String?,
      isResolved: null == isResolved
          ? _value.isResolved
          : isResolved // ignore: cast_nullable_to_non_nullable
              as bool,
      resolutionType: freezed == resolutionType
          ? _value.resolutionType
          : resolutionType // ignore: cast_nullable_to_non_nullable
              as String?,
      operation: freezed == operation
          ? _value.operation
          : operation // ignore: cast_nullable_to_non_nullable
              as SyncOperation?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      severity: freezed == severity
          ? _value.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as ConflictSeverity?,
      localValue: freezed == localValue
          ? _value.localValue
          : localValue // ignore: cast_nullable_to_non_nullable
              as String?,
      remoteValue: freezed == remoteValue
          ? _value.remoteValue
          : remoteValue // ignore: cast_nullable_to_non_nullable
              as String?,
      referencesCount: freezed == referencesCount
          ? _value.referencesCount
          : referencesCount // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SyncConflictImplCopyWith<$Res>
    implements $SyncConflictCopyWith<$Res> {
  factory _$$SyncConflictImplCopyWith(
          _$SyncConflictImpl value, $Res Function(_$SyncConflictImpl) then) =
      __$$SyncConflictImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String entityId,
      String entityType,
      Map<String, dynamic> localData,
      Map<String, dynamic> remoteData,
      DateTime localModifiedAt,
      DateTime remoteModifiedAt,
      ConflictResolutionStrategy resolutionStrategy,
      Map<String, dynamic>? resolvedData,
      String? resolutionComment,
      ConflictType conflictType,
      String? referencedEntityType,
      String? referencedEntityId,
      String? affectedField,
      String? navigationPath,
      bool isResolved,
      String? resolutionType,
      SyncOperation? operation,
      String? message,
      ConflictSeverity? severity,
      String? localValue,
      String? remoteValue,
      int? referencesCount});
}

/// @nodoc
class __$$SyncConflictImplCopyWithImpl<$Res>
    extends _$SyncConflictCopyWithImpl<$Res, _$SyncConflictImpl>
    implements _$$SyncConflictImplCopyWith<$Res> {
  __$$SyncConflictImplCopyWithImpl(
      _$SyncConflictImpl _value, $Res Function(_$SyncConflictImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? entityId = null,
    Object? entityType = null,
    Object? localData = null,
    Object? remoteData = null,
    Object? localModifiedAt = null,
    Object? remoteModifiedAt = null,
    Object? resolutionStrategy = null,
    Object? resolvedData = freezed,
    Object? resolutionComment = freezed,
    Object? conflictType = null,
    Object? referencedEntityType = freezed,
    Object? referencedEntityId = freezed,
    Object? affectedField = freezed,
    Object? navigationPath = freezed,
    Object? isResolved = null,
    Object? resolutionType = freezed,
    Object? operation = freezed,
    Object? message = freezed,
    Object? severity = freezed,
    Object? localValue = freezed,
    Object? remoteValue = freezed,
    Object? referencesCount = freezed,
  }) {
    return _then(_$SyncConflictImpl(
      entityId: null == entityId
          ? _value.entityId
          : entityId // ignore: cast_nullable_to_non_nullable
              as String,
      entityType: null == entityType
          ? _value.entityType
          : entityType // ignore: cast_nullable_to_non_nullable
              as String,
      localData: null == localData
          ? _value._localData
          : localData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      remoteData: null == remoteData
          ? _value._remoteData
          : remoteData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      localModifiedAt: null == localModifiedAt
          ? _value.localModifiedAt
          : localModifiedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      remoteModifiedAt: null == remoteModifiedAt
          ? _value.remoteModifiedAt
          : remoteModifiedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      resolutionStrategy: null == resolutionStrategy
          ? _value.resolutionStrategy
          : resolutionStrategy // ignore: cast_nullable_to_non_nullable
              as ConflictResolutionStrategy,
      resolvedData: freezed == resolvedData
          ? _value._resolvedData
          : resolvedData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      resolutionComment: freezed == resolutionComment
          ? _value.resolutionComment
          : resolutionComment // ignore: cast_nullable_to_non_nullable
              as String?,
      conflictType: null == conflictType
          ? _value.conflictType
          : conflictType // ignore: cast_nullable_to_non_nullable
              as ConflictType,
      referencedEntityType: freezed == referencedEntityType
          ? _value.referencedEntityType
          : referencedEntityType // ignore: cast_nullable_to_non_nullable
              as String?,
      referencedEntityId: freezed == referencedEntityId
          ? _value.referencedEntityId
          : referencedEntityId // ignore: cast_nullable_to_non_nullable
              as String?,
      affectedField: freezed == affectedField
          ? _value.affectedField
          : affectedField // ignore: cast_nullable_to_non_nullable
              as String?,
      navigationPath: freezed == navigationPath
          ? _value.navigationPath
          : navigationPath // ignore: cast_nullable_to_non_nullable
              as String?,
      isResolved: null == isResolved
          ? _value.isResolved
          : isResolved // ignore: cast_nullable_to_non_nullable
              as bool,
      resolutionType: freezed == resolutionType
          ? _value.resolutionType
          : resolutionType // ignore: cast_nullable_to_non_nullable
              as String?,
      operation: freezed == operation
          ? _value.operation
          : operation // ignore: cast_nullable_to_non_nullable
              as SyncOperation?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
      severity: freezed == severity
          ? _value.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as ConflictSeverity?,
      localValue: freezed == localValue
          ? _value.localValue
          : localValue // ignore: cast_nullable_to_non_nullable
              as String?,
      remoteValue: freezed == remoteValue
          ? _value.remoteValue
          : remoteValue // ignore: cast_nullable_to_non_nullable
              as String?,
      referencesCount: freezed == referencesCount
          ? _value.referencesCount
          : referencesCount // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$SyncConflictImpl extends _SyncConflict {
  const _$SyncConflictImpl(
      {required this.entityId,
      required this.entityType,
      required final Map<String, dynamic> localData,
      required final Map<String, dynamic> remoteData,
      required this.localModifiedAt,
      required this.remoteModifiedAt,
      required this.resolutionStrategy,
      final Map<String, dynamic>? resolvedData,
      this.resolutionComment,
      this.conflictType = ConflictType.dataConflict,
      this.referencedEntityType,
      this.referencedEntityId,
      this.affectedField,
      this.navigationPath,
      this.isResolved = false,
      this.resolutionType,
      this.operation,
      this.message,
      this.severity,
      this.localValue,
      this.remoteValue,
      this.referencesCount})
      : _localData = localData,
        _remoteData = remoteData,
        _resolvedData = resolvedData,
        super._();

  @override
  final String entityId;
  @override
  final String entityType;
  final Map<String, dynamic> _localData;
  @override
  Map<String, dynamic> get localData {
    if (_localData is EqualUnmodifiableMapView) return _localData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_localData);
  }

  final Map<String, dynamic> _remoteData;
  @override
  Map<String, dynamic> get remoteData {
    if (_remoteData is EqualUnmodifiableMapView) return _remoteData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_remoteData);
  }

  @override
  final DateTime localModifiedAt;
  @override
  final DateTime remoteModifiedAt;
  @override
  final ConflictResolutionStrategy resolutionStrategy;
  final Map<String, dynamic>? _resolvedData;
  @override
  Map<String, dynamic>? get resolvedData {
    final value = _resolvedData;
    if (value == null) return null;
    if (_resolvedData is EqualUnmodifiableMapView) return _resolvedData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? resolutionComment;
  @override
  @JsonKey()
  final ConflictType conflictType;
// Pour les références supprimées, on stocke des informations sur l'entité référencée
  @override
  final String? referencedEntityType;
// Type de l'entité supprimée (nomenclature, taxon, etc.)
  @override
  final String? referencedEntityId;
// ID de l'entité supprimée
  @override
  final String? affectedField;
// Champ affecté par la suppression
  @override
  final String? navigationPath;
// Chemin de navigation pour résoudre le conflit
  @override
  @JsonKey()
  final bool isResolved;
// Indique si le conflit a été géré
  @override
  final String? resolutionType;
// Comment le conflit a été résolu (ex: "modifié", "supprimé", etc.)
// Nouvelles propriétés pour la gestion améliorée des conflits
  @override
  final SyncOperation? operation;
// Opération qui a causé le conflit
  @override
  final String? message;
// Message détaillé du conflit
  @override
  final ConflictSeverity? severity;
// Sévérité du conflit
  @override
  final String? localValue;
// Valeur locale spécifique en conflit
  @override
  final String? remoteValue;
// Valeur distante spécifique en conflit
  @override
  final int? referencesCount;

  @override
  String toString() {
    return 'SyncConflict(entityId: $entityId, entityType: $entityType, localData: $localData, remoteData: $remoteData, localModifiedAt: $localModifiedAt, remoteModifiedAt: $remoteModifiedAt, resolutionStrategy: $resolutionStrategy, resolvedData: $resolvedData, resolutionComment: $resolutionComment, conflictType: $conflictType, referencedEntityType: $referencedEntityType, referencedEntityId: $referencedEntityId, affectedField: $affectedField, navigationPath: $navigationPath, isResolved: $isResolved, resolutionType: $resolutionType, operation: $operation, message: $message, severity: $severity, localValue: $localValue, remoteValue: $remoteValue, referencesCount: $referencesCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SyncConflictImpl &&
            (identical(other.entityId, entityId) ||
                other.entityId == entityId) &&
            (identical(other.entityType, entityType) ||
                other.entityType == entityType) &&
            const DeepCollectionEquality()
                .equals(other._localData, _localData) &&
            const DeepCollectionEquality()
                .equals(other._remoteData, _remoteData) &&
            (identical(other.localModifiedAt, localModifiedAt) ||
                other.localModifiedAt == localModifiedAt) &&
            (identical(other.remoteModifiedAt, remoteModifiedAt) ||
                other.remoteModifiedAt == remoteModifiedAt) &&
            (identical(other.resolutionStrategy, resolutionStrategy) ||
                other.resolutionStrategy == resolutionStrategy) &&
            const DeepCollectionEquality()
                .equals(other._resolvedData, _resolvedData) &&
            (identical(other.resolutionComment, resolutionComment) ||
                other.resolutionComment == resolutionComment) &&
            (identical(other.conflictType, conflictType) ||
                other.conflictType == conflictType) &&
            (identical(other.referencedEntityType, referencedEntityType) ||
                other.referencedEntityType == referencedEntityType) &&
            (identical(other.referencedEntityId, referencedEntityId) ||
                other.referencedEntityId == referencedEntityId) &&
            (identical(other.affectedField, affectedField) ||
                other.affectedField == affectedField) &&
            (identical(other.navigationPath, navigationPath) ||
                other.navigationPath == navigationPath) &&
            (identical(other.isResolved, isResolved) ||
                other.isResolved == isResolved) &&
            (identical(other.resolutionType, resolutionType) ||
                other.resolutionType == resolutionType) &&
            (identical(other.operation, operation) ||
                other.operation == operation) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            (identical(other.localValue, localValue) ||
                other.localValue == localValue) &&
            (identical(other.remoteValue, remoteValue) ||
                other.remoteValue == remoteValue) &&
            (identical(other.referencesCount, referencesCount) ||
                other.referencesCount == referencesCount));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        entityId,
        entityType,
        const DeepCollectionEquality().hash(_localData),
        const DeepCollectionEquality().hash(_remoteData),
        localModifiedAt,
        remoteModifiedAt,
        resolutionStrategy,
        const DeepCollectionEquality().hash(_resolvedData),
        resolutionComment,
        conflictType,
        referencedEntityType,
        referencedEntityId,
        affectedField,
        navigationPath,
        isResolved,
        resolutionType,
        operation,
        message,
        severity,
        localValue,
        remoteValue,
        referencesCount
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SyncConflictImplCopyWith<_$SyncConflictImpl> get copyWith =>
      __$$SyncConflictImplCopyWithImpl<_$SyncConflictImpl>(this, _$identity);
}

abstract class _SyncConflict extends SyncConflict {
  const factory _SyncConflict(
      {required final String entityId,
      required final String entityType,
      required final Map<String, dynamic> localData,
      required final Map<String, dynamic> remoteData,
      required final DateTime localModifiedAt,
      required final DateTime remoteModifiedAt,
      required final ConflictResolutionStrategy resolutionStrategy,
      final Map<String, dynamic>? resolvedData,
      final String? resolutionComment,
      final ConflictType conflictType,
      final String? referencedEntityType,
      final String? referencedEntityId,
      final String? affectedField,
      final String? navigationPath,
      final bool isResolved,
      final String? resolutionType,
      final SyncOperation? operation,
      final String? message,
      final ConflictSeverity? severity,
      final String? localValue,
      final String? remoteValue,
      final int? referencesCount}) = _$SyncConflictImpl;
  const _SyncConflict._() : super._();

  @override
  String get entityId;
  @override
  String get entityType;
  @override
  Map<String, dynamic> get localData;
  @override
  Map<String, dynamic> get remoteData;
  @override
  DateTime get localModifiedAt;
  @override
  DateTime get remoteModifiedAt;
  @override
  ConflictResolutionStrategy get resolutionStrategy;
  @override
  Map<String, dynamic>? get resolvedData;
  @override
  String? get resolutionComment;
  @override
  ConflictType get conflictType;
  @override // Pour les références supprimées, on stocke des informations sur l'entité référencée
  String? get referencedEntityType;
  @override // Type de l'entité supprimée (nomenclature, taxon, etc.)
  String? get referencedEntityId;
  @override // ID de l'entité supprimée
  String? get affectedField;
  @override // Champ affecté par la suppression
  String? get navigationPath;
  @override // Chemin de navigation pour résoudre le conflit
  bool get isResolved;
  @override // Indique si le conflit a été géré
  String? get resolutionType;
  @override // Comment le conflit a été résolu (ex: "modifié", "supprimé", etc.)
// Nouvelles propriétés pour la gestion améliorée des conflits
  SyncOperation? get operation;
  @override // Opération qui a causé le conflit
  String? get message;
  @override // Message détaillé du conflit
  ConflictSeverity? get severity;
  @override // Sévérité du conflit
  String? get localValue;
  @override // Valeur locale spécifique en conflit
  String? get remoteValue;
  @override // Valeur distante spécifique en conflit
  int? get referencesCount;
  @override
  @JsonKey(ignore: true)
  _$$SyncConflictImplCopyWith<_$SyncConflictImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
